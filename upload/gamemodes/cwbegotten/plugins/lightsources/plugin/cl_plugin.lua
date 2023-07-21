--[[
	Begotten III: Jesus Wept
--]]

-- A function to get the oil text.
function cwLantern:GetOilText()
	local oil = Clockwork.Client:GetSharedVar("oil", 0);
	local text = "No Information";

	if (oil) then
		if (oil <= 100 and oil >= 60) then
			text = "Full";
		elseif (oil < 60 and oil >= 15) then
			text = "Waning...";
		elseif (oil < 15 and oil >= 1) then
			text = "Running on Fumes...";
		elseif (oil <= 0) then
			text = "Out of Oil...";
		end;
	end;
	
	return text;
end;