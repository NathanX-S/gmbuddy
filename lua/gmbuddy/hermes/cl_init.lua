
GMBuddy.Hermes = GMBuddy.Hermes or nil
GMBuddy.bHermes = GMBuddy.bHermes or false
GMBuddy.bCam = GMBuddy.bCam or false
GMBuddy.CameraPos = GMBuddy.CameraPos or Vector(0, 0, 0)
GMBuddy.CameraAng = GMBuddy.CameraAng or Angle(0, 0, 0)
GMBuddy.SelectedEnts = GMBuddy.SelectedEnts or {}
GMBuddy.HoveredBtn = GMBuddy.HoveredBtn or {}

local cfg = GMBuddy.Config
GMBuddy.CameraMult = cfg.Cam.MoveMult
local selectedOption = "objs"


local function RecurseChildren(parent, parent_node)
	for k, v in pairs(parent.Children) do
		local node = parent_node:AddNode(v.Name)
		if v.Icon then
			node.Icon:SetMaterial(GMBuddy.LookupUIMat(v.Icon))
		end
		RecurseChildren(v, node)
	end
end

local function UpdateTree(tree)
	tree.RootNode:Clear()
	RecurseChildren(GMBuddy.Categories[selectedOption], tree)
end

local user_icon = Material("gmbuddy/user-solid.png")
print("HELP!")
function GMBuddy.CreateHermes()
	cfg = GMBuddy.Config
	print("????")
	if GMBuddy.Container then
		GMBuddy.Container:Remove()
	end
	local container = vgui.Create("DPanel")
	GMBuddy.Container = container
	container:SetSize(ScrW(), ScrH())
	container:SetCursor("hand")	
	function container:OnMousePressed(mouseCode)
		print("aaaa")
		GMBuddy.LastClick = {}

		local drive_ent = LocalPlayer():GetDrivingEntity()
		if !IsValid(drive_ent) then return end
		local player_pos = drive_ent:GetPos() -- Get the player's position
		
		if (mouseCode == MOUSE_RIGHT) and !GMBuddy.HoveredBtn then
			gui.EnableScreenClicker(false)
			GMBuddy.bCam = true
			--net.Start("GMBuddy.CamToggle")
			--net.WriteBool(true)
			--net.SendToServer()
		end

		if (mouseCode == MOUSE_LEFT) then
			if GMBuddy.HoveredBtn then
				GMBuddy.SelectedEnts[GMBuddy.HoveredBtn.ent] = true
				--GMBuddy.SelectedEnts = {GMBuddy.HoveredBtn.ent}
			else
				GMBuddy.SelectedEnts = {}
				local tr = util.TraceLine( {
					start = player_pos,
					endpos = player_pos + drive_ent:GetAngles():Forward() + gui.ScreenToVector(gui.MousePos()) * 10000,
				} )
				print("yo?", player_pos, tr.HitPos)
				debugoverlay.Line( player_pos, tr.HitPos, 1, color_white, true )
				
				GMBuddy.LastClick = {ThreeD = tr.HitPos, TwoD = {x = gui.MouseX(), y = gui.MouseY()}}
			end
		end
	end
	function container:Paint(w, h)
		if !IsValid(LocalPlayer()) then return end
		local drive_ent = LocalPlayer():GetDrivingEntity()
		if !IsValid(drive_ent) then return end
		local player_pos = drive_ent:GetPos() -- Get the player's position
		
		local hovered = 0
		local buttons = {}
		for k, v in ents.Iterator() do
			-- TODO: SEPERATE LOGIC FROM PAINT
			if not v:IsNPC() and not v:IsNextBot() then continue end 
			
			local ent_pos = v:GetPos()
			local min, max = v:WorldSpaceAABB()
			local screen_pos = Vector(ent_pos.x, ent_pos.y, max.z + 10):ToScreen()
			
			-- Calculate distance from the player to the entity
			local distance = player_pos:Distance(ent_pos)
			
			-- Adjust icon size based on distance (e.g., icon size decreases as distance increases)
			local icon_size = math.max(48 / (distance / 100), 32) -- Example scaling factor and minimum size
			
			-- Ensure the icon size doesn't become too small
			if icon_size < 32 then
				icon_size = 32
			end
			
			-- Draw the icon centered at the entity's screen position
			local half_size = icon_size / 2
			local scrW, scrH = ScrW(), ScrH()
			if (screen_pos.x - half_size) > scrW or (screen_pos.y - half_size) > scrH then continue end
			if (screen_pos.x - half_size) < 0 or (screen_pos.y - half_size) < 0 then continue end
			local index = table.insert(buttons, {["icon_size"] = icon_size, ["screen_pos"] = screen_pos, ["ent"] = v})
			surface.SetDrawColor(255, 255, 255, 255) -- Set the drawing color
			surface.SetMaterial(user_icon) -- Use our cached material
			local mouseX, mouseY = gui.MouseX(), gui.MouseY()
			if mouseX > (screen_pos.x - half_size) and mouseX < (screen_pos.x - half_size) + icon_size then
				if mouseY > (screen_pos.y - half_size) and mouseY < (screen_pos.y - half_size) + icon_size then
					hovered = index
				end
			end
		end
		if hovered == 0 then GMBuddy.HoveredBtn = nil end

		for k, v in ipairs(buttons) do
			local icon_size = v.icon_size
			if k == hovered then
				surface.SetDrawColor(177, 177, 255, 175)
				if input.IsMouseDown(MOUSE_LEFT) then
					icon_size = icon_size * 0.9
				end
				GMBuddy.HoveredBtn = v
				print("hovering", v.ent)
			else
				surface.SetDrawColor(222, 222, 222, 102)
			end
			local half_size = icon_size / 2
			local screen_pos = v.screen_pos
			surface.DrawRect(screen_pos.x - half_size, screen_pos.y - half_size, icon_size, icon_size) -- Actually draw the rectangle
			surface.SetDrawColor( 0, 0, 0, 255 ) -- Set the drawing color
			surface.SetMaterial( GMBuddy.LookupUIMat("gmbuddy/biohazard-solid.png") ) -- Use our cached material
			surface.DrawTexturedRect((screen_pos.x - half_size) + 4, (screen_pos.y - half_size) + 4, (icon_size) - 8, icon_size - 8) -- Actually draw the rectangle
			surface.SetDrawColor(70, 70, 70, 255)
			surface.DrawOutlinedRect((screen_pos.x - half_size) - 1, (screen_pos.y - half_size) - 1, icon_size + 1, icon_size + 1, 2)
		end

		
		if !GMBuddy.LastClick.TwoD then return end
		local click = GMBuddy.LastClick.TwoD
		local col 
		surface.SetDrawColor(cfg.Colors["WorldSelection"]) -- Set the drawing color
		local drive_ent = LocalPlayer():GetDrivingEntity()
		local player_pos = drive_ent:GetPos() -- Get the player's position
		local tr = util.TraceLine( {
			start = player_pos,
			endpos = player_pos + drive_ent:GetAngles():Forward()
				+ gui.ScreenToVector(gui.MousePos()) * 10000, 
		} )
		print("yo?", player_pos, tr.HitPos)
		print("hello??", click)
		PrintTable(click)
		local cur_x, cur_y = gui.MouseX(), gui.MouseY()
		local left = math.min(click.x, cur_x)
		local top = math.min(click.y, cur_y)
		local width = math.abs(cur_x - click.x)
		local height = math.abs(cur_y - click.y)
		
		surface.DrawOutlinedRect(left, top, width, height, 2)
	end
	local header = vgui.Create("DPanel", container)
	local spawn_menu = vgui.Create("DPanel", container)
	local edit_menu = vgui.Create("DPanel", container)
	local spawn_tree = vgui.Create("GMBTree", spawn_menu)
	header:Dock(TOP)
	local options = {}
	spawn_tree:Dock(FILL)
	spawn_tree:SetLineHeight(20)
	local edit_tree = vgui.Create("GMBTree", edit_menu)
	edit_tree:Dock(FILL)
	edit_tree:SetLineHeight(20)

	local pnl = vgui.Create("DPanel", spawn_menu)
	pnl:Dock(TOP)
	pnl:SetTall(ScrH() * 0.06)
	pnl:DockPadding(ScrW() * 0.003, ScrH() * 0.007, ScrW() * 0.003, ScrH() * 0.003)
	pnl:DockMargin(0, 0, 0, ScrH() * 0.015)

	timer.Simple(0, function()
		local fullWidth = pnl:GetWide()
		for k, v in pairs(GMBuddy.Categories) do
			local btn = vgui.Create( "DImageButton", pnl )
			fullWidth = fullWidth - v.Width
			btn:SetStretchToFit(true)
			btn:SetKeepAspect(false)
			btn:SetSize(v.Width, 48)
			btn:SetMaterial(GMBuddy.LookupUIMat(v.Icon))
			if k ~= selectedOption then
				btn.m_Image:SetImageColor(cfg.Colors["UnselectedCat"])
			else
				btn.m_Image:SetImageColor(color_white)
			end
			btn:NoClipping(true)
			btn.DoClick = function()
				surface.PlaySound("UI/buttonclick.wav")
				options[selectedOption].m_Image:SetImageColor(cfg.Colors["UnselectedCat"])
				selectedOption = k
				btn.m_Image:SetImageColor(color_white)
				UpdateTree(spawn_tree)
			end
			local oldPaint = btn.Paint
			function btn:Paint(w, h)
				oldPaint(self, w, h)
				draw.DrawText(v.Name, "GMB_UI", v.Width / 2, ScrH() * 0.05, color_white, TEXT_ALIGN_CENTER)
			end
			btn:Dock(LEFT)
			btn:DockMargin(42, 0, 0, 0)
			options[k] = btn
			UpdateTree(spawn_tree)
		end
	end)

	function header:Paint(w, h)
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, 	w, h)
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawOutlinedRect(0, 0, w, h, 2)
	end
	function pnl:Paint(w, h)
	end
	function spawn_tree:Paint(w, h)
	end
	function edit_tree:Paint(w, h)
	end

	spawn_menu:SetSize(ScrW() * 0.175, ScrH() * 0.95)
	spawn_menu:SetX(ScrW() * 0.8125)
	spawn_menu:CenterVertical()
	function spawn_menu:Paint(w, h)
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, h * 0.08, w, 2)
		surface.DrawOutlinedRect(0, 0, w, h, 2)
	end
	edit_menu:SetSize(ScrW() * 0.175, ScrH() * 0.95)
	edit_menu:SetX(ScrW() * 0.0125)
	edit_menu:CenterVertical()
	function edit_menu:Paint(w, h)
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawOutlinedRect(0, 0, w, h, 2)
	end
	GMBuddy.Hermes = container
	GMBuddy.Hermes.SpawnMenu = spawn_menu
	GMBuddy.Hermes.EditMenu = edit_menu
end



concommand.Add("gmb_ui_reload", function(ply, cmd, args)
	/*local tr = util.TraceLine({
		start = ply:GetPos(),
		endpos = ply:GetPos() + ply:GetAngles():Up() * 100000,
		mask = MASK_NPCWORLDSTATIC,
	})
	local camera_pos = tr.HitPos
	camera_pos.z = math.min(tr.HitPos.z, 1000)
	local camera_ang = Angle(45, ply:EyeAngles().yaw, 0)
	if CLIENT then
		GMBuddy.CameraPos = camera_pos
		GMBuddy.CameraAng = camera_ang
	else
		ply.CameraPos = camera_pos
		ply.CameraAng = camera_ang
	end*/
	if GMBuddy.Hermes then
		GMBuddy.Hermes:Remove()
		GMBuddy.Container:Remove()
	end
	cfg = GMBuddy.Config
	--local viscon = 
	GMBuddy.CreateHermes()
	GMBuddy.Hermes:SetVisible(GMBuddy.bHermes)
end)
