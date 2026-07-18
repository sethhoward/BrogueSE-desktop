/*
 * se-host-extras.h — prototypes for the SE-only host hooks implemented in
 * se-host-extras.c.
 *
 * The SE engine declares these as inline `extern` statements at the top of the
 * .c files that call them (they are normally implemented by the iOS bridge). This
 * header collects matching prototypes so the desktop definitions compile cleanly
 * under -Wmissing-prototypes. Keep it in sync with the engine's extern decls; if
 * a build warns about a missing prototype for a new hook, add it here.
 */
#ifndef SE_HOST_EXTRAS_H
#define SE_HOST_EXTRAS_H

#include <stdint.h>
#include "Rogue.h"   // boolean

// In-process engine-switching flags (unused on desktop).
extern volatile boolean brogueCEAtTitle;
extern volatile boolean brogueSETerminationRequested;

// Persisted last seed.
uint64_t ceLoadPersistedSeed(void);
void cePersistLastSeed(uint64_t seed);

// Keyboard scheme / on-screen text input.
void cePersistKeyboardScheme(int scheme);
void ceRequestTextInput(const char *defaultText, boolean numeric);

// Haptics.
void cePlayDetectionHaptic(int stage);
void cePlayEnvironmentalNoiseHaptic(int kind);
void cePlayerTookDamage(int severity);

// Touch/geometry reporting.
void ceSetExamining(boolean examining);
boolean ceShouldSuppressExamineBox(void);
void ceSetExamineBox(short x, short y, short width, short height);
void ceSetMenuBox(short x, short y, short width, short height);
void ceClearMenuBox(void);
void ceSetPlayerWindowLocation(short windowX, short windowY);
void ceSetTargeting(boolean isTargeting);
void ceSetTravelPending(boolean pending);
void ceSetGameContext(short depth, unsigned long turn, uint64_t seed);

// Platform UI panels.
void ceShowFileManagement(void);
void ceShowGameCenter(void);

// Telemetry.
void seRecordExplorationStats(const char *header, const char *row);
void seRecordRestStats(const char *header, const char *row);

#endif // SE_HOST_EXTRAS_H
