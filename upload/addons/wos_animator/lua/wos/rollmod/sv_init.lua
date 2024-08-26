

--[[-------------------------------------------------------------------
	Roll Mod:
		Dodge, duck, dip, dive and... roll!
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
----------------------------------------------------------------------[[
							  
	Lua Developer: King David
	Contact: http://steamcommunity.com/groups/wiltostech
		
-------------------------- Copyright 2017, David "King David" Wiltos ]]--

util.AddNetworkString( "wOS.RollMod.CallRestart" )

resource.AddFile( "sound/wos/roll/dive.wav" )
resource.AddFile( "sound/wos/roll/land.wav" )

concommand.Add("admin_roll", function(ply)
	if (ply:IsAdmin()) then
		ply:StartRolling(true)
	end;
end);

concommand.Add("begotten_roll", function( ply, cmd, args )
	if IsValid(ply.victim) then
		ply = ply.victim;
	elseif ply.possessor then
		return;
	end
	
	if (Clockwork and Clockwork.player and Clockwork.player.HasFlags and Clockwork.player:HasFlags(ply, "4")) then
		ply:StartRolling(true)
		return
	end;
	
	if !IsValid( ply ) or !ply:Alive() or ply:wOSIsRolling() or !ply:OnGround() then return end
	if ply:InVehicle() then return end
	if ply:GetVelocity() == Vector(0, 0, 0) then return end
	
	ply:StartRolling()
end )

hook.Add( "OnPlayerHitGround", "wOS.RollMod.PlayLandNoise", function( ply, inWater, onFloater, speed )
	if ply.wOS.Landed then return end
	ply:EmitSound( "wos/roll/land.wav" )
	ply.wOS.Landed = true
end )

hook.Add( "PreEntityTakeDamage", "wOS.RollMod.DodgeHook", function( ent, dmginfo )
	if IsValid(ent) then
		if !ent:IsPlayer() or !ent:Alive() --[[or !ent:wOSIsRolling()]] then return end
		if not ent.iFrames then return end

		local dmgtype = dmginfo:GetDamageType()
		
		for k, v in pairs(wOS.RollMod.Dodgeables) do
			if dmginfo:IsDamageType(k) then
				dmgtype = k;
				break;
			end
		end

		if wOS.RollMod.Dodgeables[dmgtype] then
			ent:EmitSound("meleesounds/comboattack3.wav.mp3", 75, math.random( 90, 110 ));
			netstream.Start(ent, "Parried", 0.2);
			dmginfo:ScaleDamage(0)
			--hook.Call( "wOS.RollMod.DodgedDamage", nil, ent, hitgroup, dmginfo )
			return true
		end
	end
end);

hook.Add( "PlayerSpawn", "wOS.RollMod.Reset", function( ply )

	ply:SetNW2Float( "wOS.RollTime", 0 )
	ply:SetNW2Int( "wOS.RollDir", 0 )
	ply.wOS = {}
	ply.wOS.LastRoll = 0
	ply.wOS.LastKey = 0
	ply.wOS.Landed = true
	
end )

local meta = FindMetaTable( "Player" )

function meta:OnLadder()
	return self:GetMoveType() == MOVETYPE_LADDER
end

function meta:CanRoll()
	--if self:KeyDown( IN_WALK ) then return false end
	
	if self.lastRoll and self.lastRoll > CurTime() then
		return false;
	end	

	if self:GetNWBool("bliz_frozen") then
		return false;
	end
	
	if self:GetMoveType() ~= MOVETYPE_WALK then
		return false;
	end
	
	if Clockwork then
		if (self:GetNetVar("tied", 0) ~= 0) then
			return false;
		end
	
		if self.HasBelief and !self:HasBelief("evasion") then
			return false;
		end
		
		if Clockwork.player:GetAction(self) then
			return false;
		end
		
		if cwMedicalSystem then
			local injuries = cwMedicalSystem:GetInjuries(self);
			
			if injuries then
				for k, v in pairs(injuries) do
					if v["broken_bone"] then
						return false;
					end
				end
			end
		end
		
		if cwLimbs then
			local leftLeg = Clockwork.limb:GetHealth(self, HITGROUP_LEFTLEG, false)
			local rightLeg = Clockwork.limb:GetHealth(self, HITGROUP_RIGHTLEG, false)
			local legDamage = math.min(leftLeg, rightLeg)

			if legDamage <= 25 then
				return false;
			end
		end
		
		if self.GetCharacterData then
			local lastZone = self:GetCharacterData("LastZone");
			
			if lastZone == "tower" then
				if Schema and Schema.towerSafeZoneEnabled then
					return false;
				end
			end
		end
	end
	
	local hookcheck = hook.Call( "wOS.RollMod.ShouldRoll", nil, self )
	if hookcheck then return hookcheck end
	
	return ( !self:wOSIsRolling() and self:OnGround() and !self:OnLadder() )
end

function meta:StartRolling(a)
	if not self:CanRoll() and !a then return end
	hook.Call( "wOS.RollMod.OnRoll", nil, self )
	
	local roll_sound = hook.Run("GetRollSound", self);
	local time = hook.Run("GetRollTime", self) or 0.9;
	local weaponRaised = self:IsWeaponRaised();
	
	if (Clockwork and Clockwork.player and Clockwork.player.HasFlags and Clockwork.player:HasFlags(self, "4")) then
		time = 0.9
	end;
	
	if Clockwork then
		if self.GetCharacterData then
			local stamina = self:GetCharacterData("Stamina");
			local stamina_loss = 20;
			
			if time == 1 then
				stamina_loss = 25;
			elseif time == 1.1 then
				stamina_loss = 35;
			end

			if self.GetCharmEquipped and self:GetCharmEquipped("boot_contortionist") then
				stamina_loss = stamina_loss * 0.5;
			end
			
			if stamina < stamina_loss then
				return false;
			end
			
			if self.SetCharacterData then
				self:SetCharacterData("Stamina", math.Clamp(self:GetCharacterData("Stamina") - stamina_loss, 0, cwStamina:GetMaxStaminaPlugin(self)));
				self:SetNWInt("Stamina", self:GetCharacterData("Stamina"));
			end
		end
	end
	
	self:Extinguish(); -- If on fire, put it out!
	
	self:SetNW2Float("wOS.RollSpeed", time);
	
	time = 0.9;
	
	if self:KeyDown( IN_BACK ) then
		--if Clockwork and self:GetFaction() == "Children of Satan" then
			self:SetNW2Int("wOS.RollDir", 7);
		--else
			--self:SetNW2Int("wOS.RollDir", 3);
		--end
		
		self:SetLocalVelocity( self:GetForward() * -800 )
		self:ViewPunch( Angle( -5, 0, 0 ) )
		self:SetNW2Float( "wOS.RollTime", CurTime() + time )	
	elseif self:KeyDown( IN_MOVELEFT ) then
		--if Clockwork and self:GetFaction() == "Children of Satan" then
			self:SetNW2Int("wOS.RollDir", 8);
		--else
			--self:SetNW2Int("wOS.RollDir", 4);
		--end
		
		self:SetLocalVelocity( self:GetRight() * -800  )
		self:ViewPunch( Angle( 0, 0, -10 ) )
		self:SetNW2Float( "wOS.RollTime", CurTime() + time )	
	elseif self:KeyDown( IN_MOVERIGHT ) then
		--if Clockwork and self:GetFaction() == "Children of Satan" then
			self:SetNW2Int("wOS.RollDir", 9);
		--else
			--self:SetNW2Int("wOS.RollDir", 5);
		--end
		
		self:SetLocalVelocity( self:GetRight() * 800 )
		self:ViewPunch( Angle( 0, 0, 10 ) )
		self:SetNW2Float( "wOS.RollTime", CurTime() + time )	
	else
		--if Clockwork and self:GetFaction() == "Children of Satan" then
			self:SetNW2Int("wOS.RollDir", 6);
		--else
			--self:SetNW2Int("wOS.RollDir", 2);
		--end
		
		self:SetLocalVelocity( self:GetForward() * 800 )
		self:ViewPunch( Angle( 5, 0, 0 ) )
		self:SetNW2Float( "wOS.RollTime", CurTime() + time )	
	end
	
	wOS.RollMod:ResetAnimation(self);
	
	local activeWeapon = self:GetActiveWeapon();
	
	if IsValid(activeWeapon) and activeWeapon.IsABegottenMelee then
		activeWeapon.isAttacking = false;
		
		if activeWeapon.AttackSoundTable and activeWeapon.Weapon then
			local attacksoundtable = GetSoundTable(activeWeapon.AttackSoundTable)
			
			if activeWeapon.WindUpSound then
				activeWeapon.Weapon:StopSound(activeWeapon.WindUpSound);
			end
			
			if attacksoundtable and attacksoundtable["primarysound"] then	
				for i = 1, #attacksoundtable["primarysound"] do
					activeWeapon.Weapon:StopSound("meleesounds/DS2HammerLightSwing.mp3");
				end
			end
		end
		
		activeWeapon:StopAllAnims();
		
		if activeWeapon:GetClass() == "begotten_fists" then
			self:GetViewModel():SetSequence("fists_draw");
		else
			self:GetViewModel():SetSequence(0);
		end
		
		self:SetWeaponRaised(false);
	end
	
	if !roll_sound then
		self:EmitSound("wos/roll/dive.wav")
		
		timer.Simple(time * 0.63, function()
			if not IsValid( self ) then return end
			if not self:Alive() then return end
			if not self:wOSIsRolling() then return end
			if not self:OnGround() then self.wOS.Landed = false return end
			self:EmitSound("wos/roll/land.wav");
		end);
	else
		timer.Simple(time * 0.15, function()
			if not IsValid( self ) then return end
			if not self:Alive() then return end
			if not self:wOSIsRolling() then return end
			if not self:OnGround() then self.wOS.Landed = false return end
			self:EmitSound(roll_sound);
		end);
	end
	
	if !self.wOS then
		self.wOS = {}
		self.wOS.LastKey = 0
		self.wOS.Landed = true
	end
	
	self.wOS.LastRoll = 0
	
	self.lastRoll = CurTime() + 1; -- Delay before next roll
	self.nextDeflect = CurTime() + 1.5;
	
	--timer.Create("iFramesStartTimer_"..self:EntIndex(), time * 0.15, 1, function()
		--if not IsValid( self ) then return end
		
		self.iFrames = true;
	--end);
	
	self.blockStaminaRegen = math.max(self.blockStaminaRegen or 0, CurTime() + 1.5);

	--[[timer.Create("iFramesEndTimer_"..self:EntIndex(), 1.5 - time, 1, function()
		if not IsValid( self ) then return end
		
		self.iFrames = false;
	end);]]--

	timer.Create("RollRaiseTimer_"..self:EntIndex(), time * 0.8, 1, function()
		if not IsValid( self ) then return end
		
		timer.Simple(0.25, function()
			if IsValid(self) then
				if !self:wOSIsRolling() then
					self.iFrames = false;
				end
			end
		end);
		
		if not self:Alive() then return end
		
		local curTime = CurTime();

		if weaponRaised then
			self:SetWeaponRaised(true);
			
			if IsValid(self:GetActiveWeapon()) then
				--self:GetActiveWeapon():SetNextSecondaryFire(curTime + 1);
				
				--timer.Simple(1.05, function()
					if IsValid(self) and IsValid(self:GetActiveWeapon()) then
						if self:KeyDown(IN_ATTACK2) and !self:KeyDown(IN_USE) then
							local activeWeapon = self:GetActiveWeapon();

							if activeWeapon.Base == "sword_swepbase" then
								if (activeWeapon.realIronSights == true) then
									local loweredParryDebug = activeWeapon:GetNextSecondaryFire();
									local curTime = CurTime();
									
									if (loweredParryDebug < curTime) then
										local blockTable = GetTable(activeWeapon.BlockTable);
										
										--if (blockTable and self:GetNWInt("meleeStamina", 100) >= blockTable["guardblockamount"] and !self:GetNWBool("Parried")) then
										if (blockTable and self:GetNWInt("Stamina", 100) >= blockTable["guardblockamount"] and !self:GetNWBool("Parried")) then
											self:SetNWBool("Guardening", true);
											self.beginBlockTransition = true;
											activeWeapon.Primary.Cone = activeWeapon.IronCone;
											activeWeapon.Primary.Recoil = activeWeapon.Primary.IronRecoil;
										else
											self:CancelGuardening()
										end;
									end;
								else
									self:CancelGuardening();
								end;
							end
						end
					end
				--end);
			end
		end
	end);
end

hook.Add( "KeyPress", "wOS.RollMod.CheckDoubleTap", function( ply, key )
	if ( !IsValid( ply) or !ply:Alive() ) then return end
	
	if IsValid(ply.victim) then
		ply = ply.victim;
	elseif ply.possessor then
		return;
	end
	
	if Clockwork then
		if ply:GetInfoNum("cwDoubleTapRolling", 1) == 0 then return end
	end
	
	if ply:InVehicle() then return end
	if ( key != IN_BACK and key != IN_FORWARD and key != IN_MOVELEFT and key != IN_MOVERIGHT ) then return end
	if ply:wOSIsRolling() then return end
	if !ply:OnGround() then return end
	
	if ply.wOS.LastRoll + wOS.RollMod.Sensitivity > CurTime() and ply.wOS.LastKey == key then
		ply:StartRolling()
	else
		ply.wOS.LastRoll = CurTime() 
		ply.wOS.LastKey = key
	end
end )
