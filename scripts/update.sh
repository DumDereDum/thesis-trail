#!/usr/bin/env bash
# Standalone release launcher; also supplies helpers to the release applier.
set -euo pipefail

tt_repository='https://github.com/DumDereDum/thesis-trail.git'
tt_tag_pattern='^v[0-9]+\.[0-9]+\.[0-9]+$'
tt_sha_pattern='^[0-9a-f]{40}([0-9a-f]{24})?$'
tt_workspace=''
tt_lock=''

tt_fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }

tt_dependencies() {
    local utility
    for utility in git mktemp mkdir rm date ln awk cp mv chmod cmp; do
        command -v "$utility" >/dev/null 2>&1 || tt_fail "Required command not found: $utility."
    done
}

tt_json_string() {
    local value=$1
    value=${value//\\/\\\\}
    value=${value//\"/\\\"}
    printf '"%s"' "$value"
}

# Parse the complete JSON document, retaining unknown fields and their values.
# Only top-level fields are read/replaced. No JSON content is evaluated as code.
tt_json() {
    TT_JSON_ACTION=$1 TT_JSON_KEY=${3:-} TT_JSON_VALUE=${4:-} awk '
    function invalid() { failed=1; exit 2 }
    function ws() { while (substr(doc,p,1) ~ /[ \t\r\n]/ && p<=length(doc)) p++ }
    function string( start,c,i) {
        start=p
        if (substr(doc,p++,1)!="\"") invalid()
        while (p<=length(doc)) {
            c=substr(doc,p++,1)
            if (c=="\"") return substr(doc,start,p-start)
            if (c ~ /[[:cntrl:]]/) invalid()
            if (c=="\\") {
                c=substr(doc,p++,1)
                if (c=="u") {
                    for (i=0;i<4;i++) if (substr(doc,p+i,1)!~/^[0-9a-fA-F]$/) invalid()
                    p+=4
                } else if (c !~ /^["\\\/bfnrt]$/) invalid()
            }
        }
        invalid()
    }
    function value(depth, c,token) {
        if (depth>64) invalid()
        ws(); c=substr(doc,p,1)
        if (c=="{") object(depth)
        else if (c=="[") {
            p++; ws()
            if (substr(doc,p,1)=="]") { p++; return }
            while (1) {
                value(depth+1); ws(); c=substr(doc,p++,1)
                if (c=="]") break
                if (c!=",") invalid()
            }
        } else if (c=="\"") token=string()
        else if (match(substr(doc,p),/^(true|false|null)/)) p+=RLENGTH
        else if (match(substr(doc,p),/^-?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)?/)) p+=RLENGTH
        else invalid()
    }
    function object(depth, key,start,finish,c) {
        p++; ws()
        if (substr(doc,p,1)=="}") { if (depth==0) closing=p; p++; return }
        while (1) {
            ws(); key=string(); ws()
            if (substr(doc,p++,1)!=":") invalid()
            ws(); start=p; value(depth+1); finish=p-1
            if (depth==0) {
                if (key in starts) invalid()
                starts[key]=start; ends[key]=finish; count++
            }
            ws(); c=substr(doc,p++,1)
            if (c=="}") { if (depth==0) closing=p-1; break }
            if (c!=",") invalid()
        }
    }
    { doc=doc $0 "\n" }
    END {
        if (failed) exit 2
        p=1; ws()
        if (substr(doc,p,1)!="{") invalid()
        object(0); ws()
        if (p<=length(doc)) invalid()
        action=ENVIRON["TT_JSON_ACTION"]; key="\"" ENVIRON["TT_JSON_KEY"] "\""
        if (action=="validate") exit 0
        if (action=="get") {
            if (!(key in starts)) exit 3
            print substr(doc,starts[key],ends[key]-starts[key]+1)
        } else if (action=="set") {
            replacement=ENVIRON["TT_JSON_VALUE"]
            if (key in starts) printf "%s%s%s",substr(doc,1,starts[key]-1),replacement,substr(doc,ends[key]+1)
            else printf "%s%s\n  %s: %s\n%s",substr(doc,1,closing-1),(count ? "," : ""),key,replacement,substr(doc,closing)
        } else invalid()
    }' "$2"
}

tt_json_set() {
    cp -p -- "$1" "$1.next"
    tt_json set "$1" "$2" "$3" > "$1.next" || tt_fail 'Could not prepare JSON metadata.'
    mv -f -- "$1.next" "$1"
}

tt_regular_or_absent() {
    [[ ! -L "$1" ]] || tt_fail "Symbolic links are not supported here: $1."
    [[ ! -e "$1" || -f "$1" ]] || tt_fail "Expected a regular file: $1."
}

tt_read_metadata() {
    local schema repository version tag branch commit timestamp
    tt_regular_or_absent "$tt_metadata"
    [[ -f "$tt_metadata" ]] || tt_fail 'ThesisTrail metadata is missing. Run the installer first.'
    tt_json validate "$tt_metadata" || tt_fail 'Invalid JSON metadata.'
    schema=$(tt_json get "$tt_metadata" schema_version) || tt_fail 'Missing metadata schema.'
    [[ "$schema" == 1 ]] || tt_fail "Unsupported metadata schema: $schema."
    repository=$(tt_json get "$tt_metadata" repository) || tt_fail 'Missing repository metadata.'
    [[ "$repository" == "\"$tt_repository\"" ]] || tt_fail 'Unexpected source repository in metadata.'
    version=$(tt_json get "$tt_metadata" version) || tt_fail 'Missing version metadata.'
    tag=$(tt_json get "$tt_metadata" tag) || tt_fail 'Missing tag metadata.'
    branch=$(tt_json get "$tt_metadata" branch) || tt_fail 'Missing branch metadata.'
    commit=$(tt_json get "$tt_metadata" commit) || tt_fail 'Missing commit metadata.'
    tt_current_commit=${commit#\"}; tt_current_commit=${tt_current_commit%\"}
    [[ "$tt_current_commit" =~ $tt_sha_pattern && "$commit" == "\"$tt_current_commit\"" ]] || tt_fail 'Invalid commit metadata.'
    tt_current_tag=''
    if [[ "$version" == null ]]; then
        [[ "$tag" == null && "$branch" == \"*\" && "$branch" != '""' ]] || tt_fail 'Invalid branch installation metadata.'
        tt_current_version='branch'; tt_current_label="branch $branch"
    else
        tt_current_tag=${tag#\"}; tt_current_tag=${tt_current_tag%\"}
        [[ "$tt_current_tag" =~ $tt_tag_pattern && "$tag" == "\"$tt_current_tag\"" && "$version" == "\"${tt_current_tag#v}\"" && "$branch" == null ]] || tt_fail 'Inconsistent release metadata.'
        tt_current_version=${tt_current_tag#v}; tt_current_label=$tt_current_tag
    fi
    for timestamp in installed_at updated_at; do
        timestamp=$(tt_json get "$tt_metadata" "$timestamp") || tt_fail 'Missing installation timestamp.'
        [[ "$timestamp" =~ ^\"[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z\"$ ]] || tt_fail 'Invalid installation timestamp.'
    done
}

tt_project_paths() {
    tt_service="$tt_project/.tt"; tt_metadata="$tt_service/thesis-trail.json"
    [[ ! -L "$tt_service" && ( ! -e "$tt_service" || -d "$tt_service" ) ]] || tt_fail '.tt must be a real directory.'
}

tt_acquire_lock() {
    mkdir -- "$tt_service/.update-lock" 2>/dev/null || tt_fail 'Another ThesisTrail operation holds .tt/.update-lock. Inspect a stale lock before removing it.'
    tt_lock="$tt_service/.update-lock"
}

tt_cleanup() {
    [[ -z "${tt_state_temporary:-}" ]] || rm -f -- "$tt_state_temporary" || :
    [[ -z "$tt_workspace" ]] || rm -rf -- "$tt_workspace" || :
    [[ -z "$tt_lock" ]] || rm -rf -- "$tt_lock" || :
}

tt_fetch() {
    local kind=$1 reference=$2 candidate
    tt_git="$tt_workspace/source.git"
    git init --bare --quiet "$tt_git"
    git -C "$tt_git" remote add origin "$tt_repository"
    export GIT_TERMINAL_PROMPT=0
    if [[ "$kind" == latest ]]; then
        git -C "$tt_git" fetch --quiet --depth=1 --tags origin || tt_fail 'Could not retrieve remote tags. Check network access.'
        git -C "$tt_git" for-each-ref --sort=refname --sort=-creatordate --format='%(refname:strip=2)' refs/tags > "$tt_workspace/tags"
        tt_target_tag=''
        while IFS= read -r candidate; do
            if [[ "$candidate" =~ $tt_tag_pattern ]]; then tt_target_tag=$candidate; break; fi
        done < "$tt_workspace/tags"
        [[ -n "$tt_target_tag" ]] || tt_fail 'No vX.Y.Z tags found.'
        tt_target_commit=$(git -C "$tt_git" rev-parse --verify "refs/tags/$tt_target_tag^{commit}") || tt_fail 'Selected tag does not point to a commit.'
    else
        git -C "$tt_git" fetch --quiet --depth=1 --no-tags origin "refs/tags/$reference" || tt_fail "Could not retrieve tag '$reference'."
        tt_target_tag=$reference
        tt_target_commit=$(git -C "$tt_git" rev-parse --verify 'FETCH_HEAD^{commit}') || tt_fail 'Selected tag does not point to a commit.'
    fi
    if [[ "$tt_target_tag" == "$tt_current_tag" && "$tt_target_commit" != "$tt_current_commit" ]]; then
        tt_fail "Tag $tt_target_tag has moved to another commit. Installation was not changed."
    fi
}

tt_export_release() {
    tt_release="$tt_workspace/release"
    mkdir -- "$tt_release"
    git --git-dir="$tt_git" --work-tree="$tt_release" checkout "$tt_target_commit" -- .
}

tt_print_notes() {
    local notes="$tt_workspace/CHANGELOG.md"
    if ! git -C "$tt_git" show "$tt_target_commit:CHANGELOG.md" > "$notes" 2>/dev/null; then
        printf 'Release notes are unavailable for %s.\n' "$tt_target_tag"
        return
    fi
    printf '\nChanges from the target release CHANGELOG.md:\n'
    TT_OLD_TAG=$tt_current_tag awk '
      /^## / {
        if (ENVIRON["TT_OLD_TAG"]!="" && $2=="[" ENVIRON["TT_OLD_TAG"] "]") exit
        started=1
      }
      started { print }
    ' "$notes"
}

tt_state_get() { git config --file "$tt_state" --get "$1" || [[ $? == 1 ]]; }

tt_state_set() {
    local staged
    staged=$(mktemp "$tt_service/.update-state.XXXXXXXX")
    tt_state_temporary=$staged
    if [[ -f "$tt_state" ]]; then cp -p -- "$tt_state" "$staged"; else : > "$staged"; fi
    git config --file "$staged" "$1" "$2" || { rm -f -- "$staged"; tt_fail 'Could not write update state.'; }
    mv -f -- "$staged" "$tt_state"
    tt_state_temporary=''
}

tt_usage() {
    printf '%s\n' 'Usage: update.sh [--check [--now] | --apply --tag vX.Y.Z | --dismiss --tag vX.Y.Z]' \
      '' 'Check at most once per 24 hours; --now checks immediately.' \
      'Applying requires an explicit tag. Agents must obtain user consent first.'
}

tt_main() {
    local mode='' tag='' now=0 script_directory script_path last_attempt epoch dismissed
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --check|--apply|--dismiss)
                [[ -z "$mode" ]] || tt_fail 'Choose one operation.'
                mode=${1#--}; shift ;;
            --tag)
                [[ -z "$tag" && $# -ge 2 ]] || tt_fail '--tag requires one value.'
                tag=$2; shift 2 ;;
            --now) [[ "$now" == 0 ]] || tt_fail 'Repeated --now.'; now=1; shift ;;
            -h|--help) tt_usage; return ;;
            *) tt_fail "Unknown argument: $1." ;;
        esac
    done
    mode=${mode:-check}
    if [[ "$mode" == check ]]; then
        [[ -z "$tag" ]] || tt_fail '--tag is only supported with --apply or --dismiss.'
    else
        [[ "$tag" =~ $tt_tag_pattern && "$now" == 0 ]] || tt_fail 'An exact vX.Y.Z tag is required; --now is only for checks.'
    fi
    tt_dependencies
    tt_project=$PWD
    script_path=${BASH_SOURCE[0]:-}
    if [[ -n "$script_path" ]]; then
        if [[ "$script_path" == */* ]]; then script_directory=${script_path%/*}; else script_directory=.; fi
        script_directory=$(cd -P -- "$script_directory" && pwd)
        if [[ "$script_directory" == */.tt ]]; then tt_project=${script_directory%/.tt}; fi
    fi
    tt_project_paths
    tt_read_metadata
    tt_state="$tt_service/update-state"
    tt_regular_or_absent "$tt_state"
    if [[ -f "$tt_state" ]]; then git config --file "$tt_state" --list >/dev/null || tt_fail 'Invalid update state.'; fi
    trap tt_cleanup EXIT
    trap 'exit 130' INT
    trap 'exit 143' TERM
    tt_acquire_lock
    if [[ "$mode" == dismiss ]]; then
        tt_state_set updates.dismissedTag "$tag"
        printf 'Deferred %s. Automatic checks will not offer this tag again.\n' "$tag"
        return
    fi
    if [[ "$mode" == check ]]; then
        epoch=$(date -u '+%s')
        last_attempt=$(tt_state_get updates.lastAttempt)
        [[ -z "$last_attempt" || "$last_attempt" =~ ^(0|[1-9][0-9]{0,11})$ ]] || tt_fail 'Invalid last-check time.'
        if [[ "$now" == 0 && -n "$last_attempt" && "$epoch" -ge "$last_attempt" && $((epoch-last_attempt)) -lt 86400 ]]; then
            printf 'Check skipped: the last attempt was less than 24 hours ago. Use --check --now for an explicit check.\n'
            return
        fi
        tt_state_set updates.lastAttempt "$epoch"
    fi
    tt_workspace=$(mktemp -d "${TMPDIR:-/tmp}/thesis-trail-update.XXXXXXXX")
    if [[ "$mode" == check ]]; then tt_fetch latest ''; else tt_fetch tag "$tag"; fi
    if [[ "$mode" == check ]]; then tt_state_set updates.lastCheckedAt "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"; fi
    printf 'Installed: %s (%s).\n' "$tt_current_label" "$tt_current_commit"
    if [[ "$tt_target_tag" == "$tt_current_tag" && "$tt_target_commit" == "$tt_current_commit" ]]; then
        printf 'Already installed: %s.\n' "$tt_target_tag"
        return
    fi
    if [[ "$mode" == check ]]; then
        dismissed=$(tt_state_get updates.dismissedTag)
        if [[ "$dismissed" == "$tt_target_tag" && "$now" == 0 ]]; then
            printf 'Latest tag %s was deferred; no update is being offered.\n' "$tt_target_tag"
            return
        fi
        printf 'Update available: %s (%s). User approval is required before applying.\n' "$tt_target_tag" "$tt_target_commit"
        tt_print_notes
        return
    fi
    tt_export_release
    [[ -f "$tt_release/scripts/apply-update.sh" && ! -L "$tt_release/scripts/apply-update.sh" ]] || tt_fail 'This release does not provide the update protocol.'
    # The release applier acquires its own lock. Releasing here does not change files;
    # the applier re-reads metadata and verifies the expected source version.
    rm -rf -- "$tt_lock"; tt_lock=''
    "$BASH" "$tt_release/scripts/apply-update.sh" --project "$tt_project" \
        --from-version "$tt_current_version" --tag "$tt_target_tag" --commit "$tt_target_commit"
    printf 'ThesisTrail updated: %s -> %s.\n' "$tt_current_label" "$tt_target_tag"
    tt_print_notes
}

if [[ -z "${BASH_SOURCE[0]:-}" || "${BASH_SOURCE[0]:-}" == "$0" ]]; then
    tt_main "$@"
fi
