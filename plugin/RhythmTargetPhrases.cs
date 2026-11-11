namespace XivSpell;

// A target and its spell share one rhythm phrase. Only the completed phrase
// produces a command, so missed letters cannot leave a pending target behind.
internal static class RhythmTargetPhrases
{
    internal static RhythmRound.Spell[] Expand(IEnumerable<RhythmRound.Spell> spells)
    {
        var words = spells.ToArray();
        var result = new List<RhythmRound.Spell>(words);
        var taken = words.Select(s => s.Phrase).ToHashSet(StringComparer.OrdinalIgnoreCase);
        foreach (var (word, selector) in Targets()) {
            foreach (var spell in words) {
                foreach (var prefix in new[] { word + " ", "on " + word + " " }) {
                    var phrase = prefix + spell.Phrase;
                    if (phrase.Length > RhythmRound.MaxPhraseLength || !taken.Add(phrase)) continue;
                    result.Add(new(spell.Id, phrase, spell.Name + " → " + selector.ToUpperInvariant(),
                        "on " + selector + " " + (spell.Command ?? spell.Phrase)));
                }
            }
        }
        return result.ToArray();
    }

    private static IEnumerable<(string Word, string Selector)> Targets()
    {
        foreach (var selector in new[] { "self", "friendly", "current", "focus", "targetOfTarget", "role",
            "tank", "healer", "dps", "melee", "ranged", "lowest", "enemy", "nearest", "nearestmob", "mob", "boss", "ally" })
            yield return (selector.ToLowerInvariant(), selector);
        for (var i = 1; i <= 8; i++) {
            yield return ("party" + i, "party" + i);
            foreach (var role in new[] { "tank", "healer", "dps", "melee", "ranged" })
                yield return (role + i, role + i);
        }
        yield return ("me", "self");
        yield return ("mt", "tank1");
        yield return ("ot", "tank2");
        yield return ("tot", "targetOfTarget");
    }
}
