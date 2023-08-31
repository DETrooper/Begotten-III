--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.kernel:IncludePrefixed("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

local cwRecipes = cwRecipes;

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
			
			if !self.oreLeft then
				self.oreLeft = math.random(cwRecipes.minPileItems, cwRecipes.maxPileItems);
			end
			
			if !self.strikesRequired then
				self.strikesRequired = math.random(5, 10);
			end
			
			self.strikesRequired = self.strikesRequired - 1;
			
			if cwCharacterNeeds and player.HandleNeed then
				player:HandleNeed("thirst", 0.75);
				player:HandleNeed("sleep", 0.25);
			end
			
			if self.strikesRequired <= 0 then
				local entPos = self:GetPos();
				local itemName = "iron_ore";
				
				if math.random(1, 3) == 1 then
					itemName = "stone";
				end
				
				if math.random(1, 150) == 1 then
					itemName = "gold_ore";
					
					Clockwork.chatBox:AddInTargetRadius(player, "it", "As you strike the rocks, you notice a faint glimmer. Are your eyes decieving you? Gold!.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
				end
				
				local itemTable = item.CreateInstance(itemName)

				if (itemTable) then
					itemTable:SetCondition(math.random(25, 100), true);
				
					local item = Clockwork.entity:CreateItem(nil, itemTable, Vector(entPos.x, entPos.y, entPos.z + 40));
					
					if IsValid(item) then
						item:Spawn();
						item:EmitSound("physics/concrete/concrete_break2.wav");
						
						Clockwork.entity:Decay(item, 300);
						item.lifeTime = CurTime() + 300; -- so the item save plugin doesn't save it
					end
				end
				
				if cwBeliefs and player.HandleXP then
					local playerFaction = player:GetFaction();
					
					if playerFaction == "Gatekeeper" then
						player:HandleXP(30);
					else
						player:HandleXP(10);
					end
				end
				
				self.oreLeft = self.oreLeft - 1;
				self.strikesRequired = math.random(5, 10);
			end
			
			if !activeWeapon.isPickaxe then
				local weaponItemTable = item.GetByWeapon(activeWeapon);
				
				if weaponItemTable then
					if cwBeliefs and not player:HasBelief("ingenuity_finisher") then
						weaponItemTable:TakeCondition(0.5);
					end
				end
			end
			
			if self.oreLeft <= 0 then
				Clockwork.chatBox:AddInTargetRadius(player, "it", "The ore pile is reduced to nothing, its resources fully extracted.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
				
				--[[local piles = cwRecipes.Piles;
				
				for i = 1, #piles do
					local pileTable = piles[i];
					
					for k, v in pairs(cwRecipes.pileLocations) do
						for j = 1, #v do
							if v[j].occupier == self:EntIndex() then
								v[j].occupier = nil;
								
								self:Remove();
								table.remove(cwRecipes.Piles, i);
								
								return;
							end
						end
					end
				end]]--
				
				self:Remove();
			end
		end
	end
end

function ENT:OnRemove()
	local piles = cwRecipes.Piles;
	
	for i = 1, #piles do
		local pileTable = piles[i];
		
		for k, v in pairs(cwRecipes.pileLocations) do
			for j = 1, #v do
				if v[j].occupier == self:EntIndex() then
					v[j].occupier = nil;
					
					table.remove(cwRecipes.Piles, i);
					
					return;
				end
			end
		end
	end
end;