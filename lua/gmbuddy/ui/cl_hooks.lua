local elements = {
	["CHudGMod"] = true,
	["CHudCrosshair"] = true,
	["CHudWeaponSelection"] = true
}

hook.Add( "HUDShouldDraw", "GMBuddy.HideHUD", function( name )
	if !GMBuddy.bMenu then return end
	// Disable all GMOD HUD related hooks while in Buddy Menu.
	if elements[name] then return false end
end)

hook.Add("HUDPaintBackground", "GMBuddy.MenuPaint", function()
	if !GMBuddy.bMenu then return end
	for k, v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
		local point = v:GetPos() + v:OBBCenter()
		local data2D = point:ToScreen()

		draw.SimpleText(v:Name(), "GMB_Info", data2D.x, data2D.y, team.GetColor(v:Team()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	for k, v in pairs(ents.GetAll()) do
		if !v:IsNPC() then continue end
		local point = v:GetPos() + v:OBBCenter()
		local data2D = point:ToScreen()
		draw.RoundedBox(0, data2D.x, data2D.y, 10, 10, color_white)
	end
end)

hook.Add("CreateMove", "GMBuddy.CreateMove", function(cmd)
	if !GMBuddy.bMenu then return end
	local a = Angle(GMBuddy.CameraAng.x, GMBuddy.CameraAng.y, GMBuddy.CameraAng.z)
	if cmd:GetForwardMove() > 0 then
		GMBuddy.CameraPos = GMBuddy.CameraPos + (a:Forward() * 10)
	elseif cmd:GetForwardMove() < 0 then
		GMBuddy.CameraPos = GMBuddy.CameraPos - (a:Forward() * 10)
	end
	if cmd:GetSideMove() > 0 then
		GMBuddy.CameraPos = GMBuddy.CameraPos + (a:Right() * 10)
	elseif cmd:GetSideMove() < 0 then
		GMBuddy.CameraPos = GMBuddy.CameraPos - (a:Right() * 10)
	end
	cmd:ClearButtons()
	cmd:ClearMovement()

	cmd:SetMouseX(0)
	cmd:SetMouseY(0)
	return true
end)

hook.Add("InputMouseApply", "GMBuddy.MouseInput", function(cmd, x, y)
	if !GMBuddy.bMenu then return end
	cmd:SetMouseX(0)
	cmd:SetMouseY(0)

	GMBuddy.CameraAng.pitch = math.Clamp(GMBuddy.CameraAng.pitch + (y * 0.01), -90, 90)
	GMBuddy.CameraAng.yaw = (GMBuddy.CameraAng.yaw - (x * 0.01)) % 360

	return true
end)

hook.Add("VGUIMousePressed", "GMBuddy.VGUI.Press", function(pnl, mouseCode)
	if !IsValid(pnl) then return end
	if !GMBuddy.Menu then return end
	if (pnl:GetParent() == GMBuddy.Menu.SpawnMenu or pnl:GetParent() == GMBuddy.Menu.EditMenu) and pnl:GetName() == "GMBTree" then
		pnl:SetSelectedItem(nil)
	end
end)

hook.Add("CalcView", "GMBuddy.CalcView", function(ply, origin, angles, fov, znear, zfar)
	if !GMBuddy.bMenu then return end
	local view = {
		origin = GMBuddy.CameraPos,
		angles = GMBuddy.CameraAng,
		fov = fov,
		drawviewer = true
	}

	return view
end)