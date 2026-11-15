#!/usr/bin/env bash
# Protocol v1: installation and migrations supplied by the target release.
set -euo pipefail

release_directory=$(cd -P -- "${BASH_SOURCE[0]%/*}/.." && pwd)
[[ -f "$release_directory/scripts/update.sh" && ! -L "$release_directory/scripts/update.sh" ]] || {
    printf 'Error: The release launcher is missing or unsafe.\n' >&2; exit 1;
}
# Use this release's helpers, never an installed or newer remote library.
source "$release_directory/scripts/update.sh"

tt_project=''
from_version=''
selection=''
reference=''
commit=''
transaction=''
application_started=0
application_succeeded=0
changed_count=0
archive_directory=''
archive_relative=''
archive_entries=()
archive_count=0
archive_attempted=0
instructions_index=4
instructions_replacement_started=0
metadata_index=5
managed_paths=('.tt/update.sh' '.tt/agent-rules.md' '.tt/CHANGELOG.md' 'AGENTS.md' '.tt/instructions' '.tt/thesis-trail.json')

validate_instruction_tree() {
    local entry
    [[ -d "$1" && ! -L "$1" ]] || tt_fail "Expected a real instruction directory: $1."
    for entry in "$1"/* "$1"/.[!.]* "$1"/..?*; do
        [[ -e "$entry" || -L "$entry" ]] || continue
        [[ ! -L "$entry" ]] || tt_fail "Symbolic links are not supported in instructions: $entry."
        if [[ -d "$entry" ]]; then
            validate_instruction_tree "$entry"
        else
            [[ -f "$entry" ]] || tt_fail "Expected a regular instruction file: $entry."
        fi
    done
}

validate_destinations() {
    local path
    for path in "${managed_paths[@]}"; do
        if [[ "$path" == .tt/instructions ]]; then
            [[ ! -L "$tt_project/$path" && ( ! -e "$tt_project/$path" || -d "$tt_project/$path" ) ]] || tt_fail '.tt/instructions must be a real directory.'
        else
            tt_regular_or_absent "$tt_project/$path"
        fi
    done
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --project|--from-version|--tag|--branch|--commit)
            [[ $# -ge 2 && -n "$2" && "$2" != -* ]] || tt_fail "$1 requires a value."
            case "$1" in
                --project) [[ -z "$tt_project" ]] || tt_fail 'Repeated --project.'; tt_project=$2 ;;
                --from-version) [[ -z "$from_version" ]] || tt_fail 'Repeated --from-version.'; from_version=$2 ;;
                --commit) [[ -z "$commit" ]] || tt_fail 'Repeated --commit.'; commit=$2 ;;
                --tag|--branch) [[ -z "$selection" ]] || tt_fail 'Choose one source selector.'; selection=${1#--}; reference=$2 ;;
            esac
            shift 2 ;;
        -h|--help)
            printf '%s\n' 'Usage: apply-update.sh --project PATH --from-version VERSION --tag vX.Y.Z --commit SHA' \
                'Initial installation also accepts --from-version none and --branch NAME.'
            exit 0 ;;
        *) tt_fail "Unknown argument: $1." ;;
    esac
done

[[ "$tt_project" == /* && -d "$tt_project" && -n "$from_version" && "$commit" =~ $tt_sha_pattern ]] || tt_fail 'A project directory, source version, and full target commit are required.'
tt_dependencies
if [[ "$selection" == tag ]]; then
    [[ "$reference" =~ $tt_tag_pattern ]] || tt_fail 'Version tags must match vX.Y.Z.'
elif [[ "$selection" == branch && "$from_version" == none ]]; then
    git check-ref-format "refs/heads/$reference" >/dev/null 2>&1 || tt_fail 'Invalid branch name.'
else
    tt_fail 'Updates require a tag; only initial installation supports branches.'
fi

tt_project=$(cd -P -- "$tt_project" && pwd)
tt_project_paths
for source_file in scripts/update.sh scripts/apply-update.sh instructions/agent-rules.md \
    instructions/general/git.md instructions/general/reproducibility.md instructions/general/documentation.md \
    instructions/research/topic.md instructions/research/materials.md \
    instructions/maintenance/project-setup.md instructions/maintenance/updates.md instructions/domains/README.md CHANGELOG.md; do
    [[ -f "$release_directory/$source_file" && ! -L "$release_directory/$source_file" ]] || tt_fail "Missing or unsafe release file: $source_file."
done
validate_instruction_tree "$release_directory/instructions"
validate_destinations
if [[ "$from_version" == none ]]; then
    [[ ! -e "$tt_metadata" ]] || tt_fail 'ThesisTrail metadata already exists. Use the updater instead.'
    [[ ! -e "$tt_project/.tt/instructions" ]] || tt_fail 'Initial installation would overwrite .tt/instructions.'
    # Do not overwrite unrelated files when initializing a project.
    for path in .tt/update.sh .tt/agent-rules.md .tt/CHANGELOG.md .tt/setup-state; do
        tt_regular_or_absent "$tt_project/$path"
        [[ ! -e "$tt_project/$path" ]] || tt_fail "Initial installation would overwrite $path."
    done
fi

apply_cleanup() {
    local result=$? index destination archived name restore_failed=0
    trap - EXIT INT TERM
    if [[ "$application_started" == 1 && "$application_succeeded" == 0 ]]; then
        for ((index=changed_count-1; index>=0; index--)); do
            destination="$tt_project/${managed_paths[$index]}"
            if [[ "$index" == "$instructions_index" ]]; then
                if [[ -d "$transaction/backup/$index" ]]; then
                    if rm -rf -- "$destination"; then
                        mv -- "$transaction/backup/$index" "$destination" || restore_failed=1
                    else
                        restore_failed=1
                    fi
                elif [[ "$instructions_replacement_started" == 1 ]]; then
                    rm -rf -- "$destination" || restore_failed=1
                fi
            elif [[ -f "$transaction/backup/$index" ]]; then
                cp -p -- "$transaction/backup/$index" "$destination" || restore_failed=1
            else
                rm -f -- "$destination" || restore_failed=1
            fi
        done
    fi
    if [[ "$application_succeeded" == 0 && -n "$archive_directory" ]]; then
        for ((index=archive_attempted-1; index>=0; index--)); do
            name=${archive_entries[$index]}
            archived="$archive_directory/$name"
            destination="$tt_project/$name"
            if [[ -e "$archived" || -L "$archived" ]]; then
                if [[ -e "$destination" || -L "$destination" ]]; then
                    # The transaction may already have restored these two files.
                    if [[ ( "$name" != AGENTS.md && "$name" != .gitignore ) || ! -f "$destination" || -L "$destination" ]]; then
                        printf 'Error: Cannot restore an archived entry over a conflicting path: %s.\n' "$destination" >&2
                        restore_failed=1
                        continue
                    fi
                fi
                mv -f -- "$archived" "$destination" || restore_failed=1
            elif [[ ! -e "$destination" && ! -L "$destination" ]]; then
                printf 'Error: Archived entry is missing from both locations: %s.\n' "$name" >&2
                restore_failed=1
            fi
        done
        if [[ "$restore_failed" == 0 ]]; then
            rm -rf -- "$archive_directory" || restore_failed=1
        fi
    fi
    if [[ "$application_started" == 1 && "$application_succeeded" == 0 && "$restore_failed" == 0 ]]; then
        printf 'Application failed; the previous project state was restored.\n' >&2
    fi
    if [[ "$restore_failed" == 1 ]]; then
        printf 'Error: Restoration was incomplete. Backups retained at %s.\n' "$transaction" >&2
        if [[ -n "$archive_directory" ]]; then
            printf 'Original project snapshot: %s.\n' "$archive_directory" >&2
        fi
        result=1
    elif [[ -n "$transaction" ]]; then
        rm -rf -- "$transaction" || :
    fi
    tt_cleanup
    exit "$result"
}
trap apply_cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
mkdir -p -- "$tt_service"
tt_acquire_lock
# Validate again under the lock, including the expected source version.
validate_destinations
if [[ "$from_version" == none ]]; then
    [[ ! -e "$tt_metadata" ]] || tt_fail 'Metadata appeared during installation.'
    [[ ! -e "$tt_project/.tt/instructions" ]] || tt_fail 'Initial installation would overwrite .tt/instructions.'
    [[ "$release_directory" != "$tt_project" && "$release_directory" != "$tt_project/"* ]] || tt_fail 'Initial installation requires release staging outside the project. Use a TMPDIR outside the project.'
    # Recheck initial-only conflicts under the lock before touching materials.
    for path in .tt/update.sh .tt/agent-rules.md .tt/CHANGELOG.md .tt/setup-state; do
        tt_regular_or_absent "$tt_project/$path"
        [[ ! -e "$tt_project/$path" ]] || tt_fail "Initial installation would overwrite $path."
    done
    [[ ! -L "$tt_project/.backup" && ( ! -e "$tt_project/.backup" || -d "$tt_project/.backup" ) ]] || tt_fail '.backup must be a real directory.'
    shopt -s dotglob nullglob
    for entry in "$tt_project"/*; do
        name=${entry##*/}
        case "$name" in .git|.tt|.backup) continue ;; esac
        archive_entries[$archive_count]=$name
        archive_count=$((archive_count+1))
    done
    shopt -u dotglob nullglob
    if [[ "$archive_count" -gt 0 ]]; then
        managed_paths=('.tt/update.sh' '.tt/agent-rules.md' '.tt/CHANGELOG.md' 'AGENTS.md' '.gitignore' '.tt/setup-state' '.tt/instructions' '.tt/thesis-trail.json')
        instructions_index=6
        metadata_index=7
        validate_destinations
    fi
else
    tt_read_metadata
    [[ "$tt_current_version" == "$from_version" ]] || tt_fail 'The installed version changed. Check again before updating.'
    if installed_layout=$(tt_json get "$tt_metadata" instructions_layout); then
        [[ "$installed_layout" == 1 ]] || tt_fail "Unsupported instruction layout: $installed_layout."
    else
        [[ $? == 3 ]] || tt_fail 'Could not read instruction layout metadata.'
        [[ ! -e "$tt_project/.tt/instructions" ]] || tt_fail 'Legacy upgrade would overwrite unrelated .tt/instructions.'
    fi
    if [[ "$tt_current_tag" == "$reference" ]]; then
        [[ "$tt_current_commit" == "$commit" ]] || tt_fail 'The installed tag points to a different commit.'
        printf 'Already installed: %s.\n' "$reference"
        exit 0
    fi
fi

transaction=$(mktemp -d "$tt_service/.apply.XXXXXXXX")
mkdir -- "$transaction/new" "$transaction/backup"
cp -- "$release_directory/scripts/update.sh" "$transaction/new/0"
printf '%s\n' '# ThesisTrail instructions' '' \
    'Read [instructions/agent-rules.md](instructions/agent-rules.md) and follow its module-selection, setup, release-check, and update-consent instructions.' > "$transaction/new/1"
cp -- "$release_directory/CHANGELOG.md" "$transaction/new/2"
cp -Rp -- "$release_directory/instructions" "$transaction/new/$instructions_index"
chmod 755 "$transaction/new/0"
chmod 644 "$transaction/new/1" "$transaction/new/2"

printf '%s\n' '<!-- ThesisTrail:begin -->' '## ThesisTrail' '' \
    'At the start of work in this project, read [.tt/agent-rules.md](.tt/agent-rules.md). Follow pending initial project setup before topic onboarding, and follow the student workflow, topic-card, release-check, and update-consent rules.' \
    '<!-- ThesisTrail:end -->' > "$transaction/hook"
# Validate markers before constructing an edited root instruction file.
if [[ -f "$tt_project/AGENTS.md" ]]; then
    awk '
      /<!-- ThesisTrail:(begin|end) -->/ {
        if ($0=="<!-- ThesisTrail:begin -->" && !opened && !closed) { opened=1; next }
        if ($0=="<!-- ThesisTrail:end -->" && opened && !closed) { closed=1; next }
        exit 1
      }
      END { if (opened!=closed) exit 1 }
    ' "$tt_project/AGENTS.md" || tt_fail 'Malformed or duplicate ThesisTrail markers in AGENTS.md.'
    TT_HOOK="$transaction/hook" awk '
      function hook( line) {
        while ((getline line < ENVIRON["TT_HOOK"])>0) print line
        close(ENVIRON["TT_HOOK"])
      }
      $0=="<!-- ThesisTrail:begin -->" { hook(); inside=1; found=1; next }
      $0=="<!-- ThesisTrail:end -->" { inside=0; next }
      !inside { print }
      END { if (!found) { print ""; hook() } }
    ' "$tt_project/AGENTS.md" > "$transaction/new/3"
    cp -p -- "$tt_project/AGENTS.md" "$transaction/agents-mode"
    # Preserve the existing permission bits while replacing the prepared text.
    cp -- "$transaction/new/3" "$transaction/agents-mode"
    mv -- "$transaction/agents-mode" "$transaction/new/3"
else
    cp -- "$transaction/hook" "$transaction/new/3"
    chmod 644 "$transaction/new/3"
fi

if [[ "$selection" == tag ]]; then
    version_json=$(tt_json_string "${reference#v}")
    tag_json=$(tt_json_string "$reference")
    branch_json=null
else
    version_json=null; tag_json=null
    branch_json=$(tt_json_string "$reference")
fi
timestamp=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
metadata_staged="$transaction/new/$metadata_index"
if [[ "$from_version" == none ]]; then
    printf '{\n  "schema_version": 1,\n  "repository": %s,\n  "version": %s,\n  "tag": %s,\n  "branch": %s,\n  "commit": %s,\n  "installed_at": %s,\n  "updated_at": %s\n}\n' \
      "$(tt_json_string "$tt_repository")" "$version_json" "$tag_json" "$branch_json" \
      "$(tt_json_string "$commit")" "$(tt_json_string "$timestamp")" "$(tt_json_string "$timestamp")" > "$metadata_staged"
else
    cp -p -- "$tt_metadata" "$metadata_staged"
    tt_json_set "$metadata_staged" version "$version_json"
    tt_json_set "$metadata_staged" tag "$tag_json"
    tt_json_set "$metadata_staged" branch "$branch_json"
    tt_json_set "$metadata_staged" commit "$(tt_json_string "$commit")"
    tt_json_set "$metadata_staged" updated_at "$(tt_json_string "$timestamp")"
fi
tt_json_set "$metadata_staged" instructions_layout 1
tt_json validate "$metadata_staged" || tt_fail 'Prepared metadata is invalid.'

if [[ "$archive_count" -gt 0 ]]; then
    if [[ -f "$tt_project/.gitignore" ]]; then
        cp -p -- "$tt_project/.gitignore" "$transaction/new/4"
    else
        : > "$transaction/new/4"
        chmod 644 "$transaction/new/4"
    fi
    printf '\n# ThesisTrail initial project backup\n/.backup/\n' >> "$transaction/new/4"
    mkdir -p -- "$tt_project/.backup"
    archive_directory=$(mktemp -d "$tt_project/.backup/project-$(date -u '+%Y%m%dT%H%M%SZ').XXXXXXXX")
    archive_relative=${archive_directory#"$tt_project/"}
    git config --file "$transaction/new/5" setup.status pending
    git config --file "$transaction/new/5" setup.backup "$archive_relative"
fi

for ((index=0; index<${#managed_paths[@]}; index++)); do
    destination="$tt_project/${managed_paths[$index]}"
    if [[ "$index" != "$instructions_index" && -f "$destination" ]]; then cp -p -- "$destination" "$transaction/backup/$index"; fi
done
application_started=1
for ((index=0; index<archive_count; index++)); do
    # Count before moving so a handled signal still restores the current entry.
    archive_attempted=$((index+1))
    name=${archive_entries[$index]}
    mv -- "$tt_project/$name" "$archive_directory/$name"
done
for ((index=0; index<${#managed_paths[@]}; index++)); do
    destination="$tt_project/${managed_paths[$index]}"
    changed_count=$((index+1))
    if [[ "$index" == "$instructions_index" ]]; then
        # Move the old tree intact so rollback preserves its links and modes.
        if [[ -d "$destination" ]]; then mv -- "$destination" "$transaction/backup/$index"; fi
        instructions_replacement_started=1
        mv -- "$transaction/new/$index" "$destination"
        continue
    fi
    if [[ -f "$destination" ]] && cmp -s -- "$transaction/new/$index" "$destination"; then
        continue
    fi
    mv -f -- "$transaction/new/$index" "$destination"
done
application_succeeded=1
printf 'ThesisTrail installed from %s %s (%s).\n' "$selection" "$reference" "$commit"
printf 'Metadata: %s\n' "$tt_metadata"
if [[ "$from_version" == none ]]; then
    if [[ -n "$archive_directory" ]]; then
        printf '\nOriginal project materials: %s\n' "$archive_relative"
        printf '%s\n' \
            'Next: open this project in an AI agent that reads AGENTS.md and ask it to prepare the project from the backup.' \
            'The agent will copy materials back, preserve the snapshot, and create or reuse the topic card.'
    else
        printf '\n%s\n' \
            'Next: open this project in an AI agent that reads AGENTS.md and ask to start your coursework or thesis.' \
            'The agent will help you create docs/topic.md during the conversation.'
    fi
fi
