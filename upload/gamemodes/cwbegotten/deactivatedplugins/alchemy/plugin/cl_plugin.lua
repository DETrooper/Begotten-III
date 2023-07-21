--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

-- Called when the post progress bar info is needed.
function cwAlchemy:GetPostProgressBarInfo()
	if (Clockwork.Client:Alive()) then
		local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);
		
		if (action == "transferring_contents_container") then
			return {text = "You are transferring the contents of one container to another.", percentage = percentage, flash = percentage > 75};
		elseif (action == "transferring_contents_dissolvable") then
			return {text = "You are transferring a dissolvable to a container.", percentage = percentage, flash = percentage > 75};
		elseif (action == "patting_out_fire") then
			return {text = "You are trying to pat out a fire!", percentage = percentage, flash = percentage > 75};
		end;
	end;
end;