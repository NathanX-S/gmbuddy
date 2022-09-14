util.AddNetworkString("GMBuddy.Heartbeat")
util.AddNetworkString("GMBuddy.ClientResponse")
util.AddNetworkString("GMBuddy.HermesRequest")
util.AddNetworkString("GMBuddy.HermesToggle")
util.AddNetworkString("GMBuddy.HermesResponse")

net.Receive("GMBuddy.Heartbeat", function(len, ply)
	local focus = net.ReadBool()
	local fps = net.ReadUInt(10)
	ply.bWinFocus = focus
	ply.nFps = fps
end)