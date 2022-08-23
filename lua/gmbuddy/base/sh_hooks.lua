hook.Add("Move", "GMBuddy.Move", function( ply, mv )
	if ply:GetNWBool("GMBuddy.MenuToggle", false) then
		return true
	end
end)