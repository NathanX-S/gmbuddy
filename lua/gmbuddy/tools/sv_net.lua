util.AddNetworkString("GMBuddy.ToggleStealth")

net.Receive("GMBuddy.ToggleStealth", function(len, ply)
	if (IsValid(ply) && ply:IsPlayer()) then
		ply:SetNWBool("ToolgunStealth", !ply:GetNWBool("ToolgunStealth", false))
		print(ply:GetNWBool("ToolgunStealth"))
	end
end)