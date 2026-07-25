# Brogue SE — Changelog

Release notes for **Brogue SE**, a fork of Brogue CE with original items, monsters,
and mechanics. The gameplay engine is vendored from
[Brogue-iPad](https://github.com/sethhoward/Brogue-iPad) (`BrogueSE/Engine`) and is
shared with the iOS/iPadOS/macOS app; the entries below consolidate the SE gameplay
releases shown on the in-game "About Brogue SE" screen.

Changes specific to this Windows/Linux desktop build (the SDL platform layer) are
listed separately under [Desktop port](#desktop-port) at the end.

---

## 0.12.3 — Reward-room fix

*Keeps altar and treasure rooms from handing you a downgrade.*

### 🩹 Fixes
- **No more negative-enchant gear in reward rooms** — The cursed-runics rework split negative weapons and armor into two kinds: a welded runic curse and a plain "inferior" item that carries a negative enchant but isn't flagged cursed. Reward rooms (altars, treasure rooms) only screened out the flagged-cursed kind, so the inferior negatives could slip through and land on a reward pedestal. Those rooms now reject any negatively-enchanted item, so a reward is always neutral-or-better.

---

## 0.12.2 — "Sharper Ears"

*Fixes the save/replay desync from last release's rest-listening, and lets a few
staff bolts leave a mark on the ground they streak across.*

### 🔥 Staff Trails
- **Bolts leave a trail** — A staff's bolt now leaves cosmetic residue on the bare ground it streaks across: firebolt scorches a fading line of embers to ash, poison lays a lingering acid puddle, and frost rimes the floor with a delicate frost that thaws away over time. Purely visual — it skips water, chasms, and grass, and doesn't change how the bolt plays.

### 🩹 Fixes
- **No more "out of sync" after resting near danger** — The wake-on-hearing roll added in 0.12.1 was drawn slightly differently while you played than when a save or recording replayed it, so resting within earshot of an unseen hostile could throw a playback-out-of-sync error on load or when watching a recording. The roll now behaves identically live and on replay, whether you tapped a single rest or held one down.

---

## 0.12.1 — "Sharper Ears"

*Teaches the dungeon to break your rest the moment you hear something coming,
sharpens last release's curses, and smooths the camera.*

### 🔊 Sharper Ears
- **Rest with one ear open** — Resting (`Z`) now snaps you awake the moment you hear a hostile creature's footsteps closing in, with a message, a ripple, and a pulse that scale to how loud and how near it is. You get one such wake per creature, so pressing on past a warning is an informed gamble.
- **No more resting yourself to death by earshot** — Fighting you can hear off in the distance no longer jolts you awake turn after turn: the first sound interrupts, then it quiets until you move again.
- **Thicker walls, muffled sound** — Noise now carries a little more distinctly through closed doors, so listening at one tells you more about what's on the other side.

### 🔮 Curses, Sharpened
- **No more penalty tax** — A cursed runic now starts at a clean +0 instead of a negative, so from the very first swing it's purely about the trade-off, never a dead stat loss you're digging out of.
- **Cheaper to purify armor** — Cleansing a cursed runic off your armor now takes one fewer enchant scroll, making the "keep it and purify" path a little more reachable.

### 🎮 Quality of Life
- **Smoother camera** — With zoom active, the view now glides to follow you instead of snapping a step at a time; true trips between floors still cut cleanly.
- **Quieter bottle captures** — Filling the empty bottle no longer flashes the identify star — it's a deliberate act, and the capture message already names what you scooped up.

---

## 0.12.0 — "C is for Curses"

*Turns cursed gear from a dead end into a decision — a cursed runic now pairs a real,
always-on power with its bite — and adds a shrine that will identify your pack, if you
dare wake what guards it.*

### 🔮 Cursed Runics, Reworked
- **A curse is a bargain, not a trap** — A cursed runic now grants a genuine, always-on power alongside its drawback, welded to you until you deal with it. Every downside has a counter you can lean into, so keeping a cursed item can be the smart play. all old armor/weapon cursed runics have been removed and initial negative enchant is locked to -1. 
- **Two ways to break the weld** — Pour enchant scrolls in to the purify threshold and the drawback burns away while the power stays (weapons at +6, armor at +4); or read remove-curse to pry it off early, drawback and all.
- **Maddening, reckless, and clumsy blades** — Delirium confounds what you strike but leaves you hallucinating; Recklessness trades the damage you take for the damage you deal; a Clumsy blade fumbles and stuns you — until you purify it into a true executioner's blade.
- **Anchor, Smoky, and Acrophobia armor** — Anchor steels your defense but drags your step (purify to stand immovable); Smoky armor wraps you in concealing haze at the cost of your own sight (purify for a quiet stealth aura); Acrophobia makes you fearless of pits but dizzy at their edge.

### 🗿 Altars of Divination
- **Reveal your unknowns** — A new shrine replaces the Altar of Insight, watched over by a looming statue, fully identifies any unidentified item you set on one of its altars — and the first one is always safe.
- **Press your luck** — Each further item you reveal risks waking the statue's guardian, and the greedier you get the deadlier it is: take what you dare.

### 🎣 Cleaner Distractions
- **Thrown lures buy real time** — A monster that goes to investigate a thrown item now lingers over it for a few turns before losing interest, opening a genuine window to slip past.

### 🗺️ Terrain
- **Mud and bog slow you down** — Slogging through the mire now costs extra movement, for you and monsters alike. Fighting is unaffected — you can swing at full speed, you just can't maneuver — and anything flying or levitating floats over it. Lure fast enemies in, but mind that you're slowed there too. A fleeing bog monster loses its home-turf advantage in the mire.
- **Traps hint at their surroundings** — Confusion traps now sometimes sit amid a soft patch of glowing fungus, joining fire-traps-in-grass and caustic-traps-in-bones.

### 👁️ Tells & Legibility
- **Poison, at a glance** — Poisoned creatures — you included — now show a sickly green tint and a pulsing skull, so you can read the affliction across the room.
- **Passive-event star bursts** — A color-coded star bursts over you the moment a passive item event lands, and its log line shares the color so you learn the cue: gold for something identified, red for a curse revealed on equip, green for a cursed runic purified, cyan for a spent staff or charm coming back to life.

### 🎮 Quality of Life
- **Fire no longer rattles you** — Catching fire used to throw you into a brief panic; now that disorientation strikes only monsters. It still burns — but your wits, and your next move, stay yours.
- **Study a scroll even while hunted** — Sitting down to a meal always lets you puzzle out an unidentified scroll now, even with something on your trail; the old "only when nothing's hunting you" restriction is gone.

---

## 0.11.0 — "B is for Balance"

*Retuned the arsenal — heavier trade-offs on weapons, staffs, and rings, with clearer
status tells to read the fight at a glance.*

### ⚖️ Balance Pass
- **Broadsword & war axe, soft-capped** — The two late-game staples no longer scale forever: enchanting pays full value only through +10, and each point beyond returns about a quarter of its old kick. Still top-tier, no longer an automatic win.
- **War pike, slowed** — The pike's strength was always its throughput — reach-2 and a thrust that pierces a whole line — so it now takes twice as long to recover after each attack. Trade tempo for that reach.
- **Flail, less of a lawnmower** — The flail's signature hits on enemies you sweep past while moving now land for half damage, so wading through a crowd isn't free.
- **Bare-knuckle scaling** — Unarmed attacks now grow with your strength, so being caught between weapons isn't hopeless.
- **Staffs come into their own** — Lightning and firebolt get a real power bump once enchanted to +5 and beyond, rewarding committing to a single staff or a hybrid heavy-weapon-and-stave approach.
- **Ring of Transference, reworked** — It now drains life from whatever you strike and bleeds a share of your own harmful afflictions onto the target — turning your suffering against your enemy.

### 💨 Smoke & Terrain
- **Where there's fire, there's smoke** — Burning terrain now breathes a vision-obscuring haze that drifts and thins over time, so a blaze can blind as much as it burns.
- **Traps suit their surroundings** — Fire traps nestle in dry grass, caustic traps among scattered bones — the dungeon hints at what's waiting.
- **Douse the burning** — Fiery creatures are snuffed out by water or frost, so the right element can put out a walking bonfire.

### 👁️ Tells & Legibility
- **Read the battlefield** — A small glyph now blinks over any creature (and you) that's confused, burning, stunned, protected, hasted, or healing, so you can size up the situation.
- **Clairvoyance reads the floor** — On arriving at a new depth, a worn Ring of Clairvoyance senses whether items on the level are helpful or harmful — as many as the ring's enchant level.
- **A sharper ear** — The noise system is clearer: a pack raises a rallying cry when one of them rouses the others, submerged creatures fall silent, and close threats are easier to hear.

---

## 0.10.0 — "A Is For AAaAH!"

*The sound update — the dungeon learned to hear you, and you learned to hear it.*

### 🔊 The Dungeon Can Hear You
- **Make noise, get noticed** — Footsteps, fighting, and the terrain you cross all send sound rippling through the dungeon. It bends around corners and muffles through closed doors, so unseen monsters can now hear you coming and slip away to investigate the racket.
- **Every weapon has a voice** — A dagger is nearly silent; a war hammer is a clamor. Light armor and wading keep you quiet, while heavy armor and crunching over rubble give you away.
- **Hear what you can't see** — When something stirs off-screen, a ripple shows roughly where it was, and a "?" marks a creature that heard you and is closing in. Stay still and it may pass; bolt and you'll draw a crowd.
- **A louder world** — Traps click, reward-room cages slam and machinery grinds, stone guardians boom with every step, and an alarm trap's shriek now echoes across the entire floor.
- **Throw to distract** — Hurl an item to lure investigating monsters to where it lands. The catch: the distraction is consumed when they arrive, so every diversion costs you the item.
- **The Ring of Awareness now hears, too** — Once just a sense for traps, secret doors, and hidden levers, it now also sharpens your ears: you catch unseen creatures stirring nearby, and the more powerful the ring, the farther off — and more reliably — you hear them. (Cursed rings dull your hearing instead.)

### 🐺 Lone Wolf
- **Go it alone** — Adventuring with no allies builds Lone Wolf tiers (up to five), each hardening you with extra effective strength. Take on a single companion and the bond breaks, resetting the track — the dungeon rewards the truly solitary.

### 🎮 Quality of Life
- **Re-zap your last staff** — Press "A" (modern keyboard layout) or set it to a quick action button to re-apply the staff you used last, mirroring re-throw.
- **Quiet, please** — A new menu toggle hides your own sound-ripple animation while leaving every other noise effect intact.
- **OS-proof saves** — If iOS kills the app while it's in the background, your run reloads right where you left off.
- **iPhone haptics** — Feel a pulse when something hears you, and a heavier thump when a loud event goes off.
- **Refined identification** — Detect magic and resting now surface the items you still haven't figured out first before fully identifying ones you already know polarity, and a worn Ring of Wisdom learns your armor and rings faster.

---

## 0.9.0 — "Alphabet-a Soup"

*The first Brogue SE release, which introduced original items, monsters, and mechanics.*

### 🧪 New Items
- **The Empty Bottle** — Carry it and the world fills it: step into a gas or pool to bottle it, drift over lava or a chasm while levitating to skim it, or set it down and zap it with a bolt. Each capture becomes a real, identified potion.
- **Captured potions** — Acid, webbing, steam, ice, and water can only be obtained by capturing hazards with the empty bottle. Each one re-creates its hazard when thrown.
- **Staff of Frost** — Freeze enemies solid, slow them, freeze water into walkable ice bridges, turn foliage into brittle frozen walls, and shove foes back — moving them out of your way and damaging enemies in their path.

### 👹 Monsters & Allies
- **The Gold Goblin** — A skittish treasure-hoarder that flees toward the stairs, scattering a trail of gold. Chase it down and corner it before it escapes to the next floor.
- **Cleverer thieves** — Monkeys and imps now target the items they actually covet, not just whatever's handy.
- **Better allies** — Allies keep a safe distance from invulnerable monsters, and the Ring of Light can rally and embolden the companions fighting beside you.

### 🔍 A New Way to Identify Items
- **Rest to learn** — Resting gradually reveals whether your unidentified items are helpful or harmful.
- **Clues add up** — Gather enough hints about an item — or rule out enough of the alternatives — and the dungeon puts it together for you, identifying it outright.
- **Detect magic, reined in** — The potion of detect magic now only hints at the good-or-bad nature of a couple of items instead of all, and turns up less often than before. But pair it with a Ring of Wisdom and the potion becomes stronger.
- **Altars of Insight** — Sacrifice one item to reveal the nature of another.
- **Everyday tells** — Eating a meal, watching a scroll burn, shattering a potion with a thrown weapon or a bolt, freeing a captive, and the rings of awareness and wisdom all quietly reveal clues about what you're carrying.

### 🌊 The Living Dungeon
- **Electrified water** — A lightning bolt striking a pool now shocks the entire connected body of water. Mind where you stand.
- **Water has uses** — Wading washes away the scent trail you leave for hunters and douses flames.
- **Fire spreads consequences** — Catching fire sends you into a brief panic; food rations caught in fire cook into edible "cooked food."
- **Read the chase** — You can now sense when a pursuing monster has lost your trail.

### 🎮 Quality of Life
- Potions float away when thrown into deep water.
- **Pick your controls** — Choose between Classic and Modern keyboard layouts; the game adapts when a hardware keyboard is attached.
- **Pick up where you left off** — Your last-played seed is remembered across launches.
- **Smoother and more stable** — Numerous community bug fixes, from dungeon-generation quirks to combat, stealth, and identification edge cases (#766, #805, #812, #816, #831, #837, #841).
- ...and so much more.

---

## Desktop port

Changes specific to this Windows/Linux SDL build. The SE gameplay above is shared
with the Apple app; these are the platform-layer additions that make it run on the
desktop. See the [README](README.md) for details.

- **Standalone SDL2 build** of the SE engine (Windows + Linux) with no iOS app and no
  engine picker — boots straight into SE's own title screen. GitHub Actions builds
  Windows and Linux artifacts on every push.
- **Keyboard layouts** — desktop defaults to the Modern (u/i/o-j/k/l grid) layout;
  Classic (vi-keys) is still available via `--keys classic` at launch or `?`+Tab
  in-game, and the choice persists across launches. In-play prompts show the active
  layout's key hints. The active scheme is applied when the engine consumes a key
  (keyed on its text-input context), so menu hotkeys like the title screen's `n`
  (New Game) work regardless of layout.
- **Status-blink glyphs** — the ★ paralyzed, ♥ healing, ◈ protected, ☠ poisoned, and
  ¿ confused overlays render in every graphics mode (drawn into the SDL font sheet).
- **Cosmetic animation layer** — status blinks, noise-system ripples, star ripples,
  and dash trails animate on desktop (the cosmetic animator is pumped from the SDL
  idle loop, mirroring the Apple host) at 60 Hz, so they run at the same speed as on
  iOS (the idle tick was ~28 Hz, which made these animations ~2× too slow).
- **Vendored engine** kept in sync with Brogue-iPad `main` via `sync-se-engine.sh`,
  which refuses to vendor a stale engine.
