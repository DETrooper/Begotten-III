--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
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
	"vo/breencast/br_instinct25.wav",
};

local differences = {
	[sounds[22]] = 0.4,
	[sounds[20]] = 0.4,
	[sounds[17]] = 0.4,
	[sounds[16]] = 0.15,
	[sounds[25]] = 0.4,
	[sounds[23]] = 0.1,
	[sounds[4]] = 0.05,
	[sounds[18]] = 0.1,
	[sounds[9]] = 0.1,
	[sounds[24]] = 0.15,
	[sounds[12]] = 0.3,
	[sounds[1]] = 0.2,
	[sounds[10]] = 0.1,
};

local durations = {15, 12, 18, 10, 10, 8, 7, 7, 3, 9, 3, 4, 17, 4, 5, 4, 5, 3, 8, 5, 4, 4, 4, 12, 6};

function ENT:Use(activator, caller)
	if (!self._nextUse or CurTime() > self._nextUse) then
		if (IsValid(caller)) then
			self:EmitSound("buttons/lightswitch2.wav", 70, 135);
			
			local randomChance = math.random(1, #sound);
			local sound = sounds[randomChance];
			local soundDuration = durations[randomChance];
			local difference = differences[sounds[22]] and differences[sounds[22]] or 0.1;
			
			self:EmitSound(sound, 75, 225, 1);
			
			timer.Simple((soundDuration / 2.25) + difference, function()
				if IsValid(self) then
					self:EmitSound("hl1/fvox/bell.wav", 75, 200, 1);
				end
			end);
		end;
		
		self._nextUse = CurTime() + (soundDuration / 2.25) + 2.5;
	end;
end;