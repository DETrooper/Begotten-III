--[[
	Begotten III: Jesus Wept
--]]

-- A function to add a new injury to the master table.
function cwMedicalSystem:RegisterInjury(uniqueID, data)
	if (!self.cwInjuryTable) then
		self.cwInjuryTable = {};
	end;

	if (!uniqueID or !isstring(uniqueID) or !data or !istable(data) or table.IsEmpty(data)) then
		return;
	elseif (!data.uniqueID) then
		data.uniqueID = uniqueID;
	end;

	local healItem = data.healItem;

	if (healItem) then
		if (!self.cwCureItems) then
			self.cwCureItems = {};
		end;
		
		if (!self.cwCureItems[healItem]) then
			self.cwCureItems[healItem] = {};
		end;
		
		table.insert(self.cwCureItems[healItem], uniqueID);
	end;
	
	if (!data.limb or !istable(data.limb) or table.IsEmpty(data.limb)) then
		data.limb = table.Copy(self.cwDefaultLimbs);
	end;

	self.cwInjuryTable[uniqueID] = table.Copy(data);
end;

local INJURY = {};
	INJURY.uniqueID = "broken_bone";
	INJURY.name = "Broken Bone";
	INJURY.description = "This limb has a broken bone!";
	INJURY.symptom = " appears to be broken.";
cwMedicalSystem:RegisterInjury(INJURY.uniqueID, INJURY);

local INJURY = {};
	INJURY.uniqueID = "burn";
	INJURY.name = "Burn";
	INJURY.description = "You have a sustained a severe burn on this limb!";
	INJURY.symptom = " is severely burnt.";
	INJURY.OnReceive = function(injuryTable, player)
		local maxHealth = player:GetMaxHealth();
		
		player:SetMaxHealth(maxHealth);
		player:SetHealth(math.min(player:Health(), maxHealth));
	end;
	INJURY.OnTake = function(injuryTable, player)
		player:SetMaxHealth(player:GetMaxHealth());
	end;
cwMedicalSystem:RegisterInjury(INJURY.uniqueID, INJURY);

local INJURY = {};
	INJURY.uniqueID = "gash";
	INJURY.name = "Gash";
	INJURY.description = "You have a severe gash in this limb! It cannot be treated with normal bandages.";
	INJURY.symptom = " is torn open and bleeding severely.";
	INJURY.causesBleeding = true;
	INJURY.surgeryInfo = {
		{tool = "suture", texts = {"starts stitching the gash in NAME's LIMB with a thread and needle."}, messups = {texts = {"accidentally stabs NAME's LIMB while trying to stich it up!"}, damage = 5, causesBleeding = true}},
	};
cwMedicalSystem:RegisterInjury(INJURY.uniqueID, INJURY);

local INJURY = {};
	INJURY.uniqueID = "gunshot_wound";
	INJURY.name = "Gunshot Wound";
	INJURY.description = "You have a bullet lodged inside this limb!";
	INJURY.symptom = " has a bullet hole in it with blood gushing out!";
	INJURY.causesBleeding = true;
	INJURY.surgeryInfo = {
		{tool = "scalpel", texts = {"begins cutting at the site of the gunshot wound in NAME's LIMB with a scalpel."}, messups = {texts = {"slips and accidentally puncture's NAME's LIMB while trying to make an incision."}, damage = 5, causesBleeding = true}},
		{tool = "forceps", texts = {"uses a pair of forceps to clamp the bullet inside NAME's LIMB, attempting to dislodge it and pull it out."}, messups = {texts = {"fumbles and accidentally drops the bullet inside NAME's open LIMB."}}},
		{tool = "suture", texts = {"starts stitching the incision of NAME's LIMB with a thread and needle."}, messups = {texts = {"accidentally stabs NAME's LIMB while trying to stich it up!"}, damage = 5, causesBleeding = true}},
	};
cwMedicalSystem:RegisterInjury(INJURY.uniqueID, INJURY);

local INJURY = {};
	INJURY.uniqueID = "infection";
	INJURY.name = "Infection";
	INJURY.description = "You have an infection on this limb!";
	INJURY.symptom = " has an festering infection at the site of a previous wound.";
cwMedicalSystem:RegisterInjury(INJURY.uniqueID, INJURY);

local INJURY = {};
	INJURY.uniqueID = "minor_infection";
	INJURY.name = "Minor Infection";
	INJURY.description = "You have a minor infection on this limb!";
	INJURY.symptom = " has a small infection at the site of a previous wound.";
cwMedicalSystem:RegisterInjury(INJURY.uniqueID, INJURY);
