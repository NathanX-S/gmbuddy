util.AddNetworkString("GMBuddy.ClientReady")
util.AddNetworkString("GMBuddy.ClientResponse")
util.AddNetworkString("GMBuddy.MenuRequest")
util.AddNetworkString("GMBuddy.MenuToggle")
util.AddNetworkString("GMBuddy.MenuResponse")

net.Receive("GMBuddy.ClientReady", function(len, ply)
	if (IsValid(ply) and ply:IsPlayer()) then
		hook.Run("GMBuddy.ClientReady", ply)
		net.Start("GMBuddy.ClientResponse")
		net.Send(ply)
	end
end)