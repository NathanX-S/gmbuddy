function GMBuddy.LookupUIMat(name)
	if not GMBuddy.MatCache[name] then
		GMBuddy.MatCache[name] = Material(name, "noclamp smooth mips")
	end
	return GMBuddy.MatCache[name]
end