--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

local ITEM = Clockwork.item:New()
	ITEM.name = "Cinderblock with Rope"
	ITEM.model = "models/props_junk/CinderBlock01a.mdl"
	ITEM.description = "A concrete cinderblock with a length of rope tied around it."
	ITEM.weight = 20
	ITEM.uniqueID = "cinder_block"
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local trace = player:GetEyeTrace()
		
		if (IsValid(trace.Entity) and (trace.Entity:GetClass() == "prop_ragdoll" or trace.Entity:IsPlayer())) then
			return Schema:CinderBlockExecution(player, trace.Entity, self)
		else
			Schema:EasyText(player, "peru", "You must look at somebody to tie this!")
			return false
		end
	end
	
	function ITEM:CanPickup(player, bQuickUse, entity)
		if (player:HasItemByID("cinder_block")) then
			Schema:EasyText(player, "peru", "You cannot carry more than one cinder block at a time!")
			return false
		end
	end
ITEM:Register()