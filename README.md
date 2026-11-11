# XivSpell / Grimoire

A native FFXIV spell-weaving HUD backed by Lua spellcards and a Neovim editor.
Type spell names to construct a queue, edit the cards as Lua programs, and inspect
the selected action before continuing playback. Includes an Arcanist starter
deck, a local runtime, optional voice input, and an additive MCP bridge.

Read [the user guide](doc/xivspell.txt) for controls, installation paths, runtime
setup and recovery. [The playtest handoff](doc/PLAYTEST.txt) records existing
evidence and the remaining player checks. Automatic following, healer behavior,
controller casting and duty completion are not established by offline tests.

While Grimoire is visible and live casting is enabled, it hides the game's own
player cast bar. Hiding Grimoire, using `/xivspell off`, or unloading the plugin
restores that bar. Enemy cast bars and your saved HUD layout are preserved.

## Build and check

Requires Python 3, Neovim 0.11 or newer, and .NET SDK 10.0.401. The plugin uses
Dalamud API 15 and the committed NuGet lock file. Supply your reviewed reference
assemblies through `DALAMUD_HOME`; no game installation is included here.

```sh
tools/test.sh
DALAMUD_HOME=/path/to/Dalamud dotnet build plugin/XivSpell.csproj -c Release -p:RestoreLockedMode=true
tools/package.sh
```

`tools/test.sh --lsp` also starts the real Lua language server. Install LuaLS at
`~/.local/share/xivspell/luals/bin/lua-language-server` for that check.
The package command writes the native plugin ZIP and a separate companion-source
archive under `release/`. It never installs or reloads a running plugin.

The native plugin needs the companion Lua runtime and local bridge. Start the
editor with `tools/play`; adapt the example user services to your checkout path.
Optional speech recognition needs a separately installed local Whisper server
and model. Do not copy another player's configuration or credentials.

## Rhythm weaving

`/xivspell rhythm on` opens **Spellstrings** in the existing native spell HUD.
A small reverse-pulse sigil sits beside the word in Grimoire’s existing rune HUD.
Type while the pulse is inside its shaded safe zone. The gold ring marks perfect
timing; the whole shaded annulus reflects the actual accepted timing window.
Type **any spell** from your Lua deck, one character per pulse; there is no spell picker or prescribed sequence.
The upright word display shows your prefix and matching spells. Wrong letters,
off-beat characters, or a missed pulse during a word reset that entire word.
Empty pulses before starting a word are optional.

A complete unambiguous spell queues one rune and leaves spelling active for the
next spell. If a name is also the beginning of a longer spell, keep typing the
longer name or press **Enter** to queue the exact shorter name. Spaces inside
multiword names are timed characters too.

Targets are part of the rhythm phrase: type **`tank physick`**, **`party2 physick`**,
**`focus physick`** or **`self physick`**, including the space on a pulse. The entire
phrase queues one spell with that target attached. **`on tank physick`** also works.
Target prefixes work with spell ids and shortcuts too, such as `self sc`.
A mistake or Backspace resets the whole phrase, including the target. Nothing
is selected or queued from the target word alone.

**Backspace** restarts an unfinished word. With an empty word it removes the
last queued spell; hold it to clear the queue. Visible **UNDO SPELL** and
**RESET SPELL** buttons make those actions available without remembering keys.
Escape pauses, `i` resumes weaving, `>` casts and returns movement control,
and `.` repeats. Completion alone never casts.

Rhythm input is keyboard-only for now and takes no controller lease. A future
radial spelling selector, with hover or trigger confirmation, is deferred.
Normal non-rhythm controller composition remains available with rhythm off.

For playback in either mode, hold **R2** and tap **X / Cross** to repeat (`.`),
or **O / Circle** to continue (`>`). The controller wheel does not need to be
open. Each face-button press runs once; holding it does not repeat the command.

Piano's optional `XivPiano.RhythmTimeline.v1` feed supplies up to 30 seconds of
future song onsets from a separate background decode of its downloaded song.
The chart uses those future timings when enough pulses are available; an
approach ring uses the upcoming song timestamp for each pulse.
These are measured energy onsets, not pitch transcription or guaranteed musical
beats. A missing/unfinished map uses a clearly labelled tempo guide. Piano's
`AudioFeatures.v1` feed still supplies live energy and a beat estimate.

For game music, select GUIDE and tap the native **TAP** button, or set
`/xivspell rhythm tempo 120`. Other tuning commands are `rhythm offset 100`
(milliseconds), `rhythm speed 1` or `2`, `rhythm sound on|off`, and `rhythm volume
0.1`. Quiet synthesized plucks mix through the default output without changing
music playback or volume. Use `/xivspell rhythm off` for normal spell weaving.

Casting remains a separate explicit command; musical input cannot cast a spell
or move the character. Focus loss, cutscenes and other text input pause the round.
The existing queue and casting/control mode are preserved across plugin reloads.

## Aiming spells

Physick heals the living friendly player or teammate you have selected, falling
back to yourself when an enemy or no friendly is selected.

In rhythm mode, type the target first as part of the spell: **`tank physick`**
heals a party tank; **`party2 physick`** heals party slot 2. You stay in rhythm
spelling throughout. The target stays attached to that rune through repeat and
reload; the next plain `physick` uses its normal friendly/self default. Targets
include `tank1`, `tank2`, `healer`, `party1`–`party8`, `focus`, `self`, `lowest`,
`enemy`, `nearest`, `mob`, `boss` and the other spell-language selectors.

The optional **TARGET** button or `/xivspell targets` also aims the next
completed spell. The picker works during ordinary and rhythm spelling. Choose a
named party slot, **FOCUS**, **TANK**, **LOWEST HP**, **NEAREST ENEMY**, **TRASH / ADD**,
or **BOSS**, then spell normally. With the picker open, keys **1–8** choose party
slots; **T** chooses a living party tank. **Esc** closes the picker and stops.
The choice stays on that queued rune; the next word uses its own default.
Choosing a target never casts. The picker pauses an unfinished rhythm word and
resumes it with a fresh approach after your choice.

For a mixed queue, choose your teammate's party button and spell Physick, then
choose an enemy aim and spell Ruin. Press `>` when ready. These party/focus
heals do not change your selected enemy. **FOCUS SELECTED** pins your current
teammate as focus; **SELECT ENEMY** selects the closest living hostile without
casting. **MARK BOSS** marks your selected enemy so **BOSS** and **TRASH / ADD**
can address the boss and other enemies separately. Explicitly aimed attacks may
hit adds while retaining the selected encounter; losing that encounter still
requires explicit continuation.

Ordinary weaving also accepts `on party2 physick`, `on focus physick`,
`on lowest physick`, `on targetOfTarget physick`, `on nearest ruin`, and
`on boss ruin`, followed by Enter. In rhythm mode, type the same phrases on the
pulses. A target typed into the spell takes priority over a picker choice.
Neovim's `:SpellTarget party2` and MCP's `spellbook_target` prepare the same
one-spell aim. Party/focus/nearest selectors resolve when the rune casts; use a
party or focus choice for a mixed queue instead of relying on the current
selection remaining unchanged.

## Development

Changes integrate directly on `master` after checks. CI runs offline tests and
builds the plugin; it does not prove live gameplay behavior. Preserve the running
spell queue and editor buffers when installing updates. See [CHANGELOG.txt](CHANGELOG.txt)
for the implementation history.
