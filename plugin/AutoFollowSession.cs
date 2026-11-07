namespace XivSpell;

// Movement and stop revoke this session; cast polling cannot reauthorize it.
public sealed class AutoFollowSession
{
    public bool Authorized { get; private set; } = true;
    private long nextAttempt;
    public void Authorize() { Authorized = true; nextAttempt = 0; }
    public void Revoke() { Authorized = false; }
    public bool TryStart(long now, bool live, bool playing, bool following, bool targetAvailable)
    {
        if (!Authorized || !live || !playing || following || !targetAvailable || now < nextAttempt) return false;
        nextAttempt = now + 1000;
        return true;
    }
}
