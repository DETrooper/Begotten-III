function EFFECT:Init(data)
	local cwWeather = cwWeather;
	local emitter = cwWeather.Emitter2D;

	if (emitter) then
		if cwWeather.weather == "blizzard" then
			for i = 1, 20 do
				local r = math.random(0, 1500);
				local t = math.Rand(-math.pi, math.pi);
				local pos = data:GetOrigin() + Vector(math.cos( t ) * r, math.sin( t ) * r, math.min(350, cwWeather.HeightMin or 350)) - Vector(400, 400, 0);
				
				if (cwWeather:IsOutside(pos)) then
					local p = emitter:Add("simpleweather/snow", pos);

					p:SetVelocity(Vector(200, 200, -400))
					p:SetRoll(math.random(-360, 360))
					p:SetDieTime(4)
					p:SetStartAlpha(200)
					p:SetStartSize(1.25)
					p:SetEndSize(1.25)
					p:SetColor(200, 200, 200)
					
					p:SetCollide(true)
					p:SetCollideCallback(function( p, pos, norm )
						local trace = { }
						trace.start = pos
						trace.endpos = trace.start - norm
						trace.filter = { }
						local tr = util.TraceLine( trace )
						
						p:SetDieTime( 0 )
					end)
				end
			end
		else
			for i = 1, 10 do
				local r = math.random(0, 1500);
				local t = math.Rand(-math.pi, math.pi);
				local pos = data:GetOrigin() + Vector(math.cos( t ) * r, math.sin( t ) * r, math.min(350, cwWeather.HeightMin or 350));
				
				if (cwWeather:IsOutside(pos)) then
					local p = emitter:Add("simpleweather/snow", pos);
					
					p:SetVelocity(Vector(20 + math.random(-5, 5), 20 + math.random(-5, 5), -80))
					p:SetRoll(math.random(-360, 360))
					p:SetDieTime(6)
					p:SetStartAlpha(200)
					p:SetStartSize(1)
					p:SetEndSize(1)
					p:SetColor(200, 200, 200)
					
					p:SetCollide(true)
					p:SetCollideCallback(function( p, pos, norm )
						local trace = { }
						trace.start = pos
						trace.endpos = trace.start - norm
						trace.filter = { }
						local tr = util.TraceLine( trace )
						
						p:SetDieTime( 0 )
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
