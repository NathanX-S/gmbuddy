GMBuddy.Items = GMBuddy.Items or {}
GMBuddy.Categories = GMBuddy.Categories or {}
local Item_meta = {
	AddOption = function(self, key, name, _type, extra)
		self.Options[key] = {["Key"] = key, ["Name"] = name, ["Type"] = _type, ["Parent"] = self, Children = {}}
		for k, v in pairs(extra) do
			self.Options[key][k] = v
		end
		return self.Options[key]
	end,
	GetParent = function(self)
		return self.Parent
	end
}
Item_meta.__index = Item_meta

local Supersubcategory_meta = {
	AddChild = function(self, key, name, icon)
		self.Children[key] = {["Key"] = key, ["Name"] = name, ["Icon"] = icon, ["Parent"] = self, Options = {}, Children = {}}
		setmetatable(self.Children[key], Item_meta)
		GMBuddy.Items[key] = self.Children[key]
		return self.Children[key]
	end,
	AddSubCategory = function(self, key, name)
		self.Children[key] = {["Key"] = key, ["Name"] = name, ["Parent"] = self, Children = {}}

		setmetatable(self.Children[key], Subcategory_meta)
		return self.Children[key]
	end,
	GetParent = function(self)
		return self.Parent
	end
}
Supersubcategory_meta.__index = Supersubcategory_meta

local Subcategory_meta = {
	AddChild = function(self, key, name, icon)
		self.Children[key] = {["Key"] = key, ["Name"] = name, ["Icon"] = icon, ["Parent"] = self, Options = {}, Children = {}}
		setmetatable(self.Children[key], Item_meta)
		GMBuddy.Items[key] = self.Children[key]
		return self.Children[key]
	end,
	AddSubCategory = function(self, key, name)
		self.Children[key] = {["Key"] = key, ["Name"] = name, ["Parent"] = self, Children = {}}

		setmetatable(self.Children[key], Supersubcategory_meta)
		return self.Children[key]
	end,
	GetParent = function(self)
		return self.Parent
	end
}
Subcategory_meta.__index = Subcategory_meta

local Category_meta = {
	AddSubCategory = function(self, key, name)
		self.Children[key] = {["Key"] = key, ["Name"] = name, ["Parent"] = self, Children = {}}

		setmetatable(self.Children[key], Subcategory_meta)
		return self.Children[key]
	end,
	GetParent = function(self)
		return self.Parent
	end
}
Category_meta.__index = Category_meta
function GMBuddy.AddCategory(key, name, icon)
	local cat = {["Key"] = key, ["Name"] = name, ["Icon"] = icon[1], ["Width"] = icon[2], Children = {}}
	GMBuddy.Categories[key] = cat
	setmetatable(GMBuddy.Categories[key], Category_meta)
	return GMBuddy.Categories[key]
end

function GMBuddy.PermsCheck(ply)
	return ply:GetUserGroup() == "superadmin"
end

function GMBuddy.IsValid(ent)
	return v:IsNPC() or v:IsNextBot()
end