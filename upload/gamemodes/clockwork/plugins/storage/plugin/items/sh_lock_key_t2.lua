local ITEM = Clockwork.item:New();
	ITEM.name = "Lock";
	ITEM.model = "models/props_wasteland/prison_padlock001a.mdl";
	ITEM.weight = 0.2;
	ITEM.category = "Locks";
	ITEM.description = "A generic looking key lock.";
	ITEM.lockType = "key";
	ITEM.lockTier = 2;

	if (CLIENT) then
		-- A function to get the item's markup text.
		function ITEM:GetClientSideInfo()
			if (self:IsInstance()) then
				local color = Color(255, 200, 200);
				local text = "This lock can withstand a little damage, but is still weak.";

				if (text != "") then
					return Clockwork.kernel:AddMarkupLine(
						"", "<color="..color..">"..text.."</color>"
					);
				end;
			end;
		end;
	end;
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local trace = player:GetEyeTraceNoCursor();
		local entity = trace.Entity;
		
		if (IsValid(entity)) then
			cwStorage:ApplyLock(player, self, entity);
		end;
		
		return false;
	end;
ITEM:Register();