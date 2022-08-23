local cfg = GMBuddy.Config.Menu
local selectedOption = "Objects"

concommand.Add("gmb_menu", function(ply, cmd, args)
	net.Start("GMBuddy.MenuToggle")
	net.WriteBool(!GMBuddy.bMenu)
	net.SendToServer()
	GMBuddy.bMenu = !GMBuddy.bMenu
	if GMBuddy.bMenu and GMBuddy.CameraPos == Vector(0, 0, 0) then
		local startPos = LocalPlayer():GetPos()
		local tr = util.TraceLine({
			start = LocalPlayer():GetPos(),
			endpos = LocalPlayer():GetPos() + LocalPlayer():GetAngles():Up() * 100000,
			mask = MASK_NPCWORLDSTATIC,
		})
		GMBuddy.CameraPos = tr.HitPos
		GMBuddy.CameraPos.z = math.min(tr.HitPos.z, 1000)
		GMBuddy.CameraAng = Angle(45, LocalPlayer():EyeAngles().yaw, 0)
	end
	if !GMBuddy.Menu then
		net.Start("GMBuddy.MenuRequest")
		net.SendToServer()
		return
	else
		GMBuddy.Menu:SetVisible(!GMBuddy.Menu:IsVisible())
	end
end)

concommand.Add("gmb_reload", function(ply, cmd, args)
	if GMBuddy.Menu then
		GMBuddy.Menu:Remove()
	end
	cfg = GMBuddy.Config.Menu
	GMBuddy.CreateMenu()
	GMBuddy.Menu:Show()
	GMBuddy.CameraPos = LocalPlayer():GetPos()
	local max = game.GetWorld():OBBMaxs()
	//GMBuddy.CameraPos.y = max.y
end)

net.Receive("GMBuddy.MenuResponse", function(len, ply)
	if !GMBuddy.Menu then
		GMBuddy.CreateMenu()
		return
	end
	GMBuddy.bMenu = LocalPlayer():GetNWBool("GMBuddy.MenuToggle", false)
	GMBuddy.Menu:SetVisible(!GMBuddy.Menu:IsVisible())
end)

function GMBuddy.CreateMenu()
	local container = vgui.Create("DPanel")
	local tree = vgui.Create("GMBTree", container)
	local options = {}
	tree:Dock(FILL)
	tree:SetLineHeight(24)
	local pnl = vgui.Create("DPanel", container)
	pnl:Dock(TOP)
	pnl:SetTall(ScrH() * 0.06)
	pnl:DockPadding(ScrW() * 0.003, ScrH() * 0.007, ScrW() * 0.003, ScrH() * 0.003)
	pnl:DockMargin(0, 0, 0, ScrH() * 0.015)
	//grid:SetColWide( 64 )

	timer.Simple(0, function()
		local fullWidth = pnl:GetWide()
		for k, v in pairs(cfg.Categories) do
			local btn = vgui.Create( "DImageButton", pnl )
			fullWidth = fullWidth - v.Width
			btn:SetStretchToFit(true)
			btn:SetKeepAspect(false)
			btn:SetSize(v.Width, 64)			-- OPTIONAL: Use instead of SizeToContents() if you know/want to fix the size
			btn:SetImage( v.Icon )	-- Set the material - relative to /materials/ directory
			if k ~= selectedOption then
				btn.m_Image:SetImageColor(cfg.Colors["UnselectedCat"])
			else
				btn.m_Image:SetImageColor(color_white)
			end
			btn:NoClipping(true)
			btn.DoClick = function()
				surface.PlaySound("UI/buttonclick.wav")
				PrintTable(options)
				print(options[selectedOption])
				options[selectedOption].m_Image:SetImageColor(cfg.Colors["UnselectedCat"])
				selectedOption = k
				btn.m_Image:SetImageColor(color_white)
			end
			local oldPaint = btn.Paint
			function btn:Paint(w, h)
				oldPaint(self, w, h)
				draw.DrawText(k, "GMB_UI", v.Width / 2, ScrH() * 0.05, color_white, TEXT_ALIGN_CENTER)
			end
			btn:Dock(LEFT)
			btn:DockMargin(42, 0, 0, 0)
			options[k] = btn
		end
	end)
	function pnl:Paint(w, h)
		//print(pnl:GetX(), pnl:GetY(), w, h, 2)
		//draw.RoundedBox(0, pnl:GetX(), pnl:GetY(), w, h, color_white)
	end
	function tree:Paint(w, h)
	end
	local node = tree:AddNode( "Node One" )
	//node.Label:SetContentAlignment(0)
	node:SizeToContents()
	local cnode = node:AddNode( "Node 2.1" )
	container:SetSize(ScrW() * 0.175, ScrH() * 0.98)
	container:SetX(ScrW() * 0.8125)
	container:CenterVertical()
	function container:Paint(w, h)
		//print(pnl:GetX(), pnl:GetY(), w, h, 2)
		//draw.RoundedBox(0, pnl:GetX(), pnl:GetY(), w, h, color_white)
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, ScrH() * 0.075, w, 2)
		surface.DrawOutlinedRect(0, 0, w, h, 2)
	end
	/*for i=0, 100 do
		local DButton = scroll:Add( "DButton" )
		DButton:SetText( "Button #" .. i )
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 1 )
	end*/
	GMBuddy.Menu = container
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
	if pnl:GetParent() == GMBuddy.Menu and pnl:GetName() == "GMBTree" then
		pnl:SetSelectedItem(nil)
	end
end)