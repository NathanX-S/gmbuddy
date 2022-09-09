hook.Add("InitPostEntity", "GMBuddy.ClientReady", function()
	net.Start("GMBuddy.ClientReady")
	net.SendToServer()
end)

