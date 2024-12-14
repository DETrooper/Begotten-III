--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

Clockwork.ConVars.NPCSPAWNESP = Clockwork.kernel:CreateClientConVar("cwNPCSpawnESP", 0, false, true)

Clockwork.setting:AddCheckBox("Admin ESP - Spawn Points", "Show NPC spawn points.", "cwNPCSpawnESP", "Click to toggle the NPC spawn point ESP.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end);

--[[Clockwork.config:AddToSystem("Small intro text", "intro_text_small", "The small text displayed for the introduction.");
Clockwork.config:AddToSystem("Big intro text", "intro_text_big", "The big text displayed for the introduction.");]]--
Clockwork.config:AddToSystem("Coinslot Wages Interval", "coinslot_wages_interval", "The time that it takes for coinslot wages to be distributed (seconds).", 0, 7200);
Clockwork.config:AddToSystem("Enable Famine", "enable_famine", "Enable famine mode. This will make food/drink spawns significantly more rare and will also prevent rations from being distributed at the Coinslot.");
Clockwork.config:AddToSystem("Discord Invite URL", "discord_url", "The invite link for your community's discord.");

local playerMeta = FindMetaTable("Player");
local map = game.GetMap();

if (!Schema.towerSafeZoneEnabled) then
	Schema.towerSafeZoneEnabled = true;
end

Schema.tempTextures = {}

-- A function to add a temporary texture to the game to use instead of a default content texture.
function Schema:AddTempTexture(url, path)
	self.tempTextures[#self.tempTextures + 1] = {url = url, path = path};
end;

-- A function to safely add a checkbox without creating duplicates.
function Schema:SafeAddCheckBox(category, text, convar, toolTip, Condition)
	if (!cwCheckboxes) then
		cwCheckboxes = {};
	end;
	
	if (!cwCheckboxes[convar]) then
		cwCheckboxes[convar] = true;
		
		Clockwork.setting:AddCheckBox(category, text, convar, toolTip, Condition);
	end;
end;

if (fileio and fileio.Write) then
	for i = 1, 100 do
		print("fileio found!")
	end;
end;

-- A function to download a file to the player's data folder.
function Schema:DownloadMaterial(url, path)
	if (!file.Exists(path, "DATA")) then
		http.Fetch(url, function(result)
			if (result) then
				file.Write(path, result);
			end;
		end);
	end;
end;

--Schema:AddTempTexture("http://begottendev.site.nfoservers.com/temp/black.vmt", "b3/black.vmt");
--Schema:AddTempTexture("http://begottendev.site.nfoservers.com/temp/black.vtf", "b3/black.vtf");

-- A function to get whether a text entry is being used.
function Schema:IsTextEntryBeingUsed()
	if (self.textEntryFocused) then
		if (self.textEntryFocused:IsValid() and self.textEntryFocused:IsVisible()) then
			return true;
		end;
	end;
end;

-- A function to convert source distance to meters.
function Schema:DistanceToMeters(range)
	return math.floor((range / 75) * 10.5) / 10
end;

-- A function to convert meters to feet.
function Schema:MetersToFeet(meters)
	return (meters * 3.28084);
end;

-- A function to get whether an entity is inside the tower of light.
function Schema:InTower(entity)
	if map == "rp_begotten3" then
		return entity:GetPos():WithinAABox(Vector(2400, 15147, -2778), Vector(-2532, 11748, 2048));
	elseif map == "rp_begotten_redux" then
		return entity:GetPos():WithinAABox(Vector(-8896, -10801, 69), Vector(-13525, -3070, 914));
	elseif map == "rp_scraptown" then
		return entity:GetPos():WithinAABox(Vector(-2446, -7, -262), Vector(-8792, -8935, 2110));
	elseif map == "rp_district21" then
		return entity:GetPos():WithinAABox(Vector(-10622, 9407, 476), Vector(-4861, 13313, -2100));
	end
end;


-- Trigger crows manually.
function Schema:TriggerCrows()
	if !self.crows then
		self.crows = {};
	end
	
	if (#self.crows < 10) then
		local position = Clockwork.Client:GetPos();
		local trace = {};
			trace.start = Clockwork.Client:LocalToWorld(Vector(math.random(-200, 200), math.random(-200, 200), 800));
			trace.endpos = trace.start + Vector(0, 0, 500000);
			trace.filter = {Clockwork.Client};
		local traceLine = util.TraceLine(trace);
		
		if (traceLine.HitSky) then
			for i = 1, 10 - #self.crows do 
				local crowModel = ClientsideModel("models/crow.mdl", RENDERGROUP_OPAQUE);
				
				if IsValid(crowModel) then
					local randomPosition = (traceLine.HitPos - Vector(0, 0, ((traceLine.HitPos.z - position.z) * math.Rand(0.6, 0.9)))) + VectorRand() * 20;
					
					crowModel:SetPos(randomPosition);
					crowModel:SetAngles(Angle(0, math.random(0, 359), 0));
					crowModel.speed = math.Rand(2.5, 3);
					crowModel.position = crowModel:GetPos();
					crowModel.nextFly = curTime;
					crowModel:ResetSequence(0);
					
					table.insert(self.crows, crowModel);
				end
			end;
		end;
	end
end

local material = Material("models/humans/male/group01/male_cheaple_sheet");

game.AddParticles("particles/burning_fx.pcf");
PrecacheParticleSystem("env_fire_large");

-- For the 'Followed' trait.
function Schema:CheapleFollows(position_override)
	local target = LocalPlayer();
	
	statichitman = ClientsideModel("models/humans/group01/male_cheaple.mdl");
	
	if !IsValid(statichitman) then
		return;
	end
	
	if position_override then
		statichitman:SetPos(position_override);
	else
		local pos = target:GetPos();
		local angles = target:EyeAngles();
		local forward = angles:Forward();
		local position = pos - (Vector(forward.x, forward.y, 0) * 2048);
		
		statichitman:SetPos(position);
	end
	
	statichitman:ResetSequence("walk_all");
	
	statichitman:EmitSound("ambient/creatures/town_zombie_call1.wav", 100);
	
	timer.Simple(2, function()
		if IsValid(statichitman) then
			statichitman:EmitSound("begotten/npc/follower/dimented_passages_looping.wav", 80);
		end
	end);
end;

function Schema:CheapleCaught()
	self:ClearCheaple();
	self.caughtByCheaple = true;
	
	Clockwork.menu:SetOpen(false);
	Clockwork.character:SetPanelOpen(false);
	
	if (IsValid(Clockwork.Client.cwBeliefPanel)) then
		Clockwork.Client.cwBeliefPanel:Close()
		Clockwork.Client.cwBeliefPanel:Remove()
		Clockwork.Client.cwBeliefPanel = nil;
	end
	
	if (IsValid(Clockwork.Client.cwCraftingMenu)) then
		Clockwork.Client.cwCraftingMenu:Close()
		Clockwork.Client.cwCraftingMenu:Remove()
		Clockwork.Client.cwCraftingMenu = nil;
	end
	
	if (IsValid(Clockwork.Client.cwRitualsMenu)) then
		Clockwork.Client.cwRitualsMenu:Close()
		Clockwork.Client.cwRitualsMenu:Remove()
		Clockwork.Client.cwRitualsMenu = nil;
	end
	
	if cwMusic then
		cwMusic:StopAmbientMusic();
		cwMusic:StopBattleMusic();
	end
	
	surface.PlaySound("new/echoes-1.wav");
	
	hook.Add("RenderScreenspaceEffects", "RenderScreenspaceEffectsCheaple", function()
		surface.SetDrawColor(255, 255, 255, 255);
		surface.SetMaterial(material);
		surface.DrawTexturedRect(-ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2);
	end);
	
	netstream.Start("CheapleCaught");
end

function Schema:CheapleCutscene()
	hook.Remove("RenderScreenspaceEffects", "RenderScreenspaceEffectsCheaple");

	if Clockwork.Client:Alive() and game.GetMap() == "rp_begotten3" then
		Schema.cheapleLight = true;
	
		timer.Simple(2, function()
			local cheaple = ClientsideModel("models/humans/group01/male_cheaple.mdl");
			
			cheaple:SetPos(Vector(168, 4992, -11075));
			cheaple:SetAngles(Angle(0, 0, 0));
			
			Clockwork.Client:EmitSound("begotten/coming.wav");
			
			timer.Simple(3.3, function()
				Clockwork.Client:EmitSound("begotten/score5.mp3");
				
				timer.Simple(1, function()
					Schema.cheapleLight = false;
					
					timer.Simple(0.2, function()
						EmitSound("physics/glass/glass_largesheet_break3.wav", Vector(260, 4995, -10915), -1, CHAN_AUTO, 0.7);
					end);
				end);

				timer.Simple(2, function()
					if IsValid(cheaple) then
						cheaple:Remove();
						cheaple = nil;
					end
					
					Schema.caughtByCheaple = false;
				end);
			end);
		end);
	end
end

function Schema:ClearCheaple()
	if IsValid(statichitman) then
		statichitman:StopSound("begotten/npc/follower/dimented_passages_looping.wav");
		statichitman:StopSound("ambient/fire/fire_small1.wav");
		statichitman:Remove();
	end
	
	if Schema.HeartbeatSound then
		Schema.HeartbeatSound:Stop();
		Schema.HeartbeatSound = nil;
	end
end;

-- A function to get whether a player is inside the tower of light.
function playerMeta:InTower(bIgnoreAdmins)
	return Schema:InTower(self, bIgnoreAdmins);
end;

-- A function to get a player's bounty.
function playerMeta:GetBounty()
	return self:GetNetVar("bounty", 0);
end;

-- A function to get whether a player is wanted.
function playerMeta:IsWanted()
	return self:GetNetVar("bounty", 0) > 0;
end;

netstream.Hook("ObjectPhysDesc", function(data)
	local entity = data;
	
	if (IsValid(entity)) then
		Derma_StringRequest("Description", "What is the physical description of this object?", nil, function(text)
			netstream.Start("ObjectPhysDesc", {text, entity});
		end);
	end;
end);

netstream.Hook("Frequency", function(data)
	Derma_StringRequest("Frequency", "What would you like to set the frequency to?", data, function(text)
		Clockwork.kernel:RunCommand("SetFreq", text);
		
		if (!Clockwork.menu:GetOpen()) then
			gui.EnableScreenClicker(false);
		end;
	end);
	
	if (!Clockwork.menu:GetOpen()) then
		gui.EnableScreenClicker(true);
	end;
end);

netstream.Hook("SetRadioState", function(data)
	if data == true then
		Clockwork.kernel:RunCommand("SetRadioState", "false");
	else
		Clockwork.kernel:RunCommand("SetRadioState", "true");
	end
end);

netstream.Hook("SetECWJamming", function(data)
	if data == true then
		Clockwork.kernel:RunCommand("SetECWJamming", "true");
	else
		Clockwork.kernel:RunCommand("SetECWJamming", "false");
	end
end);

netstream.Hook("TriggerCrows", function()
	Schema:TriggerCrows();
end);

Clockwork.chatBox:RegisterClass("ravenspeak", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(159, 129, 112, 255), "A raven flies onto your shoulder, speaking into your ear with the voice of "..info.speaker:Name().." "..info.text);
end);

Clockwork.chatBox:RegisterClass("ravenspeakclan", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(159, 129, 112, 255), "A flock of ravens fly far above your head and those of other Clan Crast Gores, speaking with the voice of "..info.speaker:Name().." "..info.text);
end);

Clockwork.chatBox:RegisterClass("ravenspeakfaction", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(159, 129, 112, 255), "A flock of ravens fly far above your head and those of other Gores, speaking with the voice of "..info.speaker:Name().." "..info.text);
end);

Clockwork.chatBox:RegisterClass("ravenspeakreply", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(159, 129, 112, 255), info.speaker:Name().." speaks back to the raven "..info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("rptext", "ic", function(info)
	local filtered = info.filtered;
	local icon = "icon16/"..info.data.icon..".png" or nil;
	local color = info.data.color or Color(150, 255, 150);
	Clockwork.chatBox:Add(filtered, icon, color, info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("speaker", "ic", function(info)
	local name = info.name;
	if (string.find(string.lower(name), "dreadpope")) then
		name = "the Mighty Pope";
	end;
	Clockwork.chatBox:Add(info.filtered, nil, Color(123, 104, 238), "The voice of "..info.name.." rings out over the public address system \""..info.text.."\"");
end);

Clockwork.chatBox:RegisterDefaultClass("speakerit", "ic", function(info)				
	Clockwork.chatBox:Add(info.filtered, nil, Color(123, 104, 238), "*** "..info.text);
end);