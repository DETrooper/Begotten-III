function EFFECT:Init( data )
	local cwWeather = cwWeather;

	if (cwWeather.Emitter2D) then
		local curTime = CurTime();
	
		if cwWeather.weather == "thunderstorm" then
			for i = 1, 20 do
				local r = math.random(0, 1200);
				local t = math.Rand(-math.pi, math.pi);
				local pos = data:GetOrigin() + Vector(math.cos(t) * r, math.sin(t) * r, 400);
				
				if (cwWeather:IsOutside(pos)) then
					local p = cwWeather.Emitter2D:Add("simpleweather/water_drop", pos);
					
					p:SetVelocity(Vector(-20, -20, -900))
					p:SetDieTime(5)
					p:SetStartAlpha(255)
					p:SetStartSize(1.5)
					p:SetEndSize(1.5)
					p:SetColor(255, 255, 255)
					
					p:SetCollide(true)
					p:SetCollideCallback(function( p, pos, norm )
						local ed = EffectData()
						ed:SetOrigin(pos)
						util.Effect("sw_rainsplash", ed)
						
						p:SetDieTime(0)
					end)
				end
			end
		elseif cwWeather.weather == "bloodstorm" then
			for i = 1, 10 do
				local r = math.random(0, 1500);
				local t = math.Rand(-math.pi, math.pi);
				local pos = data:GetOrigin() + Vector(math.cos(t) * r, math.sin(t) * r, 400);
				
				if (cwWeather:IsOutside(pos)) then
					local p = cwWeather.Emitter2D:Add("simpleweather/water_drop", pos);
					
					p:SetVelocity(Vector(0, 0, -700))
					p:SetDieTime(6)
					p:SetStartAlpha(255)
					p:SetStartSize(2)
					p:SetEndSize(2)
					p:SetColor(200, 0, 0)
					
					p:SetCollide(true)
					p:SetCollideCallback(function( p, pos, norm )
						local ed = EffectData()
						ed:SetOrigin(pos)
						util.Effect("sw_bloodsplash", ed)
						
						p:SetDieTime(0)
					end)
				end
			end
		else
			for i = 1, 10 do
				local r = math.random(0, 1500);
				local t = math.Rand(-math.pi, math.pi);
				local pos = data:GetOrigin() + Vector(math.cos(t) * r, math.sin(t) * r, 400);
				
				if (cwWeather:IsOutside(pos)) then
					local p = cwWeather.Emitter2D:Add("simpleweather/water_drop", pos);
					
					p:SetVelocity(Vector(0, 0, -700))
					p:SetDieTime(6)
					p:SetStartAlpha(255)
					p:SetStartSize(1.25)
					p:SetEndSize(1.25)
					p:SetColor(255, 255, 255)
					
					p:SetCollide(true)
					p:SetCollideCallback(function( p, pos, norm )
						local ed = EffectData()
						ed:SetOrigin(pos)
						util.Effect("sw_rainsplash", ed)
						
						p:SetDieTime(0)
					end)
				end
			end
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()

end