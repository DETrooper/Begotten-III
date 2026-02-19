--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.kernel:IncludePrefixed("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

local cwSailing = cwSailing;

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/begotten/misc/gorelongship.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
	self.creaksounds = {"navalsystem/coaster_creak_01.wav", "navalsystem/coaster_creak_02.wav", "navalsystem/coaster_creak_03.wav", "navalsystem/coaster_creak_06.wav"};
	self.longshipType = "longship";
	
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

function ENT:Think()
	local curTime = CurTime();
	
	if (!self.checkCooldown or self.checkCooldown < curTime) then
		self.checkCooldown = curTime + 0.1;
		
		if self.playersOnBoard and #self.playersOnBoard > 0 then
			if self.location == "styx" then
				if !self.nextNPCCheck then
					self.nextNPCCheck = curTime + 5;
					
					return;
				end
				
				if self.nextNPCCheck < curTime then
					self.nextNPCCheck = curTime + math.random(3, 10);
					
					-- Thrall combat encounters when sailing through the Styx.
					self.maxNPCs = math.min(2, math.max(1, #self.playersOnBoard / 5));
					
					if !self.spawnedNPCs then
						self.spawnedNPCs = {};
					end
					
					if #self.spawnedNPCs < self.maxNPCs and timer.Exists("TravelTimer_"..tostring(self:EntIndex())) and math.abs(timer.TimeLeft("TravelTimer_"..tostring(self:EntIndex()))) > 30 then
						local longshipPos = self:GetPos();
						local maxXs = {math.random(256, 312), math.random(-256, -312)};
						local dist = Vector(maxXs[math.random(1, #maxXs)], math.random(-312, 312), 0);
						
						local tr = util.TraceLine({
							start = longshipPos + Vector(dist.x, dist.y, 128),
							endpos = longshipPos + Vector(dist.x, dist.y, -256)
						})
						
						if tr.Hit then
							local spawnPos = tr.HitPos + Vector(0, 0, 8);
							local thrallNPCs = {"npc_bgt_brute", "npc_bgt_pursuer"};
							
							if IsValid(self.owner) and self.owner:HasTrait("marked") then
								if math.random(1, 8) == 1 then
									thrallNPCs = {"npc_bgt_otis"};
								end
							end

							local npcName = thrallNPCs[math.random(1, #thrallNPCs)];
							
							ParticleEffect("teleport_fx", spawnPos, Angle(0,0,0), nil);
							sound.Play("misc/summon.wav", spawnPos, 100, 100);
							
							timer.Simple(0.75, function()
								if IsValid(self) and self.location == "styx" then
									local entity = cwZombies:SpawnThrall(npcName, spawnPos, Angle(0, math.random(1, 359), 0));

									if IsValid(entity) then
										entity:SetMaterial("models/props_combine/com_shield001a");
										entity.noCatalysts = true;
										
										for i, v in RandomPairs(self.playersOnBoard) do
											if IsValid(v) and v:Alive() and !v.cwObserverMode then
												entity:SetEnemy(v);
												
												break;
											end
										end
										
										table.insert(self.spawnedNPCs, entity:EntIndex())
									end
								end
							end);
						end
					end
				end
			elseif self.nextNPCCheck then
				self.nextNPCCheck = nil;
			end
		
			for i, player in ipairs(self.playersOnBoard) do
				if IsValid(player) then
					local playerPos = player:GetPos();
					
					if (!player.cwObserverMode) then
						local offset = 38.5;
						
						if player:IsRagdolled() then
							offset = 28;
						end
					
						if playerPos.z <= self:GetPos().z + offset then
							if !table.HasValue(zones:GetPlayersInZone("sea_"..self.location), player) then
								table.remove(self.playersOnBoard, i);
								
								break;
							end
							
							local alive = player:Alive();
							
							if alive then
								Schema:EasyText(Schema:GetAdmins(), "icon16/water.png", "cornflowerblue", player:Name().." went overboard!");
							end
							
							if self.location == "calm" or self.location == "rough" then
								sound.Play("ambient/water/water_splash3.wav", playerPos);
								
								local effectData = EffectData();
								effectData:SetOrigin(playerPos);
								effectData:SetScale(16);
								util.Effect("watersplash", effectData, true, true);
								
								if alive then
									--player:SendLua([[RunConsoleCommand("stopsound")]]);
									player:SendLua([[Clockwork.Client:EmitSound("ambient/water/water_splash3.wav", 500, 100)]])
								
									timer.Simple(1, function()
										if IsValid(player) then
											--player.canTakeFallDamage = true;
											player:GodDisable();
										end
									end);
									
									player:SetCharacterData("permakilled", true); -- In case the player tries to d/c to avoid their fate.
									player:DeathCauseOverride("Went overboard into the sea and drowned.");
									
									if player:IsRagdolled() then
										Clockwork.player:SetRagdollState(player, RAGDOLL_NONE);
									end
									
									--player.canTakeFallDamage = false;
									Clockwork.player:SetRagdollState(player, RAGDOLL_NONE);
									player:GodEnable();
									player:SetPos(Vector(15.167375, 4397.66115, -4967.96875)); -- Teleport to black box full of water.
									--player:Freeze(true);
									netstream.Start(player, "DrowningCutscene");
								else
									local ragdollEntity = player:GetRagdollEntity();
									
									if IsValid(ragdollEntity) then
										-- Prevent belongings from spawning.
										ragdollEntity.cwInventory = nil;
										ragdollEntity.cwCash = nil;
										
										ragdollEntity:Remove();
									end
								end
							elseif self.location == "styx" then
								if alive then
									local world = GetWorldEntity();
									local damageInfo = DamageInfo();
									
									player:DeathCauseOverride("Went overboard into lava and burnt to a crisp.");
									
									damageInfo:SetDamageType(DMG_BURN);
									damageInfo:SetDamage(666);
									damageInfo:SetAttacker(world);
									damageInfo:SetInflictor(world);
									damageInfo:SetDamagePosition(player:GetPos());
									player:TakeDamageInfo(damageInfo);
								end
								
								timer.Simple(0.5, function()
									if IsValid(player) and (!player:Alive()) then
										local effectData = EffectData();
										effectData:SetOrigin(player:GetPos());
										effectData:SetScale(24);
										util.Effect("burning_vehicle", effectData, true, true);
										
										player:EmitSound("ambient/fire/mtov_flame2.wav");
										
										timer.Simple(0.2, function()
											if IsValid(player) and (!player:Alive()) then
												local ragdollEntity = player:GetRagdollEntity();
												
												if IsValid(ragdollEntity) then
													-- Prevent belongings from spawning.
													ragdollEntity.cwInventory = nil;
													ragdollEntity.cwCash = nil;
													
													ragdollEntity:Remove();
												end
											end
										end);
									end
								end);
							end
							
							table.remove(self.playersOnBoard, i);
							break;
						end
					end
				end
			end
		end
	end
	
	if (!self.damageCooldown or self.damageCooldown < curTime) then
		self.damageCooldown = curTime + 1;
	
		if self:GetNWBool("Ignited") then
			if cwWeather and cwWeather.weather == "thunderstorm" or cwWeather.weather == "bloodstorm" or cwWeather.weather == "acidrain" then
				self:SetNWBool("Ignited", false);
				self:StopParticles();
				
				return;
			end
		
			if self.health then
				if self.health > 0 then
					self:SetHP(self.health - 2);
				end
			else
				self.health = 500 - 2;
			end
		elseif self.location == "rough" then
			if self.health then
				if self.health > 0 --[[and self.health < 250]] then
					self:SetHP(self.health - math.random(2, 10));
					
					if self.health and self.health > 0 then
						local sound_chance = math.random(1, 10);
					
						if sound_chance == 10 then
							self:EmitSound(self.creaksounds[math.random(1, #self.creaksounds)]);
						end
					end
				end
			end
		end
	end
end

function ENT:SetHP(newhp)
	self.health = newhp;
	
	--[[if self.itemID then
		local itemTable = item.FindInstance(self.itemID);
		
		if itemTable then
			itemTable:SetData("health", newhp);
		end
	end]]--

	if newhp > 0 then
		if newhp == 500 then
			self.repairable = true;
		else
			self.repairable = false;
		end
	elseif self.location and (self.location == "calm" or self.location == "rough" or self.location == "styx") then
		if self.location == "styx" then
			if self.playersOnBoard and #self.playersOnBoard > 0 then
				local playersOnBoard = table.Copy(self.playersOnBoard);
				
				timer.Simple(0.5, function()
					for i, player in ipairs(playersOnBoard) do
						if IsValid(player) then
							if player:Alive() then
								player:SendLua([[Clockwork.Client:EmitSound("ambient/fire/mtov_flame2.wav", 500, 100)]]);
								player:DeathCauseOverride("Rode a sinking ship into the lava and burnt to a crisp.");
								player:KillSilent();
							else
								local ragdollEntity = player:GetRagdollEntity();
								
								if IsValid(ragdollEntity) then
									-- Prevent belongings from spawning.
									ragdollEntity.cwInventory = nil;
									ragdollEntity.cwCash = nil;
									
									ragdollEntity:Remove();
								end
							end
						end
					end
				end);
			end
			
			Clockwork.chatBox:AddInRadius(nil, "localevent", "The longship finally gives way under the strain of its damage, splitting in two and sinking into the lava below!", self:GetPos(), 1024);
		else
			if self.playersOnBoard and #self.playersOnBoard > 0 then
				local playersOnBoard = table.Copy(self.playersOnBoard);
				
				timer.Simple(0.5, function()
					for i, player in ipairs(playersOnBoard) do
						if IsValid(player) then
							if player:Alive() then
								player:SendLua([[Clockwork.Client:EmitSound("ambient/water/water_splash3.wav", 500, 100)]])
							
								timer.Simple(1, function()
									if IsValid(player) then
										player:GodDisable();
									end
								end);
								
								player:SetCharacterData("permakilled", true); -- In case the player tries to d/c to avoid their fate.
								player:DeathCauseOverride("Rode a sinking ship into the sea and drowned.");
								
								if player:IsRagdolled() then
									Clockwork.player:SetRagdollState(player, RAGDOLL_NONE);
								end

								player:GodEnable();
								player:SetPos(Vector(15.167375, 4397.66115, -4967.96875)); -- Teleport to black box full of water.
								player:Freeze(true);
								netstream.Start(player, "DrowningCutscene");
							else
								local ragdollEntity = player:GetRagdollEntity();
								
								if IsValid(ragdollEntity) then
									-- Prevent belongings from spawning.
									ragdollEntity.cwInventory = nil;
									ragdollEntity.cwCash = nil;
									
									ragdollEntity:Remove();
								end
							end
						end
					end
				end);
			end
			
			Clockwork.chatBox:AddInRadius(nil, "localevent", "The longship finally gives way under the strain of its damage, splitting in two and sinking to the bottom of the sea!", self:GetPos(), 1024);
		end
		
		self:EmitSound("physics/wood/wood_crate_break5.wav");
		self:Remove();
	else
		local huskEnt = ents.Create("cw_longship_husk");
		
		huskEnt:SetPos(self:GetPos());
		huskEnt:SetAngles(self:GetAngles());
		huskEnt.location = self.location;
		huskEnt.position = self.position;
		
		self.husk = true; -- Make sure the slot doesn't get cleared.

		huskEnt:Spawn();
		self:Remove();
	end
end

function ENT:Use(activator, caller)
	if (IsValid(caller) and caller:IsPlayer()) then
		local trace = util.TraceHull({
			start = caller:EyePos(),
			endpos = caller:GetPos() - Vector(0, 0, 100),
			maxs = caller:OBBMaxs(),
			mins = caller:OBBMins(),
			filter = function(entity)
				return (entity == self)
			end,
			collisiongroup = COLLISION_GROUP_NONE,
		})

		if (!IsValid(trace.Entity) or trace.Entity != self) then	
			netstream.Start(caller, "OpenLongshipMenu")

			return
		end

		if (self.health) then
			if ((self:GetSkin() == 1 and self.health < 1000) or self.health < 500) then
				if (!self:GetNWBool("Ignited")) then
					self.repairable = true
				else
					self.repairable = false
				end
			else
				self.repairable = false
			end
		end

		local faction = caller:GetFaction()
		local kinisgerOverride = caller:GetNetVar("kinisgerOverride")

		local bOwner = caller:GetCharacterKey() == self.ownerID
		local bOwnerless = (!IsValid(self.owner) or !self.owner:Alive()
			or self.owner:GetNetVar("tied") != 0
			or self.owner:GetCharacterKey() != self.ownerID)
			and kinisgerOverride != "Goreic Warrior"

		local data = {}
		data.entity = self
		data.location = self.location
		data.isOwner = bOwner or bOwnerless

		if (faction == "Goreic Warrior" or kinisgerOverride == "Goreic Warrior" or (caller:IsAdmin() and caller.cwObserverMode)) then
			data.cargoholdopenable = true
			data.destination = self.destination
			data.sailable = (self:GetNWBool("freeSailing") or bOwner or bOwnerless) and !self.destination

			if (self:GetNWBool("Ignited")) then
				data.cargoholdopenable = false
				data.ignited = true
			else
				data.repairable = self.repairable
			end
		end

		if (!self:GetNWBool("Ignited")) then
			if (faction != "Goreic Warrior") then
				if (!self.enchantment) then
					local weapon = caller:GetActiveWeapon()

					if (IsValid(weapon) and weapon:GetClass() == "cw_lantern") then
						local oil = caller:GetNetVar("oil", 0)

						if (oil >= 1) then
							data.ignitable = true
						end
					end
				end
			end
		end
		
		netstream.Start(caller, "OpenLongshipMenu", data)
	end
end

function ENT:OnRemove()
	if (self.cwInventory and !table.IsEmpty(self.cwInventory) or self.cwCash and self.cwCash > 0) then
		local belongingsEnt = ents.Create("cw_belongings");
	
		belongingsEnt:SetData(self.cwInventory, self.cwCash, "Longship Cargo");
		belongingsEnt:SetPos(self:GetPos() + Vector(0, 0, 128));
		belongingsEnt:Spawn();
		
		timer.Create("BelongingsTimer_" .. belongingsEnt:EntIndex(), 1200, 1, function()
			if IsValid(self) then
				self:Remove();
			end
		end);
	end
	
	if self.spawnedNPCs then
		for i, v in ipairs(self.spawnedNPCs) do
			local entity = Entity(v);
			
			if entity and (entity:IsNPC() or entity:IsNextBot()) then
				entity:Remove();
			end
		end
		
		self.spawnedNPCs = nil;
	end
	
	if self.location == "docks" then
		if self.itemID then
			if IsValid(self.owner) and self.ownerID == self.owner:GetCharacterKey() then
				local itemTable = item.FindInstance(self.itemID);
				
				if !itemTable then
					itemTable = item.CreateInstance("scroll_longship", self.itemID);
				end
				
				if itemTable then
					itemTable:SetData("health", self.health or 500);
					
					self.owner:GiveItem(itemTable, true);
				end
			end
		end
	end
	
	self:StopParticles();

	cwSailing:RemoveLongship(self);
end;

function ENT:OnTakeDamage(damageInfo)
	local curTime = CurTime()
	local attacker = damageInfo:GetAttacker()

	if (IsValid(attacker) and attacker:IsPlayer()) then
		local damage = damageInfo:GetDamage()

		if (IsValid(self.owner) and self.owner:Alive()) then
			local subfaction = self.owner:GetSubfaction()
			local bHasBelief = self.owner.HasBelief and self.owner:HasBelief("daring_trout")

			if (subfaction == "Clan Harald" and bHasBelief) then
				if (self.health <= 700) then
					if (!self.owner.nextLongshipNotify or self.owner.nextLongshipNotify <= curTime) then
						Schema:EasyText(self.owner, "icon16/anchor.png", "red", "A raven lands on your shoulder, clutching a torn piece of your longship's sail in its beak! Your longship is being damaged and may soon be destroyed if you do not act!")
						self.owner:SendLua([[Clockwork.Client:EmitSound("npc/crow/die" .. math.random(1, 2) .. ".wav", 70, 100)]])

						self.owner.nextLongshipNotify = curTime + 60
					end
				end
			end
		end

		if (damage >= 20) then
			local damageDealt = 0

			if (damageInfo:IsDamageType(DMG_SLASH)) then
				damageDealt = math.ceil(damage / 20)
			elseif (damageInfo:IsDamageType(DMG_CLUB)) then
				damageDealt = math.ceil(damage / 12)
			end

			if (damageDealt > 0) then
				self.health = self.health or 500
				self:SetHP(self.health - damageDealt)

				if (cwBeliefs and attacker.HandleXP) then
					local faction = attacker:GetFaction()

					if (faction != "Goreic Warrior") then
						local damagePercentage = math.min(damageDealt / 500, 1)
						local faith = math.Round(300 * damagePercentage)

						attacker:HandleXP(faith)
					end
				end

				local activeWeapon = attacker:GetActiveWeapon()
				local weaponItemTable = item.GetByWeapon(activeWeapon)

				if (weaponItemTable) then
					weaponItemTable:TakeConditionByPlayer(attacker, 0.5)
				end
				
				self:EmitSound("physics/wood/wood_strain" .. math.random(2, 4) .. ".wav")
			end
		end
	end
end