local cfg = GMBuddy.Config.Menu
local selectedOption = "Objects"
local function ToggleElements()
	for k, v in pairs(GMBuddy.Elements) do
		v:SetVisible(GMBuddy.bMenu)
	end
end
concommand.Add("gmb_menu", function(ply, cmd, args)
	GMBuddy.bMenu = !GMBuddy.bMenu
	net.Start("GMBuddy.MenuToggle")
	net.WriteBool(GMBuddy.bMenu)
	net.SendToServer()
	gui.EnableScreenClicker(GMBuddy.bMenu)
	if GMBuddy.bMenu and GMBuddy.CameraPos == Vector(0, 0, 0) then
		local tr = util.TraceLine({
			start = LocalPlayer():GetPos(),
			endpos = LocalPlayer():GetPos() + LocalPlayer():GetAngles():Up() * 100000,
			mask = MASK_NPCWORLDSTATIC,
		})
		GMBuddy.CameraPos = tr.HitPos
		GMBuddy.CameraPos.z = math.min(tr.HitPos.z, 1000)
		GMBuddy.CameraAng = Angle(45, LocalPlayer():EyeAngles().yaw, 0)
	end
	if #GMBuddy.Elements == 0 then
		net.Start("GMBuddy.MenuRequest")
		net.SendToServer()
	else
		ToggleElements()
	end
end)

concommand.Add("gmb_reload", function(ply, cmd, args)
	if #GMBuddy.Elements > 0 then
		for k, v in pairs(GMBuddy.Elements) do
			v:Remove()
		end
	end
	cfg = GMBuddy.Config.Menu
	GMBuddy.CreateElements()
	ToggleElements()
end)

net.Receive("GMBuddy.MenuResponse", function(len, ply)
	if #GMBuddy.Elements == 0 then
		GMBuddy.CreateElements()
		return
	end
	GMBuddy.bMenu = LocalPlayer():GetNWBool("GMBuddy.MenuToggle", false)
	ToggleElements()
end)

local function UpdateTree(tree)
	tree.RootNode:Clear()
	for k, v in pairs(cfg.Categories[selectedOption].Children) do
		local parent = tree:AddNode(v.Name)
		for key, value in pairs(v.Children) do
			local node = parent:AddNode(value.Name)
		end
	end
end

function GMBuddy.CreateElements()
	local spawn_menu = vgui.Create("DPanel")
	local tree = vgui.Create("GMBTree", spawn_menu)
	local options = {}
	tree:Dock(FILL)
	tree:SetLineHeight(24)
	local pnl = vgui.Create("DPanel", spawn_menu)
	pnl:Dock(TOP)
	pnl:SetTall(ScrH() * 0.06)
	pnl:DockPadding(ScrW() * 0.003, ScrH() * 0.007, ScrW() * 0.003, ScrH() * 0.003)
	pnl:DockMargin(0, 0, 0, ScrH() * 0.015)

	timer.Simple(0, function()
		local fullWidth = pnl:GetWide()
		for k, v in pairs(cfg.Categories) do
			local btn = vgui.Create( "DImageButton", pnl )
			fullWidth = fullWidth - v.Width
			btn:SetStretchToFit(true)
			btn:SetKeepAspect(false)
			btn:SetSize(v.Width, 64)
			btn:SetImage(v.Icon)
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
				UpdateTree(tree)
			end
			local oldPaint = btn.Paint
			function btn:Paint(w, h)
				oldPaint(self, w, h)
				draw.DrawText(k, "GMB_UI", v.Width / 2, ScrH() * 0.05, color_white, TEXT_ALIGN_CENTER)
			end
			btn:Dock(LEFT)
			btn:DockMargin(42, 0, 0, 0)
			options[k] = btn
			UpdateTree(tree)
		end
	end)

	function pnl:Paint(w, h)
	end
	function tree:Paint(w, h)
	end

	spawn_menu:SetSize(ScrW() * 0.175, ScrH() * 0.98)
	spawn_menu:SetX(ScrW() * 0.8125)
	spawn_menu:CenterVertical()
	function spawn_menu:Paint(w, h)
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, ScrH() * 0.075, w, 2)
		surface.DrawOutlinedRect(0, 0, w, h, 2)
	end
	GMBuddy.Elements[GMBuddy.SPAWN_MENU] = spawn_menu
end

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

hook.Add("VGUIMousePressed", "GMB.VGUI.Press", function(pnl, mouseCode)
	if !IsValid(pnl) then return end
	if pnl:GetParent() == GMBuddy.Elements[GMBuddy.SPAWN_MENU] and pnl:GetName() == "GMBTree" then
		pnl:SetSelectedItem(nil)
	end
end)