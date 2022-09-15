local Module_meta = {
	AddOption = function(self, key, name, _type, extra)
		self.Options[key] = {["Name"] = name, ["Type"] = _type}
		for k, v in pairs(extra) do
			self.Options[key][k] = v
		end
		return self.Options[key]
	end
}
Module_meta.__index = Module_meta

local Subcategory_meta = {
	AddChild = function(self, key, name, icon)
		self.Children[key] = {["Name"] = name, ["Icon"] = icon, Options = {}}
		setmetatable(self.Children[key], Module_meta)
		return self.Children[key]
	end
}
Subcategory_meta.__index = Subcategory_meta

local Category_meta = {
	AddSubcategory = function(self, key, name)
		self.Children[key] = {["Name"] = name, Children = {}}
		setmetatable(self.Children[key], Subcategory_meta)
		return self.Children[key]
	end
}
Category_meta.__index = Category_meta
function GMBuddy.AddCategory(key, name, icon)
	local cat = {["Name"] = name, ["Icon"] = icon[1], ["Width"] = icon[2], Children = {}}
	GMBuddy.Config.Categories[key] = cat
	setmetatable(GMBuddy.Config.Categories[key], Category_meta)
	return GMBuddy.Config.Categories[key]
end