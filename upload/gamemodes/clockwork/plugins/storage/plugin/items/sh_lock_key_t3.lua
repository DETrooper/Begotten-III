local ITEM = Clockwork.item:New();
	ITEM.name = "Strong Lock";
	ITEM.model = "models/props_wasteland/prison_padlock001a.mdl";
	ITEM.weight = 0.25;
	ITEM.category = "Locks";
	ITEM.description = "A generic looking key lock.";
	ITEM.lockType = "key";
	ITEM.lockTier = 3;

	if (CLIENT) then
		-- A function to get the item's markup text.
		function ITEM:GetClientSideInfo()
			if (self:IsInstance()) then
				local color = Color(230, 230, 255);
				local text = "This lock is strong and can take a beating.";

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