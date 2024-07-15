--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

game.AddParticles("particles/blood_impact.pcf");
PrecacheParticleSystem("blood_advisor_pierce_spray");
util.PrecacheSound("nhzombie_headexplode.wav")
util.PrecacheSound("nhzombie_headexplode_jet.wav")
util.PrecacheModel("models/begotten/heads/female_gorecap.mdl");
util.PrecacheModel("models/begotten/heads/male_gorecap.mdl");

PLUGIN:SetGlobalAlias("cwBeliefs");

Clockwork.kernel:IncludePrefixed("sh_beliefs.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_meta.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

cwBeliefs.sacramentLevelCap = cwBeliefs.sacramentLevelCap or 40;
cwBeliefs.sacramentCosts = {
	[2] = 10,
	[3] = 20,
	[4] = 30,
	[5] = 40,
	[6] = 50,
	[7] = 60,
	[8] = 70,
	[9] = 80,
	[10] = 90,
	[11] = 100,
	[12] = 120,
	[13] = 140,
	[14] = 160,
	[15] = 180,
	[16] = 200,
	[17] = 220,
	[18] = 240,
	[19] = 260,
	[20] = 280,
	[21] = 300,
	[22] = 320,
	[23] = 340,
	[24] = 360,
	[25] = 380,
	[26] = 400,
	[27] = 420,
	[28] = 440,
	[29] = 460,
	[30] = 480,
	[31] = 500,
	[32] = 520,
	[33] = 540,
	[34] = 560,
	[35] = 580,
	[36] = 600,
	[37] = 620,
	[38] = 640,
	[39] = 660,
	[40] = 666,
};

-- Called when Clockwork config has initialized.
function cwBeliefs:ClockworkConfigInitialized(key, value)
	if key == "max_sac_level" and isnumber(value) then
		self.sacramentLevelCap = math.floor(value);
	end
end

-- Called when Clockwork config has changed.
function cwBeliefs:ClockworkConfigChanged(key, data, previousValue, newValue)
	if key == "max_sac_level" and isnumber(newValue) then
		self.sacramentLevelCap = math.floor(newValue);
	end
end

local COMMAND = Clockwork.command:New("CharClearBeliefs");
COMMAND.tip = "Reset a player's beliefs.";
COMMAND.text = "<string Name>";
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.alias = {"ClearBeliefs", "PlyClearBeliefs", "ResetBeliefs"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		target:ResetBeliefs();
		
		if (player != target) then
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have reset "..target:Name().."'s beliefs.");
		else
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have reset your own beliefs.");
		end;
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

--[[local COMMAND = Clockwork.command:New("CharClearBeliefsAll");
COMMAND.tip = "Reset all players' beliefs.";
COMMAND.access = "s";
COMMAND.alias = {"ClearBeliefsAll", "PlyClearBeliefsAll", "ResetBeliefsAll"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	for k, v in pairs(_player.GetAll()) do
		if (v:HasInitialized()) then
			v:ResetBeliefs();
		end
	end

	Schema:EasyText(GetAdmins(), "lightslategrey", player:Name().." has cleared everyone's beliefs! If this was in error then god help us all.", nil);
end;

COMMAND:Register();]]--

local COMMAND = Clockwork.command:New("CharAddExperience");
COMMAND.tip = "Add faith (experience) to a player.";
COMMAND.text = "<string Name> <int Experience>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 2;
COMMAND.alias = {"CharAddXP", "AddXP", "AddExperience", "PlyAddXP", "PlyAddExperience"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local xp = arguments[2];
		
		if xp and tonumber(xp) then
			if (player != target) then
				Schema:EasyText(GetAdmins(), "cornflowerblue", "["..self.name.."] "..player:Name().." has given "..target:Name().." "..xp.." experience.");
			else
				Schema:EasyText(GetAdmins(), "cornflowerblue", "["..self.name.."] "..player:Name().." has given themself "..xp.." experience.");
			end;
			
			target:HandleXP(tonumber(xp), true);
		else
			Schema:EasyText(player, "grey", "["..self.name.."] You must specify a valid number!");
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("CharGiveBelief");
COMMAND.tip = "Give a player a belief.";
COMMAND.text = "<string Name> <string BeliefID>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 2;
COMMAND.alias = {"GiveBelief", "PlyGiveBelief"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local belief = arguments[2];
		
		if belief and cwBeliefs:FindBeliefByID(belief) then
			if (player != target) then
				Schema:EasyText(GetAdmins(), "cornflowerblue", "["..self.name.."] "..player:Name().." has given "..target:Name().." the '"..belief.."' belief.");
			else
				Schema:EasyText(GetAdmins(), "cornflowerblue", "["..self.name.."] "..player:Name().." has given themself the '"..belief.."' belief.");
			end;
			
			cwBeliefs:ForceTakeBelief(target, belief);
		else
			Schema:EasyText(player, "grey", "["..self.name.."] You must specify a valid belief!");
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("CharGetBeliefs");
	COMMAND.tip = "Display a list of a character's beliefs (use /CharOpenBeliefTree to view their belief tree).";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.alias = {"GetBeliefs", "PlyGetBeliefs"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target and target:HasInitialized()) then
			local beliefs = target:GetCharacterData("beliefs");
			
			if beliefs then
				local belief_strings = {};
			
				for k, v in pairs(beliefs) do
					table.insert(belief_strings, k);
				end
			
				Schema:EasyText(player, "cornflowerblue", "["..self.name.."] "..target:Name().." has the following beliefs: "..table.concat(belief_strings, " "));
			end
		else
			Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharTakeBelief");
COMMAND.tip = "Take a belief from a player. Optional argument to remove dependent beliefs. Levels are removed respectively.";
COMMAND.text = "<string Name> <string BeliefID> (bool RemoveDependencies)";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 2;
COMMAND.optionalArguments = 1
COMMAND.alias = {"TakeBelief", "PlyTakeBelief", "CharRemoveBelief", "RemoveBelief", "PlyRemoveBelief"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local belief = arguments[2];
		local bRemoveDependencies = arguments[3];
		
		if belief and cwBeliefs:FindBeliefByID(belief) then
			if bRemoveDependencies then
				if (player != target) then
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed from "..target:Name().." the '"..belief.."' belief and any dependencies.");
				else
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed from yourself the '"..belief.."' belief and any dependencies.");
				end;
			else
				if (player != target) then
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed from "..target:Name().." the '"..belief.."' belief.");
				else
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed from yourself the '"..belief.."' belief.");
				end;
			end
			
			cwBeliefs:ForceRemoveBelief(target, belief, bRemoveDependencies);
		else
			Schema:EasyText(player, "grey", "["..self.name.."] You must specify a valid belief!");
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("CharSetSacramentLevel");
COMMAND.tip = "Set a player's Sacrament Level.";
COMMAND.text = "<string Name> <int SacramentLevel>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 2;
COMMAND.alias = {"SetSacramentLevel", "PlySetSacramentLevel"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local level = arguments[2];
		
		if level then
			level = tonumber(level);
			
			if level > 0 then
				if (player != target) then
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] "..player:Name().." has set "..target:Name().."'s sacrament level to "..tostring(level)..".");
				else
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] "..player:Name().." has set their own sacrament level to "..tostring(level)..".");
				end;
			
				cwBeliefs:SetSacramentLevel(target, level);
			else
				Schema:EasyText(player, "grey", "["..self.name.."] You must specify a valid number above 0!");
			end
		else
			Schema:EasyText(player, "grey", "["..self.name.."] You must specify a valid number between 1 and 30!");
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

--[[local COMMAND = Clockwork.command:New("CharSetSacramentLevelAll");
COMMAND.tip = "Set all players' Sacrament Levels.";
COMMAND.text = "<int SacramentLevel>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.alias = {"SetSacramentLevelAll", "PlySetSacramentLevelAll"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local level = arguments[1];
	
	if level then
		level = tonumber(level);
		
		if level > 0 and level <= 30 then
			for k, v in pairs(_player.GetAll()) do
				if (v:HasInitialized()) then
					cwBeliefs:SetSacramentLevel(v, level);
				end
			end

			Schema:EasyText(GetAdmins(), "lightslategrey", player:Name().." has set everyone's sacrament level to "..level..".", nil);
		else
			Schema:EasyText(player, "grey", "["..self.name.."] You must specify a valid number between 1 and 30!");
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] You must specify a valid number between 1 and 30!");
	end
end;

COMMAND:Register();]]--

local COMMAND = Clockwork.command:New("CharOpenBeliefTree");
COMMAND.tip = "Open a player's belief tree.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.alias = {"OpenBeliefTree", "PlyOpenBeliefTree"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local curTime = CurTime()
		
		if (!player.NextOpenTree or player.NextOpenTree < curTime or args[1]) then
			player.NextOpenTree = curTime + 1
			
			local level = target:GetCharacterData("level", 1)
			local beliefs = target:GetCharacterData("beliefs", {})
			local experience = target:GetCharacterData("experience", 0)
			local points = target:GetCharacterData("points", 0)
			local faith = target:GetFaith() or "Faith of the Light"
			
			netstream.Start(player, "OpenLevelTreeOtherPlayer", {target, level, experience, beliefs, points, faith});
			
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] ".."You have opened "..target:Name().."'s belief tree!");
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("DarkWhisper");
COMMAND.tip = "Speak in tongues through the void to a target. If the target of this message is not of the Faith of the Dark or the Faith of the Sister then the message will be anonymous and will also drain your target's sanity, though it will result in a moderate amount of corruption for yourself.";
COMMAND.text = "<string Name> <string Message>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 2;
COMMAND.alias = {"DW"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		if player:GetFaith() == "Faith of the Dark" then
			if player:HasBelief("heretic") or player:HasBelief("soothsayer") then
				local curTime = CurTime();
				local message = "\""..table.concat(arguments, " ", 2).."\"";
				local targetFaith = target:GetFaith();
				
				if target:GetSharedVar("kinisgerOverride") == "Goreic Warrior" and target:GetSharedVar("kinisgerOverrideSubfaction") ~= "Clan Reaver" then
					targetFaith = "Faith of the Family";
				end

				if (targetFaith == "Faith of the Dark" or target:GetSubfaith() == "Faith of the Sister") then
					player:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_short"..math.random(1, 11)..".mp3", 80, 100)]]);
					target:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_short"..math.random(1, 11)..".mp3", 80, 100)]]);
					Clockwork.chatBox:Add(player, player, "darkwhisper", message);
					Clockwork.chatBox:Add(target, player, "darkwhisper", message);
				elseif !player.nextDarkWhisper or player.nextDarkWhisper <= curTime then
					player:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_short"..math.random(1, 11)..".mp3", 80, 100)]]);
					target:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_short"..math.random(1, 11)..".mp3", 80, 100)]]);
					Clockwork.chatBox:Add(player, nil, "darkwhispernondark", message);
					Clockwork.chatBox:Add(target, nil, "darkwhispernondark", message);
					player:HandleNeed("corruption", 10);
					target:HandleSanity(-5);
					target:Disorient(5);
					
					player.nextDarkWhisper = curTime + 15;
				else
					Schema:EasyText(player, "chocolate", "You must wait another "..-math.ceil(curTime - player.nextDarkWhisper).." seconds before darkwhispering this character again!");
				end;
				
				target.lastDarkWhisperer = player;
			else
				Schema:EasyText(player, "chocolate", "You must have the 'Heretic' belief before you can darkwhisper!");
			end
		else
			Schema:EasyText(player, "firebrick", "You are not the correct faith to do this!");
		end
	else
		Schema:EasyText(player, "grey",arguments[1].." is not a valid character!");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("DarkWhisperDirect");
COMMAND.tip = "Speak in tongues through the void to the character you are looking at. If the target of this message is not of the Faith of the Dark or the Faith of the Sister then the message will be anonymous and will also drain your target's sanity, though it will result in a moderate amount of corruption for yourself.";
COMMAND.text = "<string Message>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;
COMMAND.alias = {"DWD"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.entity:GetPlayer(player:GetEyeTraceNoCursor().Entity);
	
	if (target) then
		if player:GetFaith() == "Faith of the Dark" then
			if player:HasBelief("heretic") or player:HasBelief("soothsayer") then
				local curTime = CurTime();
				local message = "\""..table.concat(arguments, " ", 1).."\"";
				local targetFaith = target:GetFaith();
				
				if target:GetSharedVar("kinisgerOverride") == "Goreic Warrior" and target:GetSharedVar("kinisgerOverrideSubfaction") ~= "Clan Reaver" then
					targetFaith = "Faith of the Family";
				end

				if (targetFaith == "Faith of the Dark" or target:GetSubfaith() == "Faith of the Sister") then
					player:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_short"..math.random(1, 11)..".mp3", 80, 100)]]);
					target:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_short"..math.random(1, 11)..".mp3", 80, 100)]]);
					Clockwork.chatBox:Add(player, player, "darkwhisper", message);
					Clockwork.chatBox:Add(target, player, "darkwhisper", message);
				elseif !player.nextDarkWhisper or player.nextDarkWhisper <= curTime then
					player:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_short"..math.random(1, 11)..".mp3", 80, 100)]]);
					target:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_short"..math.random(1, 11)..".mp3", 80, 100)]]);
					Clockwork.chatBox:Add(player, nil, "darkwhispernondark", message);
					Clockwork.chatBox:Add(target, nil, "darkwhispernondark", message);
					player:HandleNeed("corruption", 10);
					target:HandleSanity(-5);
					target:Disorient(5);
					
					player.nextDarkWhisper = curTime + 15;
				else
					Schema:EasyText(player, "chocolate", "You must wait another "..-math.ceil(curTime - player.nextDarkWhisper).." seconds before darkwhispering this character again!");
				end;
				
				target.lastDarkWhisperer = player;
			else
				Schema:EasyText(player, "chocolate", "You must have the 'Heretic' belief before you can darkwhisper!");
			end
		else
			Schema:EasyText(player, "firebrick", "You are not the correct faith to do this!");
		end
	else
		Schema:EasyText(player, "firebrick", "You must look at a character!");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("DarkWhisperEvent");
COMMAND.tip = "Speak in tongues through the void to all players on the map.";
COMMAND.text = "<string Message>";
COMMAND.access = "s";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local message = "\""..table.concat(arguments, " ", 1).."\"";

	for k, v in pairs (_player.GetAll()) do
		if v:HasInitialized() and v:Alive() then
			Clockwork.chatBox:Add(v, nil, "darkwhisperevent", message);
			v:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_long"..math.random(1, 5)..".mp3", 80, 100)]]);
			
			if v:GetFaith() ~= "Faith of the Dark" and v:GetSubfaith() ~= "Faith of the Sister" then
				v:HandleSanity(-5);
				v:Disorient(5);
			end
		end
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("DarkWhisperFaction");
COMMAND.tip = "Speak in tongues through the void to your brethren.";
COMMAND.text = "<string Message>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;
COMMAND.alias = {"DWF"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local faction = player:GetFaction();
	local faith = player:GetFaith();
	
	if faith == "Faith of the Dark" then
		if faction == "Children of Satan" then
			if player:HasBelief("heretic") or player:HasBelief("soothsayer") then
				local message = "\""..table.concat(arguments, " ", 1).."\"";

				for k, v in pairs (_player.GetAll()) do
					if v:HasInitialized() and v:Alive() and ((v:GetFaction() == "Children of Satan") or Clockwork.player:HasFlags(v, "L")) then
						if v:GetSubfaction() == "Kinisger" and v:GetSharedVar("kinisgerOverride") then
							Clockwork.chatBox:Add(v, player, "darkwhisperglobalkinisger", message);
						else
							Clockwork.chatBox:Add(v, player, "darkwhisperglobal", message);
						end
							
						v:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_short"..math.random(1, 11)..".mp3", 80, 100)]]);
					end;
				end;
			else
				Schema:EasyText(player, "chocolate", "You must have the 'Heretic' belief before you can darkwhisper!");
			end
		elseif faction == "Goreic Warrior" then
			if player:HasBelief("heretic") then
				local message = "\""..table.concat(arguments, " ", 1).."\"";

				for k, v in pairs (_player.GetAll()) do
					if v:HasInitialized() and v:Alive() then
						local vFaction = v:GetSharedVar("kinisgerOverride") or v:GetFaction();
						
						if ((vFaction == "Goreic Warrior") and (v:GetFaith() == "Faith of the Dark" or v:GetSubfaith() == "Faith of the Sister")) or Clockwork.player:HasFlags(v, "L") then
							if v:GetSubfaction() == "Kinisger" then
								Clockwork.chatBox:Add(v, player, "darkwhisperglobalkinisger", message);
							else
								Clockwork.chatBox:Add(v, player, "darkwhisperglobal", message);
							end
							
							v:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_short"..math.random(1, 11)..".mp3", 80, 100)]]);
						end
					end;
				end;
			else
				Schema:EasyText(player, "chocolate", "You must have the 'Heretic' belief before you can darkwhisper!");
			end
		else
			Schema:EasyText(player, "firebrick", "You are not the correct faction to do this!");
		end
	else
		Schema:EasyText(player, "firebrick", "You are not the correct faith to do this!");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("DarkWhisperFactionKinisger");
COMMAND.tip = "Speak in tongues through the void to your pretend brethren.";
COMMAND.text = "<string Message>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;
COMMAND.alias = {"DWFK"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if player:GetSubfaction() == "Kinisger" then
		local faction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();
		
		if faction ~= "Wanderer" then
			if player:HasBelief("heretic") then
				local message = "\""..table.concat(arguments, " ", 1).."\"";

				for k, v in pairs (_player.GetAll()) do
					if v:HasInitialized() and v:Alive() then
						local vFaction = v:GetSharedVar("kinisgerOverride") or v:GetFaction();
						
						if (vFaction == faction) and (v:GetFaith() == "Faith of the Dark" or v:GetSubfaith() == "Faith of the Sister") then
							if v:GetSubfaction() == "Kinisger" and v:GetSharedVar("kinisgerOverride") then
								Clockwork.chatBox:Add(v, player, "darkwhisperglobalkinisger", message)
							else
								Clockwork.chatBox:Add(v, player, "darkwhisperglobal", message);
							end
							
							v:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_short"..math.random(1, 11)..".mp3", 80, 100)]]);
						end
					end;
				end;
			else
				Schema:EasyText(player, "chocolate", "You must have the 'Heretic' belief before you can darkwhisper!");
			end
		else
			Schema:EasyText(player, "firebrick", "You are not the correct faction to do this!");
		end
	else
		Schema:EasyText(player, "firebrick", "You are not the correct subfaction to do this!");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("DarkReply");
COMMAND.tip = "Using all your willpower, reply to a darkwhisper sent to you through the void. Note that this will incur a small amount of corruption if you are not of the Faith of the Dark.";
COMMAND.text = "<string Message>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if IsValid(player.lastDarkWhisperer) then
		local message = "\""..table.concat(arguments, " ", 1).."\"";

		Clockwork.chatBox:Add(player, player, "darkwhisperreply", message);
		Clockwork.chatBox:Add(player.lastDarkWhisperer, player, "darkwhisperreply", message);
		
		player:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_short"..math.random(1, 11)..".mp3", 80, 100)]]);
		player.lastDarkWhisperer:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_short"..math.random(1, 11)..".mp3", 80, 100)]]);
		
		if (player:GetFaith() ~= "Faith of the Dark" and player:GetSubfaith() ~= "Faith of the Sister") then
			player:HandleNeed("corruption", 5);
		end;
	else
		Schema:EasyText(player, "firebrick", "There is no darkwhisper to reply to!");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("Pray");
COMMAND.tip = "Make a prayer to the ones who rule you. Prepare for the consequences of doing so.";
COMMAND.text = "<string Message>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

local faithcolors = {
	["HARD-GLAZED"] = "goldenrod",
	["SOL ORTHODOXY"] = "darkgoldenrod",
	["VOLTISM"] = "steelblue",
	["MOTHER"] = "grey",
	["FATHER"] = "slategray",
	["OLD SON"] = "lightslategray",
	["PRIMEVALISM"] = "darkred",
	["SISTER"] = "lightsteelblue",
	["YOUNG SON"] = "darkgrey",
	["SATANISM"] = "crimson",
}

local ringcolors = {
	["LIGHT"] = "gold",
	["DARK"] = "firebrick",
	["FAMILY"] = "grey",
}

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local faith = player:GetFaith();
	
	if faith then
		local subfaith = player:GetSubfaith();
	
		if subfaith and subfaith ~= "" and subfaith ~= "N/A" then
			local message = table.concat(arguments, " ", 1)
			local faith_str = string.upper(string.gsub(faith, "Faith of the ", ""));
			local ofaithstr = faith_str
			local marked = player:GetSharedVar("marked");
			local favored = player:GetSharedVar("favored");
			local markedstr = "";
			local subfaith = player:GetSubfaith();
			
			faith_str = string.upper(string.gsub(subfaith, "Faith of the ", ""));
			
			local ringcolor = "ivory";
			local color = "ivory";
			local markedcolor = "red";
			local favoredcolor = "blue";
			local admins = {};
			
			if (ringcolors[ofaithstr]) then
				ringcolor = ringcolors[ofaithstr]
			end;
			
			if (faithcolors[faith_str]) then
				color = faithcolors[faith_str];
			end;
			
			if favored then
				markedstr = " FAVORED";
				markedcolor = "mediumblue";
			elseif marked then
				markedstr = " MARKED";
			end

			for k, v in pairs (_player.GetAll()) do
				if (Clockwork.player:IsAdmin(v)) then
					admins[#admins + 1] = v;
				end;
			end;
			
			local plycol = _team.GetColor(player:Team());
			
			if (player:GetFaction() == FACTION_GOREIC) then
				plycol = plycol:Lighten(100)
			end;

			-- Make it work with imbeciles!
			if player:HasTrait("imbecile") then
				local imbecileText = message;
				
				if #imbecileText > 2 then
					local fillers = {"uh", "uhh", "uhhh", "erm", "ehh", "like"};
					local suffixes = {".", ",", ";", "!", ":", "?"};
					local splitText = string.Split(imbecileText, " ");
					local tourettes = {"ASSHOLE", "FUCKING", "FUCK", "ASS", "BITCH", "CUNT", "PENIS"};
					local vowels = {["upper"] = {"A", "E", "I", "O", "U"}, ["lower"] = {"a", "e", "i", "o", "u"}};
					
					for i = 1, #splitText do
						local currentSplit = splitText[i];
						
						if math.random(1, 2) == 1 then
							for j = 1, #currentSplit do
								for k = 1, 5 do
									local vowelShuffle = math.random(1, 5);
									
									currentSplit = string.gsub(currentSplit, vowels["upper"][k], vowels["upper"][vowelShuffle]);
									currentSplit = string.gsub(currentSplit, vowels["lower"][k], vowels["lower"][vowelShuffle]);
								end
							end
						elseif #currentSplit >= 2 then
							local characterToRepeat = math.random(1, #currentSplit - 1);
							local str = string.sub(currentSplit, characterToRepeat, characterToRepeat);
							
							currentSplit = string.gsub(string.SetChar(currentSplit, characterToRepeat, "#"), "#", str.."-"..string.lower(str));
						end
						
						if #currentSplit >= 2 and math.random(1, 3) == 1 then
							local suffix_found = false;
							
							for j = 1, #suffixes do
								if string.EndsWith(currentSplit, suffixes[j]) then
									suffix_found = true;
									break;
								end
							end
							
							if not suffix_found then
								if math.random(1, 10) == 1 then
									currentSplit = currentSplit.."- "..tourettes[math.random(1, #tourettes)].."!";
								else
									currentSplit = fillers[math.random(1, #fillers)];
								end
							end
						end
						
						if math.random(1, 6) == 1 then
							currentSplit = string.upper(currentSplit);
						end
						
						splitText[i] = currentSplit;
					end
					
					message = table.concat(splitText, " ");
				end
			end
			
			Schema:EasyText(admins, ringcolor, "[PRAYER ", color, faith_str, markedcolor, markedstr, ringcolor, "] ", plycol, player:Name(), "ivory", ": "..message)
			Schema:EasyText(player, color, "You make a prayer: \""..message.."\"")
			
			Clockwork.chatBox:AddInTargetRadius(player, "me", "mumbles a short prayer to the gods.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
		else
			Schema:EasyText(player, "chocolate", "You must select a subfaith in the 'Beliefs' menu before you can pray!");
		end
	else
		Schema:EasyText(player, "chocolate", "You have no gods to pray to!");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("PrayReply");
COMMAND.tip = "Send a message to a player as a prayer reply.";
COMMAND.text = "<string Name> <string Message>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local message = string.upper("\""..table.concat(arguments, " ", 2).."\"");

		if target ~= player then
			Clockwork.chatBox:Add(player, nil, "prayerreply", message);
		end
		
		Clockwork.chatBox:Add(target, nil, "prayerreply", message);

		local admins = {}
		for k, v in pairs (_player.GetAll()) do
			if (Clockwork.player:IsAdmin(v)) then
				admins[#admins + 1] = v;
			end;
		end;
		
		local t = _team.GetColor(target:Team())
		local p = _team.GetColor(player:Team())
		
		if (target:GetFaction() == FACTION_GOREIC) then
		t = t:Lighten(75);
		end;
		if (player:GetFaction() == FACTION_GOREIC) then
			p = p:Lighten(75);
		end;
		
		
		Schema:EasyText(admins, t, "[PRAYER RESPONSE] ", p, player:Name(), "ivory", " to ", t, target:Name(), "ivory", ": "..message)
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("Relay");
COMMAND.tip = "Speak through aerial electrical signals to your Voltist brethren.";
COMMAND.text = "<string Message>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;
COMMAND.alias = {"RE"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local subfaith = player:GetSubfaith();
	
	if subfaith == "Voltism" then
		if player:HasBelief("wire_therapy") then
			local message = "\""..table.concat(arguments, " ", 1).."\"";

			for k, v in pairs (_player.GetAll()) do
				if v:HasInitialized() and v:Alive() and ((v:GetSubfaith() == "Voltism") or Clockwork.player:HasFlags(v, "L")) then
					Clockwork.chatBox:Add(v, player, "relay", message);
					v:SendLua([[Clockwork.Client:EmitSound("buttons/combine_button"..math.random(2, 3)..".wav", 90, 150)]]);
				end;
			end;
		else
			Schema:EasyText(player, "chocolate", "You must have the 'Wire Therapy' belief before you can relay!");
		end
	else
		Schema:EasyText(player, "firebrick", "You are not the correct faith to do this!");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("Warcry");
	COMMAND.tip = "Terrify your foes into submission with a feral yell. This will negatively affect the sanity of anyone within yelling distance that isn't of your faith.";
	COMMAND.flags = CMD_DEFAULT;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if player:WaterLevel() >= 3 then
			Schema:EasyText(player, "firebrick", "You cannot do this while submerged!");
		
			return false;
		end
	
		local faction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();
		local subfaction = player:GetSharedVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
		local faith = player:GetFaith();
		local player_has_belief = false;
		local player_has_daring_trout = player:HasBelief("daring_trout");
		local player_has_fearsome_wolf = player:HasBelief("fearsome_wolf");
		local sanity_debuff;
		local warcry_beliefs;
		
		if player:GetSharedVar("kinisgerOverride") then
			if player:GetSharedVar("kinisgerOverride") == "Goreic Warrior" then
				if player:GetSharedVar("kinisgerOverrideSubfaction") ~= "Clan Reaver" then
					faith = "Faith of the Family";
					sanity_debuff = -10;
					warcry_beliefs = {};
					player_has_belief = true;
				else
					sanity_debuff = -25;
					warcry_beliefs = {"sadism"};
				end
			else
				sanity_debuff = -25;
				warcry_beliefs = {"sadism"};
			end
		else
			if faith == "Faith of the Family" then
				sanity_debuff = -10;
				warcry_beliefs = {"father", "mother", "old_son", "young_son", "sister"};
			elseif faith == "Faith of the Dark" then
				sanity_debuff = -25;
				warcry_beliefs = {"sadism"};
			else
				Schema:EasyText(player, "firebrick", "You are not of the correct faith to do this!");
				return;
			end
		end
		
		for i = 1, #warcry_beliefs do
			if player:HasBelief(warcry_beliefs[i]) then
				player_has_belief = true;
				break;
			end
		end
		
		if player_has_belief or subfaction == "Clan Grock" then	
			local curTime = CurTime();
			
			if (!player.lastWarCry) or player.lastWarCry < curTime then
				local radius = config.Get("talk_radius"):Get() * 2;
				local playerPos = player:GetPos();
				
				for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
					local isPlayer = v:IsPlayer();
					
					if (isPlayer and v:GetMoveType() == MOVETYPE_WALK) then
						local immune = false;
						local vFaction = v:GetSharedVar("kinisgerOverride") or v:GetFaction();
						
						if v:GetFaith() ~= faith then
							-- Kinisgers can twisted warcry if disguised as a Reaver.
							if faith == "Faith of the Dark" then
								if faction == "Goreic Warrior" and vFaction == "Goreic Warrior" then
									immune = true;
								elseif v.banners then
									for k2, v2 in pairs(v.banners) do
										if v2 == "glazic" then
											if vFaction == "Gatekeeper" or vFaction == "Pope Adyssa's Gatekeepers" or vFaction == "Holy Hierarchy" then
												immune = true;
											
												break;
											end
										end
									end
								end
							
								if !immune then
									if Schema.towerSafeZoneEnabled or !v:InTower() then
										-- Cooldown for getting sanity debuff.
										if !v.lastWarCried or v.lastWarCried < curTime - 60 then
											v.lastWarCried = curTime;
											
											if v:HasBelief("prudence") then
												v:HandleSanity(math.Round(sanity_debuff / 2));
											else
												v:HandleSanity(sanity_debuff);
											end
										end
									end
								
									if v:HasBelief("saintly_composure") then
										v:Disorient(3);
									else
										v:Disorient(15);
									end
								end
							elseif faith == "Faith of the Family" then
								if faction == "Goreic Warrior" and vFaction == "Goreic Warrior" then
									immune = true;
								elseif v.banners then
									for k2, v2 in pairs(v.banners) do
										if v2 == "glazic" then
											if vFaction == "Gatekeeper" or vFaction == "Pope Adyssa's Gatekeepers" or vFaction == "Holy Hierarchy" then
												immune = true;
											
												break;
											end
										end
									end
								end
								
								if !immune then
									if Schema.towerSafeZoneEnabled or !v:InTower() then
										-- Cooldown for getting sanity debuff.
										if !v.lastWarCried or v.lastWarCried < curTime - 60 then
											v.lastWarCried = curTime;
											
											if v:HasBelief("prudence") then
												v:HandleSanity(math.Round(sanity_debuff / 2));
											else
												v:HandleSanity(sanity_debuff);
											end
										end
										
										if player_has_fearsome_wolf or player_has_daring_trout then
											if not player.warCryVictims then
												player.warCryVictims = {};
											end
											
											table.insert(player.warCryVictims, v);
										end
									end
								
									if subfaction == "Clan Grock" then
										if !v:HasBelief("saintly_composure") then
											v:Disorient(1);
										end
									else
										if v:HasBelief("saintly_composure") then
											v:Disorient(1);
										else
											v:Disorient(3);
										end
									end
								end
							end
							
							if player_has_daring_trout then
								v.warcrySlowSpeed = curTime + 10;
								
								hook.Run("RunModifyPlayerSpeed", v, v.cwInfoTable, true)
							end
						else
							if faith == "Faith of the Family" then
								v:HandleSanity(3);
							end
						end
					end
				end

				if subfaction == "Clan Grock" then
					player:HandleStamina(25);
					player:EmitSound("warcries/grock_warcry"..math.random(1, 11)..".ogg", 100, math.random(60, 75));
					Clockwork.chatBox:AddInTargetRadius(player, "me", "barbarically shouts out!", playerPos, radius);
				-- Kinisgers can FotF warcry if not disguised as a reaver.
				elseif faith == "Faith of the Family" then
					if player.bloodHowlActive then
						if cwStamina then
							local stamina = player:GetCharacterData("Stamina");
							local new_stamina = math.Clamp(stamina + 90, 0, player:GetMaxStamina());
							
							player:SetCharacterData("Stamina", new_stamina);
							player:SetNWInt("Stamina", new_stamina);
						end
						
						--[[if cwMelee then
							local poise = player:GetNWInt("meleeStamina", 90);
							
							player:SetNWInt("meleeStamina", math.Clamp(poise + 90, 0, player:GetMaxPoise() or 90));
						end]]--
					end
					
					if player:GetGender() == GENDER_MALE then
						player:EmitSound("warcries/warcry"..math.random(1, 16)..".mp3", 100, math.random(90, 105));
					else
						player:EmitSound("warcries/warcry_female"..math.random(1, 16)..".mp3", 100, math.random(90, 105));
					end
					
					Clockwork.chatBox:AddInTargetRadius(player, "me", "lets out a feral warcry!", playerPos, radius);
				else
					player:HandleSanity(-5);
					player:EmitSound("warcries/twistedwarcry"..math.random(1, 5)..".mp3", 100, math.random(90, 105));
					
					Clockwork.chatBox:AddInTargetRadius(player, "me", "lets out a twisted warcry, screaming with the voices of their past victims!", playerPos, radius);
				end
				
				if player_has_fearsome_wolf or player_has_daring_trout then
					netstream.Start(player, "UpgradedWarcry");
					
					if player_has_daring_trout then
						timer.Simple(10.5, function()
							if IsValid(player) and player.warCryVictims then
								for i = 1, #player.warCryVictims do
									local victim = player.warCryVictims[i];
									
									if IsValid(victim) then
										hook.Run("RunModifyPlayerSpeed", victim, victim.cwInfoTable, true);
									end
								end
							
								player.warCryVictims = nil;
							end
						end);
					else
						player.fearsomeSpeed = true;
					
						hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable, true);
					
						timer.Simple(20.5, function()
							if IsValid(player) then
								player.fearsomeSpeed = nil;
								player.warCryVictims = nil;
								
								hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable, true);
							end
						end);
					end
				end
				
				player.lastWarCry = curTime + 60;
			else
				Schema:EasyText(player, "firebrick", "You cannot war cry again for "..tostring(math.Round(player.lastWarCry - curTime)).." more seconds!");
			end
		else
			Schema:EasyText(player, "firebrick", "You are not of the correct subfaith to do this!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("Electrocute");
COMMAND.tip = "Electrocute yourself to stimulate your mind. This will regain some sanity but cause damage to yourself. Requires a 'Tech' or 'Technocraft' item in your inventory, and will take a small amount of condition from it.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 0;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local curTime = CurTime();

	if !player.nextFlagellate or player.nextFlagellate < curTime then
		if player:HasBelief("voltism") then
			if player:GetSharedVar("tied") == 0 and !player:IsRagdolled() then
				local itemList = Clockwork.inventory:GetItemsAsList(player:GetInventory());
				local techItemTable;
				local isTechnocraft = false;

				for k, v in pairs(itemList) do
					if v.uniqueID == "tech" then
						techItemTable = v;
						break;
					end
				end
				
				if !techItemTable then
					for k, v in pairs(itemList) do
						if v.uniqueID == "technocraft" then
							isTechnocraft = true;
							techItemTable = v;
							break;
						end
					end
				end

				if techItemTable then
					--player:TakeDamage(8);
					player:HandleSanity(10);
					
					player.flagellating = true;
					player.ignoreConditionLoss = true;
					Schema:DoTesla(player, true);
					player.flagellating = false;
					player.ignoreConditionLoss = false;
					
					if player:HasBelief("wriggle_fucking_eel") then
						player:StopAllBleeding();
						player:HandleNeed("corruption", -3);
						player:HandleNeed("sleep", -5);
					end
					
					local condition;
					
					if isTechnocraft then
						condition = techItemTable:GetCondition() - 1;
					else
						condition = techItemTable:GetCondition() - 5;
					end
					
					player:HandleXP(3);

					if condition <= 0 then
						player:TakeItem(techItemTable);
					else
						techItemTable:SetCondition(condition);
					end
					
					Clockwork.chatBox:AddInTargetRadius(player, "me", "begins convulsing as arcs of electricity eminate from their body!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					
					player.nextFlagellate = curTime + 1;
				else
					Schema:EasyText(player, "chocolate", "You do not have a 'Tech' item in your inventory!");
				end
			else
				Schema:EasyText(player, "firebrick", "You cannot self-electrocute right now!");
			end;
		else
			Schema:EasyText(player, "firebrick", "You lack the willpower to do this!");
		end
		
		player.nextFlagellate = curTime + 1;
	else
		Schema:EasyText(player, "firebrick", "You cannot self-electrocute right now!");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("Flagellate");
COMMAND.tip = "Repent for your sins by scourging your flesh.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 0;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local curTime = CurTime();
	
	if !player.nextFlagellate or player.nextFlagellate < curTime then
		if player:HasBelief("flagellant") or player:GetSubfaction() == "Kinisger" then
			if player:GetSharedVar("tied") == 0 and !player:IsRagdolled() then
				local activeWeapon = player:GetActiveWeapon();
				
				if IsValid(activeWeapon) then
					if activeWeapon:GetClass() == "cw_lantern" and player:HasBelief("extinctionist") then
						local weaponItemTable = item.GetByWeapon(activeWeapon);
						
						if weaponItemTable then
							local currentOil = weaponItemTable:GetData("oil");
							local selfless = "himself";
							
							if (player:GetGender() == GENDER_FEMALE) then
								selfless = "herself";
							end
							
							if currentOil >= 1 then
								local damageInfo = DamageInfo();
								
								player:TakeDamage(math.random(5,10));
								player:Ignite(15);
								weaponItemTable:SetData("oil", math.Clamp(currentOil - math.random(10, 25), 0, 100));
								player:SetSharedVar("oil", math.Round(weaponItemTable:GetData("oil"), 0));
								player:EmitSound("ambient/fire/gascan_ignite1.wav");
								
								Clockwork.chatBox:AddInTargetRadius(player, "me", "flagellates "..selfless.." with a lit lantern, dousing themselves with burning oil and bursting into flames!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
								
								return true;
							else
								local damage = math.random(5,10);
								
								player:TakeDamage(damage);
								
								if cwStamina then
									player:HandleStamina(damage);
								end
								
								Clockwork.chatBox:AddInTargetRadius(player, "me", "flagellates "..selfless.."!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
								
								return true;
							end
						end
					elseif activeWeapon:GetClass() == "begotten_fists" or !activeWeapon.IsABegottenMelee then
						Schema:EasyText(player, "firebrick", "You cannot flagellate with this weapon!");
						return false;
					end
				else
					Schema:EasyText(player, "firebrick", "You cannot flagellate with this weapon!");
					return false;
				end
				
				if player:GetNWBool("Guardening") then
					Schema:EasyText(player, "firebrick", "You cannot flagellate while blocking!");
					return false;
				end
				
				local attacktable = GetTable(activeWeapon.AttackTable)
				
				if attacktable then
					local damage = attacktable["primarydamage"];
					local damagetype = attacktable["dmgtype"];
					local attacksoundtable = GetSoundTable(activeWeapon.AttackSoundTable);
					
					if attacksoundtable then
						player:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])]);
					end
					
					--player:TakeDamage(damage * math.Rand(0.5, 0.75), player, activeWeapon);
					
					local d = DamageInfo()
					d:SetDamage(damage * math.Rand(0.5, 0.75));
					d:SetAttacker(player);
					d:SetDamageType(damagetype);
					d:SetDamagePosition(player:GetPos() + Vector(0, 0, 48));
					d:SetInflictor(activeWeapon);
					
					player.flagellating = true;
					player.ignoreConditionLoss = true;
					player:TakeDamageInfo(d);
					player.flagellating = false;
					player.ignoreConditionLoss = false;
					
					if cwSanity then
						player:HandleSanity(math.Round(d:GetDamage() / 3));
					end
					
					local selfless = "himself";
					
					if (player:GetGender() == GENDER_FEMALE) then
						selfless = "herself";
					end
					
					-- Bellhammer special
					if activeWeapon.IsBellHammer then
						timer.Simple(0.2, function() if player:IsValid() then
							player:EmitSound("meleesounds/bell.mp3")
						end end)
						
						local entities = ents.FindInSphere(player:GetPos(), 512);
						
						for i, v in ipairs(entities) do
							if v:IsPlayer() and v:Alive() then
								v:Disorient(5);
							end
						end
						
						Clockwork.chatBox:AddInTargetRadius(player, "me", "flagellates "..selfless.." with a thunderous toll of their Bell Hammer!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					else
						Clockwork.chatBox:AddInTargetRadius(player, "me", "flagellates "..selfless.."!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					end
					
					player.nextFlagellate = curTime + (attacktable["delay"] or 1);
				else
					Schema:EasyText(player, "firebrick", "You cannot flagellate with this weapon!");
				end
			else
				Schema:EasyText(player, "firebrick", "You cannot flagellate right now!");
			end;
		else
			Schema:EasyText(player, "firebrick", "You lack the willpower to do this!");
		end
		
		player.nextFlagellate = curTime + 1;
	else
		Schema:EasyText(player, "firebrick", "You cannot flagellate right now!");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("Suicide");
COMMAND.tip = "Commit fucking suicide and end your pitiful fucking existence.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 0;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if player:HasBelief("sol_orthodoxy") then
		if player:GetSharedVar("tied") == 0 and !player:IsRagdolled() then
			player:CommitSuicide()
		else
			Schema:EasyText(player, "firebrick", "Why the fuck would commit suicide right now? Fuck you.");
		end;
	else
		Schema:EasyText(player, "firebrick", "You lack the willpower to do this!");
	end
end;

COMMAND:Register();

-- Properties
properties.Add("add_faith", {
	MenuLabel = "Add Faith (XP)",
	Order = 10,
	MenuIcon = "icon16/award_star_add.png",
	Filter = function(self, ent, ply)
		if !IsValid(ent) or !IsValid(ply) or !ply:IsAdmin() then return false end
		if !ent:IsPlayer() then
			if Clockwork.entity:IsPlayerRagdoll(ent) then
				ent = Clockwork.entity:GetPlayer(ent);
			else
				return false;
			end
		end

		return ent:Alive();
	end,
	Action = function(self, ent)
		if IsValid(ent) then
			if !ent:IsPlayer() then
				if Clockwork.entity:IsPlayerRagdoll(ent) then
					ent = Clockwork.entity:GetPlayer(ent);
				else
					return false;
				end
			end
		
			Derma_StringRequest(ent:Name(), "How much faith (xp) would you like to add?", nil, function(xp)
				if IsValid(ent) then
					Clockwork.kernel:RunCommand("CharAddExperience", ent:Name(), xp)
				end
			end)
		end
	end,
});

properties.Add("open_belief_tree", {
	MenuLabel = "Open Belief Tree",
	Order = 100,
	MenuIcon = "icon16/bell.png",
	Filter = function(self, ent, ply)
		if !IsValid(ent) or !IsValid(ply) or !ply:IsAdmin() then return false end
		if !ent:IsPlayer() then
			if Clockwork.entity:IsPlayerRagdoll(ent) then
				ent = Clockwork.entity:GetPlayer(ent);
			else
				return false;
			end
		end

		return true;
	end,
	Action = function(self, ent)
		if IsValid(ent) then
			if !ent:IsPlayer() then
				if Clockwork.entity:IsPlayerRagdoll(ent) then
					ent = Clockwork.entity:GetPlayer(ent);
				else
					return false;
				end
			end
		
			Clockwork.kernel:RunCommand("CharOpenBeliefTree", ent:Name())
		end
	end,
});