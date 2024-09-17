print("??!?!")
concommand.Add("gmb_hermes", function(ply, cmd, args)
	print("HELP!!!")
	if !(IsValid(ply) and ply:IsPlayer()) then return end
	print("???")
	if !GMBuddy.PermsCheck(ply) then return end
	local bHermes = false
	ply.bHermes = !ply.bHermes
	bHermes = ply.bHermes
	ply:SetHermes(bHermes)
	print("TEST", bHermes)
	net.Start("GMBuddy.HermesResponse")
	net.WriteBool(bHermes)
	net.Send(ply)
end)