using System.Numerics;
using Dalamud.Game.ClientState.Conditions;
using Dalamud.Game.ClientState.Objects.Types;
using Dalamud.Game.ClientState.Objects.SubKinds;
using Dalamud.Plugin.Services;

namespace XivSpell;

public sealed partial class Plugin
{
    private string followTarget = "role";
    private float followRange = 15;
    private bool ownsPath;
    private long castHoldUntil;
    private long nextRepath;
    private Task<List<Vector3>>? pendingPath;
    private CancellationTokenSource? pathCancel;
    private Vector3 pathTarget;
    private ulong pathTargetId;
    private readonly AutoFollowSession autoFollow = new();

    private void TryAutomaticFollow(long now)
    {
        if (!config.AutoFollow || !autoFollow.Authorized || !armed || following || weave.Paused ||
            (weave.Finished && weave.InFlight == null)) return;
        if (gamepad.LeftStick.LengthSquared() > 400) { autoFollow.Revoke(); return; }
        var roleTarget = ResolveRoleTarget();
        var targetAvailable = CanFollow(roleTarget) && (objects.LocalPlayer?.ClassJob.Value.Role == 4 || IsEnemy(roleTarget));
        if (!autoFollow.TryStart(now, armed, !weave.Paused && (!weave.Finished || weave.InFlight != null),
                following, targetAvailable)) return;
        try {
            if (!pi.GetIpcSubscriber<bool>("vnavmesh.Nav.IsReady").InvokeFunc()) return;
            StopOwnedPath(); nextRepath = 0;
            followTarget = "role"; followRange = 15; following = true;
            last = "Following role target · move or Esc to take control";
        } catch (Exception ex) {
            autoFollow.Revoke();
            log.Debug(ex, "Automatic role follow unavailable");
            last = "Auto-follow unavailable · casting remains active";
        }
    }

    private bool CanFollow([System.Diagnostics.CodeAnalysis.NotNullWhen(true)] IGameObject? actor) => actor != null && actor.IsTargetable &&
        actor.GameObjectId != objects.LocalPlayer?.GameObjectId && actor is not ICharacter { IsDead: true };

    private IGameObject? ResolveRoleTarget()
    {
        var healer = objects.LocalPlayer?.ClassJob.Value.Role == 4;
        if (!healer) return targets.Target;
        var focus = targets.FocusTarget;
        if (CanFollow(focus) && (focus is IPlayerCharacter || party.Any(p => p.GameObject?.GameObjectId == focus.GameObjectId))) return focus;
        return party.Where(p => p.ClassJob.Value.Role == 1).Select(p => p.GameObject).FirstOrDefault(CanFollow);
    }

    private void StopOwnedPath()
    {
        pathCancel?.Cancel(); pathCancel?.Dispose(); pathCancel = null;
        // Observe errors even when an obsolete pathfinding task finishes later.
        if (pendingPath != null) _ = pendingPath.ContinueWith(t => { _ = t.Exception; }, TaskContinuationOptions.OnlyOnFaulted);
        pendingPath = null;
        if (!ownsPath) return;
        try { pi.GetIpcSubscriber<object>("vnavmesh.Path.Stop").InvokeAction(); }
        catch (Exception ex) { log.Debug(ex, "Stop XivSpell follow path"); }
        ownsPath = false;
    }

    private void StopFollowing(string message)
    {
        autoFollow.Revoke();
        following = false; StopOwnedPath(); nextRepath = 0; last = message;
    }

    private void FollowUpdate(IFramework _)
    {
        if (!following) return;
        try {
            var player = objects.LocalPlayer;
            if (!armed || player == null || player.IsDead || conditions[ConditionFlag.BetweenAreas] || conditions[ConditionFlag.OccupiedInCutSceneEvent]) {
                StopFollowing("Follow stopped: player unavailable"); return;
            }
            // Read only: never enable ImGui gamepad navigation, suppress a button, or rewrite a stick.
            // Dalamud exposes integer stick coordinates rather than normalized -1..1 values.
            if (gamepad.LeftStick.LengthSquared() > 400) { StopFollowing("Controller movement: follow stopped"); return; }
            var target = Resolve(followTarget);
            if (!CanFollow(target)) {
                StopFollowing("Follow target lost"); return;
            }
            if (player.IsCasting || Environment.TickCount64 < castHoldUntil) { StopOwnedPath(); return; }
            var range = followTarget == "role" && player.ClassJob.Value.Role == 4 ? Math.Min(followRange, 6) : followRange;
            var delta = player.Position - target.Position;
            if (delta.Length() <= range + 1) { StopOwnedPath(); return; }
            if (pendingPath != null) {
                if (!pendingPath.IsCompleted) return;
                var completed = pendingPath; pendingPath = null;
                if (completed.IsCanceled) return;
                if (completed.IsFaulted) { log.Debug(completed.Exception!, "Follow pathfinding"); StopFollowing("Follow path unavailable"); return; }
                if (target.GameObjectId != pathTargetId || Vector3.DistanceSquared(pathTarget, target.Position) > 16) { StopOwnedPath(); nextRepath = 0; return; }
                var waypoints = completed.Result;
                if (waypoints.Count == 0) { StopFollowing("No walkable path to follow target"); return; }
                pi.GetIpcSubscriber<List<Vector3>, bool, object>("vnavmesh.Path.MoveTo").InvokeAction(waypoints, false);
                ownsPath = true;
            }
            if (Environment.TickCount64 < nextRepath) return;
            // Avoid issuing another route when our current route still leads to this target position.
            if (ownsPath && target.GameObjectId == pathTargetId && Vector3.DistanceSquared(pathTarget, target.Position) < 4 &&
                pi.GetIpcSubscriber<bool>("vnavmesh.Path.IsRunning").InvokeFunc()) return;
            StopOwnedPath();
            pathTarget = target.Position; pathTargetId = target.GameObjectId;
            var destination = target.Position + Vector3.Normalize(delta) * range;
            pathCancel = new CancellationTokenSource(TimeSpan.FromSeconds(5));
            pendingPath = pi.GetIpcSubscriber<Vector3, Vector3, bool, CancellationToken, Task<List<Vector3>>>("vnavmesh.Nav.PathfindCancelable")
                .InvokeFunc(player.Position, destination, false, pathCancel.Token);
            nextRepath = Environment.TickCount64 + 1000;
        } catch (Exception ex) { log.Warning(ex, "XivSpell follow stopped"); StopFollowing("Follow bridge unavailable: " + ex.Message); }
    }
}
