local ITEM = Clockwork.item:New();
	ITEM.name = "Handheld Radio";
	ITEM.model = "models/damnation/radio.mdl";
	ITEM.weight = 1;
	ITEM.category = "Communication"
	ITEM.description = "An ancient piece of technology from a bygone era that allows communication over vast distances.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/handheld_radio.png"
	ITEM.customFunctions = {"Frequency", "Turn On", "Turn Off"};
	ITEM.itemSpawnerInfo = {category = "Communication", rarity = 300};
	
	ITEM.components = {breakdownType = "breakdown", items = {"tech", "tech"}};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	if (SERVER) then
		function ITEM:OnCustomFunction(player, name)
			if (name == "Frequency") then
				Clockwork.datastream:Start(player, "Frequency", player:GetCharacterData("frequency", ""));
			elseif (name == "Turn On") then
				Clockwork.datastream:Start(player, "SetRadioState", player:GetCharacterData("radioState", false));
			elseif (name == "Turn Off") then
				Clockwork.datastream:Start(player, "SetRadioState", player:GetCharacterData("radioState", false));
			end;
		end;
	end;
ITEM:Register();