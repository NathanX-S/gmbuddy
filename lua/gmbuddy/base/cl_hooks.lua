local cfg = GMBuddy.Config
GMBuddy.LastHeartbeat = 0
function GMBuddy.ClientThink()
	if SysTime() > GMBuddy.LastHeartbeat + cfg.HeartbeatPace then
		local fps = math.Round(1 / RealFrameTime())
		net.Start("GMBuddy.Heartbeat")
		net.WriteBool(system.HasFocus()) // Game in focus?
		net.WriteUInt(fps, 10) // FPS.
		net.SendToServer()
		GMBuddy.LastHeartbeat = SysTime() + cfg.HeartbeatPace
	end
end

hook.Add("InitPostEntity", "GMBuddy.ClientReady", function()
	timer.Simple(cfg.HeartbeatDelay, function()
		hook.Add("Think", "GMBuddy.ClientThink", GMBuddy.ClientThink)
	end)
end)