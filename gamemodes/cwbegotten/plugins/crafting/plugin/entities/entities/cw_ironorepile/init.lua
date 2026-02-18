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
		local activeWeapon = player:GetActiveWeapon();
		
		if (damageInfo:IsDamageType(128) and damageInfo:GetDamage() >= 15) or activeWeapon.isPickaxe then
			self:EmitSound(self.BreakSounds[math.random(1, #self.BreakSounds)]);
			
			if !self.oreLeft then
				self.oreLeft = math.random(cwRecipes.minPileItems, cwRecipes.maxPileItems);
			end
			
			if !self.strikesRequired then
				self.cycleStrikesRequired = math.random(20, 40)
				self.strikesRequired = self.cycleStrikesRequired
			end
			
			local damageDealt = 1;
			local hasToilersStone = player:GetCharmEquipped("toilers_stone")
			
			if activeWeapon and activeWeapon.isPickaxe then
				damageDealt = 4;

				if(hasToilersStone) then damageDealt = damageDealt * 1.75 end

			end
			
			if activeWeapon and activeWeapon:GetOffhand() then
				damageDealt = damageDealt / 2;
			end
			
			self.strikesRequired = self.strikesRequired - damageDealt;
			
			if cwCharacterNeeds and player.HandleNeed then
				player:HandleNeed("thirst", 0.75);
				player:HandleNeed("sleep", 0.25);
			end

			if cwBeliefs and player.HandleXP then
				local playerFaction = player:GetFaction();
				local faith = (10 / (self.cycleStrikesRequired / damageDealt))
				
				if playerFaction == "Gatekeeper" or playerFaction == "Goreic Warrior" then
					player:HandleXP(faith * 3);
				elseif playerFaction == "Hillkeeper" then
					player:HandleXP(faith * 2);
				else
					player:HandleXP(faith);
				end
			end
			
			if self.strikesRequired <= 0 then
				local entPos = self:GetPos();
				local itemName = "iron_ore";
				
				if math.random(1, (hasToilersStone and 4 or 3)) == 1 then
					itemName = "stone";
				end
				
				if math.random(1, (hasToilersStone and 130 or 150)) == 1 or self.nextDropOverride == "gold" then
					itemName = "gold_ore";
					
					Clockwork.chatBox:AddInTargetRadius(player, "it", "As you strike the rocks, you notice a faint glimmer. Are your eyes decieving you? Gold!.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
				elseif math.random(1, (hasToilersStone and 640 or 666)) == 1 or self.nextDropOverride == "blooddiamond" then
					itemName = "uncut_blood_diamond";
					
					Clockwork.chatBox:AddInTargetRadius(player, "it", "As you strike the rocks, a beautiful blood-red gem is unearthed from the pile. Whispers fill the caverns around you as the precious stone glimmers.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
					
					self:EmitSound("darkwhisper/darkwhisper_long3.mp3", 500);
					
					Clockwork.player:NotifyAdmins("operator", player:Name().." has unearthed a Blood Diamond. Let the chaos caused by greed ensue.", nil);
					
					for _, v in _player.Iterator() do
						if v ~= player and v:GetFaith() == "Faith of the Dark" then
							v:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_long"..math.random(1, 5)..".mp3", 80, 100)]]);
							Schema:EasyText(v, "red", "Your mind is abruptly overcome with feelings of unrestrained desire. A Blood Diamond has been unearthed somewhere, and it must be yours...");
							v:HandleSanity(10);
						end
					end
				end
				
				self.nextDropOverride = nil;
				
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
				
				self.oreLeft = self.oreLeft - 1;
				self.cycleStrikesRequired = math.random(20, 40)
				self.strikesRequired = self.cycleStrikesRequired
			end
			
			if !activeWeapon.isPickaxe then
				local weaponItemTable = item.GetByWeapon(activeWeapon);

				if weaponItemTable then
					weaponItemTable:TakeConditionByPlayer(player, 0.5);
				end
			end
			
			if self.oreLeft <= 0 then
				Clockwork.chatBox:AddInTargetRadius(player, "it", "The ore pile is reduced to nothing, its resources fully extracted.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
				
				self:Remove();
			end
		end
	end
end

function ENT:OnRemove()
	for category, v in pairs(cwRecipes.Piles) do
		for i, pileTable in ipairs(v) do
			if pileTable.pile == self then
				table.remove(cwRecipes.Piles[category], i);
				
				break;
			end
		end
	end
	
	for category, v in pairs(cwRecipes.pileLocations) do
		for i, location in ipairs(v) do
			if location.occupier == self:EntIndex() then
				cwRecipes.pileLocations[category][i].occupier = nil;
				
				break;
			end
		end
	end
end;
