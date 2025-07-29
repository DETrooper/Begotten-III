--[[
	Begotten III: Jesus Wept
--]]

PLUGIN:SetGlobalAlias("cwMedicalSystem");

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sh_diseases.lua");
Clockwork.kernel:IncludePrefixed("sh_injuries.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

game.AddDecal("BloodLarge", "decals/bloodstain_002");

-- this is shit, i'm replacing it with a ModifyPlayerSpeed hook
-- Called when the player's move data should be manipulated.
--[[function cwMedicalSystem:Move(player, moveData)
	local action, percentage = Clockwork.player:GetAction(player, true);
	
	if (action == "heal" or action == "healing" or action == "performing_surgery") then
		return true;
	end;
end;]]--

--[[local COMMAND = Clockwork.command:New("CharHeal");
COMMAND.tip = "Heal a character if you own a medical item.";
COMMAND.text = "<string Item>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player:GetNetVar("tied") == 0) then
		local itemTable = player:FindItemByID(arguments[1]);
		local entity = player:GetEyeTraceNoCursor().Entity;
		local target = Clockwork.entity:GetPlayer(entity);
		
		if (target) then
			if (entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
				if (itemTable and itemTable.customFunctions and table.HasValue(itemTable.customFunctions, "Give")) then
					if (player:HasItemByID(itemTable.uniqueID)) then
						cwMedicalSystem:HealPlayer(player, target, itemTable);
					else
						Schema:EasyText(player, "lightslateblue","You do not own a "..itemTable.name.."!");
					end;
				else
					Schema:EasyText(player, "lightslateblue","This is not a valid item!");
				end;
			else
				Schema:EasyText(player, "firebrick", "This character is too far away!");
			end;
		else
			Schema:EasyText(player, "firebrick", "You must look at a character!");
		end;
	else
		Schema:EasyText(player, "lightslateblue","You don't have permission to do this right now!");
	end;
end;

COMMAND:Register();]]--

local COMMAND = Clockwork.command:New("CharStopBleeding");
COMMAND.tip = "Stop all bleeding on a character.";
COMMAND.text = "<string Name>";
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.alias = {"StopBleeding", "PlyStopBleeding"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		target:StopAllBleeding();
		
		if (player != target) then
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has stopped all bleeding for "..target:Name()..".");
		else
			Schema:EasyText(player, "cornflowerblue","["..self.name.."] You have stopped all bleeding for yourself.");
		end;
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("CharResetInjuries");
COMMAND.tip = "Remove all injuries on a character.";
COMMAND.text = "<string Name>";
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.alias = {"ResetInjuries", "PlyResetInjuries"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		target:ResetInjuries();
		
		if (player != target) then
			Schema:EasyText(Schema:GetAdmins(), _team.GetColor(player:Team()), player:Name(), "cornflowerblue", " has reset all injuries for ", _team.GetColor(target:Team()), target:Name(), "cornflowerblue", ".");
		else
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have reset all injuries for yourself.");
		end;
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("CharGetInjuries");
	COMMAND.tip = "Display a list of a character's injuries.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.alias = {"GetInjuries", "PlyGetInjuries"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target and target:HasInitialized()) then
			local injuries = cwMedicalSystem:GetInjuries(target);
			local injuryStr = "";
			
			if injuries then 
				for k, v in pairs(injuries) do
					for k2, v2 in pairs(v) do
						if v2 == true then
							local injury = cwMedicalSystem.cwInjuryTable[k2];
						
							if injury and injury.symptom then
								injuryStr = injuryStr.." Their "..cwMedicalSystem.cwHitGroupToString[k]..injury.symptom;
							end
						end
					end
				end
			end
			
			Schema:EasyText(player, "cornflowerblue","["..self.name.."] "..target:Name().." has the following injuries: "..injuryStr);
		else
			Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharGiveInjury");
	COMMAND.tip = "Give a specified injury to a character.";
	COMMAND.text = "<string Name> <string Injury> <string Limb>";
	COMMAND.access = "s";
	COMMAND.arguments = 3;
	COMMAND.alias = {"GiveInjury", "PlyGiveInjury"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target and target:HasInitialized()) then
			local injury = arguments[2];
			
			if cwMedicalSystem.cwInjuryTable[injury] then
				local limb;
			
				for k, v in pairs(cwMedicalSystem.cwHitGroupToString) do
					if v == arguments[3] then
						limb = v;
						break;
					end
				end
				
				if !limb then
					Schema:EasyText(player, "grey",arguments[3].." is not a valid limb!");
				
					return false;
				end
				
				local limbNumber = cwMedicalSystem.cwStringToHitGroup[limb];
				local injuries = cwMedicalSystem:GetInjuries(target);
			
				if injuries then
					for k, v in pairs(injuries) do
						for k2, v2 in pairs(v) do
							if v2 == true then
								if k2 == injury and k == limbNumber then
									Schema:EasyText(player, "darkgrey",target:Name().." already has the "..injury.." injury!");
									
									return false;
								end
							end
						end
					end
				end
				
				target:AddInjury(limbNumber, injury);
				
				Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has given "..target:Name().." a "..injury.." injury on their "..limb.."!");
			else
				Schema:EasyText(player, "grey",arguments[2].." is not a valid injury!");
			end
		else
			Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharTakeInjury");
	COMMAND.tip = "Take a specified injury from a character.";
	COMMAND.text = "<string Name> <string Injury> <string Limb>";
	COMMAND.access = "s";
	COMMAND.arguments = 3;
	COMMAND.alias = {"TakeInjury", "PlyTakeInjury"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target and target:HasInitialized()) then
			local injury = arguments[2];
			
			if cwMedicalSystem.cwInjuryTable[injury] then
				local limb;
			
				for k, v in pairs(cwMedicalSystem.cwHitGroupToString) do
					if v == arguments[3] then
						limb = v;
						break;
					end
				end
				
				if !limb then
					Schema:EasyText(player, "grey",arguments[3].." is not a valid limb!");
				
					return false;
				end

				target:RemoveInjury(cwMedicalSystem.cwStringToHitGroup[limb], injury);
				
				Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has taken a "..injury.." injury from "..target:Name().."'s "..limb.."!");
			else
				Schema:EasyText(player, "grey",arguments[2].." is not a valid injury!");
			end
		else
			Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharClearInjuries");
	COMMAND.tip = "Clear all injuries of a character.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.alias = {"ClearInjuries", "PlyClearInjuries"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target and target:HasInitialized()) then
			target:ResetInjuries();
			
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has cleared all of "..target:Name().."'s injuries!");
		else
			Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharSetBloodLevel");
COMMAND.tip = "Set a character's blood level (0-5000).";
COMMAND.text = "<string Name> <number Blood>";
COMMAND.access = "s";
COMMAND.arguments = 2;
COMMAND.alias = {"SetBloodLevel", "PlySetBloodLevel"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		local bloodLevel = tonumber(arguments[2]);
		local oldBloodLevel = target:GetCharacterData("BloodLevel");
		
		if bloodLevel then
			target:SetBloodLevel(bloodLevel);
			
			if (player != target) then
				Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has set "..target:Name().."'s blood level to "..tostring(bloodLevel)..".");
			else
				Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have set your own blood level to "..tostring(bloodLevel)..".");
			end;
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("CharDiagnose");
	COMMAND.tip = "Diagnose a character for injuries.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.alias = {"Diagnose", "PlyDiagnose"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if cwBeliefs and !player:HasBelief("doctor") then
			Schema:EasyText(player, "chocolate","You lack the required belief to do this!");
			return false;
		end
		
		local target = Clockwork.entity:GetPlayer(player:GetEyeTraceNoCursor().Entity);
		
		if (target) then
			if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
				local bloodLevel = target:GetCharacterData("BloodLevel", cwMedicalSystem.maxBloodLevel);
				local diagnoseString = "You take a good look at "..target:Name()..".";
				local health = target:Health();
				local maxHealth = target:GetMaxHealth();
				local textColorScale = 0;
				
				if target:Alive() then
					if health < maxHealth then
						if health <= maxHealth * 0.25 then
							diagnoseString = diagnoseString.." They appear to be near death.";
							
							textColorScale = math.min(textColorScale + 0.8, 1);
						elseif health <= maxHealth * 0.55 then
							diagnoseString = diagnoseString.." They appear to be badly wounded.";
							
							textColorScale = math.min(textColorScale + 0.5, 1);
						elseif health <= maxHealth * 0.75 then
							diagnoseString = diagnoseString.." They appear to be wounded.";
							
							textColorScale = math.min(textColorScale + 0.25, 1);
						elseif health <= maxHealth * 0.9 then
							diagnoseString = diagnoseString.." They appear to have minor wounds.";
							
							textColorScale = math.min(textColorScale + 0.05, 1);
						end
					end
				
					if target.bleeding then
						local bleedingLimbsData = target:GetCharacterData("BleedingLimbs", {});
						local bleedingLimbs = {};
						
						for k, v in pairs(bleedingLimbsData) do
							if v == true then
								table.insert(bleedingLimbs, k);
								
								textColorScale = math.min(textColorScale + 0.1, 1);
							end
						end
						
						if #bleedingLimbs > 0 then
							if #bleedingLimbs == 1 then
								diagnoseString = diagnoseString.." They are bleeding from their "..bleedingLimbs[1]..".";
							else
								diagnoseString = diagnoseString.." They are bleeding from their ";
								
								for i = 1, #bleedingLimbs do
									if i == 1 then
										diagnoseString = diagnoseString..bleedingLimbs[i];
									elseif i == #bleedingLimbs then
										diagnoseString = diagnoseString..", and "..bleedingLimbs[i];
									else
										diagnoseString = diagnoseString..", "..bleedingLimbs[i];
									end
								end
								
								diagnoseString = diagnoseString..".";
							end
						end
					end
					
					local injuries = cwMedicalSystem:GetInjuries(target);
					
					if injuries then
						for k, v in pairs(injuries) do
							for k2, v2 in pairs(v) do
								if v2 == true then
									local injury = cwMedicalSystem.cwInjuryTable[k2];
								
									if injury and injury.symptom then
										diagnoseString = diagnoseString.." Their "..cwMedicalSystem.cwHitGroupToString[k]..injury.symptom;
										
										textColorScale = math.min(textColorScale + 0.1, 1);
									end
								end
							end
						end
					end
					
					if bloodLevel < cwMedicalSystem.maxBloodLevel - 1250 then
						diagnoseString = diagnoseString.." They look very pale from blood loss.";
						
						textColorScale = math.min(textColorScale + 0.2, 1);
					end
					
					local symptoms = target:GetNetVar("symptoms", {});
					local symptomText;
					
					for i = 1, #symptoms do
						local symptom = symptoms[i];
						
						if symptom == "Paleness" then
							if symptomText then
								symptomText = symptomText.." They look very pale and sickly.";
							else
								symptomText = " They look very pale and sickly.";
							end
						elseif symptom == "Pustules" then
							if symptomText then
								symptomText = symptomText.." They are covered in pustules and buboes, a textbook symptom of the Begotten Plague.";
							else
								symptomText = " They are covered in pustules and buboes, a textbook symptom of the Begotten Plague.";
							end
						elseif symptom == "Deformities" then
							if symptomText then
								symptomText = symptomText.." Their skin is deformed and discolored, and their eyes bulging.";
							else
								symptomText = " Their skin is deformed and discolored, and their eyes bulging.";
							end
						elseif symptom == "Coughing" then
							if symptomText then
								symptomText = symptomText.." They are coughing a great deal.";
							else
								symptomText = " They are coughing a great deal.";
							end
						elseif symptom == "Nausea" then
							if symptomText then
								symptomText = symptomText.." They look mildly disoriented as if afflicted by nausea.";
							else
								symptomText = " They look mildly disoriented as if afflicted by nausea.";
							end
						end
						
						textColorScale = math.min(textColorScale + 0.2, 1);
					end
					
					if symptomText then
						diagnoseString = diagnoseString..symptomText;
					end
					
					if diagnoseString == "You take a good look at "..target:Name().."." then
						diagnoseString = diagnoseString.." They look perfectly healthy.";
					end
					
					Schema:EasyText(player, Color(255 * textColorScale, 255 * (1 - textColorScale), 0), diagnoseString);
				else
					Schema:EasyText(player, "indianred", diagnoseString.." They would appear to be deceased, there is nothing more you can do for them.");
				end
			else
				Schema:EasyText(player, "firebrick", "This character is too far away!");
			end;
		else
			Schema:EasyText(player, "firebrick", "You must look at a character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharGiveDisease");
	COMMAND.tip = "Give a character a disease. Optional argument for stage. (Default = 1)";
	COMMAND.text = "<string Name> <string DiseaseID> [int Stage]";
	COMMAND.access = "s";
	COMMAND.arguments = 2;
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"GiveDisease", "PlyGiveDisease"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		local diseaseID = arguments[2];
		
		if (target and target:HasInitialized()) then
			if diseaseID then
				local diseaseTable = cwMedicalSystem:FindDiseaseByID(diseaseID);
				
				if diseaseTable then
					local stage = tonumber(arguments[3]);
					
					if stage then	
						if not target:HasDisease(diseaseID, stage) then
							if stage > 0 and stage <= #diseaseTable.stages then
								target:GiveDisease(diseaseID, arguments[3]);
								Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", "["..self.name.."] "..target:Name().." has been given the '"..diseaseID.."' disease (Stage "..tostring(stage)..") by "..player:Name().."!", nil);
							else
								Schema:EasyText(player, "grey", "["..self.name.."] You must specify a valid stage for "..diseaseID.."! (1 - "..#diseaseTable.stages..")");
							end
						else
							Schema:EasyText(player, "firebrick","["..self.name.."] "..target:Name().." already has this disease at this stage!");
						end
					else
						if not target:HasDisease(diseaseID) then
							target:GiveDisease(diseaseID);
							Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", "["..self.name.."] "..target:Name().." has been given the '"..diseaseID.."' disease by "..player:Name().."!", nil);
						else
							Schema:EasyText(player, "cornflowerblue","["..self.name.."] "..target:Name().." already has this disease!");
						end
					end
				else
					Schema:EasyText(player, "cornflowerblue","["..self.name.."] "..diseaseID.." is not a valid disease!");
				end
			else
				Schema:EasyText(player, "grey", "["..self.name.."] You must specify a valid disease!");
			end
		else
			Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharTakeDisease");
	COMMAND.tip = "Take a disease from a character.";
	COMMAND.text = "<string Name> <string DiseaseID>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;
	COMMAND.alias = {"TakeDisease", "PlyRemoveDisease", "CharRemoveDisease", "RemoveDisease", "PlyRemoveDisease"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		local diseaseID = arguments[2];
		
		if (target and target:HasInitialized()) then
			if diseaseID then
				if cwMedicalSystem:FindDiseaseByID(diseaseID) then
					if target:HasDisease(diseaseID) then
						target:TakeDisease(diseaseID);
						Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has taken the '"..diseaseID.."' disease from "..target:Name().."!", nil);
					else
						Schema:EasyText(player, "cornflowerblue","["..self.name.."] "..target:Name().." does not have that disease!");
					end
				else
					Schema:EasyText(player, "cornflowerblue","["..self.name.."] "..diseaseID.." is not a valid disease!");
				end
			else
				Schema:EasyText(player, "grey", "["..self.name.."] You must specify a valid disease!");
			end
		else
			Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharTakeAllDiseases");
	COMMAND.tip = "Take all disease from a character.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.alias = {"TakeAllDiseases", "PlyRemoveAllDiseases", "CharRemoveAllDiseases", "RemoveAllDiseases", "PlyRemoveAllDiseases"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		local diseaseID = arguments[2];
		
		if (target and target:HasInitialized()) then
			target:TakeAllDiseases();
		else
			Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharGetDiseases");
	COMMAND.tip = "Display a list of a character's diseases.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.alias = {"GetDiseases", "PlyGetDiseases"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target and target:HasInitialized()) then
			local diseases = target:GetCharacterData("diseases");
			
			if diseases and not table.IsEmpty(diseases) then
				local diseasesStr = "";
				
				for i = 1, #diseases do
					local disease = diseases[i];
					
					if disease then
						local diseaseTable = cwMedicalSystem:FindDiseaseByID(disease.uniqueID);
						
						if diseaseTable then
							diseasesStr = diseasesStr..diseaseTable.name.." (Stage: "..(disease.stage or "1")..") ";
						end
					end
				end
				
				if diseasesStr ~= "" then
					Schema:EasyText(player, "cornflowerblue","["..self.name.."] "..target:Name().." has the following diseases: "..diseasesStr);
				else
					Schema:EasyText(player, "cornflowerblue","["..self.name.."] "..target:Name().." has no diseases!");
				end
			else
				Schema:EasyText(player, "cornflowerblue","["..self.name.."] "..target:Name().." has no diseases!");
			end
		else
			Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharForceVomit");
COMMAND.tip = "Force a character to vomit.";
COMMAND.text = "<string Name> [bool VomitBlood]";
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;
COMMAND.alias = {"ForceVomit", "PlyForceVomit", "MakeVomit", "CharMakeVomit", "PlyMakeVomit"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		if arguments[2] then
			target:Vomit(true);
		else
			target:Vomit();
		end
		
		if (player != target) then
			Schema:EasyText(Schema:GetAdmins(), "olive", "["..self.name.."] "..player:Name().." has made "..target:Name().." vomit.");
		else
			Schema:EasyText(player, "olive", "["..self.name.."] You have made yourself vomit.");
		end;
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();