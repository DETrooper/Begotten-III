--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.kernel:IncludePrefixed("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

local cwScrapFactory = cwScrapFactory;

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_mining/caverocks_cluster01.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
	self.BreakSounds = {"physics/concrete/boulder_impact_hard1.wav", "physics/concrete/boulder_impact_hard2.wav", "physics/concrete/boulder_impact_hard3.wav", "physics/concrete/boulder_impact_hard4.wav"};
	
	local physicsObject = self:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(false);
	end;
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

function ENT:Use(activator, caller)

end;

function ENT:OnTakeDamage(damageInfo)
	local player = damageInfo:GetAttacker();
	
	if IsValid(player) and player:IsPlayer() then
		if damageInfo:IsDamageType(128) and damageInfo:GetDamage() >= 15 then
			local activeWeapon = player:GetActiveWeapon();
			
			self:EmitSound(self.BreakSounds[math.random(1, #self.BreakSounds)]);
			
			if math.random(1, 20) == 20 then
				local entPos = self:GetPos();
				local oreEnt = ents.Create("cw_scrapfactoryore");
					
				oreEnt:SetPos(Vector(entPos.x, entPos.y, entPos.z + 40));
				oreEnt:Spawn();
				oreEnt:EmitSound("physics/concrete/concrete_break2.wav");
				
				--Clockwork.entity:Decay(oreEnt, 1800);
			end
			
			if !activeWeapon.isPickaxe then
				local weaponItemTable = item.GetByWeapon(activeWeapon);
				
				if weaponItemTable then
					if cwBeliefs and not player:HasBelief("ingenuity_finisher") then
						weaponItemTable:TakeCondition(0.5);
					end
				end
			end
		end
	end
end

function ENT:OnRemove()

end;