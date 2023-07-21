--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

Clockwork.config:AddToSystem("Small intro text", "intro_text_small", "The small text displayed for the introduction.");
Clockwork.config:AddToSystem("Big intro text", "intro_text_big", "The big text displayed for the introduction.");

local playerMeta = FindMetaTable("Player");

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

Schema:AddTempTexture("http://begottendev.site.nfoservers.com/temp/black.vmt", "b3/black.vmt");
Schema:AddTempTexture("http://begottendev.site.nfoservers.com/temp/black.vtf", "b3/black.vtf");

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
	return entity:GetPos():WithinAABox(Vector(2400, 15147, -2778), Vector(-2532, 11748, 2048));
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

-- A function to get whether a player is inside the tower of light.
function playerMeta:InTower(bIgnoreAdmins)
	return Schema:InTower(self, bIgnoreAdmins);
end;

-- A function to get a player's bounty.
function playerMeta:GetBounty()
	return self:GetSharedVar("bounty", 0);
end;

-- A function to get whether a player is wanted.
function playerMeta:IsWanted()
	return self:GetSharedVar("bounty", 0) > 0;
end;

Clockwork.datastream:Hook("ObjectPhysDesc", function(data)
	local entity = data;
	
	if (IsValid(entity)) then
		Derma_StringRequest("Description", "What is the physical description of this object?", nil, function(text)
			Clockwork.datastream:Start("ObjectPhysDesc", {text, entity});
		end);
	end;
end);

Clockwork.datastream:Hook("Frequency", function(data)
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

Clockwork.datastream:Hook("SetRadioState", function(data)
	if data == true then
		Clockwork.kernel:RunCommand("SetRadioState", "false");
	else
		Clockwork.kernel:RunCommand("SetRadioState", "true");
	end
end);

Clockwork.datastream:Hook("SetECWJamming", function(data)
	if data == true then
		Clockwork.kernel:RunCommand("SetECWJamming", "true");
	else
		Clockwork.kernel:RunCommand("SetECWJamming", "false");
	end
end);

Clockwork.datastream:Hook("TriggerCrows", function()
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