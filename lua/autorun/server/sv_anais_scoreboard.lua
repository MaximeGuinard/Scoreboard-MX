--[[-------------------------------------------------------------------------
	Nets
---------------------------------------------------------------------------]]

util.AddNetworkString( "Anais:Scoreboard:Net:GetGod" )
util.AddNetworkString( "Anais:Scoreboard:Net:SendGod" )

--[[-------------------------------------------------------------------------
	get/send
---------------------------------------------------------------------------]]

net.Receive( "Anais:Scoreboard:Net:GetGod", function( _, pPlayer )
	local pVictim = net.ReadEntity()

	if not Anais.Scoreboard.AdminRanks[pPlayer:GetUserGroup()] then return DarkRP.notify( pPlayer, 1, 5, "Vous n'êtes pas administrateur !" ) end  
	if not IsValid( pVictim ) then return end
	if not pVictim:IsPlayer() then return end

	net.Start( "Anais:Scoreboard:Net:SendGod" )
		net.WriteBool( pVictim:HasGodMode() or false )
	net.Send( pPlayer )
end)