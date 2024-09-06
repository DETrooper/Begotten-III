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
	self:SetModel("models/begotten/misc/goreironclad.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
	self.longshipType = "ironclad";
	
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

function ENT:AttachMachinegun()
	if !IsValid(self.sandbags) then
		local sandbagsEnt = ents.Create("prop_physics");
		
		sandbagsEnt:SetModel("models/props_fortifications/sandbags_corner1.mdl");
		sandbagsEnt:SetAngles(self:GetAngles());
		sandbagsEnt:SetPos(self:GetPos() - (self:GetForward() * 574) + (self:GetRight() * 8) + Vector(0, 0, 30));
		sandbagsEnt:Spawn();
		
		local physicsObject = sandbagsEnt:GetPhysicsObject();
		
		if (IsValid(physicsObject)) then
			physicsObject:Wake();
			physicsObject:EnableMotion(false);
		end;
		
		self.sandbags = sandbagsEnt;
	end

	if !IsValid(self.machinegunEnt) then
		local machinegunEnt = ents.Create("cw_longship_m2browningpod");
		
		machinegunEnt:SetAngles(self:GetAngles() - Angle(90, 0, 180));
		machinegunEnt:SetPos(self:GetPos() - (self:GetForward() * 578) + (self:GetRight() * 0.5) + Vector(0, 0, 71.5));
		machinegunEnt:Spawn();
		
		local physicsObject = machinegunEnt:GetPhysicsObject();
		
		if (IsValid(physicsObject)) then
			physicsObject:Wake();
			physicsObject:EnableMotion(false);
		end;
		
		self.machinegun = machinegunEnt;
		machinegunEnt.ironclad = self;
	end
	
	local itemID = self.itemID;
	
	if itemID then
		local itemTable = item.FindInstance(itemID);

		if itemTable then
			local clip = itemTable:GetData("ammo");
			
			if clip and clip > 0 then
				self.machinegun.gun:Reload(true, math.min(clip, 100));
			end
		end
	end
end

function ENT:AttachSteamEngine()
	local steamEngine = ents.Create("cw_steam_engine");
	
	steamEngine:SetPos(self:GetPos() + Vector(0, 0, 108));
	steamEngine:SetAngles(self:GetAngles() + Angle(0, 0, -90));
	steamEngine:Spawn();
	steamEngine.ironclad = self;
	
	self.steamEngine = steamEngine;
	
	return steamEngine;
end

function ENT:CanMove()
	if !IsValid(self.steamEngine) or !self.steamEngine.fuel or self.steamEngine.fuel <= 0 or !self.steamEngine:GetNWBool("turnedOn") then
		return false;
	end
end

function ENT:OnMoved()
	local sandbagsEnt = self.sandbags;

	if IsValid(sandbagsEnt) then
		sandbagsEnt:SetAngles(self:GetAngles());
		sandbagsEnt:SetPos(self:GetPos() - (self:GetForward() * 574) + (self:GetRight() * 8) + Vector(0, 0, 30));
	end
	
	local machinegunEnt = self.machinegun;
	
	if IsValid(machinegunEnt) then
		machinegunEnt:SetAngles(self:GetAngles() - Angle(90, 0, 180));
		machinegunEnt:SetPos(self:GetPos() - (self:GetForward() * 578) + (self:GetRight() * 0.5) + Vector(0, 0, 71.5));
	end
	
	local steamEngine = self.steamEngine;
	
	if IsValid(steamEngine) then
		steamEngine:SetPos(self:GetPos() + Vector(0, 0, 108));
		steamEngine:SetAngles(self:GetAngles() + Angle(0, 0, -90));
		
		if steamEngine:GetNWBool("turnedOn") then
			steamEngine:StopParticles();
			
			timer.Simple(1, function()
				if IsValid(steamEngine) then
					ParticleEffect("Rocket_Smoke_Trail", steamEngine:GetPos() + (steamEngine:GetForward() * 100) + Vector(0, 0, 45), Angle(0, 0, 0), steamEngine);
				end
			end);
		end
	end
end

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
								Schema:EasyText(GetAdmins(), "icon16/water.png", "cornflowerblue", player:Name().." went overboard!");
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
end

function ENT:Use(activator, caller)
	if IsValid(caller) and caller:IsPlayer() then
		local tr = util.TraceHull({
			start = caller:EyePos(),
			endpos = caller:GetPos() - Vector(0, 0, 100),
			maxs = caller:OBBMaxs(),
			mins = caller:OBBMins(),
			filter = function( ent ) return ( ent == self ) end,
			collisiongroup = COLLISION_GROUP_NONE,
		});
		
		if !IsValid(tr.Entity) or tr.Entity ~= self then	
			netstream.Start(caller, "OpenLongshipMenu");
			return;
		end
		
		local data = {};
		
		data.entity = self;
		data.location = self.location;
		
		if caller:GetFaction() == "Goreic Warrior" or (caller:IsAdmin() and caller.cwObserverMode) then
			self.cargoholdopenable = true;
			data.destination = self.destination;
			data.sailable = true;
		
			if (IsValid(self.owner) and caller ~= self.owner) or self.destination then
				data.sailable = false;
			end
		end
		
		netstream.Start(caller, "OpenLongshipMenu", data)
	end;
end;

function ENT:OnRemove()
	local belongingsEnt = ents.Create("cw_belongings");

	if (self.cwInventory and !table.IsEmpty(self.cwInventory) or self.cwCash and self.cwCash > 0) then
		belongingsEnt:SetData(self.cwInventory, self.cwCash, "Ironclad Cargo");
		belongingsEnt:SetPos(self:GetPos() + Vector(0, 0, 128));
		belongingsEnt:Spawn();
		
		timer.Create("BelongingsTimer_"..belongingsEnt:EntIndex(), 1200, 1, function()
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
	
	if IsValid(self.sandbags) then
		self.sandbags:Remove();
	end
	
	if IsValid(self.machinegun) then
		if IsValid(self.machinegun.gun) then
			local itemID = self.itemID;
			
			local itemTable = item.FindInstance(itemID);
	
			if itemTable then
				itemTable:SetData("ammo", self.machinegun.gun:GetDTInt(0) or 0);
			end
		end
	
		self.machinegun:Remove();
	end
	
	local steamEngine = self.steamEngine;
	
	if IsValid(steamEngine) then
		local itemID = self.itemID;
		
		if itemID then
			local itemTable = item.FindInstance(itemID);
	
			if itemTable then
				itemTable:SetData("fuel", math.Round(steamEngine.fuel or 0, 2));
			end
		end
	
		steamEngine:Remove();
	end

	self:StopParticles();

	cwSailing:RemoveLongship(self);
end;