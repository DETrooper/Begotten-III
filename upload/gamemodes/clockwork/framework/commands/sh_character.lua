local COMMAND = Clockwork.command:New("CharForceFallover")
	COMMAND.tip = "Force a character to fallover."
	COMMAND.text = "<string Name> [number Seconds]"
	COMMAND.access = "a"
	COMMAND.arguments = 1
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"ForceFallover", "PlyForceFallover"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		if (target) then
			Clockwork.player:SetRagdollState(target, RAGDOLL_FALLENOVER, tonumber(arguments[2]) --[[or 5]]);
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("CharForceGetUp")
	COMMAND.tip = "Force a character to get up."
	COMMAND.text = "<string Name>"
	COMMAND.access = "a"
	COMMAND.arguments = 1
	COMMAND.alias = {"ForceGetUp", "PlyForceGetUp"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			Clockwork.player:SetRagdollState(target, RAGDOLL_NONE);
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("CharSetHealth");
	COMMAND.tip = "Set a character's health, with an optional argument for making it their new maximum health.";
	COMMAND.text = "<string Name> <int Amount> [bool SetMax]";
	COMMAND.access = "o";
	COMMAND.arguments = 2;
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"SetHealth", "PlySetHealth"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		local amount = tonumber(arguments[2]) or 100;
		
		if (target) then
			target:SetHealth(amount);
			
			if arguments[3] and tobool(arguments[3]) == true then
				target.maxHealthSet = true;
				target:SetMaxHealth(amount);
			end
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharSetMaxHealth");
	COMMAND.tip = "Set a character's maximum health.";
	COMMAND.text = "<string Name> <int Amount>";
	COMMAND.access = "o";
	COMMAND.arguments = 2;
	COMMAND.alias = {"SetMaxHealth", "PlySetMaxHealth"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		local amount = tonumber(arguments[2]) or 100;
		
		if (target) then
			target:SetMaxHealth(amount);
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("SetHealthMaxAll");
	COMMAND.tip = "Set all characters on the map to max health.";
	COMMAND.text = "[bool AffectDuelists]";
	COMMAND.access = "a";
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"CharSetHealthMaxAll", "PlySetHealthMaxAll"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local affect_duelists = false;
		
		if arguments and arguments[1] and tobool(arguments[1]) == true then
			affect_duelists = true;
		end
		
		for k, v in pairs (_player.GetAll()) do
			if v:HasInitialized() and v:Alive() then
				if !v.opponent or (v.opponent and affect_duelists) then
					v:SetHealth(v:GetMaxHealth() or 100);
				end
			end
		end
		
		Clockwork.player:NotifyAdmins("operator", player:Name().." has set everyone's health to max.", nil);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharSetArmor");
	COMMAND.tip = "Set a characters armor.";
	COMMAND.text = "<string Name> <int Amount>";
	COMMAND.access = "o";
	COMMAND.arguments = 2;
	COMMAND.alias = {"PlySetArmor"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		local amount = arguments[2] or 100;
		
		if (target) then
			target:SetArmor(amount);
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharGetTraits");
	COMMAND.tip = "Display a list of a character's traits.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.alias = {"GetTraits", "PlyGetTraits"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target and target:HasInitialized()) then
			local traits = target:GetCharacterData("Traits");
			
			if traits then
				Clockwork.player:Notify(player, target:Name().." has the following traits: "..table.concat(traits, " "));
			end
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharGiveTrait");
	COMMAND.tip = "Give a character a trait.";
	COMMAND.text = "<string Name> <string TraitID>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;
	COMMAND.alias = {"GiveTrait", "PlyGiveTrait"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		local traitID = string.lower(arguments[2]);
		
		if (target and target:HasInitialized()) then
			if Clockwork.trait:FindByID(traitID) then
				target:GiveTrait(traitID);
				Clockwork.player:NotifyAdmins("operator", target:Name().." has been given the '"..traitID.."' trait by "..player:Name().."!", nil);
			else
				Clockwork.player:Notify(player, traitID.." is not a valid trait!");
			end
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharTakeTrait");
	COMMAND.tip = "Remove a trait from a character.";
	COMMAND.text = "<string Name> <string TraitID>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;
	COMMAND.alias = {"TakeTrait", "PlyTakeTrait", "CharRemoveTrait", "RemoveTrait", "PlyRemoveTrait"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		local traitID = string.lower(arguments[2]);
		
		if (target and target:HasInitialized()) then
			if Clockwork.trait:FindByID(traitID) then
				target:RemoveTrait(traitID);
				Clockwork.player:NotifyAdmins("operator", player:Name().." has taken the '"..traitID.."' trait from "..target:Name().."!", nil);
			else
				Clockwork.player:Notify(player, traitID.." is not a valid trait!");
			end
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyGod");
	COMMAND.tip = "Toggle godmode for a player.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.alias = {"CharGod", "God"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);

		if (target) then
			if (target:HasGodMode()) then
				target:GodDisable();
				Clockwork.player:NotifyAdmins("operator", target:Name().." has been ungodded by "..player:Name().."!", nil);
			else
				target:GodEnable();
				Clockwork.player:NotifyAdmins("operator", target:Name().." has been godded by "..player:Name().."!", nil);
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyGodAll");
	COMMAND.tip = "Enable godmode for all players.";
	COMMAND.access = "s";
	COMMAND.alias = {"CharGodAll", "GodAll"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for k, v in pairs (_player.GetAll()) do
			v:GodEnable();
		end;
		
		Clockwork.player:NotifyAdmins("operator", player:Name().." has enabled god mode for all players.", nil);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyUnGodAll");
	COMMAND.tip = "Disable godmode for all players.";
	COMMAND.access = "s";
	COMMAND.alias = {"CharUnGodAll", "UnGodAll"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for k, v in pairs (_player.GetAll()) do
			v:GodDisable();
		end;
		
		Clockwork.player:NotifyAdmins("operator", player:Name().." has disabled god mode for all players.", nil);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharTransferFaction");
	COMMAND.tip = "Transfer a character to a faction. This will clear their subfaction so be sure to set a new one!";
	COMMAND.text = "<string Name> <string Faction> [string Data]";
	COMMAND.access = "o";
	COMMAND.arguments = 2;
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"TransferFaction", "PlyTransferFaction", "SetFaction", "CharSetFaction", "PlySetFaction"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local faction = arguments[2];
			local name = target:Name();
			
			if (!Clockwork.faction:GetStored()[faction]) then
				Clockwork.player:Notify(player, faction.." is not a valid faction!");
				return;
			end;
			
			--if (!Clockwork.faction:GetStored()[faction].whitelist or Clockwork.player:IsWhitelisted(target, faction)) then
				local targetFaction = target:GetFaction();
				
				if (targetFaction == faction) then
					Clockwork.player:Notify(player, target:Name().." is already the "..faction.." faction!");
					return;
				end;
				
				if (!Clockwork.faction:IsGenderValid(faction, target:GetGender())) then
					Clockwork.player:Notify(player, target:Name().." is not the correct gender for the "..faction.." faction!");
					return;
				end;
				
				if (!Clockwork.faction:GetStored()[faction].OnTransferred) then
					Clockwork.player:Notify(player, target:Name().." cannot be transferred to the "..faction.." faction!");
					return;
				end;
				
				local bSuccess, fault = Clockwork.faction:GetStored()[faction]:OnTransferred(target, Clockwork.faction:GetStored()[targetFaction], arguments[3]);
				
				if (bSuccess != false) then
					target:SetCharacterData("Faction", faction, true);
					target:SetCharacterData("Subfaction", "", true);
					target:SetCharacterData("rank", nil);
					target:SetCharacterData("rankOverride", nil);
					
					Clockwork.player:LoadCharacter(target, Clockwork.player:GetCharacterID(target));
					Clockwork.player:NotifyAll(player:Name().." has transferred "..name.." to the "..faction.." faction.");
				else
					Clockwork.player:Notify(player, fault or target:Name().." could not be transferred to the "..faction.." faction!");
				end;
			--[[else
				Clockwork.player:Notify(player, target:Name().." is not on the "..faction.." whitelist!");
			end;]]--
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharTransferSubfaction");
	COMMAND.tip = "Transfer a character to a subfaction.";
	COMMAND.text = "<string Name> <string Subfaction>";
	COMMAND.access = "o";
	COMMAND.arguments = 2;
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"TransferSubfaction", "PlyTransferSubfaction", "SetSubfaction", "CharSetSubfaction", "PlySetSubfaction"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local subfaction = arguments[2];
			local faction = target:GetFaction();
			local factionSubfactions = Clockwork.faction:GetStored()[faction].subfactions;
			local name = target:Name();
			
			if (factionSubfactions) then
				for i, v in ipairs(factionSubfactions) do
					if v.name == subfaction then
						subfaction = v;
						
						break;
					end
				end
				
				if istable(subfaction) then
					target:SetCharacterData("Subfaction", subfaction.name, true);
					
					Clockwork.player:LoadCharacter(target, Clockwork.player:GetCharacterID(target));
					Clockwork.player:NotifyAll(player:Name().." has transferred "..name.." to the "..subfaction.name.." subfaction.");
				else
					Clockwork.player:Notify(player, subfaction.." is not a valid subfaction for this faction!");
				end
			else
				Clockwork.player:Notify(player, target:Name().."'s faction does not have any subfactions!");
			end
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharTakeFlags");
	COMMAND.tip = "Take flags from a character.";
	COMMAND.text = "<string Name> <string Flag(s)>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			if (string.find(arguments[2], "a") or string.find(arguments[2], "s") or string.find(arguments[2], "o")) then
				Clockwork.player:Notify(player, "You cannot take 'o', 'a' or 's' flags!");
				return;
			end;
			
			Clockwork.player:TakeFlags(target, arguments[2]);
			Clockwork.player:NotifyAll(player:Name().." took '"..arguments[2].."' character flags from "..target:Name()..".");
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyTakeFlags");
	COMMAND.tip = "Take flags from a player.";
	COMMAND.text = "<string Name> <string Flag(s)>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			if (string.find(arguments[2], "a") or string.find(arguments[2], "s") or string.find(arguments[2], "o")) then
				Clockwork.player:Notify(player, "You cannot take 'o', 'a' or 's' flags!");
				return;
			end;

			Clockwork.player:TakePlayerFlags(target, arguments[2]);
			Clockwork.player:NotifyAll(player:Name().." took '"..arguments[2].."' player flags from "..target:Name()..".");
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharTakeColor");
	COMMAND.tip = "Take a player's custom color.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "a";
	COMMAND.arguments = 1;
	COMMAND.alias = {"PlyTakeColor"}

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			Clockwork.kernel:SetPlayerColor(target, nil);
			Clockwork.player:Notify(player, "You have taken "..target:Name().."'s color.");
		else
			Clockwork.player:Notify(player, "'"..arguments[1].."' is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharSetName");
	COMMAND.tip = "Set a character's name permanently.";
	COMMAND.text = "<string Name> <string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local name = table.concat(arguments, " ", 2);
			
			Clockwork.player:NotifyAll(player:Name().." set "..target:Name().."'s name to "..name..".");
			Clockwork.player:SetName(target, name);
			target:SaveCharacter();
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharSetModel");
	COMMAND.tip = "Set a character's model permanently.";
	COMMAND.text = "<string Name> <string Model>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local model = table.concat(arguments, " ", 2);
			
			target:SetCharacterData("Model", model, true);
			target:SetModel(model);
			target:SaveCharacter();
			
			Clockwork.player:NotifyAll(player:Name().." set "..target:Name().."'s model to "..model..".");
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharForcePhysDesc");
	COMMAND.tip = "Set a character's description permanently.";
	COMMAND.text = "<string Name> <string Description>";
	COMMAND.access = "o";
	COMMAND.arguments = 2;
	COMMAND.alias = {"CharSetDesc", "ForcePhysDesc", "SetDesc"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		local minimumPhysDesc = config.Get("minimum_physdesc"):Get();
		local text = tostring(arguments[2]);
		
		if (string.len(text) < minimumPhysDesc) then
			Clockwork.player:Notify(player, "The physical description must be at least "..minimumPhysDesc.." characters long!");
			
			return;
		end;
		
		target:SetCharacterData("PhysDesc", Clockwork.kernel:ModifyPhysDesc(text));
		target:SaveCharacter();
	end;
COMMAND:Register();


local COMMAND = Clockwork.command:New("CharSetColor");
	COMMAND.tip = "Set a player's chat color. Use /ListColors to view all available colors.";
	COMMAND.text = "<string Name> <string Color>";
	COMMAND.access = "a";
	COMMAND.arguments = 2;
	COMMAND.alias = {"PlySetColor"}

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			local colorTable = colors;
			local color = arguments[2];
			
			if (color and colorTable and !table.IsEmpty(colorTable) and colorTable[color]) then
				Clockwork.kernel:SetPlayerColor(target, colorTable[color]);
				Clockwork.player:Notify(player, "You have set "..target:Name().."'s color to '"..color.."'.")
			else
				Clockwork.player:Notify(player, "'"..arguments[2].."' is not a valid color!");
			end;
		else
			Clockwork.player:Notify(player, "'"..arguments[1].."' is not a valid player!");
		end;
	end;
COMMAND:Register();

local NAME_CASH = Clockwork.option:GetKey("name_cash");
local COMMAND = Clockwork.command:New("CharSetCoin");
	COMMAND.tip = "Set a character's coin.";
	COMMAND.text = "<string Name> <number Coin>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";
	COMMAND.arguments = 2;
	COMMAND.alias = {"CharSetTokens", "CharSetCash", "SetCoin", "SetTokens", "SetCash"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		local cash = math.floor(tonumber((arguments[2] or 0)));
		
		if (target) then
			if (cash and cash > 0) then
				local playerName = player:Name();
				local targetName = target:Name();
				local giveCash = cash - target:GetCash();
				local cashName = string.gsub(NAME_CASH, "%s", "");
				
				Clockwork.player:GiveCash(target, giveCash);
				
				Clockwork.player:Notify(player, "You have set "..targetName.."'s "..cashName.." to "..Clockwork.kernel:FormatCash(cash, nil, true)..".");
				Clockwork.player:Notify(target, "Your "..cashName.." was set to "..Clockwork.kernel:FormatCash(cash, nil, true).." by "..playerName..".");
				
				target:SaveCharacter();
			else
				Clockwork.player:Notify(player, "This is not a valid amount!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharAddCoin");
	COMMAND.tip = "Add coin to a character. Use a negative value if you want to subtract.";
	COMMAND.text = "<string Name> <number Coin>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";
	COMMAND.arguments = 2;
	COMMAND.alias = {"CharAddTokens", "CharAddCash", "AddCoin", "AddTokens", "AddCash"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		local cash = math.floor(tonumber((arguments[2] or 0)));
		
		if (target) then
			if (cash and (cash > 0 or cash < 0)) then
				local playerName = player:Name();
				local targetName = target:Name();
				
				Clockwork.player:GiveCash(target, cash);
				
				if cash > 0 then
					Clockwork.player:Notify(player, "You have given "..targetName.." "..Clockwork.kernel:FormatCash(cash, nil, true)..".");
				else
					Clockwork.player:Notify(player, "You have taken "..Clockwork.kernel:FormatCash(-cash, nil, true).." from "..targetName..".");
				end
				
				target:SaveCharacter();
			else
				Clockwork.player:Notify(player, "This is not a valid amount!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharGiveItem");
	COMMAND.tip = "Give an item to a character.";
	COMMAND.text = "<string Name> <string Item>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;
	COMMAND.alias = {"GiveItem", "PlyGiveItem"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			local itemTable = item.FindByID(arguments[2]);

			if (itemTable) then
				local itemTable = item.CreateInstance(itemTable.uniqueID);
				local bSuccess, fault = target:GiveItem(itemTable, true);
				
				if (bSuccess) then
					if (string.sub(itemTable.name, -1) == "s") then
						Clockwork.player:Notify(player, "You have given "..target:Name().." some "..itemTable.name..".");
					else
						Clockwork.player:Notify(player, "You have given "..target:Name().." a "..itemTable.name..".");
					end;
					
					if (player != target) then
						if (string.sub(itemTable.name, -1) == "s") then
							Clockwork.player:Notify(target, player:Name().." has given you some "..itemTable.name..".");
						else
							Clockwork.player:Notify(target, player:Name().." has given you a "..itemTable.name..".");
						end;
					end;
				else
					Clockwork.player:Notify(player, target:Name().." does not have enough space for this item!");
				end;
			else
				Clockwork.player:Notify(player, "This is not a valid item!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharUseItem");
	COMMAND.tip = "Make a character use/equip an item.";
	COMMAND.text = "<string Name> <string Item> [int itemID]";
	COMMAND.access = "s";
	COMMAND.arguments = 2;
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"ForceEquip", "ForceUseItem", "PlyUseItem"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			local itemTable;
			local itemList = Clockwork.inventory:GetItemsAsList(target:GetInventory());

			for k, v in pairs (itemList) do
				if v.uniqueID == arguments[2] then
					if !arguments[3] or !tonumber(arguments[3]) or math.Truncate(tonumber(arguments[3])) == v.itemID then
						itemTable = v;
						break;
					end
				end
			end
			
			if (itemTable and !itemTable.isBaseItem) then
				local bSuccess, fault = Clockwork.item:Use(target, itemTable, true);
				
				if (bSuccess) then
					Clockwork.player:Notify(player, "You have made "..target:Name().." use a "..itemTable.name..".");
					
					--[[if (player != target) then
							Clockwork.player:Notify(target, player:Name().." has made you use/equip a "..itemTable.name..".");
					end;]]--
				else
					Clockwork.player:Notify(player, target:Name().." cannot use this item!");
				end;
			else
				Clockwork.player:Notify(player, "This is not a valid item or the player does not have it!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharUnequipItem");
	COMMAND.tip = "Make a character unequip an item.";
	COMMAND.text = "<string Name> <string Item>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"ForceUnequip", "ForceUnequipItem", "PlyUnequipItem"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			local itemTable;
			local itemList = Clockwork.inventory:GetItemsAsList(target:GetInventory());

			for k, v in pairs (itemList) do
				if v.uniqueID == arguments[2] then
					if !arguments[3] or !tonumber(arguments[3]) or math.Truncate(tonumber(arguments[3])) == v.itemID then
						itemTable = v;
						break;
					end
				end
			end
			
			if (itemTable and !itemTable.isBaseItem) then
				local bSuccess, fault = Clockwork.kernel:ForceUnequipItem(target, itemTable.uniqueID, itemTable.itemID);
				
				if (bSuccess) then
					Clockwork.player:Notify(player, "You have made "..target:Name().." unequip a "..itemTable.name..".");
					
					--[[if (player != target) then
							Clockwork.player:Notify(target, player:Name().." has made you unequip "..itemTable.name..".");
					end;]]--
				else
					Clockwork.player:Notify(player, target:Name().." cannot unequip this item!");
				end;
			else
				Clockwork.player:Notify(player, "This is not a valid item or the player does not have it!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharGiveFlags");
	COMMAND.tip = "Give flags to a character.";
	COMMAND.text = "<string Name> <string Flag(s)>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (istable(target)) then
			Clockwork.player:Notify(player, "Too many players with the identifier '"..arguments[1].."' were found. Re-enter the command with a specific player's name!");
			return;
		end;
		
		if (target) then
			if (string.find(arguments[2], "a") or string.find(arguments[2], "s") or string.find(arguments[2], "o")) then
				Clockwork.player:Notify(player, "You cannot give 'o', 'a' or 's' flags!");
				return;
			end;
			
			Clockwork.player:GiveFlags(target, arguments[2]);
			Clockwork.player:NotifyAll(player:Name().." gave "..target:Name().." '"..arguments[2].."' character flags.");
			target:SaveCharacter();
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();