GMBuddy.Elements = {}
GMBuddy.bMenu = false
GMBuddy.bHUD = false
GMBuddy.CameraPos = Vector(0, 0, 0)
GMBuddy.CameraAng = Angle(0 , 0, 0)
GMBuddy.SPAWN_MENU = 1
GMBuddy.EDIT_MENU = 2

list.Set("DesktopWindows", "GMBuddyIcon", {
	title = "GMBuddy HUD",
	icon = "icon16/wand.png",
	init = function( icon, window )
		GMBuddy.bHUD = !GMBuddy.bHUD
	end
})

surface.CreateFont("GMB_UI", {
	font = "Roboto",
	extended = false,
	size = 18,
	weight = 500,
})

surface.CreateFont("GMB_Info", {
	font = "Roboto",
	extended = false,
	size = 18,
	weight = 500,
	shadow = false,
})