local ITEM = Clockwork.item:New();
	ITEM.name = "Unbreakable Lock";
	ITEM.model = "models/props_wasteland/prison_padlock001a.mdl";
	ITEM.weight = 0.3;
	ITEM.category = "Locks";
	ITEM.description = "A generic looking key lock.";
	ITEM.lockType = "key";
	ITEM.lockTier = 4;

	if (CLIENT) then
		-- A function to get the item's markup text.
		function ITEM:GetClientSideInfo()
			if (self:IsInstance()) then
				local color = Color(200, 200, 255);
				local text = "This lock is very strong.";

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