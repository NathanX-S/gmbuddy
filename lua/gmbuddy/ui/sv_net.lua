
net.Receive("GMBuddy.MenuRequest", function(len, ply)
	if !(IsValid(ply) and ply:IsPlayer()) then return end
	if !GMBuddy.PermsCheck(ply) then return end
	net.Start("GMBuddy.MenuResponse")
	net.Send(ply)
end)

net.Receive("GMBuddy.MenuToggle", function(len, ply)
	if !(IsValid(ply) and ply:IsPlayer()) then return end
	if !GMBuddy.PermsCheck(ply) then return end
	local state = net.ReadBool()
	if state then
		ply:DropToFloor()
		ply:SetAbsVelocity(Vector(0,0,0))
		ply:ResetSequence("idle")
	end
	ply:SetNWBool("GMBuddy.MenuToggle", state)
end)

net.Receive("GMBuddy.ModuleRequest", function(len, ply)
	if !(IsValid(ply) and ply:IsPlayer()) then return end
	if !GMBuddy.PermsCheck(ply) then return end
	local class = net.ReadString()
	// This shouldn't be happening to begin with, but let's breakout anyways.
	if !class:StartWith("gmb_") then return end

	local pos = net.ReadVector()
	local ang = net.ReadAngle()
	if ang.x == 0 and ang.y == 0 and ang.z == 0 then ang = nil end

	local props = net.ReadString()
	props = util.JSONToTable(util.Decompress(props))

	local ent = ents.Create(class)

	ent:SetPos(pos)
	if ang then
		ent:SetAngles(ang)
	end
	ent:ConsumeProps(props)
	ent:Spawn()
end)