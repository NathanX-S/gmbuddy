
/*hook.Add("StartCommand", "GMBuddy.StartCommand", function(ply, cmd)
	if !ply.bHermes and !GMBuddy.bHermes then return end

	if GMBuddy.bCam or ply.bCam then
		local camera_ang = nil
		local camera_mult = nil
		if CLIENT then
		    camera_ang = GMBuddy.CameraAng
		    camera_mult = GMBuddy.CameraMult
		else
		    camera_ang = ply.CameraAng
		    camera_mult = ply.CameraMult
		end

		local a = Angle(camera_ang.x, camera_ang.y, camera_ang.z)
		local fwd = (a:Forward() * camera_mult)
		local right = (a:Right() * camera_mult)
		local camera_pos = nil
		if CLIENT then
		    camera_pos = GMBuddy.CameraPos
		else
		    camera_pos = ply.CameraPos
		end
		if cmd:KeyDown(IN_FORWARD) then
			camera_pos = camera_pos + fwd
		elseif cmd:KeyDown(IN_BACK) then
			camera_pos = camera_pos - fwd
		end
		print(cmd:KeyDown(IN_RIGHT), fwd, "LOL!!")
		if cmd:KeyDown(IN_MOVERIGHT) then
			camera_pos = camera_pos + right
		elseif cmd:KeyDown(IN_MOVELEFT) then
			camera_pos = camera_pos - right
		end

		if cmd:GetMouseWheel() > 0 or cmd:GetMouseWheel() < 0 then
			camera_mult = math.Clamp(camera_mult + (cmd:GetMouseWheel() * 0.1), 1, 100)
		end

		camera_ang.pitch = math.Clamp(camera_ang.pitch + (cmd:GetMouseY() * 0.01), -90, 90)
		camera_ang.yaw = (camera_ang.yaw - (cmd:GetMouseX() * 0.01)) % 360

		if CLIENT then
			GMBuddy.CameraPos = camera_pos
			GMBuddy.CameraAng = camera_ang
			GMBuddy.CameraMult = camera_mult
		else
			ply.CameraPos = camera_pos
			ply.CameraAng = camera_ang
			ply.CameraMult = camera_mult
		end
		print("????", camera_pos, camera_ang, camera_mult)
	end

	--cmd:ClearButtons()
	--cmd:ClearMovement()

	--cmd:SetMouseX(0)
	--cmd:SetMouseY(0)
	return true
end)*/


/*hook.Add("InputMouseApply", "GMBuddy.MouseInput", function(cmd, x, y)
	--if !GMBuddy.bCam then return end
	--cmd:SetMouseX(0)
	--cmd:SetMouseY(0)

	--return true
end)*/
hook.Remove("InputMouseApply", "GMBuddy.MouseInput")



hook.Add("PlayerButtonUp", "GMBuddy.ButtonUp", function(ply, button)
	if (ply.bCam or GMBuddy.bCam) and button == MOUSE_MIDDLE then
		ply.bCam = false
		if CLIENT then
  		    gui.EnableScreenClicker(true)
		    GMBuddy.bCam = false
		end
	end
end)


hook.Add("HandlePlayerDriving", "GMBuddy.HandleDrive", function(ply)
	return true
end)