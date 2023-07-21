--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

include("shared.lua");

local crazyNumber = 100.1;
local crazyState = "add";
local glowMaterial = Material("sprites/glow04_noz");

-- Called each frame.
function ENT:Think()
	if (self:IsCrazy()) then
		if crazyState == "add" then
			crazyNumber = crazyNumber + math.random(0.1, 0.3);

			if crazyNumber >= 199.6 then
				crazyState = "subtract";
			end
		elseif crazyState == "subtract" then
			crazyNumber = crazyNumber - math.random(0.1, 0.3);

			if crazyNumber <= 100.4 then
				crazyState = "add";
			end
		end
	end
end

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = Clockwork.option:GetColor("target_id");
	local colorWhite = Clockwork.option:GetColor("white");
	local frequency = self:GetFrequency();
	
	y = Clockwork.kernel:DrawInfo("Radio", x, y, colorTargetID, alpha);
	
	if (self:IsCrazy()) then
		y = Clockwork.kernel:DrawInfo(tostring(crazyNumber), x, y, colorWhite, alpha);
	elseif (frequency == 0) then
		y = Clockwork.kernel:DrawInfo("This radio has no frequency.", x, y, colorWhite, alpha);
	else
		local faction = Clockwork.Client:GetFaction();
		
		if faction == "Gatekeeper" or faction == "Pope Adyssa's Gatekeepers" or faction == "Holy Hierarchy" then
			y = Clockwork.kernel:DrawInfo(frequency, x, y, colorWhite, alpha);
		end
	end;
end;

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
	
	local r, g, b, a = self:GetColor();
	local glowColor = Color(0, 255, 0, a);
	local position = self:GetPos();
	local forward = self:GetForward() * 9;
	local right = self:GetRight() * 1.55;
	local up = self:GetUp() * 4.9;
	
	if (self:IsCrazy()) then
		if math.random(1, 2) == 1 then
			glowColor = Color(255, 0, 0, a);
		end
	elseif (self:IsOff()) then
		glowColor = Color(255, 0, 0, a);
	end;
	
	cam.Start3D(EyePos(), EyeAngles());
		render.SetMaterial(glowMaterial);
		render.DrawSprite(position + forward + right + up, 4, 4, glowColor);
	cam.End3D();
end;