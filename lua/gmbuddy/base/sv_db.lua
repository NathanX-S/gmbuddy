GMBuddy.DB = GMBuddy.DB or {}
function GMBuddy.DB.Create()
	sql.Query("CREATE TABLE IF NOT EXISTS gmbuddy_players ( SteamID TEXT, Team INTEGER )")
end

function GMBuddy.DB.SavePly(ply)
	local sid = sql.SQLStr(ply:SteamID())
	local data = sql.Query("SELECT * FROM gmbuddy_players WHERE SteamID = " .. sid .. ";")
	if (data) then
		sql.Query("UPDATE gmbuddy_players SET Team = " .. ply:Team() .. " WHERE SteamID = " .. sid .. ";")
	else
		sql.Query("INSERT INTO gmbuddy_players ( SteamID, Team ) VALUES( " .. sid .. ", " .. ply:Team() .. " )")
	end
end

function GMBuddy.DB.GetPly(ply)
	local res = sql.QueryRow("SELECT * FROM gmbuddy_players WHERE SteamID = " .. sql.SQLStr(ply:SteamID()) .. ";")
	if not res then
		GMBuddy.DB.SavePly(ply)
		res = GMBuddy.DB.GetPly(ply)
	end
	res.Team = tonumber(res.Team)
	return res
end

hook.Add("Initialize", "GMBuddy.DB.Init", function()
	GMBuddy.DB.Create()
end)