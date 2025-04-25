--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

Schema:SetGlobalAlias("Begotten");

game.AddParticles("particles/fire_01.pcf");
PrecacheParticleSystem("env_fire_large");

Clockwork.flag:Add("C", "Spawn Vehicles", "Access to spawn vehicles.")
Clockwork.flag:Add("r", "Spawn Ragdolls", "Access to spawn ragdolls.")
Clockwork.flag:Add("c", "Spawn Chairs", "Access to spawn chairs.")
Clockwork.flag:Add("e", "Spawn Props", "Access to spawn props.")
Clockwork.flag:Add("p", "Physics Gun", "Access to the physics gun.")
Clockwork.flag:Add("n", "Spawn NPCs", "Access to spawn NPCs.")
Clockwork.flag:Add("t", "Tool Gun", "Access to the tool gun.")
Clockwork.flag:Add("j", "Bypass Char Limit", "Ability to bypass the 1 character limit for whitelisted factions as a non-admin.")
Clockwork.flag:Add("P", "Proclaim", "Access to use /proclaim as a non-admin.")
Clockwork.flag:Add("T", "Mister Electric", "Shoot lightning out of your fists.")
Clockwork.flag:Add("K", "Leofrastus Bombastus", "Shoot explosions out of your fists.")
Clockwork.flag:Add("6", "Rubber Johnny", "Deflect the blows of your foes back onto themselves.")
Clockwork.flag:Add("4", "Super Rolling", "Combat roll much further.")
Clockwork.flag:Add("B", "Infinite Jumping", "Lets you jump even when out of stamina.")
Clockwork.flag:Add("E", "Event Character", "Take no fall damage or explosive damage. Infinite stamina. Increased run speed. High jump.")
Clockwork.flag:Add("L", "Listener", "Listen in to all radio frequencies, darkwhispers, ravenspeaks, relays, and more.")
Clockwork.flag:Add("I", "No Limb Damage", "Take no limb damage.")
Clockwork.flag:Add("N", "No Character Needs", "Character needs (i.e. hunger) will not affect you.")
Clockwork.flag:Add("M", "No Pain Sounds", "No pain or death sounds from your character.")
Clockwork.flag:Add("l", "Unholy Blessing Always Active", "Unholy Blessing is always active on weapons that have the attribute.")
Clockwork.flag:Add("-", "Drop Prevention", "Do not drop items on death. Keep items when perma-killed.")

local map = game.GetMap();

if (map == "rp_begotten3") then
	Schema.MapLocations = {
		["castle"] = Vector(-12972, -12901, -1529),
		["city"] = Vector(-357, -4365, -1870),
		["duel_bridge"] = Vector(11855, -12557, -6132),
		["duel_hell"] = Vector(-11684, -8681, -12481),
		["duel_gore"] = Vector(-12067, -12392, 12062),
		["duel_silenthill"] = Vector(8966, -12703, -6185),
		["duel_wasteland"] = Vector(14075, -5952, -2306),
		["gore"] = Vector(510, -8873, 11710),
		["goredocks"] = Vector(-2509, -468, 11688),
		["gorewatch"] = Vector(9700, 11140, -1177),
		["hell"] = Vector(-1430, -9129, -6537),
		["scrapfactory"] = Vector(-1182, -11728, -1263),
		["sea_calm"] = Vector(-208, 9115, -6089),
		["sea_rough"] = Vector(10191, 9536, -5824),
		["sea_styx"] = Vector(-9911, 9171, -6033),
		["ship"] = Vector(-10612, 4328, -1702),
		["toothboy"] = Vector(12646, -12983, -1074),
		["tower"] = Vector(-84, 11626, -1081),
	}
elseif (map == "rp_begotten_redux") then
	Schema.MapLocations = {
		["church"] = Vector(-13184, -8123, 163),
		["city"] = Vector(-6317, -8067, 709),
		["duel_bridge"] = Vector(11855, -12557, -6132),
		["duel_hell"] = Vector(-11684, -8681, -12481),
		["duel_silenthill"] = Vector(8966, -12703, -6185),
		["hell"] = Vector(-1430, -9129, -6537),
		["old_manor"] = Vector(12306, 11391, 918),
		["pillars"] = Vector(-5675, 8253, 1454),
		["town"] = Vector(-9805, -8128, 463),
	}
elseif (map == "rp_scraptown") then
	Schema.MapLocations = {
		["duel_bridge"] = Vector(11855, -12557, -6132),
		["duel_hell"] = Vector(-11684, -8681, -12481),
		["duel_silenthill"] = Vector(8966, -12703, -6185),
		["hell"] = Vector(-1430, -9129, -6537),
		["pillars"] = Vector(8867.856445, -8418.77832, 613),
		["scrapfactory"] = Vector(-5816.024414, -7112.630859, -787.41449),
		["scraptown"] = Vector(-4161.598633, -3384.802979, 571),
	}
elseif (map == "rp_district21") then
	Schema.MapLocations = {
		["church"] = Vector(5299, -13730, -496),
		["docks"] = Vector(-12920, -12259, -862),
		["duel_bridge"] = Vector(11855, -12557, -6132),
		["duel_hell"] = Vector(-11684, -8681, -12481),
		["duel_gore"] = Vector(-12067, -12392, 12062),
		["duel_silenthill"] = Vector(8966, -12703, -6185),
		["duel_wasteland"] = Vector(14075, -5952, -2306),
		["gasstation"] = Vector(-11849, 3627, -752),
		["gore"] = Vector(510, -8873, 11710),
		["goredocks"] = Vector(-2509, -468, 11688),
		["hell"] = Vector(-1430, -9129, -6537),
		["hill"] = Vector(-7131, 11049, 172),
		["pillars"] = Vector(10794, -2413, -248),
		["ruins"] = Vector(9866, 9898, -508),
		["scrapfactory"] = Vector(8264, 14075, -1054),
		["sea_calm"] = Vector(-208, 9115, -6089),
		["sea_rough"] = Vector(10191, 9536, -5824),
		["sea_styx"] = Vector(-9911, 9171, -6033),
		["ship"] = Vector(-10612, 4328, -1702),
		["voltbunker"] = Vector(-12934, -3154, -512),
		["gorewatch"] = Vector(-8927, -8286, -68),
	}
else
	Schema.MapLocations = {};
end

Schema.eventDisabledCommands = {
	["maplocation"] = true,
	["helljaunt"] = true,
	["hellteleport"] = true,
	["changecyclelength"] = true,
	["getcycle"] = true,
	["setcycle"] = true,
}

-- what is this
--[[for k, v in pairs (Schema.eventDisabledCommands) do
	Schema.eventDisabledCommands[k] = string.lower(v);
end;]]--

if (SERVER) then
	netstream.Hook("ands", function(player)
		if (player:IsAdmin()) then
			player:SelectWeapon("begotten_fists");
		end;
	end);
end;

for k, v in pairs (Clockwork.command:GetAll()) do
	if (Schema.eventDisabledCommands[string.lower(v.name)]) then
		Clockwork.command:SetHidden(v.name, true);
	end;
end;

-- Called when the player's name color should be overwritten.
function Schema:GetPlayerNameColor(player, color, playerTeam)
	return false;
end;

function Schema:InitPostEntity()
	-- Make toolgun silent/effectless.
	local toolgun = weapons.GetStored("gmod_tool");

	if toolgun then
		function toolgun:DoShootEffect()
			-- do nothing
		end
	end
end

Clockwork.kernel:IncludePrefixed("cl_schema.lua");
Clockwork.kernel:IncludePrefixed("cl_theme.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_vfx.lua");
Clockwork.kernel:IncludePrefixed("sh_coms.lua");
Clockwork.kernel:IncludePrefixed("sh_faiths.lua");
Clockwork.kernel:IncludePrefixed("sh_zones.lua");
Clockwork.kernel:IncludePrefixed("sv_schema.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_notes.lua");

Clockwork.option:SetKey("default_date", {month = 666, year = 666, day = 666});
Clockwork.option:SetKey("default_time", {minute = 0, hour = 0, day = 1});
Clockwork.option:SetKey("format_singular_cash", "%a");
Clockwork.option:SetKey("model_shipment", "models/items/item_item_crate.mdl");
Clockwork.option:SetKey("intro_image", "");
Clockwork.option:SetKey("schema_logo", "");
Clockwork.option:SetKey("format_cash", "%a %n");
Clockwork.option:SetKey("menu_music", "begotten3soundtrack/title/jesus_wept.mp3");
Clockwork.option:SetKey("name_cash", "Coin");
Clockwork.option:SetKey("model_cash", "models/items/jewels/purses/big_purse.mdl")
Clockwork.option:SetKey("gradient", "h");

Clockwork.config:ShareKey("discord_url");
--[[Clockwork.config:ShareKey("intro_text_small");
Clockwork.config:ShareKey("intro_text_big");]]--

Clockwork.quiz:SetName("Consider These Fucking Questions Carefully");
Clockwork.quiz:SetEnabled(true);
Clockwork.quiz:AddQuestion("Do you understand that the admins of this server are omnipotent all-powerful beings, and that you, by joining this server, are their playthings?", 1, "Yes.", "No.");
Clockwork.quiz:AddQuestion("Do you understand that this server features explicit content and themes related to occultism, extreme violence, and strong language?", 1, "Yes.", "No.");
Clockwork.quiz:AddQuestion("Do you understand that all deaths are permanent kills, and S2K is enabled at all times outside of safezones?", 1, "Yes.", "No.");
Clockwork.quiz:AddQuestion("Do you understand that despite this server featuring over-the-top ridiculous and comical themes, you are still expected to remain in-character all times?", 1, "Yes.", "No.");
Clockwork.quiz:AddQuestion("Do you understand that survival is extremely hard and you are most likely going to die very soon?", 1, "Yes.", "No.");
Clockwork.quiz:AddQuestion("Do you understand that you should not play this server if you are an epileptic?", 1, "Yes.", "No.");
Clockwork.quiz:AddQuestion("Repeat the phrase. I am nothing but fodder for the gods of this world.", 2, "I refuse.", "I am nothing but fodder for the gods of this world.");

-- A function to get if a position is within a box.
function Schema:IsInBox(firstVector, secondVector, position, bOptimized, delay)
	local position = position
	local bIsEntity = IsEntity(position)
	local entity = nil
	local center = Vector(0, 0, 36)

	if (bIsEntity) then
		if (bOptimized) then
			local curTime = CurTime()
			entity = position
			
			if (!entity.InBox) then entity.InBox = false end
			if (!entity.OldInBox) then entity.OldInBox = false end
			
			local delay = delay or 0.5
			
			if (!entity.LastInBox or entity.LastInBox <= curTime) then
				entity.LastInBox = curTime + delay
			elseif (entity.InBox or entity.OldInBox != entity.InBox) then
				return entity.InBox
			end
		end

		position = position:GetPos()
			if (position.OBBCenter) then
				center = position:OBBCenter()
			end
		position = position + center
	elseif (isvector(position)) then
		position = position + center
	else
		return false
	end
	
	local firstVector = firstVector
	local secondVector = secondVector
	local bInBox = false

	if (position:WithinAABox(firstVector, secondVector)) then
		bInBox = true
	end
	
	if (bOptimized) then
		if (bIsEntity and entity) then
			if (entity.OldInBox == entity.InBox) then
				entity.OldInBox = !entity.InBox
				entity.LastInBox = nil
			end
			
			entity.InBox = bInBox
		end
	end
	
	return bInBox
end

-- A function to get whether an entity is inside the tower of light.
function Schema:InTower(entity)
	if SERVER and entity:IsPlayer() and entity:GetCharacterData("LastZone") == "tower" then
		return true;
	end

	if map == "rp_begotten3" then
		return entity:GetPos():WithinAABox(Vector(2400, 15147, -2778), Vector(-2532, 12022, 2048)) or entity:GetPos():WithinAABox(Vector(-831, 12023, -883), Vector(6, 11736, -1073));
	elseif map == "rp_begotten_redux" then
		return entity:GetPos():WithinAABox(Vector(-8896, -10801, 69), Vector(-13525, -3070, 914));
	elseif map == "rp_scraptown" then
		return entity:GetPos():WithinAABox(Vector(-2446, -7, -262), Vector(-8792, -8935, 2110));
	elseif map == "rp_district21" then
		return entity:GetPos():WithinAABox(Vector(-7600, 9407, 476), Vector(-4861, 13313, -2100)) or entity:GetPos():WithinAABox(Vector(-10622, 12500, 476), Vector(-7600, 10368, -2100));
	end
end;

local COMMAND = Clockwork.command:New("StartSound");
	COMMAND.tip = "Start a loopable/fadeable sound.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 2;
	COMMAND.access = "s";
	COMMAND.optionalArguments = 3;
	COMMAND.text = "<string name> <string Sound> [int Volume] [int Pitch] [int DSP]";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);

		if (!target) then
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
			
			return;
		end;
		
		local sound = arguments[2];
		local volume = arguments[3] or 1;
		local pitch = arguments[4] or 100;
		local dsp = arguments[5] or 0;

		netstream.Start({player, target}, "StartCustomSound", {sound, volume, pitch});
		
		if (tobool(arguments[6])) then
			netstream.Start({player, target}, "FadeAllMusic");
			netstream.Start({player, target}, "DisableDynamicMusic");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("StartSoundGlobal");
	COMMAND.tip = "Start a loopable/fadeable sound GLOBALLY.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;
	COMMAND.access = "s";
	COMMAND.optionalArguments = 3;
	COMMAND.text = "<string Sound> [int Volume] [int Pitch] [int DSP]";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local sound = arguments[1];
		local volume = arguments[2] or 1;
		local pitch = arguments[3] or 100;
		local dsp = arguments[4] or 0;
		
		netstream.Start(nil, "StartCustomSound", {sound, volume, pitch, dsp})
		if (tobool(arguments[5])) then
			netstream.Start(nil, "FadeAllMusic");
			netstream.Start(nil, "DisableDynamicMusic");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("StartSoundRadius");
	COMMAND.tip = "Start a loopable/fadeable sound IN A RADIUS.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 2;
	COMMAND.access = "s";
	COMMAND.optionalArguments = 3;
	COMMAND.text = "[int Radius] <string Sound> [int Volume] [int Pitch] [int DSP] [bool StopDynamicMusic]";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local players = {};
		
		for k, v in pairs (ents.FindInSphere(player:GetEyeTraceNoCursor().HitPos, arguments[1])) do
			if (v:IsPlayer()) then
				players[#players + 1] = v;
			end;
		end;
		
		local sound = arguments[2];
		local volume = arguments[3] or 1;
		local pitch = arguments[4] or 100;
		local dsp = arguments[5] or 0;
		for k, v in pairs (players) do
			netstream.Start(v, "StartCustomSound", {sound, volume, pitch});
			
			if (tobool(arguments[6])) then
				netstream.Start(v, "FadeAllMusic");
				netstream.Start(v, "DisableDynamicMusic");
			end;
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("FadeSound");
	COMMAND.tip = "Fade a loopable/fadeable sound.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 2;
	COMMAND.access = "s";
	COMMAND.text = "<string name> [int FadeDuration]";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);

		if (!target) then
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
			
			return;
		end;
		
		local duration = arguments[2] or 4;
		
		netstream.Start(player, "FadeOutCustomSound", {duration});
		netstream.Start(target, "FadeOutCustomSound", {duration});
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("FadeSoundGlobal");
	COMMAND.tip = "Fade a loopable/fadeable sound GLOBALLY.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;
	COMMAND.access = "s";
	COMMAND.text = "[int FadeDuration]";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		netstream.Start(nil, "FadeOutCustomSound", {arguments[2] or 4});
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("FadeSoundRadius");
	COMMAND.tip = "Fade a loopable/fadeable sound IN A RADIUS.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 2;
	COMMAND.access = "s";
	COMMAND.text = "[int Radius] [int Duration]";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local players = {};
		
		for k, v in pairs (ents.FindInSphere(player:GetEyeTraceNoCursor().HitPos, arguments[1])) do
			if (v:IsPlayer()) then
				players[#players + 1] = v;
			end;
		end;
		
		local duration = arguments[2] or 4;
		
		for k, v in pairs (players) do
			netstream.Start(v, "FadeOutCustomSound", {duration});
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ChangeVolume");
	COMMAND.tip = "Change the volume on a loopable/fadeable sound.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 3;
	COMMAND.access = "s";
	COMMAND.text = "<string name> [int NewVolume] [int Duration]";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);

		if (!target) then
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
			
			return;
		end;
		
		local newVolume = arguments[2] or 1;
		local duration = arguments[3] or 4;
		
		netstream.Start(player, "CustomSoundChangeVolume", {newVolume, duration});
		netstream.Start(target, "CustomSoundChangeVolume", {newVolume, duration});
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ChangeVolumeGlobal");
	COMMAND.tip = "Change the volume on a loopable/fadeable sound GLOBALLY.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;
	COMMAND.access = "s";
	COMMAND.text = "[int NewVolume] [int Duration]";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local newVolume = arguments[1] or 1;
		local duration = arguments[2] or 4;
		
		netstream.Start(nil, "CustomSoundChangeVolume", {newVolume, duration});
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ChangeVolumeRadius");
	COMMAND.tip = "Change the volume on a loopable/fadeable sound IN A RADIUS.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 3;
	COMMAND.access = "s";
	COMMAND.text = "[int Radius] [int NewVolume] [int Duration]";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local players = {};
		
		for k, v in pairs (ents.FindInSphere(player:GetEyeTraceNoCursor().HitPos, arguments[1])) do
			if (v:IsPlayer()) then
				players[#players + 1] = v;
			end;
		end;
		
		local newVolume = arguments[2] or 1;
		local duration = arguments[3] or 4;
		
		for k, v in pairs (players) do
			netstream.Start(v, "CustomSoundChangeVolume", {newVolume, duration});
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ChangePitch");
	COMMAND.tip = "Change the pitch on a loopable/fadeable sound.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";
	COMMAND.arguments = 3;
	COMMAND.text = "<string name> [int NewPitch] [int Duration]";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);

		if (!target) then
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
			
			return;
		end;
		
		local newPitch = arguments[2] or 1;
		local duration = arguments[3] or 4;
		
		netstream.Start(player, "CustomSoundChangePitch", {newPitch, duration});
		netstream.Start(target, "CustomSoundChangePitch", {newPitch, duration});
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ChangePitchGlobal");
	COMMAND.tip = "Change the pitch on a loopable/fadeable sound GLOBALLY.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 2;
	COMMAND.access = "s";
	COMMAND.text = "[int NewPitch] [int Duration]";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local newPitch = arguments[1] or 1;
		local duration = arguments[2] or 4;
		
		netstream.Start(nil, "CustomSoundChangePitch", {newPitch, duration});
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ChangePitchRadius");
	COMMAND.tip = "Change the pitch on a loopable/fadeable sound IN A RADIUS.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 3;
	COMMAND.access = "s";
	COMMAND.text = "[int Radius] [int NewPitch] [int Duration]";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local players = {};
		
		for k, v in pairs (ents.FindInSphere(player:GetEyeTraceNoCursor().HitPos, arguments[1])) do
			if (v:IsPlayer()) then
				players[#players + 1] = v;
			end;
		end;
		
		local newPitch = arguments[2] or 1;
		local duration = arguments[3] or 4;
		
		for k, v in pairs (players) do
			netstream.Start(v, "CustomSoundChangePitch", {newPitch, duration});
		end;
	end;
COMMAND:Register();

-- Properties
properties.Add("heal", {
	MenuLabel = "Heal",
	Order = 200,
	MenuIcon = "icon16/heart.png",
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
			
			Clockwork.kernel:RunCommand("PlyHealFull", ent:Name())
		end
	end,
});

properties.Add("unpk", {
	MenuLabel = "Unpermakill",
	Order = 666,
	MenuIcon = "icon16/pill_add.png",
	Filter = function(self, ent, ply)
		if !IsValid(ent) or !IsValid(ply) or !ply:IsAdmin() then return false end
		if !ent:IsPlayer() then
			if Clockwork.entity:IsPlayerRagdoll(ent) then
				ent = Clockwork.entity:GetPlayer(ent);
			else
				return false;
			end
		end

		return !ent:Alive();
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
			
			Clockwork.kernel:RunCommand("CharUnPermakill", ent:Name())
		end
	end,
});

properties.Add("unpkstay", {
	MenuLabel = "Unpermakill (Stay)",
	Order = 666,
	MenuIcon = "icon16/pill_go.png",
	Filter = function(self, ent, ply)
		if !IsValid(ent) or !IsValid(ply) or !ply:IsAdmin() then return false end
		if !ent:IsPlayer() then
			if Clockwork.entity:IsPlayerRagdoll(ent) then
				ent = Clockwork.entity:GetPlayer(ent);
			else
				return false;
			end
		end

		return !ent:Alive();
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
			
			Clockwork.kernel:RunCommand("CharUnPermakillStay", ent:Name())
		end
	end,
});

properties.Add("smite", {
	MenuLabel = "Smite",
	Order = 150,
	MenuIcon = "icon16/weather_lightning.png",
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
			
			Clockwork.kernel:RunCommand("PlySmite", ent:Name())
		end
	end,
});