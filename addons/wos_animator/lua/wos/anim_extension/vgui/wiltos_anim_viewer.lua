--[[-------------------------------------------------------------------
	wiltOS Animation Viewer:
		A Supplement to the animation base, it allows you to view more than	
					2000 animations/sequences with it's model viewer
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
-------------------------------------------------------------------]]--[[
							  
	Lua Developer: King David
	Contact: http://steamcommunity.com/groups/wiltostech
		
----------------------------------------]]--
wOS = wOS or {}

local w, h = ScrW(), ScrH()

surface.CreateFont( "wOS.Anim.TitleFont", {
	font = "Roboto Cn", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 24*(h/1200),
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "wOS.Anim.DescFont",{
	font = "Roboto Cn", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 18*(h/1200),
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

list.Add( "DesktopWindows", {
	icon = "wos/anim_extension/emblem.png",
	title = "wiltOS Viewer",
	init = function() wOS:OpenAnimationMenu() end,
})

function wOS:OpenAnimationMenu()

	if self.OverFrame then 
		self.OverFrame:Remove()
		self.OverFrame = nil
		gui.EnableScreenClicker( false )
		return 
	end

	self.OverFrame = vgui.Create( "DFrame" )
	self.OverFrame:SetSize( w, h )
	self.OverFrame:Center()
	self.OverFrame.Paint = function() end
	self.OverFrame:SetTitle( "" )
	self.OverFrame:ShowCloseButton( false )
	self.OverFrame:SetDraggable( false )
	
	gui.EnableScreenClicker( true )
	self.AnimMenu = vgui.Create( "DFrame", self.OverFrame )
	self.AnimMenu:SetSize( w*0.5, h*0.5 )
	self.AnimMenu:Center()
	self.AnimMenu.Display = LocalPlayer():GetModel()
	self.AnimMenu:MakePopup()
	self.AnimMenu:SetTitle( "" )
	self.AnimMenu:ShowCloseButton( false )
	self.AnimMenu:SetDraggable( false )
	
	local fw, fh = self.AnimMenu:GetSize()
	local padx = fh*0.025
	local pady = padx
	
	local modelmenu = vgui.Create( "DAdjustableModelPanel", self.AnimMenu )
	modelmenu:SetPos( padx, pady )
	modelmenu:SetSize( fw/2 - padx - padx/2, fh - 2*pady )
	modelmenu.LayoutEntity = function() local ent = modelmenu:GetEntity() ent:SetEyeTarget( modelmenu:GetCamPos() ) ent:FrameAdvance( FrameTime() ) end
	
	self.AnimMenu.Paint = function( pan, ww, hh )
		if not vgui.CursorVisible() then gui.EnableScreenClicker( true ) end
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
		--draw.SimpleText( "Animation Viewer", "wOS.Anim.TitleFont", ww/2, hh*0.05, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
		surface.SetDrawColor( Color( 0, 155, 155, 255 ) )
		surface.DrawOutlinedRect( padx, pady, modelmenu:GetWide(), modelmenu:GetTall() )
	end 
		
	local lister = vgui.Create( "DListView", self.AnimMenu )
	lister:SetPos( fw/2 + padx/2, pady )
	lister:SetSize( fw/2 - padx - padx/2, fh*0.77 - pady)	
	lister:AddColumn( "Name" )
	lister:SetMultiSelect( false )
	lister:SetHideHeaders( true )
	lister.Pages = {}
	lister.CurrentPage = 1
	
	function lister:Think()
		if wOS.AnimMenu.Display != modelmenu:GetModel() then
			modelmenu:RebuildModel()
		end	
	end
	
	function lister:RebuildCache( ent )
		lister:Clear()
		lister.Pages = {}
		lister.CurrentPage = 1
		local max = 500
		local count = 0
		local curpage = 1
		for k, v in SortedPairsByValue( ent:GetSequenceList() ) do
			if not lister.Pages[ curpage ] then lister.Pages[ curpage ] = {} end
			if count < max then
				table.insert( lister.Pages[ curpage ], string.lower( v ) )
				if curpage == 1 then
					local line = lister:AddLine( string.lower( v ) )
					line.OnSelect = function()
						ent:ResetSequence( v )
						ent:SetCycle( 0 )
						
					end
				end
				count = count + 1
			else
				curpage = curpage + 1
				count = 0
			end
		end
	end
	
	function lister:ChangePage( page )
		lister:Clear()
		if not page then return end	
		if not lister.Pages[ page ] then return end
		local ent = modelmenu:GetEntity()
		for k, v in pairs( lister.Pages[ page ] ) do
			local line = lister:AddLine( string.lower( v ) )
			line.OnSelect = function()
				ent:ResetSequence( v )
				ent:SetCycle( 0 )
			end
		end
	end
	
	function modelmenu:RebuildModel()
		modelmenu:SetModel( wOS.AnimMenu.Display )
		local ent = modelmenu:GetEntity()
		local pos = ent:GetPos()
		local campos = pos + Vector( -150, 0, 0 )
		modelmenu:SetCamPos( campos )
		modelmenu:SetFOV( 45 )
		modelmenu:SetLookAng( ( campos * -1 ):Angle() )
		lister:RebuildCache( modelmenu:GetEntity() )
	end
	
	local nextbutt = vgui.Create( "DButton", self.AnimMenu )
	nextbutt:SetSize( fw*0.15, fh*0.05 )
	nextbutt:SetPos( fw*0.85 - padx, fh*0.77 + 2*pady )
	nextbutt:SetText( "" )
	nextbutt.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "NEXT PAGE", "wOS.Anim.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	nextbutt.DoClick = function( pan )
		lister.CurrentPage = math.Clamp( lister.CurrentPage + 1, 1, #lister.Pages )
		lister:ChangePage( lister.CurrentPage )
	end
	
	local prevbutt = vgui.Create( "DButton", self.AnimMenu )
	prevbutt:SetSize( fw*0.15, fh*0.05 )
	prevbutt:SetPos( fw/2 + padx/2, fh*0.77 + 2*pady )
	prevbutt:SetText( "" )
	prevbutt.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "PREVIOUS PAGE", "wOS.Anim.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	prevbutt.DoClick = function( pan )
		lister.CurrentPage = math.Clamp( lister.CurrentPage - 1, 1, #lister.Pages )
		lister:ChangePage( lister.CurrentPage )
	end
	
	local replaybutt = vgui.Create( "DButton", self.AnimMenu )
	replaybutt:SetSize( fw*0.15, fh*0.05 )
	replaybutt:SetPos( fw/2 + padx/2 + fw*0.15 + padx, fh*0.77 + 2*pady )
	replaybutt:SetText( "" )
	replaybutt.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "REPLAY SELECTION", "wOS.Anim.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	replaybutt.DoClick = function( pan )
		local selected = lister:GetSelectedLine()
		if not selected then return end
		local ent = modelmenu:GetEntity()
		ent:ResetSequence( lister:GetLines()[ selected ]:GetValue( 1 ) )
		ent:SetCycle( 0 )		
	end
	
	local closebutt = vgui.Create( "DButton", self.AnimMenu )
	closebutt:SetSize( fw*0.3, fh*0.05 )
	closebutt:SetPos( fw/2 + fw*0.1, fh*0.95 - pady )
	closebutt:SetText( "" )
	closebutt.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "CLOSE MENU", "wOS.Anim.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	closebutt.DoClick = function( pan )
		wOS:OpenAnimationMenu()	
	end
	
	local mw, mh = modelmenu:GetSize()
	
	local infoframe = vgui.Create( "DPanel", modelmenu )
	infoframe:SetSize( mw, mh*0.2 )
	infoframe:SetPos( 0, mh*0.8 )
	infoframe.Paint = function( pan, ww, hh )
		if not lister:GetLines()[ lister:GetSelectedLine() ] then return end
		local title = lister:GetLines()[ lister:GetSelectedLine() ]:GetValue( 1 )
		local ent = modelmenu:GetEntity()
		local act = ent:LookupSequence( title )
		draw.SimpleText( "SEQUENCE: " .. title, "wOS.Anim.DescFont", ww/2, hh*0.25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		if act then
			local actn = ent:GetSequenceActivityName( act )
			act = ent:GetSequenceActivity( act )
			if not act then 
				draw.SimpleText( "ACT ID: NONE", "wOS.Anim.DescFont", ww/2, hh*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( "ACT ID: " .. act, "wOS.Anim.DescFont", ww/2, hh*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			if not actn then 
				draw.SimpleText( "ACT NAME: N/A", "wOS.Anim.DescFont", ww/2, hh*0.75, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( "ACT NAME: " .. actn, "wOS.Anim.DescFont", ww/2, hh*0.75, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end	
	end
	
	local holdframe = vgui.Create( "DFrame", self.OverFrame )
	holdframe:SetSize( fw*0.3, fh*0.1 )
	holdframe:SetPos( fw*1.5 + fw*0.01, fh - fh/2 )
	holdframe:SetText( "" )
	holdframe:SetTitle( "" )
	holdframe:ShowCloseButton( false )
	holdframe:SetDraggable( false )
	holdframe.Paint = function( pan, ww, hh )
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
	end
	holdframe.Think = function( pan )
		local endy = fh*0.1
		if pan.Expand then
			endy = fh
		end
		pan:SetTall( math.Approach( pan:GetTall(), endy, 15 ) )
	end
	holdframe.Expand = false
	holdframe:MakePopup()
	
	local iw, ih = holdframe:GetSize()
	
	local togglebutt = vgui.Create( "DButton", holdframe )
	togglebutt:SetSize( iw*0.9, fh*0.05 )
	togglebutt:SetPos( iw*0.05, ih - fh*0.075 )
	togglebutt:SetText( "" )
	togglebutt.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( ( holdframe.Expand and "Close Holdtype Creator" ) or "Open Holdtype Creator", "wOS.Anim.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	local ACTS = { 
		[ "Idle Standing" ] = "ACT_MP_STAND_IDLE", 
		[ "Walk Standing" ] = "ACT_MP_WALK", 
		[ "Running" ] = "ACT_MP_RUN", 
		[ "Idle Crouching" ] = "ACT_MP_CROUCH_IDLE", 
		[ "Walk Crouching" ] = "ACT_MP_CROUCHWALK", 
		[ "Attack Standing" ] = "ACT_MP_ATTACK_STAND_PRIMARYFIRE",
		[ "Attack Crouching" ] = "ACT_MP_ATTACK_CROUCH_PRIMARYFIRE",
		[ "Reload Standing" ] = "ACT_MP_RELOAD_STAND",
		[ "Reload Crouching" ] = "ACT_MP_RELOAD_CROUCH",
		[ "Reload Crouching" ] = "ACT_MP_JUMP",
		[ "Swimming" ] = "ACT_MP_SWIM",
		[ "Jumping" ] = "ACT_MP_JUMP",
		[ "Landing" ] = "ACT_LAND",
	}
	
	local title = vgui.Create( "DLabel", holdframe )
	title:SetSize( iw*0.8, fh*0.05 )
	title:SetPos( iw*0.05, ih )
	title:SetText( "Base Holdtype:" )
	title:SetFont( "wOS.Anim.TitleFont" )
	
	local basetype = vgui.Create( "DTextEntry", holdframe )
	basetype:SetSize( iw*0.8, fh*0.03 )
	basetype:SetPos( iw*0.05, ih + fh*0.05 )
	
	local baselist = vgui.Create( "DImageButton", holdframe )
	baselist:SetSize( fh*0.03, fh*0.03 )
	baselist:SetPos( iw*0.86, ih + fh*0.05 )
	baselist:SetImage( "icon16/application_view_list.png" )	
	baselist.DoClick = function( pan )
		if pan.ItemIconOptions then pan.ItemIconOptions:Remove() pan.ItemIconOptions = nil end
		pan.ItemIconOptions = DermaMenu( baselist )
		pan.ItemIconOptions:MakePopup()
		pan.ItemIconOptions:SetPos( gui.MouseX(), gui.MouseY() )
		pan.ItemIconOptions.Think = function( self )
			if not pan then self:Remove() end
		end
		local holdlist = { "pistol", "smg", "grenade", "ar2", "shotgun", "rpg", "physgun", "crossbow", "melee", "slam", "normal", "fist", "melee2", "passive", "knife", "duel", "camera", "magic", "revolver" }
		for name, _ in pairs( wOS.AnimExtension.TranslateHoldType ) do
			table.insert( holdlist, name )
		end
		for _, typ in ipairs( holdlist ) do
			pan.ItemIconOptions:AddOption( typ, function( self ) 
				basetype:SetText( typ )
				self:Remove()
			end )
		end			
	end
	
	local title = vgui.Create( "DLabel", holdframe )
	title:SetSize( iw*0.9, fh*0.05 )
	title:SetPos( iw*0.05, ih + fh*0.09 )
	title:SetText( "Holdtype Name:" )
	title:SetFont( "wOS.Anim.TitleFont" )
	
	local nametext = vgui.Create( "DTextEntry", holdframe )
	nametext:SetSize( iw*0.9, fh*0.03 )
	nametext:SetPos( iw*0.05, ih + fh*0.15 )
	
	local title = vgui.Create( "DLabel", holdframe )
	title:SetSize( iw*0.9, fh*0.05 )
	title:SetPos( iw*0.05, ih + fh*0.19 )
	title:SetText( "Holdtype Code:" )
	title:SetFont( "wOS.Anim.TitleFont" )
	
	local prefix = vgui.Create( "DTextEntry", holdframe )
	prefix:SetSize( iw*0.9, fh*0.03 )
	prefix:SetPos( iw*0.05, ih + fh*0.25 )
	prefix:SetText( "wos-custom-xxx" )
	
	local title2 = vgui.Create( "DLabel", holdframe )
	title2:SetSize( iw*0.9, fh*0.05 )
	title2:SetPos( iw*0.05, ih + fh*0.29 )
	title2:SetText( "Current Action:" )
	title2:SetFont( "wOS.Anim.TitleFont" )
	
	local DComboBox = vgui.Create( "DComboBox", holdframe )
	DComboBox:SetSize( iw*0.9, fh*0.03 )
	DComboBox:SetPos( iw*0.05, ih + fh*0.35 )
	DComboBox:SetValue( "Idle Standing" )
	for act, _ in pairs( ACTS ) do
		DComboBox:AddChoice( act )
	end
	
	local AddSeq = vgui.Create( "DButton", holdframe )
	AddSeq:SetSize( iw*0.9, fh*0.05 )
	AddSeq:SetPos( iw*0.05, fh*0.515 )
	AddSeq:SetText( "" )
	AddSeq.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "Add Selected Sequence", "wOS.Anim.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	local AppList = vgui.Create( "DListView", holdframe )
	AppList:SetSize( iw*0.9, fh*0.3 )
	AppList:SetPos( iw*0.05, fh*0.6 )
	AppList:SetMultiSelect( false )
	AppList:AddColumn( "Animation" )
	AppList:AddColumn( "Weight" )
	AppList.OnRowRightClick = function( pan, id, line )
		if pan.ItemIconOptions then pan.ItemIconOptions:Remove() pan.ItemIconOptions = nil end
		pan.ItemIconOptions = DermaMenu( AppList )
		pan.ItemIconOptions:MakePopup()
		pan.ItemIconOptions:SetPos( gui.MouseX(), gui.MouseY() )
		pan.ItemIconOptions.Think = function( self )
			if not pan then self:Remove() end
		end
		pan.ItemIconOptions:AddOption( "Change Weight", function( self ) 

			local Scratch = vgui.Create( "DNumberScratch", holdframe:GetParent() )
			Scratch:SetSize( 1, 1 )
			Scratch:Center()
			Scratch:MakePopup()
			Scratch:SetValue( pan.Selections[ pan.ActSelect ][ line:GetValue( 1 ) ]*100 or 100 )
			Scratch:SetMin( 0 )
			Scratch:SetMax( 100 )
			Scratch.OnMousePressed = function() end
			Scratch.OnMouseReleased = function() end
			Scratch.OnValueChanged = function( panz )
				pan.Selections[ pan.ActSelect ][ line:GetValue( 1 ) ] = math.Round( panz:GetFloatValue() )/100
			end
			Scratch.Think = function( panz )
				if input.IsMouseDown( MOUSE_LEFT ) or input.IsMouseDown( MOUSE_RIGHT ) then
					panz:Remove()
					AppList:ReloadAll()
					return
				end
				panz:SetActive( true )
				panz:MouseCapture( true )
				panz:LockCursor()
				if ( !system.IsLinux() ) then
					panz:SetCursor( "none" )
				end
				panz:SetShouldDrawScreen( true )
			end
			hook.Add( "DrawOverlay", "wOS.AnimExtension.ReallyFuckedUpWorkAround", function()
				if ( !IsValid( Scratch ) ) then hook.Remove( "DrawOverlay", "wOS.AnimExtension.ReallyFuckedUpWorkAround" ) return end
				Scratch:PaintScratchWindow()
			end )
			self:Remove()
		end )	
		pan.ItemIconOptions:AddOption( "Remove", function( self ) 
			pan.Selections[ pan.ActSelect ][ line:GetValue( 1 ) ] = nil
			pan:RemoveLine( id )
			self:Remove()
		end )	
	end
	AppList.Selections = {}
	AppList.ActSelect = DComboBox:GetValue()
	AppList.ReloadAll = function( pan ) 
		pan:Clear()
		if pan.Selections[ pan.ActSelect ] then
			for sequence, weight in pairs( pan.Selections[ pan.ActSelect ] ) do
				pan:AddLine( sequence, weight * 100 .. "%" )
			end
		end
	end
	AppList:ReloadAll()
	
	AddSeq.DoClick = function( pan )
		local l = lister:GetSelected()[1]
		if l then
			AppList:AddLine( l:GetValue(1), "100%" )
			if not AppList.Selections[ AppList.ActSelect ] then
				AppList.Selections[ AppList.ActSelect ] = {}
			end
			AppList.Selections[ AppList.ActSelect ][ l:GetValue(1) ] = 1
		end
	end
	
	DComboBox.OnSelect = function( panel, index, value )
		AppList.ActSelect = value
		AppList:ReloadAll()
	end
	
	togglebutt.DoClick = function( pan )
		holdframe.Expand = !holdframe.Expand
		if !holdframe.Expand then
			basetype:SetText( "" )
			nametext:SetText( "" )
			prefix:SetText( "wos-custom-xxx" )
			DComboBox:SetValue( "Idle Standing" )
			AppList.ActSelect = "Idle Standing"
			AppList.Selections = {}
			AppList:ReloadAll()
		end
	end
	
	local CreateHoldType = vgui.Create( "DButton", holdframe )
	CreateHoldType:SetSize( iw*0.9, fh*0.05 )
	CreateHoldType:SetPos( iw*0.05, fh*0.925 )
	CreateHoldType:SetText( "" )
	CreateHoldType.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "Print Holdtype ( Console )", "wOS.Anim.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	CreateHoldType.DoClick = function( pan )
		chat.AddText( color_white, "[", Color( 0, 175, 255 ), "wOS", color_white, "] The Holdtype code has been printed into console!" )
		local name = ( nametext:GetText():len() > 0 and nametext:GetText() ) or "Rename Me" 
		local pref = ( prefix:GetText():len() > 0 and prefix:GetText() ) or "wos-custom-xxx" 
		local base = ( basetype:GetText():len() > 0 and basetype:GetText() ) or "normal"
		print( [[--=====================================================================]] )
		print( [[/*		My Custom Holdtype
			Created by ]] .. LocalPlayer():Nick() .. [[( ]] .. LocalPlayer():SteamID() .. [[ )*/]])
		print( [[
local DATA = {}
DATA.Name = "]] .. name .. [["
DATA.HoldType = "]] .. pref .. [["
DATA.BaseHoldType = "]] .. base .. [["
DATA.Translations = {} 
]])
		for slot, data in pairs( AppList.Selections ) do
			if table.Count( data ) > 0 then
				print( [[DATA.Translations[ ]] .. ACTS[slot] .. [[ ] = {]] )
				for seq, weight in pairs( data ) do
					print( [[	{ Sequence = "]] .. seq .. [[", Weight = ]] .. weight .. [[ },]])
				end
				print( [[}]] )
				print( "" )
			end
		end
		print( [[wOS.AnimExtension:RegisterHoldtype( DATA )]] )
		print( [[--=====================================================================]] )
	end
	
end