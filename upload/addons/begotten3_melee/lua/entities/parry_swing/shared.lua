ENT.Type 			= "anim"
ENT.PrintName		= "parryswing"
ENT.Author			= ""
ENT.Information		= "Begotten Parry Swing"
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
		
		self:NextThink(CurTime());
		
		multiplier = (attacktable["meleerange"]) * 1.65
		
		if self.Entity:GetPos():Distance(owner:GetPos()) >= (multiplier / 7.5) then
			self.Entity:Remove()
			return true;
		end

		local phys = self:GetPhysicsObject()
		
		if IsValid(phys) and !owner:IsRagdolled() and owner:Alive() then
			phys:SetVelocityInstantaneous((self:GetAngles():Forward() * 10000) + owner:GetVelocity() * 10);
		end
	else
		self:Remove();
		return;
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
			
			if hit:IsValid() and (hit:IsPlayer() or hit:IsNPC()) then
				local melee_range = attacktable["meleerange"];
						
				if distance >= (melee_range / 7.5) then
					--self.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
					self:Remove();
					return false;
				end;
			end
		end
	end
	
	if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() then
		enemywep = data.HitEntity:GetActiveWeapon()
	end

	if owner:IsValid() and !owner:IsRagdolled() and owner:Alive() then
		local effectdata = EffectData() 
		effectdata:SetOrigin( self:GetPos() ) 
		effectdata:SetNormal( self:GetPos():GetNormal() ) 
		effectdata:SetEntity( self ) 

		local trace = owner:GetEyeTrace()
		local activeWeapon = owner:GetActiveWeapon();
		local weaponclass = activeWeapon:GetClass()
		local shieldnumber = (GetShieldString(weaponclass))
		
		-- Bellhammer special
		if activeWeapon.IsBellHammer == true and data.HitEntity:IsValid() and !data.HitEntity:GetNWBool("Guardening") == true and data.HitEntity:GetNWBool("Parry") != true then
			owner:Disorient(1)
			timer.Simple( 0.2, function() if data.HitEntity:IsValid() then
			data.HitEntity:EmitSound("meleesounds/bell.mp3")
			end end)
			if data.HitEntity:IsPlayer() then
				data.HitEntity:Disorient(8)
			end
		end
	
		local shield_reduction = GetShieldReduction(shieldnumber);
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
		
		if cwBeliefs and owner.HasBelief and owner:HasBelief("repulsive_ripsote") then
			d:SetDamage( (attacktable["primarydamage"]) * shield_reduction * 4)
		else
			d:SetDamage( (attacktable["primarydamage"]) * shield_reduction * 3)
		end
		
		d:SetAttacker( self.Entity:GetOwner() )
		d:SetDamageType( (attacktable["dmgtype"]) )
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
			
			-- Fire attack type
			if (data.HitEntity:IsValid()) and attacktable["attacktype"] == "fire_swing" then
				local target = data.HitEntity
				target:Ignite(activeWeapon.IgniteTime * 3)
			end
			
			-- Ice attack type
			if (data.HitEntity:IsValid()) and attacktable["attacktype"] == "ice_swing" then
				local target = data.HitEntity
				DoElementalEffect( { Element = EML_ICE, Target = data.HitEntity, Duration = activeWeapon.FreezeTime * 3, Attacker = self.Owner } )
			end
			
			if (owner:IsValid()) then
				local pos = data.HitEntity:GetPos() + Vector(0,0, 50);

				if (trace.HitPos:Distance(data.HitEntity:GetPos()) < 128 and !trace.Entity:IsWorld() and (trace.Entity:IsNPC() or trace.Entity:IsNextBot())) then
					pos = trace.HitPos;
				end;
			end;
		end

		if data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and !data.HitEntity:IsRagdolled() and data.HitEntity:GetNWBool("Deflect") != true and data.HitEntity:GetNWBool("Parry") != true and !data.HitEntity.iFrames then
			self:TriggerAnim4(data.HitEntity, "a_shared_hit_0"..math.random(1, 3));
			
			if owner.upstagedActive and not data.HitEntity.opponent then
				if IsValid(enemywep) then
					if not string.find(enemywep:GetClass(), "_shield") and not string.find(enemywep:GetClass(), "begotten_fists") and not string.find(enemywep:GetClass(), "begotten_claws") then
						local dropMessages = {" goes flying out of their hand!", " is knocked out of their hand!"};
						local dropPos = data.HitEntity:GetPos() + Vector(0, 0, 35) + data.HitEntity:GetAngles():Forward() * 4
						local itemTable = Clockwork.item:GetByWeapon(enemywep);
						
						if itemTable then
							local itemEnt = Clockwork.entity:CreateItem(data.HitEntity, itemTable, dropPos);
							
							if (IsValid(itemEnt)) then
								Clockwork.chatBox:AddInTargetRadius(data.HitEntity, "me", "'s "..itemTable.name..dropMessages[math.random(1, #dropMessages)], data.HitEntity:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
								data.HitEntity:TakeItem(itemTable, true)
								data.HitEntity:SelectWeapon("begotten_fists")
								data.HitEntity:StripWeapon(enemywep:GetClass())
							end
						end
					end
				end
			end
		end

		self.Entity:Remove()
		 
		if data.HitEntity:IsPlayer() and !data.HitEntity:GetNWBool("Guardening") == true and !data.HitEntity:GetNWBool("Parry") == true and !data.HitEntity.iFrames then
		
			data.HitEntity:TakeStability((attacktable["stabilitydamage"] * 3) * shield_reduction)		

			-- Fire attack type
			if (data.HitEntity:IsValid()) and attacktable["attacktype"] == "fire_swing" then
				local target = data.HitEntity
				target:Ignite(activeWeapon.IgniteTime)
			end
			
			-- Ice attack type
			if (data.HitEntity:IsValid()) and attacktable["attacktype"] == "ice_swing" then
				local target = data.HitEntity
				DoElementalEffect( { Element = EML_ICE, Target = data.HitEntity, Duration = activeWeapon.FreezeTime, Attacker = self.Owner } )
			end

			local i = math.random(1)
			i = math.random(1,2)
			
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
end print("Melee Ent (Parry Swing) Loaded")