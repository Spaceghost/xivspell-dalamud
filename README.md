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

`/xivspell rhythm on` opens **Spellstrings**, a four-lane letter highway. Choose a
spell, wait through the four-beat count-in, and type each letter as it crosses the
strike line. Spaces are notes too. Perfect/Great/Good judgments build combos,
multipliers and stars. Mistakes keep the missing letter and give it a later beat;
they never queue a partly spelled spell.

For controllers, use `/xivspell rhythm pad`. Press both sticks to weave/pause,
use D-pad Left/Right to choose a spell, and match the letter to the coloured face
button. The other letters come from available spell-name completions, with
distinct decoys filling the remaining lanes. R3 casts the prepared queue and
releases the controller for movement; L3 repeats it. Keyboard mode uses `>` to
cast and move, `.` to repeat, `i` to weave another, and Escape to pause. Normal
spell weaving remains available with `/xivspell rhythm off`.

Piano's optional `XivPiano.AudioFeatures.v1` feed supplies a live spectrum, energy
and an **estimated** beat grid. It is not a pre-authored song chart or guaranteed
beat detection. Let it learn a few pulses before starting a round. With game
music, turn off Follow Piano and tap **Tap beat** along with the music, or set
`/xivspell rhythm tempo 120`. Chart tempo is fixed for each round. The timing
panel adjusts input offset and quiet plucked hit sounds, mixed through your
default output without changing music playback or volume.

The round queues a rune only after every letter was hit. Casting requires a
separate explicit command, so preparing a musical spell cannot cast it or move
the character. Losing focus, cutscenes and other text editors pause the round.

## Development

Changes integrate directly on `master` after checks. CI runs offline tests and
builds the plugin; it does not prove live gameplay behavior. Preserve the running
spell queue and editor buffers when installing updates. See [CHANGELOG.txt](CHANGELOG.txt)
for the implementation history.
