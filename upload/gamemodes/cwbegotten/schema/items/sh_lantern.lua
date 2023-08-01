--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Lantern";
	ITEM.model = "models/weapons/w_lantern.mdl";
	ITEM.weight = 0.5;
	ITEM.category = "Lights";
	ITEM.uniqueID = "cw_lantern";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/lantern.png";
	ITEM.description = "An old, dim oil lantern...";
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(337.13, 76.57, 355.26);
	ITEM.attachmentOffsetVector = Vector(-4.95, 3.54, 12.73);
	ITEM.lantern = true;
	--ITEM.customFunctions = {"Wear On Hip"};
	--ITEM:AddData("IsWorn", false, true);

	--[[if (SERVER) then
		function ITEM:OnCustomFunction(player, name)
			if (name == "Wear On Hip") then
				if (self:GetData("IsWorn", false) == true) then
					return;
				end;
				
				self:SetData("IsWorn", true);
			end;
		end;
	end;--]]
	--[[
	function ITEM:OnHolster(player, bForced)
		self:SetData("IsWorn", false);
	end;--]]
ITEM:Register();