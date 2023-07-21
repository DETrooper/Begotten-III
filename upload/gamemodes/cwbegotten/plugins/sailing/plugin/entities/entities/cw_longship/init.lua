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
			for i = 1, #self.playersOnBoard do
				local player = self.playersOnBoard[i];
				
				if IsValid(player) then
					local playerPos = player:GetPos();
					
					if (!player.cwObserverMode) then
						local offset = 38.5;
						
						if player:IsRagdolled() then
							offset = 28;
						end
					
						if playerPos.z <= self:GetPos().z + offset then
							Schema:EasyText(GetAdmins(), "icon16/water.png", "cornflowerblue", player:Name().." went overboard!");
							
							if self.location == "calm" or self.location == "rough" then
								sound.Play("ambient/water/water_splash3.wav", playerPos);
								
								--player:SendLua([[RunConsoleCommand("stopsound")]]);
								player:SendLua([[Clockwork.Client:EmitSound("ambient/water/water_splash3.wav", 500, 100)]])
								
								local effectData = EffectData();
								effectData:SetOrigin(playerPos);
								effectData:SetScale(16);
								util.Effect("watersplash", effectData, true, true);
												
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
								player:Spawn();
								player:GodEnable();
								player:SetPos(Vector(15.167375, 4397.66115, -4967.96875)); -- Teleport to black box full of water.
								--player:Freeze(true);
								netstream.Start(player, "DrowningCutscene");
							elseif self.location == "styx" then
								if player:Alive() then
									local world = GetWorldEntity();
									local damageInfo = DamageInfo();
									
									player:DeathCauseOverride("Went overboard into lava and burnt to a crisp.");
									
									damageInfo:SetDamageType(DMG_BURN);
									damageInfo:SetDamage(666);
									damageInfo:SetAttacker(world);
									damageInfo:SetInflictor(world);
									damageInfo:SetDamagePosition(player:GetPos());
									player:TakeDamageInfo(damageInfo);
									
									timer.Simple(0.5, function()
										if IsValid(player) and (!player:Alive()) then
											local effectData = EffectData();
											effectData:SetOrigin(player:GetPos());
											effectData:SetScale(24);
											util.Effect("burning_vehicle", effectData, true, true);
											
											player:EmitSound("ambient/fire/mtov_flame2.wav");
											
											timer.Simple(0.2, function()
												if IsValid(player) and (!player:Alive()) then
													if IsValid(player:GetRagdollEntity()) then
														player:GetRagdollEntity():Remove();
													end
												end
											end);
										end
									end);
								end
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
	
		if self.ignited then
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
					self:SetHP(self.health - math.random(1, 5));
					
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

	if newhp > 0 then
		if newhp == 500 then
			self.repairable = true;
		else
			self.repairable = false;
		end
	elseif self.location and self.location ~= "calm" and self.locaiton ~= "rough" and self.location ~= "styx" then
		local huskEnt = ents.Create("cw_longship_husk");
		
		huskEnt:SetPos(self:GetPos());
		huskEnt:SetAngles(self:GetAngles());
		
		self.husk = true;
		
		if self.location and self.position then
			huskEnt.location = self.location;
			huskEnt.position = self.position;
			
			huskEnt:Spawn();
			self:Remove();
		end
	else
		self:EmitSound("physics/wood/wood_crate_break5.wav");
		self:Remove();
	end
end

function ENT:Use(activator, caller)
	if IsValid(caller) and caller:IsPlayer() then
		local bounding_box = cwSailing:GetLongshipBoundingBox(self);
		
		if bounding_box then
			local callerPos = caller:GetPos();
				
			if not callerPos:WithinAABox(bounding_box["lower"], bounding_box["upper"]) then
				Clockwork.datastream:Start(caller, "OpenLongshipMenu", false, false, false, false, false, false);
				return;
			end
		end
		
		if self.health then
			if self.health < 500 then
				if self.ignited == false then
					self.repairable = true;
				else
					self.repairable = false;
				end
			else
				self.repairable = false;
			end
		end
		
		if caller:GetFaction() == "Goreic Warrior" then
			if (IsValid(self.owner) and caller ~= self.owner) or self.ignited == true then
				Clockwork.datastream:Start(caller, "OpenLongshipMenu", false, self.ignited, self.repairable, false, false, false);
			elseif self.destination then
				Clockwork.datastream:Start(caller, "OpenLongshipMenu", false, self.ignited, self.repairable, false, true, true);
			else
				Clockwork.datastream:Start(caller, "OpenLongshipMenu", true, self.ignited, self.repairable, true, false, true);
			end
		end
	end;
end;

function ENT:OnRemove()
	cwSailing:RemoveLongship(self);
end;