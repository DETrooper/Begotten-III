--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

-- Called when an entity's menu options are needed.
function cwContainerHiding:GetEntityMenuOptions(entity, options)
	local class = entity:GetClass();
	
	if (class == "prop_physics") then
		local model = entity:GetModel();
		
		if (table.HasValue(self.containerProps["white"], string.lower(model)) or table.HasValue(self.containerProps["black"], string.lower(model))) then
			if (entity:GetNWBool("unlocked", true) == true) then
				if (Clockwork.Client:GetNetVar("hidden")) then
					options["Open"] = nil;
					options["Unhide"] = "cw_entityUnHide";
				else
					if (game.GetMap() != "rp_begotten3") then
						return;
					end;
					
					options["Hide"] = "cw_entityHide";
				end;
			end
		end;
	end;
end;

-- Called when the post progress bar info is needed.
function cwContainerHiding:GetProgressBarInfoAction(action, percentage)
	if (action == "hide") then
		return {text = "You are hiding in the closet. Click to cancel.", percentage = percentage, flash = percentage > 75};
	end;
	
	if (action == "unhide") then
		return {text = "You are coming out of the closet. Click to cancel.", percentage = percentage, flash = percentage > 75};
	end;
end;