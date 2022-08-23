local bg_color = Color(0,0,0,250)

hook.Add("HUDPaint", "GMBuddy.ContextPaint", function()
	if !g_ContextMenu:IsVisible() or !GMBuddy.bHUD then return end
	local box_w = ScrW() * 0.25
	local box_h = ScrH() * 0.2
	local base_x = ScrW() * 0.5 - (box_w / 2), ScrH() * 0.75
	local base_y = ScrH() * 0.75
	local tr = LocalPlayer():GetEyeTrace()
	draw.RoundedBox(0, base_x, base_y, box_w, box_h, bg_color)
	draw.SimpleText(tostring(tr.Entity), "DermaLarge", base_x + ScrW() * 0.01, base_y + ScrH() * 0.01)
	if !IsValid(tr.Entity) then return end
	draw.SimpleText("Health: " .. tostring(tr.Entity:Health()) .. "/" .. tostring(tr.Entity:GetMaxHealth()), 
	"DermaLarge", base_x + ScrW() * 0.01, base_y + ScrH() * 0.04)
end)