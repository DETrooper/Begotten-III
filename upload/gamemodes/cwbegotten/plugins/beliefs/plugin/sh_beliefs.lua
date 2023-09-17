--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

library.New("beliefTrees", cwBeliefs);
cwBeliefs.beliefTrees.stored = cwBeliefs.beliefTrees.stored or {};
local BELIEF_TREE = {__index = BELIEF_TREE};

-- Called when the belief tree is converted to a string.
function BELIEF_TREE:__tostring()
	return self.uniqueID;
end;

-- Called when the belief tree is invoked as a function.
function BELIEF_TREE:__call(varName, failSafe)
	return self[varName] or failSafe;
end;

-- A function to register a belief tree.
function BELIEF_TREE:Register()
	cwBeliefs.beliefTrees:Register(self);
end;

-- A function to get a new belief tree.
function cwBeliefs.beliefTrees:New(uniqueID)
	if (!uniqueID) then
		return;
	end;
	
	local object = Clockwork.kernel:NewMetaTable(BELIEF_TREE);
		object.uniqueID = cwBeliefs:SafeName(uniqueID);
	return object;
end;

-- A function to register a belief tree.
function cwBeliefs.beliefTrees:Register(beliefTree)
	if (beliefTree) then
		if (!beliefTree.uniqueID or !beliefTree.beliefs) then
			return;
		end
		
		local tab = {};
		
		tab.uniqueID = cwBeliefs:SafeName(beliefTree.uniqueID);
		tab.name = beliefTree.name or "Beliefs";
		
		if (CLIENT) then
			tab.color = beliefTree.color;
			tab.beliefs = beliefTree.beliefs;
			tab.order = beliefTree.order;
			tab.size = beliefTree.size;
			tab.textures = beliefTree.textures;
			tab.tooltip = beliefTree.tooltip;
			
			if beliefTree.columnPositions then
				tab.columnPositions = beliefTree.columnPositions;
			end
			
			if beliefTree.rowPositions then
				tab.rowPositions = beliefTree.rowPositions;
			end
			
			if beliefTree.headerFontOverride then
				tab.headerFontOverride = beliefTree.headerFontOverride;
			end
			
			for k, v in pairs(tab.beliefs) do
				for k2, v2 in pairs(v) do
					v2.uniqueID = k2;
				end
			end
		else
			tab.beliefs = {};
		
			for i, v in pairs(beliefTree.beliefs) do
				tab.beliefs[i] = {};
				
				for k2, v2 in pairs(v) do
					local beliefTab = {};
					
					beliefTab.uniqueID = k2;
					beliefTab.name = v2.name;
					beliefTab.row = v2.row;
					
					if v2.requirements then
						beliefTab.requirements = v2.requirements;
					end
					
					if v2.subfaith then
						beliefTab.subfaith = v2.subfaith;
					end
					
					if v2.disabled then
						beliefTab.disabled = true
					end
					
					if v2.lockedFactions then
						beliefTab.lockedFactions = v2.lockedFactions;
					end
					
					if v2.lockedSubfactions then
						beliefTab.lockedSubfactions = v2.lockedSubfactions;
					end
					
					if v2.lockedBeliefs then
						beliefTab.lockedBeliefs = v2.lockedBeliefs;
					end
					
					if v2.lockedTraits then
						beliefTab.lockedTraits = v2.lockedTraits;
					end
					
					if v2.requiredFaiths then
						beliefTab.requiredFaiths = v2.requiredFaiths;
					end
				
					tab.beliefs[i][k2] = beliefTab;
				end
			end
		end;
		
		if beliefTree.disabled then
			tab.disabled = true
		else
			if beliefTree.hasFinisher then
				tab.hasFinisher = beliefTree.hasFinisher;
			end
			
			if beliefTree.lockedFactions then
				tab.lockedFactions = beliefTree.lockedFactions;
			end
			
			if beliefTree.lockedSubfactions then
				tab.lockedSubfactions = beliefTree.lockedSubfactions;
			end
			
			if beliefTree.lockedBeliefs then
				tab.lockedBeliefs = beliefTree.lockedBeliefs;
			end
			
			if beliefTree.lockedTraits then
				tab.lockedTraits = beliefTree.lockedTraits;
			end
			
			if beliefTree.requiredFaiths then
				tab.requiredFaiths = beliefTree.requiredFaiths;
			end
		end
		
		self.stored[beliefTree.uniqueID] = tab;
	end;
end;

-- A function to convert a string to a uniqueID.
function cwBeliefs:SafeName(uniqueID)
	return string.lower(string.gsub(uniqueID, "['%.]", ""));
end;

-- A function to get all of the belief trees.
function cwBeliefs:GetBeliefTrees()
	return self.beliefTrees.stored;
end;

-- A function to get all of the beliefs in a tree.
function cwBeliefs:GetBeliefsByTree(beliefTree)
	if beliefTree then
		if isstring(beliefTree) then
			beliefTree = self.beliefTrees.stored[beliefTree];
		end
		
		if beliefTree then
			local beliefsTab = {};
			
			for k, v in pairs(beliefTree.beliefs) do
				for k2, v2 in pairs(v) do
					beliefsTab[k2] = v2;
				end
			end
			
			if beliefTree.hasFinisher then
				beliefsTab[treeID.."_finisher"] = {uniqueID = treeID.."_finisher", name = beliefTree.name.." Finisher", isFinisher = true};
			end
			
			return beliefTree.beliefs;
		end
	end
end;

-- A function to get all of the beliefs.
function cwBeliefs:GetBeliefs()
	local beliefsTab = {};
	
	for k, v in pairs(self.beliefTrees.stored) do
		if v.hasFinisher then
			beliefsTab[k.."_finisher"] = {uniqueID = k.."_finisher", name = v.name.." Finisher", isFinisher = true};
		end
	
		for k2, v2 in pairs(v.beliefs) do
			for k3, v3 in pairs(v2) do
				beliefsTab[k3] = v3;
			end
		end;
	end;
	
	return beliefsTab;
end;

-- A function to get the name of beliefs or multiple beliefs.
function cwBeliefs:GetBeliefName(beliefs, treeID)
	local names;
	
	if istable(beliefs) then
		names = {};
	else
		names = "";
	end

	if treeID then
		local beliefTree = self.beliefTrees.stored[beliefTree];
		
		if (beliefTree) then
			for k, v in pairs(beliefTree.beliefs) do
				for k2, v2 in pairs(v) do
					if isstring(beliefs) then
						if (string.lower(v2.uniqueID) == string.lower(beliefs)) then
							return v2.name;
						end
					else
						if table.HasValue(beliefs, v2.uniqueID) then
							table.insert(names, v2.name);
						end
					end;
				end;
			end;
		end;
		
		return names;
	end;

	for k, v in pairs(self.beliefTrees.stored) do
		for k2, v2 in pairs(v.beliefs) do
			for k3, v3 in pairs(v2) do
				if isstring(beliefs) then
					if (string.lower(v3.uniqueID) == string.lower(beliefs)) then
						return v3.name;
					end
				else
					if table.HasValue(beliefs, v3.uniqueID) then
						table.insert(names, v3.name);
					end
				end;
			end;
		end;
	end;
	
	return names;
end;

-- A function to find a specific belief tree table.
function cwBeliefs:FindBeliefTreeByID(identifier)
	if identifier then
		identifier = string.lower(identifier);
		
		if (self.beliefTrees.stored[identifier]) then
			return self.beliefTrees.stored[identifier];
		else
			for k, v in pairs(self.beliefTrees.stored) do
				if v.uniqueID == identifier or string.lower(v.name) == identifier then
					return self.beliefTrees.stored[k];
				end;
			end;
		end;
	end;
end;

-- A function to find a specific belief tree table by a child belief.
function cwBeliefs:FindBeliefTreeByBelief(identifier)
	if identifier then
		identifier = string.lower(identifier);
		
		for k, v in pairs(self.beliefTrees.stored) do
			for k2, v2 in pairs(v.beliefs) do
				for k3, v3 in pairs(v2) do
					if v3.uniqueID == identifier or string.lower(v3.name) == identifier then
						return v;
					end;
				end
			end;
		end;
	end;
end;


-- A function to find a specific belief table.
function cwBeliefs:FindBeliefByID(identifier, treeID)
	if identifier then
		identifier = string.lower(identifier);
		
		if treeID then
			local beliefTree = self.beliefTrees.stored[beliefTree];
			
			if (beliefTree) then
				for k, v in pairs(cwBeliefs:GetBeliefsByTree(beliefTree)) do
					if v.uniqueID == identifier or string.lower(v.name) == identifier then
						return v;
					end
				end
			end;
		end;

		for k, v in pairs(cwBeliefs:GetBeliefs()) do
			if v.uniqueID == identifier or string.lower(v.name) == identifier then
				return v;
			end
		end
	end;
end;

-- A function to get if a player has the requirements for a belief or not.
function cwBeliefs:ResolveBelief(player, uniqueID, category, playerBeliefs)
	if (!uniqueID and !category) then
		return;
	end;
	
	if !playerBeliefs then
		if SERVER then
			playerBeliefs = player:GetCharacterData("beliefs", {});
		else
			playerBeliefs = self.beliefs;
		end
	end

	if (playerBeliefs[uniqueID]) then
		return false;
	end;
	
	local beliefTree = self:FindBeliefTreeByID(category)
	
	if beliefTree then
		local beliefTable;
		
		for k, v in pairs(beliefTree.beliefs) do
			for k2, v2 in pairs(v) do
				if v2.uniqueID == uniqueID then
					beliefTable = v2;
				
					break;
				end;
			end;
			
			if beliefTable then
				break;
			end
		end;
		
		if beliefTable then
			local requirements = beliefTable.requirements; 

			if requirements then
				for k, v in pairs(requirements) do
					if (!playerBeliefs[v]) then
						return false
					end;
				end
			end;
			
			if self:GetBeliefLocked(player, uniqueID, beliefTree, beliefTable, playerBeliefs) then
				return false;
			end
			
			return true;
		end
	end
	
	return false;
end;

function cwBeliefs:GetBeliefLocked(player, uniqueID, beliefTree, beliefTable, playerBeliefs)
	if beliefTree.disabled or beliefTable.disabled then
		return false;
	end

	local faction = player:GetFaction();
	local subfaction = player:GetSubfaction();
	local faith = player:GetFaith();
	local subfaith = player:GetSubfaith();
	local traits = player:GetTraits();
	
	if beliefTree.lockedBeliefs then
		for i, v in pairs(beliefTree.lockedBeliefs) do
			if playerBeliefs[v] then
				return true;
			end
		end
	end
	
	if beliefTable.lockedBeliefs then
		for i, v in pairs(beliefTable.lockedBeliefs) do
			if playerBeliefs[v] then
				return true;
			end
		end
	end
	
	if beliefTree.lockedTraits then
		for i, v in pairs(beliefTree.lockedTraits) do
			if table.HasValue(traits, v) then
				return true;
			end
		end
	end
	
	if beliefTable.lockedTraits then
		for i, v in pairs(beliefTable.lockedTraits) do
			if table.HasValue(traits, v) then
				return true;
			end
		end
	end
	
	if beliefTree.lockedFactions then
		for i, v in pairs(beliefTree.lockedFactions) do
			if faction == v then
				return true;
			end
		end
	end
	
	if beliefTable.lockedFactions then
		for i, v in pairs(beliefTable.lockedFactions) do
			if faction == v then
				return true;
			end
		end
	end
	
	if beliefTree.lockedSubfactions then
		for i, v in pairs(beliefTree.lockedSubfactions) do
			if subfaction == v then
				return true;
			end
		end
	end
	
	if beliefTable.lockedSubfactions then
		for i, v in pairs(beliefTable.lockedSubfactions) do
			if subfaction == v then
				return true;
			end
		end
	end
	
	if beliefTree.requiredFaiths then
		local faith_found = false;
	
		for i, v in pairs(beliefTree.requiredFaiths) do
			if faith == v then
				faith_found = true;
			
				break;
			end
		end
		
		if not faith_found then
			return true;
		end
	end
	
	if beliefTable.requiredFaiths then
		local faith_found = false;
	
		for i, v in pairs(beliefTable.requiredFaiths) do
			if faith == v then
				faith_found = true;
			
				break;
			end
		end
		
		if not faith_found then
			return true;
		end
	end
	
	if beliefTable.subfaith and subfaith and subfaith ~= "N/A" and subfaith ~= beliefTable.subfaith then
		return true;
	end
	
	if player:HasBelief("jack_of_all_trades") then
		if (beliefTable.row >= 4 and !beliefTable.subfaith) then
			return true;
		elseif beliefTable.isFinisher then
			-- Check to see if there are any tier 4 beliefs in this belief tree.
			for k, v in pairs(beliefTree.beliefs) do
				for k2, v2 in pairs(v) do
					if v2.row >= 4 then
						return true;
					end
				end
			end
		end
	end
	
	return false;
end

plugin.AddExtra("belieftrees");