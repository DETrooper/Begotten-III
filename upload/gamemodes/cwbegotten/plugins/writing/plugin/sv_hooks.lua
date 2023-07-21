--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local PLUGIN = PLUGIN;

-- Called when an entity's menu option should be handled.
function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	local class = entity:GetClass();
	
	if (class == "cw_paper" and arguments == "cw_paperOption") then
		if (entity.text) then
			if cwBeliefs and !player:HasBelief("literacy") then
				Schema:EasyText(player, "chocolate", "You are not literate!");
			
				return false;
			end
		
			if (!player.paperIDs or !player.paperIDs[entity.uniqueID]) then
				if (!player.paperIDs) then
					player.paperIDs = {};
				end;
				
				player.paperIDs[entity.uniqueID] = true;
				
				Clockwork.datastream:Start(player, "ViewPaper", {entity, entity.uniqueID, entity.text});
			else
				Clockwork.datastream:Start(player, "ViewPaper", {entity, entity.uniqueID});
			end;
		else
			if cwBeliefs and !player:HasBelief("literacy") then
				Schema:EasyText(player, "chocolate", "You are not literate!");
			
				return false;
			end
			
			if player:HasItemByID("quill") then
				Clockwork.datastream:Start(player, "EditPaper", entity);
			else
				Schema:EasyText(player, "chocolate", "You need a quill to write on paper!");
				
				return false;
			end
		end;
	end;
end;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	self:LoadPaper();
end;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
	self:SavePaper();
end;