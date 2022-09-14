GMBuddy.bHUD = false

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