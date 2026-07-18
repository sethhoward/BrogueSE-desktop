/*
 * se-host-extras.c — desktop implementations of the Brogue SE host hooks.
 *
 * The SE engine (src/brogue, synced from Brogue-iPad/BrogueSE/Engine) shares the
 * flat platform interface that upstream BrogueCE exposes via platformdependent.c
 * + sdl2-platform.c (plotChar, nextKeyOrMouseEvent, pauseForMilliseconds, high
 * scores, run history, file listing, controlKeyIsDown/shiftKeyIsDown,
 * isApplicationActive, ...). Those are reused verbatim.
 *
 * On top of that, SE was iOS-ified and added a handful of host hooks that the
 * iOS bridge (SEBridge.mm) implements: haptics, telemetry, on-screen keyboard,
 * menu/examine-box geometry reporting, Game Center / file-management UI, and the
 * in-process engine-switching flags. None of those apply to a standalone desktop
 * build, so they are inert here — the engine keeps its keyboard/mouse behavior.
 *
 * Seed persistence IS implemented (a one-line prefs file) so "New Seeded Game"
 * pre-fills the last seed across launches, matching the iOS affordance.
 *
 * If a future SE change adds a new host hook, the desktop link will fail with an
 * undefined symbol; add the matching stub here.
 */

#include <stdio.h>
#include <stdint.h>
#include "platform.h"
#include "GlobalsBase.h"
#include "se-host-extras.h"

// --- In-process engine-switching flags -------------------------------------
// On iOS these coordinate handing the screen back and forth between the Classic,
// CE, and SE engines running in one process. There is no engine switching on
// desktop, so termination is never requested and the "at title" state is unused.
volatile boolean brogueCEAtTitle = false;
volatile boolean brogueSETerminationRequested = false;

// --- Persisted last seed ----------------------------------------------------
// Stored in the current working directory (the save directory), mirroring how
// high scores / run history are stored by platformdependent.c.
#define SE_LAST_SEED_FILE "seLastSeed.txt"

uint64_t ceLoadPersistedSeed(void) {
    FILE *f = fopen(SE_LAST_SEED_FILE, "r");
    if (!f) return 0;
    unsigned long long seed = 0;
    if (fscanf(f, "%llu", &seed) != 1) seed = 0;
    fclose(f);
    return (uint64_t) seed;
}

void cePersistLastSeed(uint64_t seed) {
    FILE *f = fopen(SE_LAST_SEED_FILE, "w");
    if (!f) return;
    fprintf(f, "%llu\n", (unsigned long long) seed);
    fclose(f);
}

// --- Keyboard scheme --------------------------------------------------------
// SE supports two hardware-keyboard layouts (enum keyboardScheme): CLASSIC
// (vi-keys) and MODERN (a right-hand u/i/o, j/k/l, m/,/. movement grid). The
// engine toggles between them from the in-game help screen (press '?' then TAB)
// and persists the choice via cePersistKeyboardScheme(). Mirror the iOS build by
// persisting to a prefs file so the choice survives across launches; main.c reads
// it back at startup via seLoadPersistedKeyboardScheme().
#define SE_KEYBOARD_SCHEME_FILE "seKeyboardScheme.txt"

void cePersistKeyboardScheme(int scheme) {
    FILE *f = fopen(SE_KEYBOARD_SCHEME_FILE, "w");
    if (!f) return;
    fprintf(f, "%d\n", scheme);
    fclose(f);
}

int seLoadPersistedKeyboardScheme(void) {
    FILE *f = fopen(SE_KEYBOARD_SCHEME_FILE, "r");
    if (!f) return 0; // KEYBOARD_SCHEME_CLASSIC
    int scheme = 0;
    if (fscanf(f, "%d", &scheme) != 1) scheme = 0;
    fclose(f);
    if (scheme < 0 || scheme >= KEYBOARD_SCHEME_COUNT) scheme = 0;
    return scheme;
}

// --- On-screen text input ---------------------------------------------------
// iOS pops a soft keyboard here and feeds characters back asynchronously. On
// desktop the engine's own inline getInputTextString() reads keystrokes straight
// from SDL, so there is nothing to do.
void ceRequestTextInput(const char *defaultText, boolean numeric) {
    (void) defaultText; (void) numeric;
}

// --- Haptics (no vibration motor on desktop) --------------------------------
void cePlayDetectionHaptic(int stage) { (void) stage; }
void cePlayEnvironmentalNoiseHaptic(int kind) { (void) kind; }
void cePlayerTookDamage(int severity) { (void) severity; }

// --- Touch/geometry reporting (used by the iOS overlay UI) ------------------
void ceSetExamining(boolean examining) { (void) examining; }
// iOS suppresses the examine box while a touch overlay covers it; on desktop the
// box should always show, so never suppress.
boolean ceShouldSuppressExamineBox(void) { return false; }
void ceSetExamineBox(short x, short y, short width, short height) {
    (void) x; (void) y; (void) width; (void) height;
}
void ceSetMenuBox(short x, short y, short width, short height) {
    (void) x; (void) y; (void) width; (void) height;
}
void ceClearMenuBox(void) {}
void ceSetPlayerWindowLocation(short windowX, short windowY) {
    (void) windowX; (void) windowY;
}
void ceSetTargeting(boolean isTargeting) { (void) isTargeting; }
void ceSetTravelPending(boolean pending) { (void) pending; }
void ceSetGameContext(short depth, unsigned long turn, uint64_t seed) {
    (void) depth; (void) turn; (void) seed;
}

// --- Platform UI panels -----------------------------------------------------
void ceShowFileManagement(void) {}
void ceShowGameCenter(void) {}

// --- Telemetry (iOS records rest/exploration stats) -------------------------
void seRecordExplorationStats(const char *header, const char *row) {
    (void) header; (void) row;
}
void seRecordRestStats(const char *header, const char *row) {
    (void) header; (void) row;
}
