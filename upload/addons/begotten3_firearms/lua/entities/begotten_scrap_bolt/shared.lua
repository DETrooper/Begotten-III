ENT.Type 			= "anim"
ENT.PrintName		= "Scrap Bolt"
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
		
		net.Start( "BegottenAnim4", true )
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
				self:GetPhysicsObject():AddAngleVelocity(Vector(0, 5, 0))
			end
			
			self:EmitSound("weapons/throw_swing_03.wav", 80, 110);
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
					self:SetPos(data.HitPos - data.HitNormal * 10)
					self:SetAngles(self:GetAngles())
					self:GetPhysicsObject():EnableMotion(false)
				else
					self:StopSound("weapons/throw_swing_03.wav");
					self:EmitSound(self.Hit[math.random(1, #self.Hit)])
				end
				
				self:EmitSound("weapons/arrow_to_shield_02.wav")
				self:Disable();
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
				
				local damage = (self.AttackTable["primarydamage"])
				local damagetype = (self.AttackTable["dmgtype"])
				local trace = self.Owner:GetEyeTrace()
				
				if Ent:IsNPC() or Ent:IsNextBot() or (Ent:IsPlayer() and !Ent:GetNWBool("Parry") and !Ent:GetNWBool("Deflect")) and !Ent.iFrames then
					local hitEntPos = Ent:GetPos();
					local distance = hitEntPos:DistToSqr(self.cachedStartPos);
					local poiseDamage = self.AttackTable["poisedamage"];
					local stabilityDamage = self.AttackTable["stabilitydamage"];

					if distance < 150 * 150 then
						--print("tier 1");
						damage = damage * 0.8;
						poiseDamage = poiseDamage * 0.8;
						stabilityDamage = stabilityDamage * 0.8;
					elseif distance >= 150 * 150 and distance < 250 * 250 then
						--print("tier 2");
						damage = damage * 1;
						poiseDamage = poiseDamage * 1;
						stabilityDamage = stabilityDamage * 1;
					elseif distance >= 250 * 250 and distance < 400 * 400 then
						--print("tier 3");
						damage = damage * 1.1;
						poiseDamage = poiseDamage * 1.2;
						stabilityDamage = stabilityDamage * 1.2;
					elseif distance >= 400 * 400 and distance < 600 * 600 then
						--print("tier 4");
						damage = damage * 1.2;
						poiseDamage = poiseDamage * 1.3;
						stabilityDamage = stabilityDamage * 1.3;
					elseif distance >= 600 * 600 and distance < 900 * 900 then
						--print("tier 5");
						damage = damage * 1.3;
						poiseDamage = poiseDamage * 1.6;
						stabilityDamage = stabilityDamage * 1.6;
					elseif distance >= 900 * 900 then
						--print("tier 6");
						damage = damage * 1.5;
						poiseDamage = poiseDamage * 1.7;
						stabilityDamage = stabilityDamage * 1.7;
					else
					end
							
					if Ent:IsPlayer() then
						--Ent:TakePoise(poiseDamage);
						--Ent:TakeStamina(poiseDamage);
						Ent:TakeStability(stabilityDamage);
						self:TriggerAnim4(Ent, "a_shared_hit_0"..math.random(1, 3));
					end
					
					if self.parried then
						if cwBeliefs and self.Owner.HasBelief and self.Owner:HasBelief("repulsive_riposte") then
							damage = damage * 3.5;
						else
							damage = damage * 3;
						end
					end
					
					local d = DamageInfo()
					d:SetDamage(damage)
					d:SetAttacker(self.Owner)
					d:SetDamageType( damagetype )
					d:SetDamagePosition(trace.HitPos)
					d:SetInflictor(self);
					
					if (Ent:IsPlayer()) then
						d:SetDamageForce( self.Owner:GetForward() * 5000 )
					end

					Ent:TakeDamageInfo(d)
					
					self:EmitSound(self.FleshHit[math.random(1, #self.FleshHit)])
					self:SetCollisionGroup(COLLISION_GROUP_WORLD);
					
					return;
				elseif Ent:IsPlayer() and (Ent:GetNWBool("Deflect") or Ent:GetNWBool("Parry")) then
					local bolt = ents.Create(self:GetClass())
					if !bolt:IsValid() then return false end
					
					self.collided = true;
					
					bolt:SetModel(self:GetModel());
					bolt:SetPos(self:GetPos())
					bolt:SetOwner(Ent)
					
					bolt.AttackTable = self.AttackTable;
					bolt.itemTable = self.itemTable;
					bolt.SticksInShields =  self.SticksInShields;
					bolt.ConditionLoss = self.ConditionLoss;
					bolt.itemTable = self.itemTable;
					bolt.deflected = true;
					
					if Ent:GetNWBool("Parry") then
						bolt.parried = true;
					end
					
					-- for parry/deflect
					local d = DamageInfo()
					d:SetDamage(0 )
					d:SetAttacker(self.Owner)
					d:SetDamageType(damagetype)
					d:SetDamagePosition(trace.HitPos)
					d:SetInflictor(bolt);

					Ent:TakeDamageInfo(d)
					
					self:Remove();
					
					bolt:Spawn()
					bolt.Owner = Ent
					bolt:Activate()
					
					local phys = bolt:GetPhysicsObject()
					
					if Ent.HasBelief and Ent:HasBelief("impossibly_skilled") then
						bolt:SetAngles(Ent:GetAimVector():Angle())
						phys:SetVelocityInstantaneous(Ent:GetAimVector() * 1800);
						
						Clockwork.chatBox:AddInTargetRadius(Ent, "me", "suddenly catches the crossbow bolt mid-flight with their weapon and redirects it, showing impossible skill and grace as it is deflected in the direction of its shooter!", Ent:GetPos(), config.Get("talk_radius"):Get() * 4);
					else
						phys:SetVelocityInstantaneous(Ent:GetAimVector() * 50);
					end
				
					if !Ent:GetNWBool("Parry") then
						bolt:StopSound("weapons/throw_swing_03.wav");
						bolt:EmitSound(bolt.Hit[math.random(1, #bolt.Hit)])
					end
				
					return;
				elseif Ent.iFrames then
					self:SetCollisionGroup(COLLISION_GROUP_WORLD);
					self:SetVelocityInstantaneous(data.OurOldVelocity);
					Ent:EmitSound("meleesounds/comboattack3.wav.mp3", 75, math.random( 90, 110 ));
					
					return;
				else
					self:StopSound("weapons/throw_swing_03.wav");
					self:EmitSound(self.Hit[math.random(1, #self.Hit)])
				end

				self:Disable();
			end

			self:SetOwner(nil);
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end