GMBuddy.SLIDER = 1
GMBuddy.TEXT = 2
GMBuddy.CHECKBOX = 3
GMBuddy.LIST = 4
GMBuddy.RADIO = 5

GMBuddy.Config.HUDElements = {
	["CHudGMod"] = true,
	["CHudCrosshair"] = true,
	["CHudWeaponSelection"] = true,
	["CHudAmmo"] = true,
	["CHudHealth"] = true,
	["CHudSecondaryAmmo"] = true,
}
GMBuddy.Config.Cam = {}
GMBuddy.Config.Cam.MoveMult = 10
GMBuddy.Config.Colors = {}
GMBuddy.Config.Colors["Selected"] = Color(204, 204,204,50)
GMBuddy.Config.Colors["UnselectedCat"] = Color(255, 255, 255,50)
GMBuddy.Config.Colors["Marker"] = Color(127, 255, 0, 150)

local cat = GMBuddy.AddCategory("mdls", "Modules", {"gmbuddy/box-solid.png", 48})
local sub = cat:AddSubcategory("fx", "Effects")
local child = sub:AddChild("gmb_explosion", "Explosion", "gmbuddy/explosion-solid.png")
child:AddOption("delay", "Delay",
	GMBuddy.SLIDER,
	{Step = 0.01,
	Min = 0, Max = 600})
child:AddOption("dmg", "Damage",
	GMBuddy.SLIDER,
	{Step = 1,
	Min = 0, Max = 1000})
child:AddOption("radius", "Radius",
	GMBuddy.SLIDER,
	{Step = 1,
	Min = 0, Max = 1000})

cat = GMBuddy.AddCategory("objs", "Objects", {"gmbuddy/person-solid.png", 32})
cat = GMBuddy.AddCategory("groups", "Groups", {"gmbuddy/people-group-solid.png", 64})

PrintTable(GMBuddy.Config.Categories)
GMBuddy.Config.Colors["Marker"] = Color(127, 255, 0, 150)
GMBuddy.Config.Colors["PlayerInfo"] = Color(255, 255, 255, 150)