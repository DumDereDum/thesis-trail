#!/usr/bin/env bash
# Install ThesisTrail from the selected remote revision.
set -euo pipefail

repository='https://github.com/DumDereDum/thesis-trail.git'
tag_pattern='^v[0-9]+\.[0-9]+\.[0-9]+$'
selection='latest'
reference=''
temporary_directory=''
metadata_temporary_file=''

fail() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

usage() {
    printf '%s\n' \
        'Usage: install.sh [--branch NAME | --tag vX.Y.Z]' \
        '' \
        'Initialize ThesisTrail in the current directory.' \
        'Without arguments, use the most recent vX.Y.Z tag by date.' \
        'Existing installations are left unchanged.' \
        'Releases with project setup archive existing materials under .backup/.' \
        '' \
        'Options:' \
        '  --branch NAME  Install from a remote branch.' \
        '  --tag vX.Y.Z   Install from a specific version tag.' \
        '  -h, --help     Show this help.'
}

cleanup() {
    if [[ -n "$metadata_temporary_file" ]]; then
        rm -f -- "$metadata_temporary_file" || :
    fi
    if [[ -n "$temporary_directory" ]]; then
        rm -rf -- "$temporary_directory" || :
    fi
}

json_string() {
    local value=$1
    value=${value//\\/\\\\}
    value=${value//\"/\\\"}
    printf '"%s"' "$value"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --branch|--tag)
            [[ "$selection" == 'latest' ]] || fail 'Choose only one --branch or --tag option.'
            [[ $# -ge 2 && -n "$2" && "$2" != -* ]] || fail "$1 requires a value."
            selection=${1#--}
            reference=$2
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            fail "Unknown argument: $1. See --help."
            ;;
    esac
done

for utility in git mktemp mkdir rm date ln awk cp mv chmod cmp; do
    command -v "$utility" >/dev/null 2>&1 || fail "Required command not found: $utility."
done

if [[ "$selection" == 'tag' ]]; then
    [[ "$reference" =~ $tag_pattern ]] || fail 'Version tags must match vX.Y.Z.'
elif [[ "$selection" == 'branch' ]]; then
    git check-ref-format "refs/heads/$reference" >/dev/null 2>&1 || fail "Invalid branch name: $reference."
fi

project_directory=$PWD
service_directory="$project_directory/.tt"
metadata_file="$service_directory/thesis-trail.json"

[[ ! -L "$service_directory" ]] || fail '.tt must not be a symbolic link.'
if [[ -e "$service_directory" && ! -d "$service_directory" ]]; then
    fail '.tt exists and is not a directory.'
fi
if [[ -e "$metadata_file" || -L "$metadata_file" ]]; then
    fail 'ThesisTrail metadata already exists. This installer does not update existing installations.'
fi

trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

mkdir -p -- "$service_directory"
temporary_directory=$(mktemp -d "${TMPDIR:-/tmp}/thesis-trail.XXXXXXXX")
source_directory="$temporary_directory/source.git"
git init --bare --quiet "$source_directory"
git -C "$source_directory" remote add origin "$repository"

# Public GitHub access must not prompt for credentials in unattended runs.
export GIT_TERMINAL_PROMPT=0
printf 'Retrieving ThesisTrail from %s...\n' "$repository"

if [[ "$selection" == 'latest' ]]; then
    git -C "$source_directory" fetch --quiet --depth=1 --tags origin || fail 'Could not retrieve remote tags. Check network access.'
    git -C "$source_directory" for-each-ref \
        --sort=refname --sort=-creatordate \
        --format='%(refname:strip=2)' refs/tags > "$temporary_directory/tags"
    while IFS= read -r candidate; do
        if [[ "$candidate" =~ $tag_pattern ]]; then
            reference=$candidate
            break
        fi
    done < "$temporary_directory/tags"
    [[ -n "$reference" ]] || fail 'No vX.Y.Z tags found. Use --branch NAME until the first version tag is available.'
    commit=$(git -C "$source_directory" rev-parse --verify "refs/tags/$reference^{commit}") || fail 'The selected tag does not point to a commit.'
    selection='tag'
else
    if [[ "$selection" == 'branch' ]]; then
        remote_reference="refs/heads/$reference"
    else
        remote_reference="refs/tags/$reference"
    fi
    git -C "$source_directory" fetch --quiet --depth=1 --no-tags origin "$remote_reference" || fail "Could not retrieve $selection '$reference'. Check the reference and network access."
    commit=$(git -C "$source_directory" rev-parse --verify 'FETCH_HEAD^{commit}') || fail 'The selected reference does not point to a commit.'
fi

# Releases carry their own application and migration rules. Do not install
# updater files from main when the user selected a different revision.
if git -C "$source_directory" cat-file -e "$commit:scripts/apply-update.sh" 2>/dev/null; then
    release_directory="$temporary_directory/release"
    mkdir -- "$release_directory"
    git --git-dir="$source_directory" --work-tree="$release_directory" checkout "$commit" -- .
    [[ -f "$release_directory/scripts/apply-update.sh" && ! -L "$release_directory/scripts/apply-update.sh" ]] || fail 'The release applier is missing or unsafe.'
    "$BASH" "$release_directory/scripts/apply-update.sh" --project "$project_directory" \
        --from-version none "--$selection" "$reference" --commit "$commit"
    exit 0
fi
if git -C "$source_directory" cat-file -e "$commit:scripts/update.sh" 2>/dev/null; then
    fail 'The selected revision contains a launcher but no release applier.'
fi
printf 'The selected revision predates the updater; installing metadata only.\n'

version_json='null'
tag_json='null'
branch_json='null'
if [[ "$selection" == 'tag' ]]; then
    version_json=$(json_string "${reference#v}")
    tag_json=$(json_string "$reference")
else
    branch_json=$(json_string "$reference")
fi
timestamp=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
metadata_temporary_file=$(mktemp "$service_directory/.thesis-trail.XXXXXXXX")
printf '{
  "schema_version": 1,
  "repository": %s,
  "version": %s,
  "tag": %s,
  "branch": %s,
  "commit": %s,
  "installed_at": %s,
  "updated_at": %s
}\n' \
    "$(json_string "$repository")" \
    "$version_json" "$tag_json" "$branch_json" \
    "$(json_string "$commit")" \
    "$(json_string "$timestamp")" "$(json_string "$timestamp")" \
    > "$metadata_temporary_file"

# A hard link publishes the complete JSON without replacing an existing file.
if [[ -e "$metadata_file" || -L "$metadata_file" ]]; then
    fail 'Metadata appeared during installation; leaving it unchanged.'
fi
ln "$metadata_temporary_file" "$metadata_file" || fail 'Could not create metadata without overwriting an existing file.'
printf 'ThesisTrail initialized from %s %s (%s).\n' "$selection" "$reference" "$commit"
printf 'Metadata: %s\n' "$metadata_file"
