ENT.Type 			= "anim"
ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly = true 
ENT.DoNotDuplicate = true 
ENT.DisableDuplicator = true
ENT.isJavelin = true;
ENT.noHandsPickup = true;

--For flinching only 

if SERVER then
	util.AddNetworkString( "BegottenAnim4" )
end;

if CLIENT then
	net.Receive( "BegottenAnim4", function()
		 local target = net.ReadEntity()
		 if target:IsValid() and target:Alive() then
		 local anim = net.ReadString()
		 local lookup = target:LookupSequence(anim)
		 target:AddVCDSequenceToGestureSlot( GESTURE_SLOT_FLINCH, lookup, 0, 1 );
	end end )
end;

function ENT:TriggerAnim4(target, anim) -- The two arguments for this function are "target" and "anim". Target is the entity we want to call the animation on, and anim being the animation itself.
	if SERVER then
		if (!target or !IsValid(target)) then
			target = self.Owner; -- Redundancy check to make sure that we don't get any errors incase "target" isn't valid.
		end;
		
		net.Start( "BegottenAnim4" )
		net.WriteEntity( target ); -- Before, the argument here was just "self.Owner" which was always going to return the player holding the weapon, making them flinch instead of whatever "target" is.
		net.WriteString( anim );
		net.Broadcast();
	end;
end;

--For flinching only

if SERVER then
	AddCSLuaFile("shared.lua")

	/*---------------------------------------------------------
	   Name: ENT:Initialize()
	---------------------------------------------------------*/
	function ENT:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		--self.NextThink = CurTime() +  1
		
		if IsValid(self.Owner) and self.Owner:GetActiveWeapon().Category == "(Begotten) Javelin" then
			if !self.deflected then
				self.attacktable = GetTable(self.Owner:GetActiveWeapon().AttackTable);
				self.itemTable = item.GetByWeapon(self.Owner:GetActiveWeapon());
				self.SticksInShields = self.Owner:GetActiveWeapon().SticksInShields;
				self.ConditionLoss = self.Owner:GetActiveWeapon().ConditionLoss;
				
				if !self.itemTable then
					self.itemTable = item.CreateInstance(self.Owner:GetActiveWeapon());
				end
			end
		else
			if self:GetModel() == "models/demonssouls/weapons/cut javelin.mdl" then
				self.itemTable = item.CreateInstance("begotten_javelin_iron_javelin");
			elseif self:GetModel() == "models/props/begotten/melee/heide_lance.mdl" then
				self.itemTable = item.CreateInstance("begotten_javelin_pilum");
			end
		end

		if (phys:IsValid()) then
			phys:Wake()
			phys:SetMass(10)
		end
		
		self.cachedStartPos = self:GetPos();
		self.InFlight = true

		util.PrecacheSound("physics/metal/metal_grenade_impact_hard3.wav")
		util.PrecacheSound("physics/metal/metal_grenade_impact_hard2.wav")
		util.PrecacheSound("physics/metal/metal_grenade_impact_hard1.wav")
		util.PrecacheSound("physics/flesh/flesh_impact_bullet1.wav")
		util.PrecacheSound("physics/flesh/flesh_impact_bullet2.wav")
		util.PrecacheSound("physics/flesh/flesh_impact_bullet3.wav")
		util.PrecacheSound("weapons/throw_swing_03.wav")

		self.Hit = { 
		Sound("physics/metal/metal_grenade_impact_hard1.wav"),
		Sound("physics/metal/metal_grenade_impact_hard2.wav"),
		Sound("physics/metal/metal_grenade_impact_hard3.wav")};

		self.FleshHit = { 
		Sound("physics/flesh/flesh_impact_bullet1.wav"),
		Sound("physics/flesh/flesh_impact_bullet2.wav"),
		Sound("physics/flesh/flesh_impact_bullet3.wav")}

		self:GetPhysicsObject():SetMass(2)	

		--self:SetUseType(SIMPLE_USE)
		self.CanTool = false
	end

	/*---------------------------------------------------------
	   Name: ENT:Think()
	---------------------------------------------------------*/
	function ENT:Think()
		if not IsValid(self) then return end
		
		self.lifetime = self.lifetime or CurTime() + 20

		if CurTime() > self.lifetime then
			self:Remove()
		end
		
		if self.InFlight then
			if self:GetAngles().pitch <= 55 then
				self:GetPhysicsObject():AddAngleVelocity(Vector(0, 10, 0))
			end
			
			self:EmitSound("weapons/throw_swing_03.wav", 80, 95);
		end
	end

	/*---------------------------------------------------------
	   Name: ENT:Disable()
	---------------------------------------------------------*/
	function ENT:Disable()
		self.PhysicsCollide = function() end
		self.lifetime = CurTime() + 30
		self.InFlight = false
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end

	/*---------------------------------------------------------
	   Name: ENT:PhysicsCollided()
	---------------------------------------------------------*/
	function ENT:PhysicsCollide(data, phys)
		if !self.collided then
			local Ent = data.HitEntity
			
			if !(Ent:IsValid() or Ent:IsWorld()) then return end

			if Ent:IsWorld() and self.InFlight then
				if data.Speed > 500 then
					self:StopSound("weapons/throw_swing_03.wav");
					self:EmitSound("meleesounds/c2920_weapon_land.wav.mp3", 90)
					self:SetPos(data.HitPos - data.HitNormal * 25)
					self:SetAngles(self:GetAngles())
					self:GetPhysicsObject():EnableMotion(false)
				else
					self:StopSound("weapons/throw_swing_03.wav");
					self:EmitSound(self.Hit[math.random(1, #self.Hit)])
				end

				if Clockwork and !self.Owner.opponent then
					if self.itemTable then
						local entity = Clockwork.entity:CreateItem(self.Owner, self.itemTable, self:GetPos());
						 
						if IsValid(entity) then
							self.collided = true;
							self.itemTable:TakeCondition(self.ConditionLoss or 34);
							
							entity:Spawn();
							entity:SetAngles(self:GetAngles());
							entity:GetPhysicsObject():EnableMotion(false);
							self:StopSound("weapons/throw_swing_03.wav");
							entity:EmitSound("meleesounds/c2920_weapon_land.wav.mp3", 90)
							Clockwork.entity:Decay(entity, 300);
							entity.lifeTime = CurTime() + 300; -- so the item save plugin doesn't save it
							
							local phys = entity:GetPhysicsObject();
							
							if (phys:IsValid()) then
								phys:Wake();
								phys:SetMass(2);
								phys:SetVelocity(self:GetPhysicsObject():GetVelocity());
							end
							
							self:Remove();
						else
							self:StopSound("weapons/throw_swing_03.wav");
							self:EmitSound("meleesounds/c2920_weapon_land.wav.mp3", 90)
							self:Disable();
						end
					else
						self:StopSound("weapons/throw_swing_03.wav");
						self:EmitSound("meleesounds/c2920_weapon_land.wav.mp3", 90)
						self:Disable();
					end
				else
					self:StopSound("weapons/throw_swing_03.wav");
					self:EmitSound("meleesounds/c2920_weapon_land.wav.mp3", 90)
					self:Disable();
				end
			elseif Ent.Health and IsValid(self.Owner) then
				local should_stick = false;
				
				if not(Ent:IsPlayer() or Ent:IsNPC() or Ent:IsNextBot() or Ent:GetClass() == "prop_ragdoll") then 
					util.Decal("ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
					self:StopSound("weapons/throw_swing_03.wav");
					self:EmitSound(self.Hit[math.random(1, #self.Hit)])
				end
				
				if Ent:GetClass() == "prop_ragdoll" then
					local ragdollPlayer = Clockwork.entity:GetPlayer(Ent);
					
					if IsValid(ragdollPlayer) then
						Ent = ragdollPlayer;
					end
				end
				
				local enemywep;

				if Ent:IsValid() and Ent:IsPlayer() then
					enemywep = Ent:GetActiveWeapon()
				end
				
				local damage = (self.attacktable["primarydamage"])
				local damagetype = (self.attacktable["dmgtype"])
				local trace = self.Owner:GetEyeTrace()
				
				if Ent:IsNPC() or Ent:IsNextBot() or (Ent:IsPlayer() and !Ent:GetNWBool("Parry") and !Ent:GetNWBool("Deflect")) and !Ent.iFrames then
					if Ent:IsPlayer() and !Ent:GetNWBool("Guardening") then
						damage = (self.attacktable["primarydamage"])
						damagetype = (self.attacktable["dmgtype"])
					else
						if Ent:GetNWBool("Guardening") then
							if enemywep and string.find(enemywep:GetClass(), "_shield") then
								if self.SticksInShields then
									should_stick = true;
									self.ConditionLoss = 100;
								end
								
								local shieldData = Ent.bgShieldData;
								
								if shieldData and shieldData.uniqueID and shieldData.realID then
									local itemTable = Ent:FindItemByID(shieldData.uniqueID, shieldData.realID);
									
									if (itemTable) and !Ent.opponent then
										if self.SticksInShields then
											itemTable:TakeCondition(self.ConditionLoss or 50);
										else
											itemTable:TakeCondition(self.ConditionLoss or 34);
										end
									end
								end
							end
						end
					end
					
					local hitEntPos = Ent:GetPos();
					local distance = hitEntPos:DistToSqr(self.cachedStartPos);
					local poiseDamage = self.attacktable["poisedamage"];
					local stabilityDamage = self.attacktable["stabilitydamage"];

					if distance < 200 * 200 then
						--print("tier 1");
						damage = damage * 0.6;
						poiseDamage = poiseDamage * 0.6;
						stabilityDamage = stabilityDamage * 0.6;
					elseif distance >= 200 * 200 and distance < 400 * 400 then
						--print("tier 2");
						damage = damage * 1;
						poiseDamage = poiseDamage * 1;
						stabilityDamage = stabilityDamage * 1;
					elseif distance >= 700 * 700 then
						--print("tier 4");
						damage = damage * 1.6;
						poiseDamage = poiseDamage * 1.8;
						stabilityDamage = stabilityDamage * 1.8;
					else
						--print("tier 3 (normal)");
					end
							
					if Ent:IsPlayer() then
						Ent:TakePoise(poiseDamage);
						Ent:TakeStability(stabilityDamage);
						self:TriggerAnim4(Ent, "a_shared_hit_0"..math.random(1, 3));
					end
					
					if self.parried then
						if cwBeliefs and self.Owner.HasBelief and self.Owner:HasBelief("repulsive_ripsote") then
							damage = damage * 4;
						else
							damage = damage * 3;
						end
					end
					
					local d = DamageInfo()
					d:SetDamage( damage * GetShieldReduction(shieldnumber) )
					d:SetAttacker(self.Owner)
					d:SetDamageType( damagetype )
					d:SetDamagePosition(trace.HitPos)
					d:SetInflictor(self);
					
					if (Ent:IsPlayer()) then
						d:SetDamageForce( self.Owner:GetForward() * 5000 )
					end

					Ent:TakeDamageInfo(d)
					
					if Clockwork and !self.Owner.opponent then
						if self.itemTable then
							local entity = Clockwork.entity:CreateItem(self.Owner, self.itemTable, self:GetPos());
							 
							if IsValid(entity) then
								self.collided = true;
								self.itemTable:TakeCondition(self.ConditionLoss or 34);
								
								entity:Spawn();
								entity:SetAngles(self:GetAngles());
								self:StopSound("weapons/throw_swing_03.wav");
								entity:EmitSound("meleesounds/c2920_weapon_land.wav.mp3", 90)
								Clockwork.entity:Decay(entity, 300);
								entity.lifeTime = CurTime() + 300; -- so the item save plugin doesn't save it
								
								local phys = entity:GetPhysicsObject();
								
								if (phys:IsValid()) then
									phys:Wake();
									phys:SetMass(2);
									
									--[[if should_stick then
										local bone = Ent:GetHitBoxBone(Ent:LastHitGroup(), 0);
										
										entity:FollowBone(Ent, bone);
									end]]--
								end
								
								self:Remove();
								return;
							end
						end
					end
				elseif Ent:IsPlayer() and (Ent:GetNWBool("Deflect") or Ent:GetNWBool("Parry")) then
					local javelin = ents.Create(self:GetClass())
					if !javelin:IsValid() then return false end
					
					self.collided = true;
					
					javelin:SetModel(self:GetModel());
					javelin:SetPos(self:GetPos())
					javelin:SetOwner(Ent)
					
					javelin.attacktable = self.attacktable;
					javelin.itemTable = self.itemTable;
					javelin.SticksInShields =  self.SticksInShields;
					javelin.ConditionLoss = self.ConditionLoss;
					javelin.itemTable = self.itemTable;
					javelin.deflected = true;
					
					if Ent:GetNWBool("Parry") then
						javelin.parried = true;
					end
					
					-- for parry/deflect
					local d = DamageInfo()
					d:SetDamage(0 )
					d:SetAttacker(self.Owner)
					d:SetDamageType( damagetype )
					d:SetDamagePosition(trace.HitPos)
					d:SetInflictor(javelin);

					Ent:TakeDamageInfo(d)
					
					self:Remove();
					
					javelin:Spawn()
					javelin.Owner = Ent
					javelin:Activate()
					eyes = Ent:EyeAngles()
					
					local phys = javelin:GetPhysicsObject()
					
					if Ent.HasBelief and Ent:HasBelief("impossibly_skilled") then
						javelin:SetAngles(Ent:GetAimVector():Angle())
						phys:SetVelocity(Ent:GetAimVector() * 1250);
						
						Clockwork.chatBox:AddInTargetRadius(Ent, "me", "suddenly catches the projectile mid-flight with their weapon and redirects it, showing impossible skill and grace as it is deflected in the direction of its hurler!", Ent:GetPos(), config.Get("talk_radius"):Get() * 4);
					else
						phys:SetVelocity(Ent:GetAimVector() * 50);
					end
				
					if !Ent:GetNWBool("Parry") then
						javelin:StopSound("weapons/throw_swing_03.wav");
						javelin:EmitSound("meleesounds/c2920_weapon_land.wav.mp3", 90)
					end
				
					return;
				elseif Ent.iFrames then
					self:SetCollisionGroup(COLLISION_GROUP_WORLD);
					self:SetVelocity(data.OurOldVelocity);
					Ent:EmitSound("meleesounds/comboattack3.wav.mp3", 75, math.random( 90, 110 ));
					
					return;
				else
					if Clockwork and !self.Owner.opponent then
						if self.itemTable then
							local entity = Clockwork.entity:CreateItem(self.Owner, self.itemTable, self:GetPos());
							 
							if IsValid(entity) then
								self.collided = true;
								self.itemTable:TakeCondition(self.ConditionLoss or 34);
								
								entity:Spawn();
								entity:SetAngles(self:GetAngles());
								self:StopSound("weapons/throw_swing_03.wav");
								entity:EmitSound("meleesounds/c2920_weapon_land.wav.mp3", 90)
								Clockwork.entity:Decay(entity, 300);
								entity.lifeTime = CurTime() + 300; -- so the item save plugin doesn't save it
								
								local phys = entity:GetPhysicsObject();
								
								if (phys:IsValid()) then
									phys:Wake();
									phys:SetMass(2);
									
									--[[if should_stick then
										local bone = Ent:GetHitBoxBone(Ent:LastHitGroup(), 0);
										
										entity:FollowBone(Ent, bone);
									end]]--
								end
								
								self:Remove();
								return;
							end
						end
					end
				end
				
				--[[if should_stick then
					local bone = Ent:GetHitBoxBone(Ent:LastHitGroup(), 0);
					
					self:FollowBone(Ent, bone);
				else]]--
					self:Disable();
				--end
			end

			self:SetOwner(NUL);
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end