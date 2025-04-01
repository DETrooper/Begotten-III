function EFFECT:Init(data)
	local cwWeather = cwWeather;
	local emitter = cwWeather.Emitter2D;

	if (emitter) then
		for i = 1, 8 do
			local r = math.random(0, 1500);
			local t = math.Rand(-math.pi, math.pi);
			local pos = data:GetOrigin() + Vector(math.cos( t ) * r, math.sin( t ) * r, math.min(250, cwWeather.HeightMin or 250));
			
			if (cwWeather:IsOutside(pos)) then
				local p = emitter:Add("simpleweather/snow", pos);
				
				p:SetVelocity(Vector(20 + math.random(-10, 10), 20 + math.random(-10, 10), -55))
				p:SetRoll(math.random(-360, 360))
				p:SetDieTime(8)
				p:SetStartAlpha(255)
				p:SetStartSize(1)
				p:SetEndSize(1)
				p:SetColor(5, 5, 5)
				
				p:SetCollide(true)
				p:SetCollideCallback(function( p, pos, norm )
					local trace = { }
					trace.start = pos
					trace.endpos = trace.start - norm
					trace.filter = { }
					local tr = util.TraceLine( trace )
					
					p:SetDieTime(0)
				end)
			end
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	
end
