local cfg = GMBuddy.Config
local move_mult = cfg.Cam.MoveMult

hook.Add( "HUDShouldDraw", "GMBuddy.HideHUD", function( name )
	if !GMBuddy.bMenu then return end
	// Disable all GMOD HUD related hooks while in Buddy Menu.
	if cfg.HUDElements[name] then return false end
end)

hook.Add("HUDPaintBackground", "GMBuddy.MenuPaint", function()
	if !GMBuddy.bMenu then return end
	for k, v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
		local point = v:GetPos() + v:OBBCenter()
		local data2D = point:ToScreen()

		draw.SimpleText(v:Name(), "GMB_Info", data2D.x, data2D.y, cfg.Colors["PlayerInfo"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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

	if GMBuddy.bCam then
		local a = Angle(GMBuddy.CameraAng.x, GMBuddy.CameraAng.y, GMBuddy.CameraAng.z)
		local fwd = (a:Forward() * move_mult)
		local right = (a:Right() * move_mult)
		if cmd:GetForwardMove() > 0 then
			GMBuddy.CameraPos = GMBuddy.CameraPos + fwd
		elseif cmd:GetForwardMove() < 0 then
			GMBuddy.CameraPos = GMBuddy.CameraPos - fwd
		end
		if cmd:GetSideMove() > 0 then
			GMBuddy.CameraPos = GMBuddy.CameraPos + right
		elseif cmd:GetSideMove() < 0 then
			GMBuddy.CameraPos = GMBuddy.CameraPos - right
		end
	end

	cmd:ClearButtons()
	cmd:ClearMovement()

	cmd:SetMouseX(0)
	cmd:SetMouseY(0)
	return true
end)

hook.Add("InputMouseApply", "GMBuddy.MouseInput", function(cmd, x, y)
	if !GMBuddy.bCam then return end
	cmd:SetMouseX(0)
	cmd:SetMouseY(0)
	if cmd:GetMouseWheel() > 0 or cmd:GetMouseWheel() < 0 then
		move_mult = math.Clamp(move_mult + (cmd:GetMouseWheel() * 0.1), 1, 100)
	end

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

	if (pnl == GMBuddy.Menu) and (mouseCode == MOUSE_RIGHT) then
		gui.EnableScreenClicker(false)
		GMBuddy.bCam = true
	end
end)

hook.Add("PlayerButtonUp", "GMBuddy.ButtonUp", function(ply, button)
	if GMBuddy.bCam and button == MOUSE_RIGHT then
		gui.EnableScreenClicker(true)
		GMBuddy.bCam = false
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

if !DarkRP then return end

local GUIToggled = false
local mouseX, mouseY = ScrW() / 2, ScrH() / 2

function GAMEMODE:ShowSpare1()
	if GMBuddy.bMenu then return end
	local jobTable = LocalPlayer():getJobTable()

	// We need to check for the existance of jobTable here, because in very rare edge cases, the player's team isn't set, when the getJobTable-function is called here.
	if jobTable and jobTable.ShowSpare1 then
		return jobTable.ShowSpare1(LocalPlayer())
	end

	GUIToggled = not GUIToggled

	if GUIToggled then
		gui.SetMousePos(mouseX, mouseY)
	else
		mouseX, mouseY = gui.MousePos()
	end
	gui.EnableScreenClicker(GUIToggled)
end