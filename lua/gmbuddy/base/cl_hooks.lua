hook.Add("InitPostEntity", "GMBuddy.ClientReady", function()
	net.Start("GMBuddy.ClientReady")
	net.SendToServer()
end)

hook.Add("CalcView", "GMBuddy.CalcView", function(ply, origin, angles, fov, znear, zfar)
	if !GMBuddy.bMenu then return end
	local view = {
		origin = GMBuddy.CameraPos,
		angles = Angle(90, 0, 0),
		fov = fov,
		drawviewer = true
	}

	return view
end)

