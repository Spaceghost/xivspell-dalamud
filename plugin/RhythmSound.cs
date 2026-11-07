using System.Runtime.InteropServices;

namespace XivSpell;

// Quiet synthesized plucks mix through the default audio output. Buffers stay
// owned until asynchronous playback has stopped; no music source is modified.
internal sealed class RhythmSound : IDisposable
{
    [DllImport("winmm.dll", EntryPoint = "PlaySoundW")]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool PlaySound(nint data, nint module, uint flags);
    private readonly nint[] sounds = new nint[4];
    private float volume = -1;
    private bool unavailable;
    public void Play(int lane, float gain)
    {
        if (unavailable || lane is < 0 or > 3) return;
        gain = Math.Clamp(float.IsFinite(gain) ? gain : 0, 0, .3f);
        if (gain <= 0) return;
        try {
            if (gain != volume) {
                Free(); volume = gain;
                double[] frequencies = [261.63, 293.66, 329.63, 392];
                for (var i = 0; i < sounds.Length; i++) {
                    const int rate = 22050, count = rate / 12;
                    using var buffer = new MemoryStream();
                    using var writer = new BinaryWriter(buffer);
                    writer.Write("RIFF"u8); writer.Write(36 + count * 2); writer.Write("WAVEfmt "u8);
                    writer.Write(16); writer.Write((short)1); writer.Write((short)1); writer.Write(rate);
                    writer.Write(rate * 2); writer.Write((short)2); writer.Write((short)16);
                    writer.Write("data"u8); writer.Write(count * 2);
                    for (var frame = 0; frame < count; frame++) {
                        var time = (double)frame / rate;
                        var envelope = Math.Min(1, time / .003) * Math.Exp(-time * 55);
                        var wave = Math.Sin(2 * Math.PI * frequencies[i] * time) + .2 * Math.Sin(4 * Math.PI * frequencies[i] * time);
                        writer.Write((short)(wave * envelope * gain * 18000));
                    }
                    var bytes = buffer.ToArray();
                    sounds[i] = Marshal.AllocHGlobal(bytes.Length); Marshal.Copy(bytes,0,sounds[i],bytes.Length);
                }
            }
            PlaySound(sounds[lane], 0, 0x0001 | 0x0002 | 0x0004); // ASYNC | NODEFAULT | MEMORY
        } catch { unavailable = true; }
    }
    private void Free()
    {
        if (sounds.Any(x => x != 0)) PlaySound(0, 0, 0);
        for (var i = 0; i < sounds.Length; i++) {
            if (sounds[i] != 0) Marshal.FreeHGlobal(sounds[i]);
            sounds[i] = 0;
        }
    }
    public void Dispose() { try { Free(); } catch { } }
}
