net.Receive("GMBuddy.HermesResponse", function(len, ply)
	local state = net.ReadBool()
	if !GMBuddy.Hermes then
		GMBuddy.CreateHermes()
	else
		GMBuddy.Hermes:SetVisible(state)
	end
	GMBuddy.bHermes = state
	print("lol", "yep", GMBuddy.bHermes)
	//GMBuddy.Hermes:SetVisible(!GMBuddy.Hermes:IsVisible())
	bHermes = GMBuddy.bHermes
	GMBuddy.bCam = false
	gui.EnableScreenClicker(bHermes)

end)