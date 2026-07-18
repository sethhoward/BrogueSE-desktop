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
