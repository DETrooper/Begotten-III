ENT.Type 			= "anim"
ENT.PrintName		= "regswing"
ENT.Author			= ""
ENT.Information		= "Begotten Regular Swing"
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
		
	self.Entity:SetModel("models/hunter/plates/plate025x1.mdl")
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
		local melee_range = attacktable["meleerange"];
		
		if melee_range < 500 then
			melee_range = 500;
		end
		
		self:NextThink(CurTime());
		
		if self.Entity:GetPos():Distance(owner:GetPos()) >= (melee_range / 7.5) then
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
	-- OPTIMIZE NOTE: clean this up
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
				local melee_range = attacktable["meleerange"];
						
				if distance >= (melee_range / 7.5) then
					--self.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
					self:Remove();
					return false;
				end;
			end
		end
	end

	if hit:IsValid() and hit:IsPlayer() then
		enemywep = data.HitEntity:GetActiveWeapon()
	end

	if owner:IsValid() and !owner:IsRagdolled() and owner:Alive() then
		local trace = owner:GetEyeTrace()
		local activeWeapon = owner:GetActiveWeapon();
		local weaponclass = activeWeapon:GetClass();
							
		-- Spear Damage System (Messy)					
		local distance = (owner:GetPos():Distance(data.HitEntity:GetPos()))
				
		local damage = (attacktable["primarydamage"])
		local damagetype = (attacktable["dmgtype"])
		
		local blockTable = GetTable(activeWeapon:GetNWString("activeShield"));
		local shield_reduction = 1;
		
		if blockTable then
			shield_reduction = blockTable.damagereduction or 1;
		end
		
		if (IsValid(activeWeapon)) then
			if string.find(activeWeapon:GetClass(), "begotten_spear_") then
				if distance >= 0 and distance <= 64 and data.HitEntity:IsValid() then
					damage = (attacktable["primarydamage"]) * 0.05
					damagetype = 128
					
					if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or (data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") and !data.HitEntity:GetNWBool("Parry") and !data.HitEntity:GetNWBool("Deflect")) and !data.HitEntity.iFrames then
						--print "Spear Shaft Hit"
						
						-- KNOCKBACK
						local knockback = owner:GetAngles():Forward() * 650;
						knockback.z = 0

						timer.Simple(0.1, function()
							if IsValid(data.HitEntity) then
								data.HitEntity:SetVelocity(knockback);
							end
						end);
						
						if data.HitEntity:IsPlayer() then
							data.HitEntity:TakeStability(15)
						end
					end
			
				elseif distance >= 65 and data.HitEntity:IsValid() then
					damage = (attacktable["primarydamage"])
					damagetype = (attacktable["dmgtype"])
					
					if (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or (data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") and !data.HitEntity:GetNWBool("Parry") and !data.HitEntity:GetNWBool("Deflect")) and !data.HitEntity.iFrames then
						-- counter damage
						local targetVelocity = data.HitEntity:GetVelocity();
						
						if math.abs(targetVelocity.x) > 150 or math.abs(targetVelocity.y) > 150 then
							local entEyeAngles = data.HitEntity:EyeAngles();
						
							if math.abs(math.AngleDifference(entEyeAngles.y, (owner:GetPos() - data.HitEntity:GetPos()):Angle().y)) <= 90 then
								damage = damage + (damage * 0.6);
							end
						end
						
						if data.HitEntity:IsPlayer() then
							data.HitEntity:TakeStability((attacktable["stabilitydamage"] * shield_reduction));
						end
					end
				end
			else
				-- For non-spears
				if data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") and !data.HitEntity:GetNWBool("Parry") and !data.HitEntity:GetNWBool("Deflect") and !data.HitEntity.iFrames then
					if owner.GetCharmEquipped and owner:GetCharmEquipped("ring_pugilist") and activeWeapon:GetClass() == "begotten_fists" then
						data.HitEntity:TakeStability(25);
					else
						data.HitEntity:TakeStability((attacktable["stabilitydamage"] * shield_reduction));
					end
				end
				
				-- Bellhammer special
				if activeWeapon.IsBellHammer == true and ((data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or (data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") and !data.HitEntity:GetNWBool("Parry") and !data.HitEntity:GetNWBool("Deflect"))) and !data.HitEntity.iFrames then
					owner:Disorient(1)
					
					timer.Simple(0.2, function() 
						if data.HitEntity:IsValid() and (data.HitEntity:IsNPC() or data.HitEntity:IsNextBot()) or data.HitEntity:IsPlayer() then
							data.HitEntity:EmitSound("meleesounds/bell.mp3")
						end 
					end);
					
					if data.HitEntity:IsPlayer() then
						data.HitEntity:Disorient(5);
					end
				end
			end
		end

		-- Spear Damage System (Messy)					
		
		--print(damagetype)
		
		local itemTable = item.GetByWeapon(activeWeapon);

		-- Condition damage penalty
		if itemTable then
			local condition = itemTable:GetCondition();
			
			if condition and condition < 100 then
				if damagetype == DMG_CLUB then
					damage = damage * Lerp(condition / 100, 0.75, 1);
				elseif damagetype == DMG_SLASH then
					damage = damage * Lerp(condition / 100, 0.4, 1);
				elseif damagetype == DMG_VEHICLE then
					damage = damage * Lerp(condition / 100, 0.5, 1);
				end
			end
		end
		
		if cwBeliefs and owner.HasBelief then
			if owner:HasBelief("shieldwall") then
				shield_reduction = 1 - ((1 - shield_reduction) * 0.6);
			end
		end
		
		local d = DamageInfo()
		d:SetDamage( damage * shield_reduction)
		d:SetAttacker( self.Entity:GetOwner() )
		d:SetDamageType( damagetype )
		d:SetDamagePosition(trace.HitPos)

		if (data.HitEntity:IsPlayer()) then
			d:SetDamageForce( self.Owner:GetForward() * 5000 )
		end
	
		if (IsValid(forcent) and owner:IsValid() and !owner:IsRagdolled() and owner:Alive()) then
			if (Clockwork.entity:IsPlayerRagdoll(forcent)) then
				if string.find(activeWeapon:GetClass(), "begotten_dagger_") or string.find(activeWeapon:GetClass(), "begotten_dualdagger_") then -- Daggers deal more damage against fallen opponents
					d:SetDamage(d:GetDamage() * 4)
					forcent:TakeDamageInfo(d)
				else
					forcent:TakeDamageInfo(d)
				end
			end;
		end;
	
		if owner:IsValid() and !owner:IsRagdolled() and owner:Alive() then
			data.HitEntity:TakeDamageInfo( d )
		end

		if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:IsRagdolled() and data.HitEntity:GetNWBool("Deflect") != true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
			self:TriggerAnim4(data.HitEntity, "a_shared_hit_0"..math.random(1, 3));
		end

		self.Entity:Remove()
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
end print("Melee Ent 1 Loaded")