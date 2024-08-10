--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local playerMeta = FindMetaTable("Player");
cwMelee.parryEffects = {};

-- A function to add a parry effect.
function cwMelee:AddParryEffect(duration)
	local curTime = CurTime();
	
	if (!duration or duration == 0) then
		duration = 1;
	end;

	self.parryEffects[#self.parryEffects + 1] = {curTime + duration, duration};
end;

function cwMelee:Disorient(blurAmount)
	util.ScreenShake(Clockwork.Client:GetPos(), 15, 2, 3, 10)
	self.blurAmount = blurAmount or 1.5;
end;

-- A function to disorient the player.
function playerMeta:Disorient(blurAmount)
	cwMelee:Disorient(blurAmount);
end;

--[[function playerMeta:GetMaxPoise()
	return self:GetNetVar("maxMeleeStamina", 90);
end;]]--

netstream.Hook("Parried", function(data)
	cwMelee:AddParryEffect(data);
	Schema:SanityZoom(-0.1)
end);

netstream.Hook("Disorient", function(blurAmount)
	cwMelee:Disorient(blurAmount);
end);