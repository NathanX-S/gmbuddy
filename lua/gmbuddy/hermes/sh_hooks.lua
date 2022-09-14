hook.Add("Move", "GMBuddy.Move", function( ply, mv )
	if ply:GetNWBool("GMBuddy.HermesToggle", false) then
		return true
	end
end)