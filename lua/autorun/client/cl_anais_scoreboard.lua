surface.CreateFont( "Anais:Scoreboard:Fonts:TitleCMDS", { font = "Roboto", size = ScrW() * 0.015 } )
surface.CreateFont( "Anais:Scoreboard:Fonts:InfosTime", { font = "Roboto", size = ScrW() * 0.008 } )
surface.CreateFont( "Anais:Scoreboard:Fonts:PInfos", { font = "Arial", size = ScrW() * 0.008 } )
surface.CreateFont( "Anais:Scoreboard:Fonts:PlayerInfos", { font = "Roboto", size = ScrW() * 0.012 } )

function Anais.Scoreboard:HideMenu()
	if IsValid( Anais.Scoreboard.Base ) then Anais.Scoreboard.Base:Remove() end
end

function Anais.Scoreboard:ShowMenu()
	Anais.Scoreboard.Base = vgui.Create( "DPanel" )
	local Base = Anais.Scoreboard.Base
	Base:SetSize( ScrW() * 0.58, ScrH() * 0.7 )
	Base:Center()
	Base:MakePopup()
	function Base:Paint()end

	local cmdPanel = vgui.Create( "DPanel", Base )
	cmdPanel:SetSize( ScrW() * 0.17, Base:GetTall() )
	function cmdPanel:Paint( w, h )
		draw.RoundedBox( 12, 0, 0, w, h, Color( 34, 52, 68 ) )
		draw.SimpleText( "Liste des commandes :", "Anais:Scoreboard:Fonts:TitleCMDS", w / 2, ScrH() * .01, color_white, 1 )
		draw.RoundedBox( 0, 0, ScrH() * 0.045, w, ScrH() * .001, color_white )
	end

	local Scroll = vgui.Create( "DScrollPanel", cmdPanel )
	Scroll:SetSize( cmdPanel:GetWide() - ScrW() * 0.01 + 15, cmdPanel:GetTall() - ScrH() * 0.065 )
	Scroll:SetPos( ScrW() * 0.005, ScrH() * 0.055 )

	local sbar = Scroll:GetVBar()
	function sbar:Paint()end function sbar.btnUp:Paint()end function sbar.btnDown:Paint()end function sbar.btnGrip:Paint()end

	local List = vgui.Create( "DIconLayout", Scroll )
	List:SetSize( Scroll:GetWide() - 15, Scroll:GetTall() )
	List:SetSpaceY( 5 )
	List:SetSpaceX( 0 )

	for k, v in pairs( Anais.Scoreboard.Commands ) do
		local btn = vgui.Create( "DButton", List )
		btn:SetSize( List:GetWide(), ScrH() * 0.04 )
		btn:SetText("")
		function btn:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 21, 35, 47 ) )
			draw.SimpleText( v.title, "Anais:Scoreboard:Fonts:TitleCMDS", w / 2, h / 2, color_white, 1, 1 )
		end
		function btn:DoClick()
			v.f()
		end
	end

	local playersPanel = vgui.Create( "DPanel", Base )
	playersPanel:SetSize( ScrW() * 0.4, Base:GetTall() )
	playersPanel:SetPos( ScrW() * 0.18, 0 )
	function playersPanel:Paint( w, h )
		draw.RoundedBox( 12, 0, 0, w, h, Color( 21, 35, 47 ) )
		draw.SimpleText( "BoomCityRP", "Anais:Scoreboard:Fonts:TitleCMDS", w / 2, ScrH() * .01, color_white, 1 )
		draw.RoundedBox( 0, 0, ScrH() * 0.045, w, ScrH() * .001, color_white )

		draw.SimpleText( table.Count( player.GetAll() ) .. " / " .. game.MaxPlayers(), "Anais:Scoreboard:Fonts:InfosTime", w - ScrW() * 0.01, ScrH() * 0.007, color_white, 2, 0 )
		draw.SimpleText( os.date( "%H:%M", os.time() ), "Anais:Scoreboard:Fonts:InfosTime", w - ScrW() * 0.01, ScrH() * 0.022, color_white, 2, 0 )
	end

	local Scroll = vgui.Create( "DScrollPanel", playersPanel )
	Scroll:SetSize( playersPanel:GetWide() - ScrW() * 0.01 + 15, playersPanel:GetTall() - ScrH() * 0.065 )
	Scroll:SetPos( ScrW() * 0.005, ScrH() * 0.055 )

	local sbar = Scroll:GetVBar()
	function sbar:Paint()end function sbar.btnUp:Paint()end function sbar.btnDown:Paint()end function sbar.btnGrip:Paint()end

	local List = vgui.Create( "DIconLayout", Scroll )
	List:SetSize( Scroll:GetWide() - 15, Scroll:GetTall() )
	List:SetSpaceY( 5 )
	List:SetSpaceX( 0 )

	local pActiveScore = nil
	if Anais.Scoreboard.AdminRanks[LocalPlayer():GetUserGroup()] then
		Anais.Scoreboard.adminPanel = vgui.Create( "DPanel", Base )
		Anais.Scoreboard.adminPanel:SetSize( ScrW() * 0.17, Base:GetTall() )
		Anais.Scoreboard.adminPanel:SetPos( ScrW() * 0.59, 0 )
		function Anais.Scoreboard.adminPanel:Paint( w, h )
			if pActiveScore == nil then return end

			draw.RoundedBox( 12, 0, 0, w, h, Color( 34, 52, 68 ) )
			draw.SimpleText( "Informations du joueur :", "Anais:Scoreboard:Fonts:TitleCMDS", w / 2, ScrH() * .01, color_white, 1 )
			draw.RoundedBox( 0, 0, ScrH() * 0.045, w, ScrH() * .001, color_white )

			draw.SimpleText( pActiveScore:Nick(), "Anais:Scoreboard:Fonts:PlayerInfos", w / 2, ScrH() * .055, color_white, 1 )
			draw.SimpleText( pActiveScore:SteamID(), "Anais:Scoreboard:Fonts:PlayerInfos", w / 2, ScrH() * .085, color_white, 1 )
			draw.SimpleText( "Grade :  " .. pActiveScore:GetUserGroup(), "Anais:Scoreboard:Fonts:PlayerInfos", w / 2, ScrH() * .115, color_white, 1 )
			draw.SimpleText( "Métier :  " .. pActiveScore:getDarkRPVar( "job" ), "Anais:Scoreboard:Fonts:PlayerInfos", w / 2, ScrH() * .145, color_white, 1 )
			draw.SimpleText( "Santé :  " .. pActiveScore:Health(), "Anais:Scoreboard:Fonts:PlayerInfos", w / 2, ScrH() * .175, color_white, 1 )
			draw.SimpleText( "Meurtre(s) :  " .. pActiveScore:Frags(), "Anais:Scoreboard:Fonts:PlayerInfos", w / 2, ScrH() * .205, color_white, 1 )
			draw.SimpleText( "Mort(s) :  " .. pActiveScore:Deaths(), "Anais:Scoreboard:Fonts:PlayerInfos", w / 2, ScrH() * .235, color_white, 1 )
		end

		local Scroll = vgui.Create( "DScrollPanel", Anais.Scoreboard.adminPanel )
		Scroll:SetSize( Anais.Scoreboard.adminPanel:GetWide() - ScrW() * 0.01 + 15, Anais.Scoreboard.adminPanel:GetTall() - ScrH() * 0.28 )
		Scroll:SetPos( ScrW() * 0.005, ScrH() * 0.27 )

		local sbar = Scroll:GetVBar()
		function sbar:Paint()end function sbar.btnUp:Paint()end function sbar.btnDown:Paint()end function sbar.btnGrip:Paint()end

		local List = vgui.Create( "DIconLayout", Scroll )
		List:SetSize( Scroll:GetWide() - 15, Scroll:GetTall() )
		List:SetSpaceY( 5 )
		List:SetSpaceX( 0 )

		for Bk, Bv in pairs( Anais.Scoreboard.AdminCommands ) do
			local btn = vgui.Create( "DButton", List )
			btn:SetSize( List:GetWide(), ScrH() * 0.04 )
			btn:SetText("")
			function btn:Paint( w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 21, 35, 47 ) )
				draw.SimpleText( Bv.title, "Anais:Scoreboard:Fonts:TitleCMDS", w / 2, h / 2, color_white, 1, 1 )
			end
			function btn:DoClick()
				if not IsValid( pActiveScore ) then return end
				Bv.f( pActiveScore )
			end
		end
	end

	for k, v in pairs( player.GetAll() ) do
		local pPanel = vgui.Create( "DPanel", List )
		pPanel:SetSize( List:GetWide(), ScrH() * 0.04 )
		pPanel:SetText("")
		function pPanel:Paint( w, h )
			if not IsValid( v ) then self:Remove() return end

			local kills = v:Frags() > 1 and "s" or ""
			local deaths = v:Frags() > 1 and "s" or ""

			draw.RoundedBox( 0, 0, 0, w, h, Color( 34, 52, 68 ) )
			draw.SimpleText( "Nom : " .. v:Nick(), "Anais:Scoreboard:Fonts:PInfos", ScrH() * 0.03 + ScrW() * 0.01, h / 2, color_white, 0, 1 )
			draw.SimpleText( "Meurtre(s) : " .. v:Frags(), "Anais:Scoreboard:Fonts:PInfos", ScrH() * 0.03 + ScrW() * 0.20, h / 2, color_white, 0, 1 )
			draw.SimpleText( "Morts(s) : " .. v:Deaths(), "Anais:Scoreboard:Fonts:PInfos", ScrH() * 0.03 + ScrW() * 0.26, h / 2, color_white, 0, 1 )
			draw.SimpleText( "Ping : " .. v:Ping(), "Anais:Scoreboard:Fonts:PInfos", ScrH() * 0.03 + ScrW() * 0.32, h / 2, color_white, 0, 1 )
		end

		local pAvatar = vgui.Create( "AvatarImage", pPanel )
		pAvatar:SetSize( ScrH() * 0.03, ScrH() * 0.03 )
		pAvatar:SetPos( ScrH() * 0.005, ScrH() * 0.005 )
		pAvatar:SetPlayer( v )

		if Anais.Scoreboard.AdminRanks[LocalPlayer():GetUserGroup()] then
			local btnOver = vgui.Create( "DButton", pPanel )
			btnOver:SetSize( pPanel:GetWide(), pPanel:GetTall() )
			btnOver:SetText("")
			function btnOver:Paint() end
			function btnOver:DoClick()

				Anais.Scoreboard.adminPanel:AlphaTo( 0, 0.1, 0, function()
					Anais.Scoreboard.adminPanel:AlphaTo( 255, 0.1 )
					Base:SetWide( ScrW() * 0.76 )
					Base:Center()
					pActiveScore = v
				end)

			end
		end
	end


	return false	
end

hook.Add( "InitPostEntity", "Anais:Scoreboard:Hook:InitPostEntity", function()
	hook.Add( "ScoreboardHide", "Anais:Scoreboard:Hook:ScoreboardHide", function()
		Anais.Scoreboard:HideMenu()
	end)

	hook.Add( "ScoreboardShow", "Anais:Scoreboard:Hook:ScorebodardShow", function()
		return Anais.Scoreboard:ShowMenu()
	end)
end)