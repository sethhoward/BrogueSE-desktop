include config.mk

cflags := -Isrc/brogue -Isrc/platform -std=c99 \
	-Wall -Wpedantic -Werror=implicit -Wno-parentheses -Wno-unused-result \
	-Wformat -Werror=format-security -Wformat-overflow=0 -Wmissing-prototypes
libs := -lm
cppflags := -DDATADIR=$(DATADIR)

# SE desktop shim defines. The SE engine gates several symbols on BROGUE_TABLET
# (its iOS build flag, which we intentionally leave undefined so the engine's
# desktop code paths compile). One of them, HARDWARE_KEYBOARD_CONNECTED, is read
# ungated in RogueMain.c to decide whether to show the "Press <?> for help" hint;
# on desktop a hardware keyboard is always present, so define it to true.
cppflags += -DHARDWARE_KEYBOARD_CONNECTED=true

# Brogue SE is a single-variant engine (GlobalsBase + GlobalsBrogue), so there is
# no src/variants tree; the variant globals live in src/brogue alongside the rest
# of the engine (synced from Brogue-iPad/BrogueSE/Engine by sync-se-engine.sh).
# se-host-extras.c supplies the SE-only host hooks that the iOS bridge normally
# provides (haptics/telemetry/geometry no-ops + seed persistence).
sources := $(wildcard src/brogue/*.c) $(addprefix src/platform/,main.c platformdependent.c null-platform.c se-host-extras.c)
objects :=

ifeq ($(SYSTEM),WINDOWS)
objects += windows/resources.o
.exe := .exe
endif

ifeq ($(SYSTEM),OS2)
cflags += -march=pentium4 -mtune=pentium4 -Zmt -Wno-narrowing
cppflags += -D__ST_MT_ERRNO__
libs += -lcx -lc -Zomf -Zbin-files -Zargs-wild -Zargs-resp -Zhigh-mem -Zstack 8000
objects += os2/icon.res os2/brogue.lib
.exe := .exe
endif

ifeq ($(RELEASE),YES)
extra_version :=
else
extra_version := $(shell bash tools/git-extra-version)
endif

ifeq ($(TERMINAL),YES)
sources += $(addprefix src/platform/,curses-platform.c term.c)
cppflags += -DBROGUE_CURSES
libs += -lncurses
ifeq ($(SYSTEM),OS2)
libs += -ltinfo
endif
endif

ifeq ($(GRAPHICS),YES)
sources += $(addprefix src/platform/,sdl2-platform.c tiles.c)
cflags += $(shell $(SDL_CONFIG) --cflags)
cppflags += -DBROGUE_SDL
libs += $(shell $(SDL_CONFIG) --libs) -lSDL2_image
endif

ifeq ($(WEBBROGUE),YES)
sources += $(addprefix src/platform/,web-platform.c)
cppflags += -DBROGUE_WEB
endif

ifeq ($(RAPIDBROGUE),YES)
cppflags += -DRAPID_BROGUE
endif

ifeq ($(MAC_APP),YES)
cppflags += -DSDL_PATHS
endif

ifeq ($(DEBUG),YES)
cflags += -g -Og
cppflags += -DENABLE_PLAYBACK_SWITCH
else
cflags += -O2
endif

# Add user-provided flags.
cflags += $(CFLAGS)
cppflags += $(CPPFLAGS)
libs += $(LDLIBS)

objects += $(sources:.c=.o)

include make/*.mk
.DEFAULT_GOAL := bin/brogue$(.exe)

clean:
	$(warning 'make clean' is no longer needed in many situations, so is not supported. Use 'make -B' to force rebuild something.)

escape = $(subst ','\'',$(1))
vars:
	mkdir -p vars
# Write the value to a temporary file and only overwrite if it's different.
vars/%: vars FORCE
	@echo '$(call escape,$($*))' > vars/$*.tmp
	@if ! cmp --quiet vars/$*.tmp vars/$*; then cp vars/$*.tmp vars/$*; fi


FORCE:
