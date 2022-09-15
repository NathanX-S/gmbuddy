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

hook.Add("EntityRemoved", "GMBuddy.EntRemoved",function(ent)
	//print( ent:GetRagdollOwner() )
	if IsValid(ent:GetRagdollOwner()) or ent:IsRagdoll() then
		table.RemoveByValue(GMBuddy.CorpseStack, ent)
	end
	//print(ent:IsRagdoll())
end)

hook.Add("CreateClientsideRagdoll", "GMBuddy.ClientCorpse", function( entity, ragdoll )
	if #GMBuddy.CorpseStack == cfg.MaxCorpses then // We need room for more, knock out the first corpse.
		GMBuddy.CorpseStack[1]:SetSaveValue("m_bFadingOut", true)
		table.remove(GMBuddy.CorpseStack, 1)
	end
	table.insert(GMBuddy.CorpseStack, ragdoll)
end)