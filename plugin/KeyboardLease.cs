namespace XivSpell;

// A modal shortcut may close its picker while the key is still down. Drain
// that press through release before returning the key to the game's hotbars.
public sealed class KeyboardLease
{
    private readonly HashSet<int> held = [];
    public void Hold(int key) => held.Add(key);
    public bool Filter(int key, bool down)
    {
        if (!held.Contains(key)) return false;
        if (!down) held.Remove(key);
        return true;
    }
}
