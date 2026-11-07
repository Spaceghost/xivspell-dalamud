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

## Development

Changes integrate directly on `master` after checks. CI runs offline tests and
builds the plugin; it does not prove live gameplay behavior. Preserve the running
spell queue and editor buffers when installing updates. See [CHANGELOG.txt](CHANGELOG.txt)
for the implementation history.
