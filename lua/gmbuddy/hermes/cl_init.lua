GMBuddy.Hermes = nil
GMBuddy.bHermes = false
GMBuddy.bCam = false
GMBuddy.CameraPos = Vector(0, 0, 0)
GMBuddy.CameraAng = Angle(0 , 0, 0)

local cfg = GMBuddy.Config
local selectedOption = "objs"

concommand.Add("gmb_hermes", function(ply, cmd, args)
	GMBuddy.bHermes = !GMBuddy.bHermes
	GMBuddy.bCam = false
	net.Start("GMBuddy.HermesToggle")
	net.WriteBool(GMBuddy.bHermes)
	net.SendToServer()
	ply:SetCanZoom(GMBuddy.bHermes)
	gui.EnableScreenClicker(GMBuddy.bHermes)
	if GMBuddy.bHermes and GMBuddy.CameraPos == Vector(0, 0, 0) then
		local tr = util.TraceLine({
			start = LocalPlayer():GetPos(),
			endpos = LocalPlayer():GetPos() + LocalPlayer():GetAngles():Up() * 100000,
			mask = MASK_NPCWORLDSTATIC,
		})
		GMBuddy.CameraPos = tr.HitPos
		GMBuddy.CameraPos.z = math.min(tr.HitPos.z, 1000)
		GMBuddy.CameraAng = Angle(45, LocalPlayer():EyeAngles().yaw, 0)
	end
	if !GMBuddy.Hermes then
		net.Start("GMBuddy.HermesRequest")
		net.SendToServer()
	else
		GMBuddy.Hermes:SetVisible(!GMBuddy.Hermes:IsVisible())
	end
end)

concommand.Add("gmb_reload", function(ply, cmd, args)
	local tr = util.TraceLine({
		start = LocalPlayer():GetPos(),
		endpos = LocalPlayer():GetPos() + LocalPlayer():GetAngles():Up() * 100000,
		mask = MASK_NPCWORLDSTATIC,
	})
	GMBuddy.CameraPos = tr.HitPos
	GMBuddy.CameraPos.z = math.min(tr.HitPos.z, 1000)
	GMBuddy.CameraAng = Angle(45, LocalPlayer():EyeAngles().yaw, 0)
	if GMBuddy.Hermes then
		GMBuddy.Hermes:Remove()
	end
	cfg = GMBuddy.Config
	GMBuddy.CreateHermes()
	GMBuddy.Hermes:SetVisible(!GMBuddy.Hermes:IsVisible())
end)

local function UpdateTree(tree)
	tree.RootNode:Clear()
	for k, v in pairs(cfg.Categories[selectedOption].Children) do
		local parent = tree:AddNode(v.Name)
		if v.Icon then
			parent.Icon:SetImage(v.Icon)
		end
		for key, value in pairs(v.Children) do
			local node = parent:AddNode(value.Name)
			if value.Icon then
				node.Icon:SetImage(value.Icon)
			end
		end
	end
end

function GMBuddy.CreateHermes()
	local container = vgui.Create("DPanel")
	container:SetSize(ScrW(), ScrH())
	container:SetCursor("hand")
	function container:Paint(w, h)
	end
	local spawn_menu = vgui.Create("DPanel", container)
	local edit_menu = vgui.Create("DPanel", container)
	local spawn_tree = vgui.Create("GMBTree", spawn_menu)
	local options = {}
	spawn_tree:Dock(FILL)
	spawn_tree:SetLineHeight(24)
	local edit_tree = vgui.Create("GMBTree", edit_menu)
	edit_tree:Dock(FILL)
	edit_tree:SetLineHeight(24)

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

	function pnl:Paint(w, h)
	end
	function spawn_tree:Paint(w, h)
	end
	function edit_tree:Paint(w, h)
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
	edit_menu:SetSize(ScrW() * 0.175, ScrH() * 0.98)
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
