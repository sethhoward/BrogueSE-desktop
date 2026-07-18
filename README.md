Brogue SE — Desktop
===================

Desktop (Windows / Linux) builds of **Brogue SE** ("Seth's Edition"), the
firehose fork of Brogue CE that lives in the iOS/iPadOS/macOS app. This repo is a
thin **desktop platform layer** wrapped around the SE engine so it can be built
and played with a keyboard and mouse via SDL2 — no iOS app, no engine picker.

The SE engine itself is **not authored here**. It is vendored (copied) from the
`Brogue-iPad` repo, which is the single source of truth for all SE gameplay and
content. This repo only owns the desktop platform glue and the build/CI.


How it fits together
--------------------

Brogue SE was forked from Brogue CE and then heavily adapted for iOS. On iOS the
engine talks to a host bridge (`SEBridge.mm`) through a flat set of free
functions — `plotChar`, `nextKeyOrMouseEvent`, `pauseForMilliseconds`, high
scores, run history, file listing, haptics, and so on. That flat interface is
*identical* to the one upstream Brogue CE exposes from its own desktop platform
layer (`platformdependent.c` + `sdl2-platform.c`), which is why the SE engine
drops straight onto the CE desktop platform with only a small shim.

    src/brogue/          <- the SE engine, VENDORED from Brogue-iPad/BrogueSE/Engine
                            (synced by ./sync-se-engine.sh; never edit by hand)
    src/platform/
      main.c             <- entry point + CLI parsing (from Brogue CE)
      sdl2-platform.c    <- SDL2 rendering + input (from Brogue CE, unmodified)
      tiles.c/.h         <- tile-sheet / font rendering (from Brogue CE)
      platformdependent.c<- flat host funcs: scores, run history, files, keys (CE)
      platform.h         <- the brogueConsole interface (CE)
      null-platform.c    <- headless console (CE)
      PlatformDefines.h  <- desktop defines (NOT the SE engine's iOS copy)
      se-host-extras.c/.h<- the ONLY new code: desktop implementations of the
                            SE-specific host hooks the iOS bridge normally
                            provides (haptics/telemetry/geometry = no-ops; seed
                            persistence = a tiny prefs file)

The desktop build deliberately leaves `BROGUE_TABLET` undefined, so the engine's
`#ifndef BROGUE_TABLET` desktop code paths (keyboard/mouse main menu, hotkey
labels, etc.) are the ones that compile. There is no lineage/engine picker — that
lives in the iOS app layer, not the engine — so the game boots straight into
SE's own title screen.


Building
--------

Requires a C compiler, `make`, and SDL2 + SDL2_image.

**Linux**

    sudo apt install build-essential libsdl2-dev libsdl2-image-dev
    make bin/brogue
    ./brogue        # launcher: cd's into bin/ and runs ./brogue

**macOS** (local dev / smoke testing)

    brew install sdl2 sdl2_image
    make bin/brogue
    cd bin && ./brogue

**Windows** (MinGW, as the CI does it)

    .\.github\get-deps-mingw.ps1
    mingw32-make SDL_CONFIG='sdl2-config --prefix=/opt/local/x86_64-w64-mingw32' SYSTEM=WINDOWS CC=gcc bin/brogue.exe

Useful flags: `make -B ...` forces a rebuild; `make GRAPHICS=NO bin/brogue`
builds a headless binary (no SDL) — handy for validating the engine compiles and
links without a display.


Updating the vendored SE engine
-------------------------------

Whenever the SE engine changes in `Brogue-iPad`, re-sync and rebuild:

    ./sync-se-engine.sh                 # defaults to ../Brogue-iPad
    ./sync-se-engine.sh /path/to/Brogue-iPad
    make -B bin/brogue

`sync-se-engine.sh` copies `BrogueSE/Engine/*.c` and `*.h` into `src/brogue`,
records the source commit in `src/brogue/.se-engine-rev`, and **excludes** the
engine's `PlatformDefines.h` (its iOS copy hard-codes `BROGUE_TABLET=1` and an
`-ios` version suffix; the desktop copy in `src/platform` is used instead).

If a future SE change adds a new host hook, the desktop **link** will fail with
an undefined `ce…`/`se…` symbol — add a matching stub to `se-host-extras.c`
(and its prototype to `se-host-extras.h`).


Continuous integration
-----------------------

`.github/workflows/build.yml` builds two artifacts on every push (and on manual
dispatch):

  * **windows-x86_64** — `BrogueSE-windows-x86_64.zip` (primary target)
  * **linux-x86_64** — `BrogueSE-linux-x86_64.tar.gz`

The CI builds the **committed** `src/brogue`; it does not run the sync script, so
remember to sync + commit the engine before pushing a build.


Known gaps / follow-ups
-----------------------

  * **New SE glyphs in text mode.** SE added display glyphs (e.g. status-blink
    stars/hearts/shields, smoke, new altars). `glyphToUnicode()` in
    `platformdependent.c` is upstream CE's and doesn't map them yet, so they fall
    through to `'?'` in text mode. Extend that switch (and the `tiles.png` sheet
    for graphical mode) to render them. This is desktop-owned code, so it can be
    fixed without touching the engine.
  * **Graphical tiles.** Tile indices are derived from glyph enum values; SE's
    extended enum may need `tiles.png` / `tiles.bin` regenerated before TILES /
    HYBRID graphics modes look right. Text mode is unaffected.
  * **Saves are per-platform.** SE saves/recordings are input replays; desktop
    saves interchange across desktop builds but not with iOS unless the version
    string and glyph enum match exactly.

Brogue and Brogue CE are © their respective authors; see LICENSE.txt (GPLv3).
