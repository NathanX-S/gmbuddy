net.Receive("GMBuddy.HermesResponse", function(len, ply)
	if !GMBuddy.Hermes then
		GMBuddy.CreateHermes()
		return
	end
	GMBuddy.bHermes = LocalPlayer():GetNWBool("GMBuddy.HermesToggle", false)
	GMBuddy.Hermes:SetVisible(!GMBuddy.Hermes:IsVisible())
end)