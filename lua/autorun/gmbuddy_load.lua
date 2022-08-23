AddCSLuaFile()
GMBuddy = GMBuddy or {}
GMBuddy.CL = 1
GMBuddy.SH = 2
GMBuddy.SV = 3

GMBuddy.REALM_ORDER = {"sh", "sv", "cl"}

GMBuddy.FILE_ORDER = {"config", "util", "init"}

function GMBuddy.GetFileRealm(f)
	if not f:EndsWith(".lua") then return nil end
	if f:StartWith("sh_") then return GMBuddy.SH end
	if f:StartWith("cl_") then return GMBuddy.CL end
	if f:StartWith("sv_") then return GMBuddy.SV end
end

function GMBuddy.IsSV(f)
	return GMBuddy.GetFileRealm(f) == GMBuddy.SV
end

function GMBuddy.IsCL(f)
	return GMBuddy.GetFileRealm(f) == GMBuddy.CL
end

function GMBuddy.IsSH(f)
	return GMBuddy.GetFileRealm(f) == GMBuddy.SH
end

local function LoadFile(dir, f, element)
	for k, v in ipairs(GMBuddy.REALM_ORDER) do
		if not element[v] then continue end
		local path = dir .. "/" .. v .. "_" .. f .. ".lua"
		local f_split = string.Split(path, "/")
		local short = f_split[#f_split]
		if (GMBuddy.IsCL(short) or GMBuddy.IsSH(short)) and SERVER then
			AddCSLuaFile(path)
		end

		if GMBuddy.IsSH(short) or (GMBuddy.IsCL(short) and CLIENT) or (GMBuddy.IsSV(short) and SERVER) then
			include(path)
		end
	end

end

local function LoadDir(dir)
	if dir:StartWith("_") then return end

	local current_files = {}
	local found_files = file.Find(dir .. "/*.lua", "LUA")
	local _, directories = file.Find(dir .. "/*", "LUA")

	print("Loading \"" .. dir .. "\"!")

	for k, v in ipairs(found_files) do
		local f_split = string.Split(string.StripExtension(v), "_")
		PrintTable(f_split)
		if current_files[f_split[2]] == nil then
			current_files[f_split[2]] = {["sh"] = false, ["sv"] = false, ["cl"] = false}
		end
		current_files[f_split[2]][f_split[1]] = true
	end
	PrintTable(current_files)
	PrintTable(found_files)

	for _, v in ipairs(GMBuddy.FILE_ORDER) do
		if current_files[v] then
			LoadFile(dir, v, current_files[v])
		end
	end

	for k, v in pairs(current_files) do
		if k:StartWith("_") then continue end // skip _'d files
		LoadFile(dir, k, v)
	end

	for k, v in ipairs(directories) do
		LoadDir(dir .. "/" .. v)
	end
end

LoadDir("gmbuddy/base")
LoadDir("gmbuddy/ui")
LoadDir("gmbuddy/tools")
/*local _, dirs = file.Find("GMBuddy_*", "LUA") // load any GMBuddy related folders

for k, v in pairs(dirs) do
	LoadDir(v)
end*/