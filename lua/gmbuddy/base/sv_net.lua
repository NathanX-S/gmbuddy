util.AddNetworkString("GMBuddy.Heartbeat")
util.AddNetworkString("GMBuddy.ClientResponse")
util.AddNetworkString("GMBuddy.MenuRequest")
util.AddNetworkString("GMBuddy.MenuToggle")
util.AddNetworkString("GMBuddy.MenuResponse")

net.Receive("GMBuddy.Heartbeat", function(len, ply)
	local focus = net.ReadBool()
	local fps = net.ReadUInt(10)
	ply.bWinFocus = focus
	ply.nFps = fps
end)