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
managed_paths=('.tt/update.sh' '.tt/agent-rules.md' '.tt/CHANGELOG.md' 'AGENTS.md' '.tt/thesis-trail.json')

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
for source_file in scripts/update.sh scripts/apply-update.sh instructions/agent-rules.md CHANGELOG.md; do
    [[ -f "$release_directory/$source_file" && ! -L "$release_directory/$source_file" ]] || tt_fail "Missing or unsafe release file: $source_file."
done
for path in "${managed_paths[@]}"; do tt_regular_or_absent "$tt_project/$path"; done
if [[ "$from_version" == none ]]; then
    [[ ! -e "$tt_metadata" ]] || tt_fail 'ThesisTrail metadata already exists. Use the updater instead.'
    # Do not overwrite unrelated files when initializing a project.
    for path in .tt/update.sh .tt/agent-rules.md .tt/CHANGELOG.md; do
        [[ ! -e "$tt_project/$path" ]] || tt_fail "Initial installation would overwrite $path."
    done
fi

apply_cleanup() {
    local result=$? index destination restore_failed=0
    trap - EXIT INT TERM
    if [[ "$application_started" == 1 && "$application_succeeded" == 0 ]]; then
        for ((index=changed_count-1; index>=0; index--)); do
            destination="$tt_project/${managed_paths[$index]}"
            if [[ -f "$transaction/backup/$index" ]]; then
                cp -p -- "$transaction/backup/$index" "$destination" || restore_failed=1
            else
                rm -f -- "$destination" || restore_failed=1
            fi
        done
        if [[ "$restore_failed" == 0 ]]; then
            printf 'Update application failed; the previous installation was restored.\n' >&2
        fi
    fi
    if [[ "$restore_failed" == 1 ]]; then
        printf 'Error: Restoration was incomplete. Backups retained at %s.\n' "$transaction" >&2
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
for path in "${managed_paths[@]}"; do tt_regular_or_absent "$tt_project/$path"; done
if [[ "$from_version" == none ]]; then
    [[ ! -e "$tt_metadata" ]] || tt_fail 'Metadata appeared during installation.'
else
    tt_read_metadata
    [[ "$tt_current_version" == "$from_version" ]] || tt_fail 'The installed version changed. Check again before updating.'
    if [[ "$tt_current_tag" == "$reference" ]]; then
        [[ "$tt_current_commit" == "$commit" ]] || tt_fail 'The installed tag points to a different commit.'
        printf 'Already installed: %s.\n' "$reference"
        exit 0
    fi
fi

transaction=$(mktemp -d "$tt_service/.apply.XXXXXXXX")
mkdir -- "$transaction/new" "$transaction/backup"
cp -- "$release_directory/scripts/update.sh" "$transaction/new/0"
cp -- "$release_directory/instructions/agent-rules.md" "$transaction/new/1"
cp -- "$release_directory/CHANGELOG.md" "$transaction/new/2"
chmod 755 "$transaction/new/0"
chmod 644 "$transaction/new/1" "$transaction/new/2"

printf '%s\n' '<!-- ThesisTrail:begin -->' '## ThesisTrail' '' \
    'At the start of work in this project, read [.tt/agent-rules.md](.tt/agent-rules.md) and follow its student workflow, topic-card, release-check, and update-consent rules.' \
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
if [[ "$from_version" == none ]]; then
    printf '{\n  "schema_version": 1,\n  "repository": %s,\n  "version": %s,\n  "tag": %s,\n  "branch": %s,\n  "commit": %s,\n  "installed_at": %s,\n  "updated_at": %s\n}\n' \
      "$(tt_json_string "$tt_repository")" "$version_json" "$tag_json" "$branch_json" \
      "$(tt_json_string "$commit")" "$(tt_json_string "$timestamp")" "$(tt_json_string "$timestamp")" > "$transaction/new/4"
else
    cp -p -- "$tt_metadata" "$transaction/new/4"
    tt_json_set "$transaction/new/4" version "$version_json"
    tt_json_set "$transaction/new/4" tag "$tag_json"
    tt_json_set "$transaction/new/4" branch "$branch_json"
    tt_json_set "$transaction/new/4" commit "$(tt_json_string "$commit")"
    tt_json_set "$transaction/new/4" updated_at "$(tt_json_string "$timestamp")"
fi
tt_json validate "$transaction/new/4" || tt_fail 'Prepared metadata is invalid.'

for ((index=0; index<${#managed_paths[@]}; index++)); do
    destination="$tt_project/${managed_paths[$index]}"
    if [[ -f "$destination" ]]; then cp -p -- "$destination" "$transaction/backup/$index"; fi
done
application_started=1
for ((index=0; index<${#managed_paths[@]}; index++)); do
    destination="$tt_project/${managed_paths[$index]}"
    changed_count=$((index+1))
    if [[ -f "$destination" ]] && cmp -s -- "$transaction/new/$index" "$destination"; then
        continue
    fi
    mv -f -- "$transaction/new/$index" "$destination"
done
application_succeeded=1
printf 'ThesisTrail installed from %s %s (%s).\n' "$selection" "$reference" "$commit"
printf 'Metadata: %s\n' "$tt_metadata"
if [[ "$from_version" == none ]]; then
    printf '\n%s\n' \
        'Next: open this project in an AI agent that reads AGENTS.md and ask to start your coursework or thesis.' \
        'The agent will help you create docs/topic.md during the conversation.'
fi
