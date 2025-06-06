--[[
	Begotten III: Jesus Wept
--]]

-- hook.Add( "PostDrawTranslucentRenderables", "AlyToolsRender", function()
	-- cwAlyTools:DrawStuff()
-- end )

-- Called just after the translucent renderables have been drawn.
function cwAlyTools:PostDrawTranslucentRenderables(bDrawingDepth, bDrawingSkybox)
	cwAlyTools:DrawStuff()
end

function cwAlyTools:DrawStuff()
	if Clockwork.Client:IsAdmin() then
		Clockwork.Client.MarkPointPulse = Clockwork.Client.MarkPointPulse or 0;
		Clockwork.Client.MarkPointPulseB = Clockwork.Client.MarkPointPulseB or false;
		for _, v in _player.Iterator() do
			if v:IsAdmin() then
				local markeddata = cwAlyTools:UpdateMarkerTrace(v:GetNetVar("markedpoint", nil))
				
				if istable(markeddata) then
					if markeddata.valid then
						local beamColor = Color(255,0,255,200)
						if v == Clockwork.Client then
							beamColor = Color(255,0,0,200)
						end
						local glowMaterial = Material("sprites/redglow1");
						local plyMaterial = Material("sprites/hud/v_crosshair2");
						local beamMaterial = Material("sprites/physbeam");
						local boxMaterial = Material("sprites/reticle");
						render.SetMaterial( beamMaterial )
						render.DrawBeam( markeddata.corepos, markeddata.rooftgt, 4, 1, 1, beamColor )
						render.SetMaterial( boxMaterial )
						render.DrawBox( markeddata.corepos, Angle(0,0,0), Vector(-20,-15,0), Vector(20,15,0), beamColor )
						render.SetMaterial( glowMaterial )
						render.DrawSprite( markeddata.corepos, 32, 32, Color( 255, 0, 0, 240 ))
						if Clockwork.Client.MarkPointPulseB then
							render.SetMaterial( plyMaterial )
							render.DrawSprite( markeddata.plytgt, 32, 32, Color( 255, 120, 0, 240 ))
						end
					end
				end
			end
		end
		Clockwork.Client.MarkPointPulse = Clockwork.Client.MarkPointPulse + 1;
		if Clockwork.Client.MarkPointPulse > 12 then
			Clockwork.Client.MarkPointPulse = 0;
			Clockwork.Client.MarkPointPulseB = not Clockwork.Client.MarkPointPulseB;
		end
	end
	-- {
		-- valid = true,
		-- corepos = position,
		-- rooftgt = roof,
		-- plytgt = position + Vector(0, 0, 42),
		-- headroom = height * skytrace.Fraction,
		-- indoors = (skytrace.HitWorld)
	-- });
end

function cwAlyTools:HUDPaint()
	if Clockwork.Client:IsAdmin() then
		for k, v in pairs (ents.FindByClass( "cw_teleportal" )) do
			local portalpos = v:GetPos():ToScreen()
			draw.DrawText("TELEPORTAL", "DermaDefault", portalpos.x, portalpos.y, Color(255,0,255,255), TEXT_ALIGN_CENTER)
		end;
		Clockwork.Client.MarkPointPulse = Clockwork.Client.MarkPointPulse or 0;
		Clockwork.Client.MarkPointPulseB = Clockwork.Client.MarkPointPulseB or false;
		hidedata = Clockwork.Client:GetNetVar("markeddata", false);
		for _, v in _player.Iterator() do
			if v:IsAdmin() then
				local markeddata = cwAlyTools:UpdateMarkerTrace(v:GetNetVar("markedpoint", nil))
				local corevect = markeddata.corepos or Clockwork.Client:GetPos()
				local range = corevect:Distance(Clockwork.Client:GetPos())
				if istable(markeddata) and range > 32 then
					if IsValid(markeddata.entity) then
						ent = markeddata.entity
						local textply = markeddata.plytgt:ToScreen()
						local coretextpos = markeddata.corepos + Vector(0,0,50)
						local coretext = markeddata.corepos + Vector(0,0,50)
						local textply2 = coretextpos:ToScreen()
						local textcore = coretext:ToScreen()
						local coredisp = markeddata.corepos:ToScreen()
						local alpha = math.Clamp(600-(range),0,255)
						local beamColor = Color(255,0,255,alpha)
						if v == Clockwork.Client then
							beamColor = Color(255,0,0,alpha)
						end
						local zone = Clockwork.Client:GetZone() or "UNKNOWN"
						local state = "UNROOFED/OUTDOORS"
						local stateColor = Color(100,255,255,alpha)
						if markeddata.indoors then
							state = "HEADROOM: "..math.Round(markeddata.headroom * 0.025,1).."m"
							stateColor = Color(255,0,100,alpha)
						end
						if not hidedata then
							surface.SetDrawColor( 255, 120, 0, alpha )
							surface.DrawLine( textply.x, textply.y, textply2.x+150, textply2.y-95 )
							surface.DrawLine( textply2.x+150, textply2.y-95, textply2.x+290, textply2.y-95 )
							
							surface.DrawLine( coredisp.x, coredisp.y, textply2.x+150, textply2.y-48 )
							surface.DrawLine( textply2.x+150, textply2.y-48, textply2.x+225, textply2.y-48 )
							
							surface.SetDrawColor( 0, 0, 0, math.Clamp(alpha,0,50) )
							surface.DrawRect( textply2.x+145, textply2.y-112, 155, 200 )
							draw.DrawText("ENTITY INTERACTION POINT", "DermaDefault", textply2.x+150, textply2.y-112, Color(255,100,0,alpha), TEXT_ALIGN_LEFT)
							draw.DrawText(v:SteamName(), "DermaDefault", textply2.x+150, textply2.y-92, beamColor, TEXT_ALIGN_LEFT)
							draw.DrawText("TRACKING ENTITY", "DermaDefault", textply2.x+150, textply2.y-65, Color(255,100,0,alpha), TEXT_ALIGN_LEFT)
							draw.DrawText(ent:GetClass(), "DermaDefault", textply2.x+150, textply2.y-45, Color(255,100,0,alpha), TEXT_ALIGN_LEFT)
							draw.DrawText(ent:Health().."/"..ent:GetMaxHealth().." HP", "DermaDefault", textply2.x+150, textply2.y-35, Color(255,100,0,alpha), TEXT_ALIGN_LEFT)
							draw.DrawText("AREA INFO", "DermaDefault", textply2.x+150, textply2.y-15, Color(255,100,0,alpha), TEXT_ALIGN_LEFT)
							draw.DrawText("ZONE", "DermaDefault", textply2.x+160, textply2.y-3, Color(255,255,0,alpha), TEXT_ALIGN_LEFT)
							draw.DrawText(string.upper(zone), "DermaDefault", textply2.x+170, textply2.y+7, Color(0,255,0,alpha), TEXT_ALIGN_LEFT)
							draw.DrawText("STATE", "DermaDefault", textply2.x+160, textply2.y+20, Color(255,255,0,alpha), TEXT_ALIGN_LEFT)
							draw.DrawText(state, "DermaDefault", textply2.x+170, textply2.y+29, stateColor, TEXT_ALIGN_LEFT)
							draw.DrawText("COORDS", "DermaDefault", textply2.x+160, textply2.y+41, Color(255,255,0,alpha), TEXT_ALIGN_LEFT)
							local cx, cy, cz = markeddata.corepos:Unpack()
							draw.DrawText("X: "..math.Round(cx,2), "DermaDefault", textply2.x+170, textply2.y+51, stateColor, TEXT_ALIGN_LEFT)
							draw.DrawText("Y: "..math.Round(cy,2), "DermaDefault", textply2.x+170, textply2.y+61, stateColor, TEXT_ALIGN_LEFT)
							draw.DrawText("Z: "..math.Round(cz,2), "DermaDefault", textply2.x+170, textply2.y+71, stateColor, TEXT_ALIGN_LEFT)
						end
						if (v == Clockwork.Client) and (alpha < 10) then
							local hudMaterial = Material("vgui/cursors/crosshair");
							surface.SetMaterial( hudMaterial)
							surface.SetDrawColor( 255, 255, 255, 255 )
							surface.DrawTexturedRect( coredisp.x-50, coredisp.y-50, 100, 100 )
							--draw.DrawText("TEST", "DermaDefault", textply2.x, textply2.y, Color(0,0,255,255), TEXT_ALIGN_LEFT)
						end
						
					
					elseif markeddata.valid then
						local textply = markeddata.plytgt:ToScreen()
						local coretextpos = markeddata.corepos + Vector(0,0,50)
						local coretext = markeddata.corepos + Vector(0,0,50)
						local textply2 = coretextpos:ToScreen()
						local textcore = coretext:ToScreen()
						local coredisp = markeddata.corepos:ToScreen()
						local alpha = math.Clamp(600-(range),0,255)
						local beamColor = Color(255,0,255,alpha)
						if v == Clockwork.Client then
							beamColor = Color(255,0,0,alpha)
						end
						local zone = Clockwork.Client:GetZone() or "UNKNOWN"
						local state = "UNROOFED/OUTDOORS"
						local stateColor = Color(100,255,255,alpha)
						if markeddata.indoors then
							state = "HEADROOM: "..math.Round(markeddata.headroom * 0.025,1).."m"
							stateColor = Color(255,0,100,alpha)
						end
						if not hidedata then
							surface.SetDrawColor( 255, 120, 0, alpha )
							surface.DrawLine( textply.x, textply.y, textply2.x+150, textply2.y-95 )
							surface.DrawLine( textply2.x+150, textply2.y-95, textply2.x+290, textply2.y-95 )
							
							surface.DrawLine( coredisp.x, coredisp.y, textply2.x+150, textply2.y-48 )
							surface.DrawLine( textply2.x+150, textply2.y-48, textply2.x+225, textply2.y-48 )
							
							surface.SetDrawColor( 0, 0, 0, math.Clamp(alpha,0,50) )
							surface.DrawRect( textply2.x+145, textply2.y-112, 155, 200 )
							draw.DrawText("ENTITY INTERACTION POINT", "DermaDefault", textply2.x+150, textply2.y-112, Color(255,100,0,alpha), TEXT_ALIGN_LEFT)
							draw.DrawText(v:SteamName(), "DermaDefault", textply2.x+150, textply2.y-92, beamColor, TEXT_ALIGN_LEFT)
							draw.DrawText("MARKED POINT", "DermaDefault", textply2.x+150, textply2.y-65, Color(255,100,0,alpha), TEXT_ALIGN_LEFT)
							draw.DrawText("AREA INFO", "DermaDefault", textply2.x+150, textply2.y-45, Color(255,100,0,alpha), TEXT_ALIGN_LEFT)
							draw.DrawText("ZONE", "DermaDefault", textply2.x+160, textply2.y-33, Color(255,255,0,alpha), TEXT_ALIGN_LEFT)
							draw.DrawText(string.upper(zone), "DermaDefault", textply2.x+170, textply2.y-23, Color(0,255,0,alpha), TEXT_ALIGN_LEFT)
							draw.DrawText("STATE", "DermaDefault", textply2.x+160, textply2.y-10, Color(255,255,0,alpha), TEXT_ALIGN_LEFT)
							draw.DrawText(state, "DermaDefault", textply2.x+170, textply2.y-1, stateColor, TEXT_ALIGN_LEFT)
							draw.DrawText("COORDS", "DermaDefault", textply2.x+160, textply2.y+11, Color(255,255,0,alpha), TEXT_ALIGN_LEFT)
							local cx, cy, cz = markeddata.corepos:Unpack()
							draw.DrawText("X: "..math.Round(cx,2), "DermaDefault", textply2.x+170, textply2.y+21, stateColor, TEXT_ALIGN_LEFT)
							draw.DrawText("Y: "..math.Round(cy,2), "DermaDefault", textply2.x+170, textply2.y+31, stateColor, TEXT_ALIGN_LEFT)
							draw.DrawText("Z: "..math.Round(cz,2), "DermaDefault", textply2.x+170, textply2.y+41, stateColor, TEXT_ALIGN_LEFT)
						end
						if (v == Clockwork.Client) and (alpha < 10) then
							local hudMaterial = Material("vgui/cursors/crosshair");
							surface.SetMaterial( hudMaterial)
							surface.SetDrawColor( 255, 255, 255, 255 )
							surface.DrawTexturedRect( coredisp.x-50, coredisp.y-50, 100, 100 )
							--draw.DrawText("TEST", "DermaDefault", textply2.x, textply2.y, Color(0,0,255,255), TEXT_ALIGN_LEFT)
						end
					end
				end
			end
		end
	end
end

function cwAlyTools:AddEntityOutlines(outlines)
	local isdemon = Clockwork.Client:GetCharacterData("isDemon", false);
	
	if isdemon then
		for _, v in _player.Iterator() do
			local dist = Clockwork.Client:GetPos():Distance(v:GetPos())
			self:DrawPlayerOutline(v, outlines, Color(255, 0, 0, 255));
		end;
	end
end

netstream.Hook("AlyToolsTeleporters", function(data)
	if data then
		if data[1] then
			cwItemSpawner.SpawnLocations = data[1];
		end
	end
end);

-- function cwAlyTools:DrawPlayerOutline(player, outlines, color)
	-- if (player:GetMoveType() == MOVETYPE_WALK) then
		-- outlines:Add(player, color, 2, true);
	-- elseif player:IsRagdolled() then
		-- outlines:Add(player:GetRagdollEntity(), color, 2, true);
	-- end;
-- end;