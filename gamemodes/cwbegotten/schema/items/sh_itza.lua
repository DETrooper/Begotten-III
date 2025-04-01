--[[
local ITEM = Clockwork.item:New("armor_base")
	-- first some default shit
	ITEM.name = "Armor Example"
	ITEM.model = "models/error.mdl"
	ITEM.description = "An example armor item."
	ITEM.weight = 5 -- 5kg
	
	-- damage scaling, you could 
	ITEM.bluntScale = 1; -- if hit by a blunt attack, the wearer will receive default damage.
	ITEM.pierceScale = 0.75; -- blocks 75% of pierce damage dealt to the wearer 
	ITEM.slashScale = 2; -- multiplies the damage dealt to the wearer by 2
	-- this will be much easier to code the back end for and is more dynamic than setting the item as "SLASH RESISTANT" or something like that
	
	ITEM.armorClass = ARMORCLASS_HEAVY; -- custom enum for use in stability
	
	-- here's some stuff I've come up with
	ITEM.stabilityScale = 0.5 -- when the player's stability is set, it'll see if the player's armor item has this value set and if it does will multiply the amount of stability taken by it, in this case the player wearing this item will take 50% less stability damage from TakeStability
	ITEM.pocketSpace = 5 -- gives an extra 5kg to the player wearing the armor, if set as a negative value it will take space instead
	ITEM.runSpeed = 0.75 -- player runs 25% slower
	ITEM.walkSpeed = 0.75 -- player walks 25% slower
	ITEM.crouchSpeed = 0.75 -- player crouches 25% slower
	ITEM.jumpScale = 1.75 -- player jumps 75% higher
	
	ITEM.limbScales = {
		[HITGROUP_GENERIC] = 2, -- damage taken to hitgroup_generic
		[HITGROUP_HEAD] = 2,
		[HITGROUP_CHEST] = 2,
		[HITGROUP_STOMACH] = 2,
		[HITGROUP_LEFTARM] = 2,
		[HITGROUP_RIGHTARM] = 2,
		[HITGROUP_LEFTLEG] = 2,
		[HITGROUP_RIGHTLEG] = 2,
		[HITGROUP_GEAR] = 2,
	}
ITEM:Register()--]]

--[[
local ITEM = Clockwork.item:New()
	ITEM.name = "sex";
	ITEM.description = "sex";
	ITEM.model = "models/props_combine/breenglobe.mdl";
	ITEM.uniqueID = "sex";
	ITEM:AddData("sex", 100, true);

	--ITEM.decayRate = 128 -- Time in seconds to decay X% of condition. item will decay X% every 2 minutes while valid
	--ITEM.decayAmount = 2; -- 2% per decay tick
	--ITEM.defaultCondition = 20; -- Item will always start with 20% condition when instantiated.
	--ITEM.decayOnDamage = true; -- Item will decay when the entity is damaged.
	--ITEM.brokenItems = {["Glass Shards"] = 2} -- Gives 2 glass shards when broken.
	--ITEM.breakable = true; -- When the item condition reaches zero, the contents of "brokenItems" will be given to the player and the item will be taken.
	--ITEM.breakMessage = "Your #ITEM broke."; -- Message given to the player when the item breaks. #ITEM gsub for lowercase item name.
	ITEM.repairItem = "sewing_kit"; -- uniqueID of the item that may repair the item.
	ITEM.minRepairCondition = 20; -- Item condition must be 20% or under for the item to be repaired.
	ITEM.brokenModel = "models/error.mdl" -- Model after item reaches 0%
	
	-- ITEM:OnRepair(player)
	-- ITEM:CanRepair(player)
	-- ITEM:PostDecayTick(player)
	-- ITEM:AdjustDecayRate(player)
	-- ITEM:CanDecay(holder)
	-- ITEM:GetDefaultCondition()
	-- ITEM:Break()
	-- ITEM:CanBreak()
	-- ITEM:GetCondition()
	-- ITEM:GetRepairItem(uniqueID)
	
	function ITEM:OnUse(player)
		self:SetData("sex", math.Clamp(self:GetData("sex") - 10, 0, 100));
		printp(self:GetData("sex"));
		return false;
	end;
	
	if (CLIENT) then
		function ITEM:GetClientSideInfo()
			if (self:IsInstance()) then
				local text = tostring("Sex: "..self:GetData("sex"));
				if (text != "") then
					return Clockwork.kernel:AddMarkupLine(
						"", "<font=cwInfoTextFont>"..text.."</font>"
					);
				end;
			end;
		end;
	end;
ITEM:Register();
--]]