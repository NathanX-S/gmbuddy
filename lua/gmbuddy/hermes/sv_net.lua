net.Receive("GMBuddy.CamToggle", function(len, ply)
	if !(IsValid(ply) and ply:IsPlayer()) then return end
	local state = net.ReadBool()
	if isbool(state) then
		ply.bCam = state
	end
end)

net.Receive("GMBuddy.HermesRequest", function(len, ply)
	if !(IsValid(ply) and ply:IsPlayer()) then return end
	if !GMBuddy.PermsCheck(ply) then return end
	net.Start("GMBuddy.HermesResponse")
	net.Send(ply)
end)

net.Receive("GMBuddy.ModuleRequest", function(len, ply)
	if !(IsValid(ply) and ply:IsPlayer()) then return end
	if !GMBuddy.PermsCheck(ply) then return end
	local class = net.ReadString()
	-- This shouldn't be happening to begin with, but let's breakout anyways.
	-- if !class:StartWith("gmb_") then return end

	local pos = net.ReadVector()
	local ang = net.ReadAngle()
	if ang.x == 0 and ang.y == 0 and ang.z == 0 then ang = nil end

	local options_length = net.ReadUInt(16)
	local options = net.ReadData()
	options = util.JSONToTable(util.Decompress(options))

	local ent = ents.Create(class)

	ent:SetPos(pos)
	if ang then
		ent:SetAngles(ang)
	end
	ent:ConsumeOptions(options)
	ent:Spawn()
end)

net.Receive("GMBuddy.NPCRequestMove", function(len, ply)
	if !(IsValid(ply) and ply:IsPlayer()) then return end
	if !GMBuddy.PermsCheck(ply) then return end
	local target_pos = net.ReadVector()
	local entities = net.ReadTable()
	for k, v in pairs(entities) do
		if v != true then continue end
		if !k:IsNPC() then continue end
		k:SetLastPosition(target_pos)
		k:ClearSchedule()
		k:SetSchedule( SCHED_FORCED_GO_RUN )
	end
end)