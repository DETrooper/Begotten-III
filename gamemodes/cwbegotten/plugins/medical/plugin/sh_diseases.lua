--[[
	Begotten III: Jesus Wept
--]]

-- A function to add a new disease to the master table.
function cwMedicalSystem:RegisterDisease(uniqueID, data)
	if (!self.cwDiseaseTable) then
		self.cwDiseaseTable = {};
	end;

	if (!uniqueID or !isstring(uniqueID) or !data or !istable(data) or table.IsEmpty(data)) then
		return;
	elseif (!data.uniqueID) then
		data.uniqueID = uniqueID;
	end;

	if data.treatments then
		self.treatments = data.treatments;
	end;
	
	if data.stages then
		self.stages = data.stages;
	end
	
	if data.rarity then
		self.rarity = data.rarity;
	end

	self.contagious = data.contagious or false;
	self.deathChance = data.deathChance or 0;
	self.inPerishables = data.inPerishables or false;
	self.fromWater = data.fromWater or false;
	self.permanent = data.permanent or false;
	self.showOnAdminESP = data.showOnAdminESP or false;

	if (!data.OnReceive) then
		data.OnReceive = function(self, player, diseaseTable) end;
	end;
	
	if (!data.OnTake) then
		data.OnTake = function(self, player) end;
	end;
	
	if CLIENT then
		if (!self.espDiseases) then
			self.espDiseases = {};
		end
		
		if data.showOnAdminESP then
			if not table.HasValue(self.espDiseases, data.uniqueID) then
				table.insert(self.espDiseases, data.uniqueID);
			end
		end
	end

	self.cwDiseaseTable[uniqueID] = table.Copy(data);
end;

-- A function to find a specific disease.
function cwMedicalSystem:FindDiseaseByID(identifier)
	if (self.cwDiseaseTable[identifier]) then
		return self.cwDiseaseTable[identifier];
	else
		for k, v in pairs (self.cwDiseaseTable) do
			if (string.lower(v.uniqueID) == string.lower(identifier)) or (string.lower(v.name) == string.lower(identifier)) then
				return self.cwDiseaseTable[k];
			end;
		end;
	end;
end;

-- Possible symptoms are: Fatigue, Nausea, Coughing, Vomiting, Vomiting Blood, Paleness, Pustules, Deformities, Rage.

local DISEASE = {};
	DISEASE.uniqueID = "common_cold";
	DISEASE.name = "Common Cold";
	DISEASE.deathChance = 33; -- Chance of death when final stage is reached. Otherwise they will recover.
	DISEASE.contagious = true;
	DISEASE.inPerishables = true;
	DISEASE.fromWater = true;
	DISEASE.stages = {
		[1] = {progressionTime = 1800, symptoms = nil,},
		[2] = {progressionTime = 3600, symptoms = {"Headaches", "Coughing"}},
		[3] = {progressionTime = 3600, symptoms = {"Fatigue", "Headaches", "Coughing"}},
		[4] = {progressionTime = 3600, symptoms = {"Fatigue", "Headaches", "Coughing", "Paleness"}},
	};
cwMedicalSystem:RegisterDisease(DISEASE.uniqueID, DISEASE);

local DISEASE = {};
	DISEASE.uniqueID = "flu";
	DISEASE.name = "Flu";
	DISEASE.deathChance = 67; -- Chance of death when final stage is reached. Otherwise they will recover.
	DISEASE.rarity = 50; -- Chance from 1 to 100 of the disease being considered an option, usually further modified by other chances.
	DISEASE.contagious = true;
	DISEASE.inPerishables = true;
	DISEASE.fromWater = true;
	DISEASE.stages = {
		[1] = {progressionTime = 1800, symptoms = nil,},
		[2] = {progressionTime = 3600, symptoms = {"Nausea"}},
		[3] = {progressionTime = 3600, symptoms = {"Nausea", "Coughing", "Paleness"}},
		[4] = {progressionTime = 3600, symptoms = {"Nausea", "Coughing", "Paleness", "Vomiting"}},
	};
cwMedicalSystem:RegisterDisease(DISEASE.uniqueID, DISEASE);

local DISEASE = {};
	DISEASE.uniqueID = "begotten_plague";
	DISEASE.name = "Begotten Plague";
	DISEASE.deathChance = 95; -- Chance of death when final stage is reached. Otherwise they will recover.
--	DISEASE.rarity = 1; -- Chance from 1 to 100 of the disease being considered an option, usually further modified by other chances.
	DISEASE.contagious = true;
--	DISEASE.inPerishables = true;
--	DISEASE.fromWater = true;
	DISEASE.stages = {
		[1] = {progressionTime = 900, symptoms = nil,},
		[2] = {progressionTime = 3600, symptoms = {"Headaches", "Coughing", "Vomiting"}},
		[3] = {progressionTime = 3600, symptoms = {"Fatigue", "Headaches", "Nausea", "Coughing", "Vomiting Blood", "Pustules"}},
		[4] = {progressionTime = 3600, symptoms = {"Fatigue", "Headaches", "Nausea", "Coughing", "Vomiting Blood", "Pustules", "Rage"}},
	};
	DISEASE.showOnAdminESP = true; -- Show disease on admin ESP if it's important.
	DISEASE.OnReceive = function(player)
		Schema:EasyText(Schema:GetAdmins(), "icon16/bug.png", "tomato", player:Name().." has contracted the Begotten Plague!", nil);
	end;
	DISEASE.OnTake = function(player)
		--printp(player:Name().." survived the Begotten Plague!");
	end;
cwMedicalSystem:RegisterDisease(DISEASE.uniqueID, DISEASE);

-- Only from trait, non-contagious.
local DISEASE = {};
	DISEASE.uniqueID = "leprosy";
	DISEASE.name = "Leprosy";
	DISEASE.permanent = true;
	DISEASE.stages = {
		[1] = {symptoms = {"Deformities"}},
	};
cwMedicalSystem:RegisterDisease(DISEASE.uniqueID, DISEASE);