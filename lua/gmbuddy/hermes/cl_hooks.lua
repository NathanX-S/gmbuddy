local cfg = GMBuddy.Config
GMBuddy.CamMoveMult = cfg.Cam.MoveMult
GMBuddy.LastClick = {}

hook.Add( "HUDShouldDraw", "GMBuddy.HideHUD", function( name )
	if !GMBuddy.bHermes then return end
	// Disable all GMOD HUD related hooks while in Hermes.
	if cfg.HUDElements[name] then return false end
end)

hook.Add("HUDPaintBackground", "GMBuddy.HermesPaint", function()
	if !GMBuddy.bHermes then return end
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

hook.Add("VGUIMousePressed", "GMBuddy.VGUI.Press", function(pnl, mouseCode)
	if !IsValid(pnl) then return end
	if !GMBuddy.Hermes then return end
	if (pnl:GetParent() == GMBuddy.Hermes.SpawnMenu or pnl:GetParent() == GMBuddy.Hermes.EditMenu) and pnl:GetName() == "GMBTree" then
		pnl:SetSelectedItem(nil)
	end

	if (pnl != GMBuddy.Hermes) then return end
end)

-- Helper function to get the world space coordinates for an entity's bounding box
local function GetEntityBoundingBox(entity)
    local mins, maxs = entity:OBBMins(), entity:OBBMaxs()
    local pos = entity:GetPos()
    return pos + mins, pos + maxs
end

-- Draw the wireframe box
hook.Add("PostDrawTranslucentRenderables", "DrawBoundingBox", function()

	-- Initialize extreme points
	local globalMins, globalMaxs = Vector(math.huge, math.huge, math.huge), Vector(-math.huge, -math.huge, -math.huge)

	-- Calculate the global mins and maxs
	for ent, _ in pairs(GMBuddy.SelectedEnts) do
		if IsValid(ent) then
			local mins, maxs = GetEntityBoundingBox(ent)
			globalMins = Vector(math.min(globalMins.x, mins.x), math.min(globalMins.y, mins.y), math.min(globalMins.z, mins.z))
			globalMaxs = Vector(math.max(globalMaxs.x, maxs.x), math.max(globalMaxs.y, maxs.y), math.max(globalMaxs.z, maxs.z))
		end
	end
	local center = (globalMins + globalMaxs) / 2
    local angles = angle_zero
	cam.IgnoreZ(true)
	render.DrawWireframeBox(center, angles, globalMins - center, globalMaxs - center, cfg.Colors["WorldSelection"], true)
	cam.IgnoreZ(false)
end)


/*hook.Add("CalcView", "GMBuddy.CalcView", function(ply, origin, angles, fov, znear, zfar)
	if !GMBuddy.bHermes then return end
	local view = {
		origin = GMBuddy.CameraPos,
		angles = GMBuddy.CameraAng,
		fov = fov,
		drawviewer = true
	}

	return view
end)*/

hook.Add("SpawnMenuOpen", "GMBuddy.CancelSpawnMenu", function()
	if !GMBuddy.bHermes then return end
	return false
end)

if !DarkRP then return end

local GUIToggled = false
local mouseX, mouseY = ScrW() / 2, ScrH() / 2

function GAMEMODE:ShowSpare1()
	if GMBuddy.bHermes then return end
	local jobTable = LocalPlayer():getJobTable()

	// We need to check for the existance of jobTable here, because in very rare edge cases, the player's team isn't set, when the getJobTable-function is called here.
	if jobTable and jobTable.ShowSpare1 then
		return jobTable.ShowSpare1(LocalPlayer())
	end

	GUIToggled = !GUIToggled

	if GUIToggled then
		gui.SetMousePos(mouseX, mouseY)
	else
		mouseX, mouseY = gui.MousePos()
	end
	gui.EnableScreenClicker(GUIToggled)
end

function GAMEMODE:ShowSpare2()
	if GMBuddy.bHermes then return end
	local jobTable = LocalPlayer():getJobTable()

	// We need to check for the existance of jobTable here, because in very rare edge cases, the player's team isn't set, when the getJobTable-function is called here.
	if jobTable and jobTable.ShowSpare2 then
		return jobTable.ShowSpare2(LocalPlayer())
	end

	DarkRP.toggleF4Menu()
end