--[[
	Created by cash wednesday.
--]]

local ITEM = Clockwork.item:New();
	ITEM.name = "Key";
	ITEM.model = "models/props_c17/TrapPropeller_Lever.mdl";
	ITEM.weight = 0.05;
	ITEM.category = "Keys";
	ITEM.description = "A dirty, unmarked key.";
	ITEM.uniqueID = "key";
	ITEM.bNoStacking = true;
	
	ITEM:AddData("KeyID", "", true);
	ITEM:AddData("KeyName", "", true);
	ITEM:AddData("bIsCopy", false, true);
	
	if (SERVER) then
		-- Called when the item is instantiated.
		function ITEM:OnInstantiated()
			if (self:GetData("KeyID") == "" or self:GetData("KeyName") == "") then
				self:SetData("KeyID", self.itemID);
				self:SetData("KeyName", string.utf8sub(self.itemID, string.utf8len(self.itemID) - 1, string.utf8len(self.itemID)));
			end;
		end;
	else
		-- A function to get the item's markup text.
		function ITEM:GetClientSideInfo()
			if (self:IsInstance()) then
				local infoColor = Clockwork.option:GetColor("target_id");
				local color = infoColor.r..","..infoColor.g..","..infoColor.b;
				local keyName = self:GetData("KeyName");
				local text = "Written on the key is: "..keyName;
				local afterText = "";
				
				if (self:GetData("bIsCopy") == true) then
					afterText = "\nThis key is a copy."
				end;
				
				if (text != "") then
					return Clockwork.kernel:AddMarkupLine(
						"", "<color="..color..">"..text.."</color><color=175,100,100>"..afterText.."</color>"
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
			cwStorage:TryKey(player, self, entity);
		end;
		
		return false;
	end;
ITEM:Register();