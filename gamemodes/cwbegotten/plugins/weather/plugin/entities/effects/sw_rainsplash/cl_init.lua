function EFFECT:Init(data)
	local emitter = cwWeather.Emitter2D;

	if (emitter) then
		local p = emitter:Add("simpleweather/snow", data:GetOrigin());
		
		p:SetDieTime(0.5)
		p:SetStartAlpha(15)
		p:SetEndAlpha(0)
		p:SetStartSize(2)
		p:SetEndSize(2)
		p:SetColor(255, 255, 255)
		p:SetCollide(true)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()

end
