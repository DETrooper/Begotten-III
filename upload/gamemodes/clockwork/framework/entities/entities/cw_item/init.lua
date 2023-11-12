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
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetHealth(25);
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

-- A function to get the entity's item table.
function ENT:GetItemTable()
	return self.cwItemTable;
end;

-- A function to set the item of the entity.
function ENT:SetItemTable(itemTable)
	if (itemTable) then
		self:SetSkin(itemTable("skin", 1));
		self:SetModel(itemTable("model"));
		self:SetDTInt(0, itemTable("index"));
		
		if (itemTable.OnCreated) then
			itemTable:OnCreated(self);
		end;
		
		self:SetHealth(math.max(1, math.Round((itemTable:GetCondition() or 100) / 4)));
		
		self.cwItemTable = itemTable;
		
		Clockwork.item:RemoveItemEntity(self);
		Clockwork.item:AddItemEntity(self, itemTable);
	end;
end;

-- Called when the entity is removed.
function ENT:OnRemove()
	local itemTable = self.cwItemTable;
	
	if (itemTable) then
		if itemTable.OnEntityRemoved then
			itemTable:OnEntityRemoved(self);
		end
		
		item.RemoveInstance(itemTable.itemID);
	end;
end;

-- A function to explode the entity.
function ENT:Explode()
	local effectData = EffectData();
		effectData:SetStart(self:GetPos());
		effectData:SetOrigin(self:GetPos());
		effectData:SetScale(8);
	util.Effect("GlassImpact", effectData, true, true);

	self:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
end;

-- Called when the entity takes damage.
function ENT:OnTakeDamage(damageInfo)
	local damage = damageInfo:GetDamage();
	
	if damage > 0 then
		local itemTable = self.cwItemTable;

		if (itemTable.OnEntityTakeDamage and itemTable:OnEntityTakeDamage(self, damageInfo) == false) then
			return;
		end;
		
		Clockwork.plugin:Call("ItemEntityTakeDamage", self, itemTable, damageInfo);
		
		--if (damage > 0) then
			self:SetHealth(math.max(self:Health() - damage, 0));
			
			if !itemTable.attributes or !table.HasValue(itemTable.attributes, "conditionless") then
				itemTable:TakeCondition(damageInfo:GetDamage() * 4);
			end
			
			if (self:Health() <= 0) then
				if (itemTable.OnEntityDestroyed) then
					itemTable:OnEntityDestroyed(self);
				end;
				
				Clockwork.plugin:Call("ItemEntityDestroyed", self, itemTable);
				
				self:Explode();
				self:Remove();
			end;
		--end;
	end
end;

-- Called each frame.
function ENT:Think()
	local itemTable = self.cwItemTable;
	
	if (!itemTable) then
		self:Remove();
		return;
	end;
	
	local curTime = CurTime();
	
	--[[if (!self:IsInWorld()) then
		if (!self.cwOutOfWorldTime or curTime >= self.cwOutOfWorldTime) then
			self.cwOutOfWorldTime = curTime + 5;

			self:Remove();
			return;
		end;
	else
		self.cwOutOfWorldTime = nil;
	end;]]--
	
	--[[if (itemTable) then
		if (itemTable.OnEntityThink) then
			local nextThink = itemTable:OnEntityThink(self);
			
			if (type(nextThink) == "number") then
				return self:NextThink(curTime + nextThink);
			end;
		end;
	end;]]--

	self:NextThink(curTime + math.random(2, 5));
end;