#!/usr/bin/env bash
#
# Sync the Brogue SE engine sources into this desktop build tree.
#
# Brogue SE lives in the Brogue-iPad repo (BrogueSE/Engine). It is the single
# source of truth for all SE gameplay/content; this desktop port never edits the
# engine. This script copies the engine .c/.h files into src/brogue so the
# desktop SDL platform layer (src/platform) can be compiled against them.
#
# Usage:  ./sync-se-engine.sh [path-to-Brogue-iPad-repo]
# Default source: ../Brogue-iPad
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
IPAD_REPO="${1:-$HERE/../Brogue-iPad}"
ENGINE_SRC="$IPAD_REPO/BrogueSE/Engine"
ENGINE_DST="$HERE/src/brogue"

if [ ! -d "$ENGINE_SRC" ]; then
    echo "error: SE engine not found at $ENGINE_SRC" >&2
    echo "       pass the path to your Brogue-iPad checkout as the first argument." >&2
    exit 1
fi

# The SE engine's source of truth is the REMOTE main branch of Brogue-iPad, not
# whatever the local checkout happens to be at (it can be behind). Fetch and verify
# before syncing so we never quietly vendor a stale engine. Set SE_SYNC_ALLOW_BEHIND=1
# to override (e.g. deliberately syncing a local WIP branch).
if git -C "$IPAD_REPO" rev-parse --git-dir >/dev/null 2>&1; then
    branch="$(git -C "$IPAD_REPO" rev-parse --abbrev-ref HEAD)"
    echo "Checking $IPAD_REPO is up to date with its remote ($branch)..."
    git -C "$IPAD_REPO" fetch --quiet origin 2>/dev/null || echo "  (warning: git fetch failed; proceeding with local state)"
    upstream="$(git -C "$IPAD_REPO" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || echo '')"
    if [ -n "$upstream" ]; then
        local_rev="$(git -C "$IPAD_REPO" rev-parse HEAD)"
        remote_rev="$(git -C "$IPAD_REPO" rev-parse "$upstream")"
        if [ "$local_rev" != "$remote_rev" ]; then
            behind="$(git -C "$IPAD_REPO" rev-list --count "HEAD..$upstream" 2>/dev/null || echo '?')"
            if [ "$behind" != "0" ]; then
                echo "WARNING: $IPAD_REPO ($branch) is BEHIND $upstream by $behind commit(s)." >&2
                echo "         You would be vendoring a stale engine. Pull first:" >&2
                echo "             git -C \"$IPAD_REPO\" pull --ff-only" >&2
                if [ "${SE_SYNC_ALLOW_BEHIND:-0}" != "1" ]; then
                    echo "         (set SE_SYNC_ALLOW_BEHIND=1 to sync anyway.)" >&2
                    exit 1
                fi
                echo "         SE_SYNC_ALLOW_BEHIND=1 set; syncing the local (behind) state anyway." >&2
            fi
        fi
    fi
fi

echo "Syncing SE engine:"
echo "  from $ENGINE_SRC"
echo "  to   $ENGINE_DST"

mkdir -p "$ENGINE_DST"
# Copy only the engine translation units + headers. Deletes stale files that no
# longer exist upstream (--delete), but never touches non-source files.
#
# PlatformDefines.h is deliberately EXCLUDED: the SE engine's copy hard-codes
# BROGUE_TABLET=1 (touch/tablet UI) and BROGUE_EXTRA_VERSION="-ios", which are
# wrong for a desktop build. The desktop copy in src/platform/PlatformDefines.h
# is used instead (no BROGUE_TABLET -> the engine's #ifndef BROGUE_TABLET desktop
# code paths activate), and BROGUE_EXTRA_VERSION is injected by the Makefile.
rsync -a --delete \
    --exclude='PlatformDefines.h' \
    --include='*.c' --include='*.h' --exclude='*' \
    "$ENGINE_SRC"/ "$ENGINE_DST"/

# Record the engine provenance so a desktop build can report which SE tree it came from.
if git -C "$IPAD_REPO" rev-parse --short HEAD >/dev/null 2>&1; then
    git -C "$IPAD_REPO" rev-parse --short HEAD > "$ENGINE_DST/.se-engine-rev"
fi

echo "done: $(ls "$ENGINE_DST"/*.c | wc -l | tr -d ' ') .c files, $(ls "$ENGINE_DST"/*.h | wc -l | tr -d ' ') .h files"
