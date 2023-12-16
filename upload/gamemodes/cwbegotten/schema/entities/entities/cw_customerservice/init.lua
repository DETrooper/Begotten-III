--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

Clockwork.kernel:IncludePrefixed("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_trainstation/payphone001a.mdl");
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);

	local physicsObject = self:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end;
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

function ENT:Use(activator, caller)
	if (!self._nextUse or CurTime() > self._nextUse) then
		local sounds = {
			"vo/breencast/br_instinct01.wav",
			"vo/breencast/br_instinct02.wav",
			"vo/breencast/br_instinct03.wav",
			"vo/breencast/br_instinct04.wav",
			"vo/breencast/br_instinct05.wav",
			"vo/breencast/br_instinct06.wav",
			"vo/breencast/br_instinct07.wav",
			"vo/breencast/br_instinct08.wav",
			"vo/breencast/br_instinct09.wav",
			"vo/breencast/br_instinct10.wav",
			"vo/breencast/br_instinct11.wav",
			"vo/breencast/br_instinct12.wav",
			"vo/breencast/br_instinct13.wav",
			"vo/breencast/br_instinct14.wav",
			"vo/breencast/br_instinct15.wav",
			"vo/breencast/br_instinct16.wav",
			"vo/breencast/br_instinct17.wav",
			"vo/breencast/br_instinct18.wav",
			"vo/breencast/br_instinct19.wav",
			"vo/breencast/br_instinct20.wav",
			"vo/breencast/br_instinct21.wav",
			"vo/breencast/br_instinct22.wav",
			"vo/breencast/br_instinct23.wav",
			"vo/breencast/br_instinct24.wav",
			"vo/breencast/br_instinct25.wav"
		};
		
		local durations = {15, 12, 18, 10, 10, 8, 7, 7, 3, 9, 3, 4, 17, 4, 5, 4, 5, 3, 8, 5, 4, 4, 4, 12, 6};
		
		if (IsValid(caller)) then
			self:EmitSound("buttons/lightswitch2.wav", 55, 135);
			
			local randomChance = math.random(1, 25);
			local sound = sounds[randomChance];
			local soundDuration = durations[table.KeyFromValue(sounds, sound)];
			local difference = 0.1;

			if (sound == sounds[22]) then
				difference = 0.4;
			elseif (sound == sounds[20]) then
				difference = 0.4;
			elseif (sound == sounds[17]) then
				difference = 0.4;
			elseif (sound == sounds[16]) then
				difference = 0.15;
			elseif (sound == sounds[25]) then
				difference = 0.4;
			elseif (sound == sounds[23]) then
				difference = 0.1;
			elseif (sound == sounds[4]) then
				difference = 0.05;
			elseif (sound == sounds[18]) then
				difference = 0.1;
			elseif (sound == sounds[9]) then
				difference = 0.15;
			elseif (sound == sounds[24]) then
				difference = 0.15;
			elseif (sound == sounds[9]) then
				difference = 0.1;
			elseif (sound == sounds[12]) then
				difference = 0.3;
			elseif (sound == sounds[1]) then
				difference = 0.2;
			elseif (sound == sounds[10]) then
				difference = 0.1;
			end;
			
			self:EmitSound(sound, 60, 225, 1);
			
			timer.Simple((soundDuration / 2.25) + difference, function()
				self:EmitSound("hl1/fvox/bell.wav", 65, 200, 1);
			end);
		end;
		
		self._nextUse = CurTime() + (soundDuration / 2.25) + 2.5;
	end;
end;