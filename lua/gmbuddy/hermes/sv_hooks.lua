hook.Add("SetupPlayerVisibility", "GMBuddy.Hermes.PlayerVis", function(ply, viewEntity)
	if !ply.bHermes then return end
	-- print("VISCON. VISCON.")
	-- Adds any view entity
	if viewEntity:IsValid() and !viewEntity:TestPVS( ply ) then -- If we don't test if the PVS is already loaded, it could crash the server.
		AddOriginToPVS( viewEntity:GetPos() )
	end
end)

hook.Add("PlayerInitialSpawn", "GMBuddy.Hermes.InitPlayer", function(ply)
	/*ply.CameraPos = Vector(0, 0, 0)
	ply.CameraAng = Angle(0 , 0, 0)
	ply.CameraMult = GMBuddy.Config.Cam.MoveMult*/
	return
end)

hook.Add("Tick", "GMBuddy.Hermes.Tick", function()
	local target = {}
	local entities = {}
	local destinations = {}
	local ignore = {}
	for k, v in pairs(GMBuddy.HermesUsers) do
		for l, w in pairs(ents.FindInPVS(v.HermesCam:GetPos())) do
			local isNB = w:IsNextBot()
			local isNPC = w:IsNPC()
			if ignore[w] then continue end
			if !isNB and !isNPC then continue end
			if !entities[w] then
				local cached = GMBuddy.AICache[w]
				if cached and isNPC then
					if RealTime() - cached.last_update < w:GetMoveInterval() then
						ignore[w] = true
						continue
					end
					cached.last_update = RealTime()
				end
				entities[w] = {destinations = {[v] = true}, ["info"] = {}}

				local info = {}
				if isNPC then
					info.act = w:GetActivity()
					info.arrival_act = w:GetArrivalActivity()
					info.sched = w:GetCurrentSchedule()
					info.enemy = w:GetEnemy()
					info.lkp = w:GetEnemyLastKnownPos()
					info.goal_trgt = w:GetGoalTarget()
					info.trgt = w:GetTarget()
					info.wp_pos = w:GetCurWaypointPos()
				else
					info.act = w:GetActivity()
				end
				if !cached then
					GMBuddy.AICache[w] = {["info"] = info, ["last_update"] = RealTime(), ["ent"] = w}
				else
					GMBuddy.AICache[w]["info"] = info
				end
			else
				entities[w].destinations[v] = true
			end
		end
	end
	for k, v in pairs(entities) do
		local data = util.Compress(util.TableToJSON(v.info))
		net.Start("GMBuddy.AIInfo")
		net.WriteEntity(v)
		net.WriteUInt(#data, 16)
		net.WriteData(data)
		local filter = RecipientFilter()
		for l, w in pairs(v.destinations) do
			filter:AddPlayer(l)
		end
		net.Send(filter)
	end
end)

hook.Add("PlayerDisconnected", "GMBuddy.Hermes.Disconnect", function(ply)
	table.RemoveByValue(GMBuddy.HermesUsers, ply)
end)

function GAMEMODE:PlayerDriveAnimate( ply )
end