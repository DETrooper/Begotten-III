--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/begotten_apocalypse/items/houndcage.mdl");
	--self:SetAngles(self:GetAngles() + Angle(0, 0, 90))
	self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

	local physicsObject = self:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		--physicsObject:EnableMotion(false);
	end;

	if !self.savedskin then
		self:SetSkin( math.random(1, 3) )
	end
	--self:DoSolidCheck();
	self.isplayingsound = self:StartLoopingSound( "fiend/cagehound.wav" )
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

local buddiestable = {
	["Hillkeeper"] = "Holy Hierarchy",
	["Holy Hierarchy"] = "Hillkeeper",
}

function ENT:OnTakeDamage(damageInfo)
	local player = damageInfo:GetAttacker();

	if !IsValid(player) or !player:IsPlayer() then return end
	
	if self.hasunleashedwolf then return end
	
	local entity = ents.Create("npc_drg_animals_wolf");

	
	
	--self:EmitSound("fiend/presentunwrap.wav")

	if IsValid(entity) then
		self:EmitSound("fiend/chainsnap.wav")
		self:SetCollisionGroup( 20 )
		entity:Spawn();
		if !self.setwolfhealth then
			entity:SetHealth(300);
		elseif self.setwolfhealth then
			entity:SetHealth(self.setwolfhealth);
		end
		entity:Activate(); 
		entity:AddEntityRelationship(player, D_LI, 99);
		entity.XPValue = 50;
		self.hasunleashedwolf = true
		self:SetNWBool("houndunleashed", 1)

		local mins = entity:OBBMins() -- Minimum bounds
		local maxs = entity:OBBMaxs() -- Maximum bounds
		local size = maxs - mins   -- The size of the entity's bounding box
		local height = size.z      -- Height of the entity
		local height = height/4

		entity:SetPos(self:GetPos() + Vector(0, 0, height));
		
		local playerFaith = player:GetFaction();
		
		entity.summonedFaith = playerFaith;
		self:SetBodygroup( 1, 1 )
		self:SetBodygroup( 2, 1 )

		entity:SetSkin(self:GetSkin())
		for _, v in _player.Iterator() do
			if (v:GetFaction() == playerFaith) or (v:GetFaction() == buddiestable[playerFaith]) or (self.houndattackall==false and v:GetFaction() == "Wanderer") then
				entity:AddEntityRelationship(v, D_LI, 99);
			else					
				local faction = v:GetNetVar("kinisgerOverride")
				
				if faction == "Hillkeeper" or faction == "Holy Hierarchy" then
					entity:AddEntityRelationship(v, D_LI, 99);
				end
			end
		end
		self:StopLoopingSound(self.isplayingsound)
		--self:Remove()
	end
end

function ENT:OnRemove()
	if self.isplayingsound then
		self:StopLoopingSound(self.isplayingsound)
	end
end

function ENT:Touch(entity)
	if !self.nextbarksound then self.nextbarksound = 0 end
	if self.nextbarksound and self.nextbarksound < CurTime() then return end

end;