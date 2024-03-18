function EFFECT:Init(data)
	local cwWeather = cwWeather;

	if (cwWeather.Emitter2D) then
		local p = cwWeather.Emitter2D:Add("simpleweather/snow", data:GetOrigin());
		
		p:SetDieTime(0.5)
		p:SetStartAlpha(15)
		p:SetEndAlpha(0)
		p:SetStartSize(2)
		p:SetEndSize(2)
		p:SetColor(255, 255, 0)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()

end
