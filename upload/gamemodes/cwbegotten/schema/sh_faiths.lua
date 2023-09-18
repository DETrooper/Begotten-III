--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

library.New("faiths", Schema);
Schema.faiths.stored = Schema.faiths.stored or {};
local FAITHS = {__index = FAITHS};

-- Called when the faith is converted to a string.
function FAITHS:__tostring()
	return self.uniqueID;
end;

-- Called when the faith is invoked as a function.
function FAITHS:__call(varName, failSafe)
	return self[varName] or failSafe;
end;

-- A function to register a faith..
function FAITHS:Register()
	Schema.faiths:Register(self);
end;

-- A function to get a new faith.
function Schema.faiths:New(uniqueID)
	if (!uniqueID) then
		return;
	end;
	
	local object = Clockwork.kernel:NewMetaTable(FAITHS);
		object.uniqueID = Schema.faiths:SafeName(uniqueID);
	return object;
end;

-- A function to register a faith.
function Schema.faiths:Register(faith)
	if (faith) then
		if (!faith.uniqueID) then
			return;
		end
		
		local tab = {};
		
		if (CLIENT) then
			tab = table.Copy(faith);
		else
			tab.uniqueID = faith.uniqueID;
			tab.name = faith.name or "Faith";
			tab.subfaiths = faith.subfaiths;
		end
		
		self.stored[faith.uniqueID] = tab;
	end;
end;

-- A function to convert a string to a uniqueID.
function Schema.faiths:SafeName(uniqueID)
	return string.lower(string.gsub(uniqueID, "['%.]", ""));
end;

-- A function to get all of the faiths.
function Schema.faiths:GetFaiths()
	return self.stored;
end;

-- A function to find a specific faith.
function Schema.faiths:GetFaith(identifier)
	if identifier then
		identifier = string.lower(identifier);
		
		if (self.stored[identifier]) then
			return self.stored[identifier];
		else
			for k, v in pairs(self.stored) do
				if v.uniqueID == identifier or string.lower(v.name) == identifier then
					return self.stored[k];
				end;
			end;
		end;
	end;
end;

local LIGHT = Schema.faiths:New("light")
	LIGHT.name = "Faith of the Light";
	LIGHT.color = Color(230, 209, 87, 255);
	LIGHT.subfaiths = {"Sol Orthodoxy", "Hard-Glazed", "Voltism"};
	
	-- for character creation
	LIGHT.description = "The Faith of the Light, also known as the Hard-Glaze or shortened to the Glaze, is a collection of ideas and beliefs widely held by most in the territory of the now-extinct Empire of Light. The faith is said to have originated during the hundred years of hardship, until it finally sparked the Holy Hierarchy Wars that led to the ultimate creation of said government. \n\nThe vast majority of those who follow and practice the Faith of the Light have only a simplistic and vague understanding of it. Common folk, far secluded from the workings of government, often create their own interpretations that are vastly different from official text. Indeed the true understanding of the Glaze is extremely complex, often intermixing philosophical inquiries, works of abstract art, and even some advanced mathematical equations. The 'Unenlightened Fucklets', critics of Glazic ways, often claim that the reason why the Glaze is so hard to understand is so that commoners will be unable to comprehend it, and thus cannot question their lord's command.\n\nAlthough the teachings of the Glaze are spread out among many thousands of old scriptures, there supposedly exists a singular Manifesto - the original first text of Glaze. Although many artifact searches have been commissioned by various clergymen, no man alive knows the whereabouts of this holy relic. A popular saying among the Holy Hierarchy is that \"All links to the manifesto...\".";
	LIGHT.image = "begotten/ui/bgtbtnfaithlight.png";
Schema.faiths:Register(LIGHT)

local FAMILY = Schema.faiths:New("family")
	FAMILY.name = "Faith of the Family";
	FAMILY.color = Color(163, 153, 143, 255);
	FAMILY.subfaiths = {"Faith of the Father", "Faith of the Mother", "Faith of the Old Son", "Faith of the Young Son", "Faith of the Sister"};
	
	-- for character creation
	FAMILY.description = "The Faith of the Family is a form of polytheism that is followed by the Gores and many scrapper bands. The original founders of this religion were the Blade Druids, named after their ability to forge steel weapons. It is said that these Druids planted a seed in the ground that sprouted a great and glorious tree that reached far into the sky. The Gores of this time were godless men, killing each other with bone clubs and sharp sticks as the North was too harsh a place for any progress to be made. When they came to the Great Tree, the Blade Druids taught them their ways, which included the belief of the Five Gods.\n\nAlthough these druids were soon betrayed by the savage Gores and the true names of the Five Gods forgotten, they live on as the Family: The Mother, the Father, the Old Son, the Sister, and the Young Son. Ever since the burning of the Great Tree at the hands of Lord Maximus, the remaining Gores have united with the singular purpose of avenging their tree. When the God of the Light committed suicide shortly after, his fractured power rained over the Great Tree, granting it a slither of life. Now the Gores have a glimpse of hope to keep their tree from dying through blood sacrifices, though it takes hundreds of corpses a year to simply remain alive.";
	FAMILY.image = "begotten/ui/bgtbtnfaithfamily.png";
Schema.faiths:Register(FAMILY)

local DARK = Schema.faiths:New("dark")
	DARK.name = "Faith of the Dark";
	DARK.color = Color(137, 0, 0, 255);
	DARK.subfaiths = {"Primevalism", "Satanism"};
	
	-- for character creation
	DARK.description = "The Faith of the Dark is the name given to the truest belief of all. Mankind made the choice to bar themselves of pleasure for the hope of something more, a sort of justification behind their misery. They made the mistake of following the Light, something that exists only to draw men astray from their true desires. Those men pray to a god that never listens, a god that is dead in more ways than one. They believe that they should suffer a life of misery and pain for an afterlife of bliss and ignorance. The Faith of the Dark is the inverse of that belief.\n\nThe Faith of the Dark has existed in secret for thousands of years, yet there had never been a true Legion under its rule until the coming of the Undergod, when its followers had finally decided it was time to come out of hiding. There were also those who worshipped Satan unknowingly, their own gods being twisted manifestations of his presence. No one truly knows which of the Gods were real and which were merely proxies of the Dark One. Far to the East of the lands of the Empire of Light was the vast Nigerii Empire, divided into feuding states ruled by many princes. This Empire is often considered by Hierarchy sources as the first Dark Legion, for all their Gods were puppets or intermediate forms of Satan. However, with the coming of the Undergod this entire landscape was devoured, proving no match to the might of Satan's nemesis.";
	DARK.image = "begotten/ui/bgtbtnfaithdark.png";
Schema.faiths:Register(DARK)

local COMMAND = Clockwork.command:New("CharTransferFaith");
	COMMAND.tip = "Transfer a character to a faith.";
	COMMAND.text = "<string Name> <string Faith>";
	COMMAND.access = "o";
	COMMAND.arguments = 2;
	COMMAND.alias = {"TransferFaith", "PlyTransferFaith"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local faith = string.gsub(arguments[2], "\"", "");
			local faithTable = Schema.faiths:GetFaith(faith);
			
			if faithTable then
				if target:GetFaith() ~= faithTable.name then
					local name = target:Name();

					if cwBeliefs then
						local beliefTrees = cwBeliefs.beliefTrees.stored;
						local targetBeliefs = target:GetCharacterData("beliefs", {});
						local oldFaith = target:GetFaith();
						local points = target:GetCharacterData("points", 0);
						
						for k, beliefTree in pairs(beliefTrees) do
							if beliefTree.requiredFaiths and table.HasValue(beliefTree.requiredFaiths, oldFaith) then
								for k2, v2 in pairs(beliefTree.beliefs) do
									for k3, v3 in pairs(v2) do
										for k4, v4 in pairs(targetBeliefs) do
											if k3 == k4 and v4 == true then
												targetBeliefs[k4] = false;
												points = points + 1;
											end
										end
									end
								end
								
								if beliefTree.hasFinisher and targetBeliefs[k.."_finisher"] then
									targetBeliefs[k.."_finisher"] = false;
								end
							end
						end
						
						target:SetCharacterData("beliefs", targetBeliefs);
						target:SetCharacterData("points", points);
					end
					
					target:SetCharacterData("Faith", faithTable.name, true);
					target:GetCharacter().subfaith = nil;
					
					Clockwork.player:LoadCharacter(target, Clockwork.player:GetCharacterID(target));
					Clockwork.player:NotifyAll(player:Name().." has transferred "..name.." to the "..faithTable.name.." faith.");
				else
					Clockwork.player:Notify(player, target:GetName().." is already a member of the "..faithTable.name.." faith!");
				end
			else
				Clockwork.player:Notify(player, arguments[2].." is not a valid faith!");
			end
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();