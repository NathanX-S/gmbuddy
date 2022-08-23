GMBuddy.Config.Menu = {}
GMBuddy.Config.Menu.Colors = {}
GMBuddy.Config.Menu.Colors["Selected"] = Color(204, 204,204,50)
GMBuddy.Config.Menu.Colors["UnselectedCat"] = Color(255, 255, 255,50)
GMBuddy.Config.Menu.Categories = {
	Modules = {
		Icon = "gmbuddy/box-solid.png",
		Children = {
			fx = {
				Name = "Effects",
				Children = {
					gmb_explosion = {
						Name = "Explosion",
						Icon = "gmbuddy/explosion-solid.png",
					}
				}
			}
		},
		Width = 48
	},
	Objects = {
		Icon = "gmbuddy/person-solid.png",
		Width = 32
	},
	Groups = {
		Icon = "gmbuddy/people-group-solid.png",
		Width = 64
	}
}
GMBuddy.Config.Colors = {}
GMBuddy.Config.Colors["Marker"] = Color(127, 255, 0, 150)