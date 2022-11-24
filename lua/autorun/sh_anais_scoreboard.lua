Anais = Anais or {}
Anais.Scoreboard = Anais.Scoreboard or {}

Anais.Scoreboard.AdminRanks = {
	["superadmin"] = true,
	["admin"] = true,
	["moderateur"] = true,
	["moderateur-test"] = true,
}

Anais.Scoreboard.URLs = {
	{ title = "Voir le site", url = "https://site.fr" },
	{ title = "Voir le forum", url = "https://forum.fr" },
	{ title = "Voir la boutique", url = "https://shop.fr" },
}

Anais.Scoreboard.Commands = {
	{ title = "Donner de l'argent", f = function()
		Derma_StringRequest( "Donner de l'argent", "Quelle est la somme ?", "", function( text ) LocalPlayer():ConCommand( "say /give " .. text ) end)
	end },
	{ title = "Déposer de l'argent", f = function()
		Derma_StringRequest( "Déposer de l'argent", "Quelle est la somme ?", "", function( text ) LocalPlayer():ConCommand( "say /dropmoney " .. text ) end)
	end },
	{ title = "Jeter mon arme", f = function() LocalPlayer():ConCommand( "say /drop" )end },
	{ title = "Mettre les mains en l'air", f = function() LocalPlayer():ConCommand( "????" )end },
	{ title = "Mode FPS/TPS", f = function() if not DTP_Toggle then DTP_Toggle = true else DTP_Toggle = false end end },
	{ title = "Stopper les sons", f = function() LocalPlayer():ConCommand( "stopsound" )end },
	{ title = "Ouvrir le boutique", f = function() LocalPlayer():ConCommand( "say !boutique" )end },
}

for k, v in pairs( Anais.Scoreboard.URLs ) do
	table.insert( Anais.Scoreboard.Commands, { title = v.title, f = function() gui.OpenURL( v.url ) end } )
end

Anais.Scoreboard.AdminCommands = {
	{ title = "Goto", f = function( pVictim ) LocalPlayer():ConCommand( "ulx goto \"" .. pVictim:Nick() .. "\"" ) end },
	{ title = "Teleporter", f = function( pVictim ) LocalPlayer():ConCommand( "ulx teleport \"" .. pVictim:Nick() .. "\"" ) end },
	{ title = "Retourner", f = function( pVictim ) LocalPlayer():ConCommand( "ulx return \"" .. pVictim:Nick() .. "\"" ) end },
	{ title = "Espionner", f = function( pVictim ) LocalPlayer():ConCommand( "say /spectate " .. pVictim:UserID() ) end },
	{ title = "SetTeam", f = function( pVictim )
		local menu = DermaMenu()

        local Padding = vgui.Create("DPanel")
        Padding:SetPaintBackgroundEnabled(false)
        Padding:SetSize(1,5)
        menu:AddPanel(Padding)

        local Title = vgui.Create("DLabel")
        Title:SetText("  Teams:\n")
        Title:SetFont("UiBold")
        Title:SizeToContents()
        Title:SetTextColor(color_black)

        menu:AddPanel(Title)
        for k, v in SortedPairsByMemberValue(team.GetAllTeams(), "Name") do
            local uid = pVictim:UserID()
            menu:AddOption(v.Name, function() RunConsoleCommand("_FAdmin", "setteam", uid, k) end)
        end
        menu:Open()
	end },
	{ title = "Geler/Dégeler", f = function( pVictim )
		if pVictim:IsFlagSet( 64 ) then
			LocalPlayer():ConCommand( "ulx unfreeze \"" .. pVictim:Nick() .. "\"" )
		else
			LocalPlayer():ConCommand( "ulx freeze \"" .. pVictim:Nick() .. "\"" )
		end
	end },
	{ title = "Cloak/Uncloak", f = function( pVictim )
		if pVictim:FAdmin_GetGlobal("FAdmin_cloaked") then
			LocalPlayer():ConCommand( "_fadmin uncloak \"" .. pVictim:Nick() .. "\"" )
		else
			LocalPlayer():ConCommand( "_fadmin cloak \"" .. pVictim:Nick() .. "\"" )
		end
	end },
	{ title = "God/UnGod", f = function( pVictim ) 
		net.Start( "Anais:Scoreboard:Net:GetGod" )
		net.WriteEntity( pVictim )
		net.SendToServer()

		net.Receive( "Anais:Scoreboard:Net:SendGod", function()
			local bool = net.ReadBool()

			if bool then
				LocalPlayer():ConCommand( "ulx ungod \"" .. pVictim:Nick() .. "\"" )
			else
				LocalPlayer():ConCommand( "ulx god \"" .. pVictim:Nick() .. "\"" )
			end
		end)
	end },
	{ title = "Set Health", f = function( pVictim )
		Derma_StringRequest( "Définir la vie d'un joueur", "?", "", function( text ) LocalPlayer():ConCommand( "_fadmin hp " .. pVictim:UserID() .. " " .. text ) end )
	end },
	{ title = "Kick", f = function( pVictim )
		Derma_StringRequest( "Expulser un joueur", "?", "", function( text ) LocalPlayer():ConCommand( "ulx kick \"" .. pVictim:Nick() .. "\" " .. text ) end )
	end },
	{ title = "Ban", f = function( pVictim ) LocalPlayer():ConCommand( "say !gmenu" ) end },
	{ title = "Demote", f = function( pVictim ) LocalPlayer():ConCommand( "rp_" .. RPExtraTeams[ GAMEMODE.DefaultTeam ].command .. " " .. pVictim:UserID() ) end },
	{ title = "Avertir", f = function() LocalPlayer():ConCommand( "say !warn" ) end },
	{ title = "Clear Decals", f = function() LocalPlayer():ConCommand( "_fadmin cleardecals" ) end },
	{ title = "Clean Up", f = function() LocalPlayer():ConCommand( "_fadmin cleanup" ) end },
}