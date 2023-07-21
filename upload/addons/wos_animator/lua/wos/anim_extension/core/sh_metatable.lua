--[[-------------------------------------------------------------------
	wiltOS Hold Type Meta Tables:
		Creating functions for your Hold Types since 2017
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
-------------------------------------------------------------------]]--[[
							  
	Lua Developer: King David
	Contact: http://steamcommunity.com/groups/wiltostech
		
----------------------------------------]]--

wOS = wOS or {}
wOS.AnimExtension.HoldTypeMeta = wOS.AnimExtension.HoldTypeMeta or {}

local HOLDTYPE = {}

HOLDTYPE.GetName = function( self ) 
	return self.Name or nil
end

HOLDTYPE.GetID = function( self )
	return self.HoldType or "wos-custom"
end

HOLDTYPE.GetActivityList = function( self )
	local index = wOS.AnimExtension.ActIndex[ self:GetBaseHoldType() ]
	return {
		[ACT_MP_STAND_IDLE] 				= index,
	    [ACT_MP_WALK] 						= index+1,
		[ACT_MP_RUN] 						= index+2,
		[ACT_MP_CROUCH_IDLE] 				= index+3,
		[ACT_MP_CROUCHWALK] 				= index+4,
		[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 	= index+5,
		[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = index+5,
		[ACT_MP_RELOAD_STAND]		 		= index+6,
		[ACT_MP_RELOAD_CROUCH]		 		= index+6,
		[ACT_MP_JUMP] 						= index+7,
		[ACT_RANGE_ATTACK1] 				= index+8,
		[ACT_MP_SWIM] 						= index+9,	
	}
end

HOLDTYPE.GetBaseHoldType = function( self )
	return self.BaseHoldType or "normal"
end

HOLDTYPE.SetBaseHoldType = function( self, newtype )
	self.BaseHoldType = newtype
end

//This is a god damn mess mostly because of legacy support, I need to redo this part for sure.
//OR at least make the old hold-types switch over to the new one
HOLDTYPE.GetActData = function( self, act ) 

	local base = self.Translations[ act ]
	local tbl
	
	if base then
		tbl = {}
		if istable( base ) then
			if base.Sequence then
				tbl.Sequence = base.Sequence
				tbl.Weight = base.Weight or 1
			else
				local key = math.Round( util.SharedRandom( "wOS.AnimExtension." .. self:GetName() .. "[" .. act .. "]", 1, #base ) )
				local innerbase = base[key]
				if istable( innerbase ) then
					tbl = innerbase
				elseif isstring( innerbase ) then
					tbl.Sequence = innerbase
					tbl.Weight = 1
				end
			end
		elseif isstring( base ) then
			tbl.Sequence = base
		end
	end

	return tbl
	
end

HOLDTYPE.__index = HOLDTYPE

function wOS.AnimExtension.HoldTypeMeta:CreateMetaType( tbl )
	setmetatable( tbl, HOLDTYPE )
end