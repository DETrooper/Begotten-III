
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

local meta = FindMetaTable( "Player" )

function meta:wOSIsRolling()

	return ( self:GetRollTime() >= CurTime() )

end

function meta:GetRollTime()

	return ( self:GetNW2Float( "wOS.RollTime", 0 ) )

end

function meta:GetRollDir()

	return ( self:GetNW2Int( "wOS.RollDir", 1 ) )

end

function wOS.RollMod:ResetAnimation( ply )
	ply:AnimRestartMainSequence()
	
	if SERVER then
		net.Start( "wOS.RollMod.CallRestart" )
			net.WriteEntity( ply )
		net.Broadcast()
	end
end

--[[hook.Add( "ModifyPlayerPlaybackRate", "wOS.RollMod.SlowDownAnim", function(ply)
	if ply:wOSIsRolling() then
		local roll_speed = math.Round(ply:GetNW2Float("wOS.RollSpeed", 0.9), 2);
		
		if roll_speed == 0.9 then
			ply.cwPlaybackRate = 1;
		elseif roll_speed == 1.1 then
			ply.cwPlaybackRate = 0.8;
		elseif roll_speed == 1.25 then
			ply.cwPlaybackRate = 0.6;
		end
		
		return true
	end
end )]]--

hook.Add( "ModifyCalcMainActivity", "wOS.RollMod.Animations", function( ply, velocity )
	if !IsValid( ply ) or !ply:wOSIsRolling() then return end

	local seq = wOS.RollMod.Animations[ ply:GetRollDir() ]
	local seqid = ply:LookupSequence( seq or "" )
	if seqid < 0 then return end

	return -1, seqid or nil

end )

local CMoveData = FindMetaTable("CMoveData")

function CMoveData:RemoveKeys(keys)
	-- Using bitwise operations to clear the key bits.
	local newbuttons = bit.band(self:GetButtons(), bit.bnot(keys))
	self:SetButtons(newbuttons)
end

hook.Add("SetupMove", "wOS.RollMod.NoJump", function(ply, mvd, cmd)
	if ply:wOSIsRolling() then
		if mvd:KeyDown(IN_JUMP) then
			mvd:RemoveKeys(IN_JUMP)
		end
	end
end)

hook.Add("Move", "wOS.RollMod.MoveDir", function( ply, mv ) 
	if not ply:wOSIsRolling() then
		if ply.rollAngles then
			ply.rollAngles = nil;
		end
		
		return;
	end
	
	if not ply.rollAngles then
		ply.rollAngles = mv:GetMoveAngles()
	end
	
	local vel = mv:GetVelocity()
	local roll_dir = ply:GetRollDir();
	local roll_speed = math.Round(ply:GetNW2Float("wOS.RollSpeed", 0.9), 2);
	
	--[[if roll_speed == 0.9 then
		roll_speed = 1;
	elseif roll_speed == 1.1 then
		roll_speed = 0.9
	elseif roll_speed == 1.25 then
		roll_speed = 0.75
	end]]--
	
	roll_speed = 1;
	
	if (Clockwork and Clockwork.player and Clockwork.player.HasFlags and Clockwork.player:HasFlags(ply, "4")) then
		roll_speed = 2.5
	end;
	
	if roll_dir == 2 or roll_dir == 6 then
		vel = ply.rollAngles:Forward() * (roll_speed * 150)
	elseif roll_dir == 3 or roll_dir == 7 then
		vel = ply.rollAngles:Forward() * -(roll_speed * 150)
	elseif roll_dir == 4 or roll_dir == 8 then
		vel = ply.rollAngles:Right() * -(roll_speed * 150)
	elseif roll_dir == 5 or roll_dir == 9 then
		vel = ply.rollAngles:Right() * (roll_speed * 150)
	end
	
	mv:SetVelocity(Vector(vel.x, vel.y, math.min(vel.z, 30)));
end);