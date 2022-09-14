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
GMBuddy.Config.Categories = {
	Modules = {
		Icon = "gmbuddy/box-solid.png",
		Children = {
			fx = {
				Name = "Effects",
				Children = {
					gmb_explosion = {
						Name = "Explosion",
						Icon = "gmbuddy/explosion-solid.png",
						Options = {
							delay = {
								Name = "Delay",
								Type = GMBuddy.SLIDER,
								Step = 0.01,
								Min = 0,
								Max = 600
							},
							dmg = {
								Name = "Damage",
								Type = GMBuddy.SLIDER,
								Step = 1,
								Min = 0,
								Max = 1000
							},
							radius = {
								Name = "Radius",
								Type = GMBuddy.SLIDER,
								Step = 1,
								Min = 0,
								Max = 1000
							}
						}
					}
				}
			}
		},
		Width = 48
	},
	Objects = {
		Icon = "gmbuddy/person-solid.png",
		Width = 32,
		Children = {}
	},
	Groups = {
		Icon = "gmbuddy/people-group-solid.png",
		Width = 64,
		Children = {}
	}
}
GMBuddy.Config.Colors["Marker"] = Color(127, 255, 0, 150)
GMBuddy.Config.Colors["PlayerInfo"] = Color(255, 255, 255, 150)