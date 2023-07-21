--[[
	Begotten III: Jesus Wept
--]]

cwMedicalSystem.bloodScreens = {};
cwMedicalSystem.lethalBloodLoss = 2500; -- Blood level required for critical condition.
cwMedicalSystem.maxBloodLevel = 5000; -- Maximum blood level.
cwMedicalSystem.morphineDream = 0;

-- A function to add a blood screen.
function cwMedicalSystem:BloodScreenBullet()
	local scrW, scrH = ScrW(), ScrH();
	local rotation = math.random(0, 360);
	local screenX = math.random(0, scrW * 0.3);
	local screenY = math.random(0, scrH * 0.3);
	local randomSize = math.random(70, 1075);
	local alpha = 255;
	local bloodDecal = Material("decals/blood"..math.random(1, 6));
	
	if (math.random(1, 2) == 1) then
		screenX = math.random(scrW * 0.9, scrW);
	end;
	
	if (math.random(1, 2) == 1) then
		screenY = math.random(scrH * 0.9, scrH);
	end
	
	self.bloodScreens[#self.bloodScreens + 1] = {
		x = screenX,
		y = screenY,
		size = randomSize,
		rotation = rotation,
		decal = bloodDecal,
		alpha = alpha
	};
end;

Clockwork.datastream:Hook("MorphineDream", function(data)
	cwMedicalSystem.morphineDream = CurTime() + data;
end);

Clockwork.datastream:Hook("ScreenBloodEffect", function(data)
	cwMedicalSystem:BloodScreenBullet();
end);

Clockwork.datastream:Hook("NetworkInjuries", function(data)
	Clockwork.Client.cwInjuries = table.Copy(pon.decode(data))
end);

Clockwork.datastream:Hook("NetworkLimbs", function(data)
	Clockwork.Client.cwLimbs = table.Copy(pon.decode(data))
end);

Clockwork.datastream:Hook("TriggerCrazyBob", function(data)
	if data and isnumber(data) then
		CRAZYBOB = data;
	else
		CRAZYBOB = 75;
	end
end);