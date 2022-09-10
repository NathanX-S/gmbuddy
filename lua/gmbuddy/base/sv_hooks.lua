hook.Add("OnEntityCreated", "GMBuddy.NPCCheck", function(ent)
	timer.Simple(0, function()
		if !ent:IsValid() then return end
		if !(ent:IsNPC() or ent:IsNextBot()) then return end
		if !ent:IsInWorld() then return end
		local trace = {start = ent:GetPos(), endpos = ent:GetPos(), filter = ent, mins = ent:OBBMins() * 0.64, maxs = ent:OBBMaxs(), dir = ent:GetUp()}
		local tr = util.TraceHull(trace)
		if (tr.Hit and tr.HitWorld) then
			ent:Remove()
		end
	end)
end)

hook.Add("PlayerChangedTeam", "GMBuddy.ChangedTeam", function(ply, old, new)
	if (old == TEAM_CONNECTING or old == TEAM_UNASSIGNED) then return end
	timer.Simple(0, function()
		local res = GMBuddy.DB.GetPly(ply)
		if res.Team == new then
			return
		end
		GMBuddy.DB.SavePly(ply)
	end)
end)

hook.Add("PlayerInitialSpawn", "GMBuddy.ClientReady", function(ply)
	timer.Simple(0, function()
		ply.bWinFocus = nil
		ply.nFps = nil

		local data = GMBuddy.DB.GetPly(ply)
		ply:changeTeam(data.Team, false, true)

		net.Start("GMBuddy.ClientResponse")
		net.Send(ply)
	end)
end)