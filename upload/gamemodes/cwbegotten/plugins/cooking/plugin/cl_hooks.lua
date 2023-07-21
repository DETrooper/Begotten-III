--[[
	B3 Jessu Weep
--]]

-- Called when an entity's menu options are needed.
function cwCooking:GetEntityMenuOptions(entity, options)
end;

-- Called when the post progress bar info is needed.
function cwCooking:GetPostProgressBarInfo()
	--[[
	local alive = Clockwork.Client:Alive();
	
	if (alive) then
		local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);

		if (action == "hide") then
			return {text = "You are hiding in the closet.", percentage = percentage, flash = percentage > 75};
		end;
		
		if (action == "unhide") then
			return {text = "You are coming out of the closet.", percentage = percentage, flash = percentage > 75};
		end;
	end;
	--]]
end;