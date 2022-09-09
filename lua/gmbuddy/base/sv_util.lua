function GMBuddy.PermsCheck(ply)
	return ply:GetUserGroup() == "superadmin"
end