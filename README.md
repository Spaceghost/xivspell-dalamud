# XivSpell / Grimoire

A native FFXIV spell-weaving HUD backed by Lua spellcards and a Neovim editor.
Type spell names to construct a queue, edit the cards as Lua programs, and inspect
the selected action before continuing playback. Includes an Arcanist starter
deck, a local runtime, optional voice input, and an additive MCP bridge.

Read [the user guide](doc/xivspell.txt) for controls, installation paths, runtime
setup and recovery. [The playtest handoff](doc/PLAYTEST.txt) records existing
evidence and the remaining player checks. Automatic following, healer behavior,
controller casting and duty completion are not established by offline tests.

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
A reverse pulse contracts toward a fixed target ring. Type when the rings meet.
Type **any spell** from your Lua deck, one character per pulse; there is no spell picker or prescribed sequence.
The upright word display shows your prefix and matching spells. Wrong letters,
off-beat characters, or a missed pulse during a word reset that entire word.
Empty pulses before starting a word are optional.

A complete unambiguous spell queues one rune and leaves spelling active for the
next spell. If a name is also the beginning of a longer spell, keep typing the
longer name or press **Enter** to queue the exact shorter name. Spaces inside
multiword names are timed characters too.

**Backspace** restarts an unfinished word. With an empty word it removes the
last queued spell; hold it to clear the queue. Visible **UNDO SPELL** and
**RESET WORD** buttons make those actions available without remembering keys.
Escape pauses, `i` resumes weaving, `>` casts and returns movement control,
and `.` repeats. Completion alone never casts.

Rhythm input is keyboard-only for now and takes no controller lease. A future
radial spelling selector, with hover or trigger confirmation, is deferred.
Normal non-rhythm controller composition remains available with rhythm off.

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

## Development

Changes integrate directly on `master` after checks. CI runs offline tests and
builds the plugin; it does not prove live gameplay behavior. Preserve the running
spell queue and editor buffers when installing updates. See [CHANGELOG.txt](CHANGELOG.txt)
for the implementation history.
