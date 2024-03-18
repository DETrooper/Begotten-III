function EFFECT:Init( data )
	local cwWeather = cwWeather;

	if (cwWeather.Emitter2D) then
		local curTime = CurTime();
	
		for i = 1, 10 do
			local r = math.random(0, 1500);
			local t = math.Rand(-math.pi, math.pi);
			local pos = data:GetOrigin() + Vector(math.cos( t ) * r, math.sin( t ) * r, math.min(800, cwWeather.HeightMin or 800));
			
			if (cwWeather:IsOutside(pos)) then
				local p = cwWeather.Emitter2D:Add("simpleweather/water_drop", pos);
				
				p:SetVelocity(Vector(0, 0, -700))
				p:SetDieTime(6)
				p:SetStartAlpha(255)
				p:SetStartSize(3)
				p:SetEndSize(3)
				p:SetColor(255, 255, 0)
				
				p:SetCollide(true)
				p:SetCollideCallback(function( p, pos, norm )
					local ed = EffectData()
					ed:SetOrigin(pos)
					util.Effect("sw_acidrainsplash", ed)
					
					p:SetDieTime(0)
				end)
			end
		end

		--[[if (math.random(1, 3) == 1) then
			local r = math.random(0, 1500);
			local t = math.random(-180, 180)
			local pos = data:GetOrigin() + Vector(math.cos( t ) * r, math.sin( t ) * r, math.min(600, cwWeather.HeightMin or 600));
			
			if (cwWeather:IsOutside(pos) and bit.band(util.PointContents(pos), CONTENTS_WATER ) != CONTENTS_WATER) then
				local p = cwWeather.Emitter2D:Add( "simpleweather/rainsmoke", pos )
				
				p:SetVelocity( Vector( 0, 0, -700 ) )
				p:SetDieTime(4);
				p:SetStartAlpha(6)
				p:SetEndAlpha(0)
				p:SetStartSize(100)
				p:SetEndSize(100)
				p:SetColor(200, 200, 0)
				
				p:SetCollide(true)
				p:SetCollideCallback(function( p, pos, norm )
					p:SetDieTime( 0 )
				end)
			end
		end]]--
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()

end