hook.Add( "DrawPhysgunBeam", "GMBuddy.Tools.DrawBeam", function( ply, wep, enabled, target, bone, deltaPos )
	// Not "firing" the physgun? Don't draw anything.
	if !enabled then return false end

	return !(ply:GetNWBool("ToolgunStealth", false) && LocalPlayer() ~= ply)
end)