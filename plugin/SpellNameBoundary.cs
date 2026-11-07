namespace XivSpell;

// A short alias must not consume the beginning of a longer spell name.
// For example "ra" remains editable while typing "radiant aegis"; Tab may
// explicitly bind the alias, and the complete name still binds immediately.
internal static class SpellNameBoundary
{
    internal static bool HasLongerMatch(string draft, IEnumerable<string> names) =>
        names.Any(name => name.Length > draft.Length && name.StartsWith(draft, StringComparison.OrdinalIgnoreCase));
}
