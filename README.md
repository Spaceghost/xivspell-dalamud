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
Two perspective lanes approach from the distance: left and right. Keyboard notes
show the exact letter at its hand/column position; controller notes show the
D-pad direction on the left or face button on the right, with the letter it types.
Each complete spell queues one rune. Misses retain the untyped letter.

For controllers use `/xivspell rhythm pad`: both sticks weave/pause, L1/R1 choose
a spell, R3 casts and releases movement, and L3 repeats. The eight button choices
come from available spell-name completions, with distinct decoys filling spare
buttons. Keyboard mode uses `>` to cast and move, `.` to repeat, `i` to weave
another, and Escape to pause. Native buttons also choose spells, pause/resume,
change input mode, cast, select Piano/guide timing and tap a beat.

Piano's optional `XivPiano.RhythmTimeline.v1` feed supplies up to 30 seconds of
future song onsets from a separate background decode of its downloaded song.
The chart uses those future timings when enough pulses are available; an
eight-second perspective approach makes the exact keys visible well in advance.
These are measured energy onsets, not pitch transcription or guaranteed musical
beats. A missing/unfinished map uses a clearly labelled tempo guide. Piano's
`AudioFeatures.v1` feed still supplies live energy and a beat estimate.

For game music, select GUIDE and tap the native **TAP BEAT** button, or set
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
