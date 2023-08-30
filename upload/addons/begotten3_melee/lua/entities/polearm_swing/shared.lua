ENT.Type 			= "anim"
ENT.PrintName		= "regswing"
ENT.Author			= ""
ENT.Information		= "Begotten Polearm Swing"
ENT.Category		= "Begotten"
ENT.Spawnable		= false
ENT.AdminSpawnable	= false

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

function ENT:Initialize()
	local owner = self.Entity:GetOwner()
	local weapon = owner:GetActiveWeapon()
	
	self.Entity:SetModel("models/hunter/plates/plate025x075.mdl")
    self.Entity:SetNoDraw( true )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetMoveCollide(COLLISION_GROUP_PROJECTILE)
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetSolid( SOLID_CUSTOM )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	self.Entity:DrawShadow( false )
	
	self.AttackTable = GetTable(weapon.AttackTable)
	self.AttackSoundTable = GetSoundTable(weapon.AttackSoundTable)
	
	local phys = self:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(0.01)
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:SetBuoyancyRatio(0)
		phys:SetMaterial( "default_silent" )
		
		phys:SetVelocityInstantaneous((self:GetAngles():Forward() * 10000) + owner:GetVelocity() * 10);
	end
end

function ENT:Think()
	local owner = self.Entity:GetOwner()
	
	if IsValid(owner) then
		local weapon = owner:GetActiveWeapon()
		local attacktable = self.AttackTable;
		
		self:NextThink(CurTime());
		
		if self.Entity:GetPos():Distance(owner:GetPos()) >= (attacktable["meleerange"] / 7.5) then
			self.Entity:Remove()
			return true;
		end

		local phys = self:GetPhysicsObject()
		
		if IsValid(phys) and !owner:IsRagdolled() and owner:Alive() then
			phys:SetVelocityInstantaneous((self:GetAngles():Forward() * 10000) + owner:GetVelocity() * 10);
		end
	else
		self:Remove();
		return true;
	end
end

function ENT:Touch(ent)
end

function ENT:PhysicsCollide(data, physobj)
	if (!self.already) then
		self.already = true;
	else
		return;
	end;
	
	local distance;
	local forcent;
	local attacktable = self.AttackTable;
	local attacksoundtable = self.AttackSoundTable;
	local owner = self.Entity:GetOwner()
	local hit = data.HitEntity
	local activeWeapon = owner:GetActiveWeapon()
	
	if !owner:IsValid() then
		--self.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self:Remove();
		return false;
	else
		if (hit:IsWorld()) then
			for k, v in pairs (ents.FindInSphere(data.HitPos, 32)) do
				if (v:GetClass() == "prop_ragdoll") and Clockwork.entity:IsPlayerRagdoll(v) then
					forcent = v;
					break;
				end;
			end;
		end;
	
		if forcent then
			distance = owner:GetPos():Distance(forcent:GetPos());
				
			local melee_range = attacktable["meleerange"];
					
			if distance >= (melee_range / 7.5) then
				--self.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
				self:Remove();
				return false;
			end;
		else
			distance = owner:GetPos():Distance(hit:GetPos());
			
			if hit:IsValid() and (hit:IsPlayer() or hit:IsNPC() or hit:IsNextBot()) then
				if distance >= (attacktable["meleerange"] / 7.5) then
					--self.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
					self:Remove();
					return false;
				end;
			end
		end
	end
	
	if (!hit.nexthit or CurTime() > hit.nexthit) then 
		hit.nexthit = CurTime() + 1
	end

	if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() then
		enemywep = data.HitEntity:GetActiveWeapon()
	end

	if !owner:IsRagdolled() and owner:Alive() then
		local effectdata = EffectData() 
		effectdata:SetOrigin( self:GetPos() ) 
		effectdata:SetNormal( self:GetPos():GetNormal() ) 
		effectdata:SetEntity( self ) 

		local trace = owner:GetEyeTrace()
		
		-- Polearm Damage System
				
		local poledamage = (attacktable["primarydamage"])
		local poletype = (attacktable["dmgtype"])
		
		if activeWeapon.ShortPolearm != true then
			if distance >= 0 and distance <= 35 and data.HitEntity:IsValid() then
				if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or data.HitEntity:IsPlayer() then
					--print "Tier 0"
					poledamage = (attacktable["primarydamage"]) * 0.01
					poletype = 128
					if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") == true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
						data.HitEntity:TakeStability(5)
						--data.HitEntity:EmitSound( "physics/body/body_medium_impact_hard"..math.random(2,6)..".wav" ) 
						
						-- KNOCKBACK
						local knockback = owner:GetAngles():Forward() * 750;
						knockback.z = 0
						
						timer.Simple(0.1, function()
							if IsValid(data.HitEntity) then
								data.HitEntity:SetVelocity(knockback);
							end
						end);
					end
					if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) then
						--data.HitEntity:EmitSound( "physics/body/body_medium_impact_hard"..math.random(2,6)..".wav" ) 
					end
				end
			
			elseif distance > 35 and distance <= 55 and data.HitEntity:IsValid() then
				if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or data.HitEntity:IsPlayer() then
					--print "Tier 1"
					poledamage = (attacktable["primarydamage"]) * 0.05
					poletype = 128
					if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") == true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
						data.HitEntity:TakeStability(10)
						--data.HitEntity:EmitSound( "physics/body/body_medium_impact_hard"..math.random(2,6)..".wav" ) 
						
						-- KNOCKBACK
						local knockback = owner:GetAngles():Forward() * 700;
						knockback.z = 0
						
						timer.Simple(0.1, function()
							if IsValid(data.HitEntity) then
								data.HitEntity:SetVelocity(knockback);
							end
						end);
					end
					if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) then
						--data.HitEntity:EmitSound( "physics/body/body_medium_impact_hard"..math.random(2,6)..".wav" ) 
					end
				end
			
			elseif distance > 55 and distance <= 65 and data.HitEntity:IsValid() then
				if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or data.HitEntity:IsPlayer() then
					--print "Tier 2"
					poledamage = (attacktable["primarydamage"]) * 0.08
					poletype = 128
					if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") == true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
						data.HitEntity:TakeStability(15)
						--data.HitEntity:EmitSound( "physics/body/body_medium_impact_hard"..math.random(2,6)..".wav" ) 
						
						-- KNOCKBACK
						local knockback = owner:GetAngles():Forward() * 650;
						knockback.z = 0
						
						timer.Simple(0.1, function()
							if IsValid(data.HitEntity) then
								data.HitEntity:SetVelocity(knockback);
							end
						end);
					end
					if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) then
						--data.HitEntity:EmitSound( "physics/body/body_medium_impact_hard"..math.random(2,6)..".wav" ) 
					end
				end
			
			elseif distance > 65 and distance <= 75 and data.HitEntity:IsValid() then
				if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or data.HitEntity:IsPlayer() then
					--print "Tier 3"
					poledamage = (attacktable["primarydamage"]) * 0.1
					poletype = 128
					if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") == true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
						data.HitEntity:TakeStability(20)
						--data.HitEntity:EmitSound( "physics/body/body_medium_impact_hard"..math.random(2,6)..".wav" ) 
						
						-- KNOCKBACK
						local knockback = owner:GetAngles():Forward() * 600;
						knockback.z = 0
						
						timer.Simple(0.1, function()
							if IsValid(data.HitEntity) then
								data.HitEntity:SetVelocity(knockback);
							end
						end);
					end
					if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) then
						--data.HitEntity:EmitSound( "physics/body/body_medium_impact_hard"..math.random(2,6)..".wav" ) 
					end
				end
			
			elseif distance > 75 and distance <= 85 and data.HitEntity:IsValid() then
				if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or data.HitEntity:IsPlayer() then
					--print "Tier 4"
					poledamage = (attacktable["primarydamage"]) * 0.7
					
					-- counter damage
					local targetVelocity = data.HitEntity:GetVelocity();
					
					if math.abs(targetVelocity.x) > 150 or math.abs(targetVelocity.y) > 150 then
						local entEyeAngles = data.HitEntity:EyeAngles();
					
						if math.abs(math.AngleDifference(entEyeAngles.y, (owner:GetPos() - data.HitEntity:GetPos()):Angle().y)) <= 90 then
							poledamage = poledamage + (poledamage * 0.6);
						end
					end
					
					poletype = (attacktable["dmgtype"])
					if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") == true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
						data.HitEntity:TakeStability((attacktable["stabilitydamage"] * 0.7))			
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
					if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) then
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
				end
			
			elseif distance > 85 and distance <= 95 and data.HitEntity:IsValid() then
				if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or data.HitEntity:IsPlayer() then
					--print "Tier 5"
					poledamage = (attacktable["primarydamage"]) * 0.8
					
					-- counter damage
					local targetVelocity = data.HitEntity:GetVelocity();
					
					if math.abs(targetVelocity.x) > 150 or math.abs(targetVelocity.y) > 150 then
						local entEyeAngles = data.HitEntity:EyeAngles();
					
						if math.abs(math.AngleDifference(entEyeAngles.y, (owner:GetPos() - data.HitEntity:GetPos()):Angle().y)) <= 90 then
							poledamage = poledamage + (poledamage * 0.5);
						end
					end
					
					poletype = (attacktable["dmgtype"])
					if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") == true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
						data.HitEntity:TakeStability((attacktable["stabilitydamage"] * 0.8))			
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
					if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) then
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
				end
			
			elseif distance > 95 and distance <= 105 and data.HitEntity:IsValid() then
				if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or data.HitEntity:IsPlayer() then
					--print "Tier 6"
					poledamage = (attacktable["primarydamage"]) * 1
					
					-- counter damage
					local targetVelocity = data.HitEntity:GetVelocity();
					
					if math.abs(targetVelocity.x) > 150 or math.abs(targetVelocity.y) > 150 then
						local entEyeAngles = data.HitEntity:EyeAngles();
					
						if math.abs(math.AngleDifference(entEyeAngles.y, (owner:GetPos() - data.HitEntity:GetPos()):Angle().y)) <= 90 then
							poledamage = poledamage + (poledamage * 0.5);
						end
					end
					
					poletype = (attacktable["dmgtype"])
					if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") == true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
						data.HitEntity:TakeStability((attacktable["stabilitydamage"] * 1))			
						data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
					if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) then
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
				end
			
			elseif distance > 105 and distance <= 115 and data.HitEntity:IsValid() then
				if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or data.HitEntity:IsPlayer() then
					--print "Tier 7"
					poledamage = (attacktable["primarydamage"]) * 1.1
					
					-- counter damage
					local targetVelocity = data.HitEntity:GetVelocity();
					
					if math.abs(targetVelocity.x) > 150 or math.abs(targetVelocity.y) > 150 then
						local entEyeAngles = data.HitEntity:EyeAngles();
					
						if math.abs(math.AngleDifference(entEyeAngles.y, (owner:GetPos() - data.HitEntity:GetPos()):Angle().y)) <= 90 then
							poledamage = poledamage + (poledamage * 0.5);
						end
					end
					
					poletype = (attacktable["dmgtype"])
					if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") == true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
						data.HitEntity:TakeStability((attacktable["stabilitydamage"] * 1.1))			
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
					if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) then
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
				end
			
			elseif distance > 115 and distance <= 125 and data.HitEntity:IsValid() then
				if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or data.HitEntity:IsPlayer() then
					--print "Tier 8"
					poledamage = (attacktable["primarydamage"]) * 1.3
					
					-- counter damage
					local targetVelocity = data.HitEntity:GetVelocity();
					
					if math.abs(targetVelocity.x) > 150 or math.abs(targetVelocity.y) > 150 then
						local entEyeAngles = data.HitEntity:EyeAngles();
					
						if math.abs(math.AngleDifference(entEyeAngles.y, (owner:GetPos() - data.HitEntity:GetPos()):Angle().y)) <= 90 then
							poledamage = poledamage + (poledamage * 0.6);
						end
					end
					
					poletype = (attacktable["dmgtype"])
					if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") == true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
						data.HitEntity:TakeStability((attacktable["stabilitydamage"] * 1.3))			
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
					if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) then
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
				end
			
			elseif distance > 125 and distance <= 135 and data.HitEntity:IsValid() then
				if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or data.HitEntity:IsPlayer() then
					--print "Tier 9"
					poledamage = (attacktable["primarydamage"]) * 1.6
					
					-- counter damage
					local targetVelocity = data.HitEntity:GetVelocity();
					
					if math.abs(targetVelocity.x) > 150 or math.abs(targetVelocity.y) > 150 then
						local entEyeAngles = data.HitEntity:EyeAngles();
						
						if math.abs(math.AngleDifference(entEyeAngles.y, (owner:GetPos() - data.HitEntity:GetPos()):Angle().y)) <= 90 then
							poledamage = poledamage + (poledamage * 0.6);
						end
					end
					
					poletype = (attacktable["dmgtype"])
					if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") == true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
						data.HitEntity:TakeStability((attacktable["stabilitydamage"] * 1.6))			
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
					if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) then
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
				end
			
			elseif distance > 135 and data.HitEntity:IsValid() then
				if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or data.HitEntity:IsPlayer() then
					--print "Tier 10"
					poledamage = (attacktable["primarydamage"]) * 1.7
					
					-- counter damage
					local targetVelocity = data.HitEntity:GetVelocity();
					
					if math.abs(targetVelocity.x) > 150 or math.abs(targetVelocity.y) > 150 then
						local entEyeAngles = data.HitEntity:EyeAngles();
					
						if math.abs(math.AngleDifference(entEyeAngles.y, (owner:GetPos() - data.HitEntity:GetPos()):Angle().y)) <= 90 then
							poledamage = poledamage + (poledamage * 0.6);
						end
					end
					
					poletype = (attacktable["dmgtype"])
					if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") == true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
						data.HitEntity:TakeStability((attacktable["stabilitydamage"] * 1.7))			
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
					if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) then
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
				end
			end
		else
			if distance >= 0 and distance <= 70 and data.HitEntity:IsValid() then
				if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or data.HitEntity:IsPlayer() then
					--print "Tier 1 (Small Polearm)"
					poledamage = (attacktable["primarydamage"]) * 0.1
					poletype = 128
					if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") == true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
						data.HitEntity:TakeStability(15)

						-- KNOCKBACK
						local knockback = owner:GetAngles():Forward() * 650;
						knockback.z = 0
						
						timer.Simple(0.1, function()
							if IsValid(data.HitEntity) then
								data.HitEntity:SetVelocity(knockback);
							end
						end);
						
						--data.HitEntity:EmitSound( "physics/body/body_medium_impact_hard"..math.random(2,6)..".wav" ) 
					end
					if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) then
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
				end
				
			elseif distance > 70 and distance <= 85 and data.HitEntity:IsValid() then
				if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or data.HitEntity:IsPlayer() then
					--print "Tier 2 (Small Polearm)"
					poledamage = (attacktable["primarydamage"]) * 1
					
					-- counter damage
					local targetVelocity = data.HitEntity:GetVelocity();
					
					if math.abs(targetVelocity.x) > 150 or math.abs(targetVelocity.y) > 150 then
						local entEyeAngles = data.HitEntity:EyeAngles();
					
						if math.abs(math.AngleDifference(entEyeAngles.y, (owner:GetPos() - data.HitEntity:GetPos()):Angle().y)) <= 90 then
							poledamage = poledamage + (poledamage * 0.5);
						end
					end
					
					poletype = (attacktable["dmgtype"])
					if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") == true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
						data.HitEntity:TakeStability((attacktable["stabilitydamage"] * 1))			
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
					if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) then
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
				end
				
			elseif distance > 85 and data.HitEntity:IsValid() then
				if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or data.HitEntity:IsPlayer() then
					--print "Tier 3 (Small Polearm)"
					poledamage = (attacktable["primarydamage"]) * 1.5
					
					-- counter damage
					local targetVelocity = data.HitEntity:GetVelocity();
					
					if math.abs(targetVelocity.x) > 150 or math.abs(targetVelocity.y) > 150 then
						local entEyeAngles = data.HitEntity:EyeAngles();
					
						if math.abs(math.AngleDifference(entEyeAngles.y, (owner:GetPos() - data.HitEntity:GetPos()):Angle().y)) <= 90 then
							poledamage = poledamage + (poledamage * 0.5);
						end
					end
					
					poletype = (attacktable["dmgtype"])
					if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") == true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
						data.HitEntity:TakeStability((attacktable["stabilitydamage"] * 1.5))			
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
					if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) then
						--data.HitEntity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
					end
				end
			end
		end
		
		-- Polearm Damage System
	
		local itemTable = item.GetByWeapon(activeWeapon);
		
		if itemTable then
			local condition = itemTable:GetCondition();
			
			if condition and condition < 100 then
				if poletype == DMG_CLUB then
					poledamage = poledamage * Lerp(condition / 100, 0.9, 1);
				elseif poletype == DMG_SLASH then
					poledamage = poledamage * Lerp(condition / 100, 0.7, 1);
				elseif poletype == DMG_VEHICLE then
					poledamage = poledamage * Lerp(condition / 100, 0.8, 1);
				end
			end
		end
	
		local d = DamageInfo()
		d:SetDamage( poledamage )
		d:SetAttacker( self.Entity:GetOwner() )
		d:SetDamageType( poletype )
		d:SetDamagePosition(trace.HitPos)

		if (data.HitEntity:IsPlayer()) then
			d:SetDamageForce( self.Owner:GetForward() * 5000 )
		end
	
		if (IsValid(forcent) and owner:IsValid() and !owner:IsRagdolled() and owner:Alive()) then
			if (Clockwork.entity:IsPlayerRagdoll(forcent)) then
				forcent:TakeDamageInfo(d)
			end;
		end;
	
		if owner:IsValid() and !owner:IsRagdolled() and owner:Alive() then
			data.HitEntity:TakeDamageInfo( d )
		end

		if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) then
			local trace = owner:GetEyeTrace();
			
			if (owner:IsValid()) then
				local pos = data.HitEntity:GetPos() + Vector(0,0, 50);

				if (trace.HitPos:Distance(data.HitEntity:GetPos()) < 128 and !trace.Entity:IsWorld() and (trace.Entity:IsNPC() or trace.Entity:IsNextBot())) then
					pos = trace.HitPos;
				end;
			end;
		end

		if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:IsRagdolled() and data.HitEntity:GetNWBool("Deflect") != true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
			self:TriggerAnim4(data.HitEntity, "a_shared_hit_0"..math.random(1, 3)); 
		end
		
		self.Entity:Remove()
		 
		if data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") == true and !data.HitEntity:GetNWBool("Parry") == true and !data.HitEntity.iFrames then
		
			local trace = owner:GetEyeTrace();
			
			if (owner:IsValid()) then
				local pos = data.HitEntity:GetPos() + Vector(0,0, 50);

				if (trace.HitPos:Distance(data.HitEntity:GetPos()) < 128 and !trace.Entity:IsWorld() and trace.Entity:IsPlayer()) then
					pos = trace.HitPos;
				end;
			end;
		end
	end
end
end

function ENT:SetEntityOwner(ent)
	self:SetOwner(ent)
	self.entOwner = ent
end

if CLIENT then
function ENT:Initialize()
pos = self:GetPos()
self.emitter = ParticleEmitter( pos )
end
end print("Melee Ent (Polearm Swing) Loaded")