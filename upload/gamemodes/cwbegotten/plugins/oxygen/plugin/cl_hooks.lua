--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

function cwOxygen:PlayerCharacterInitialized(data)
	local oxygen = Clockwork.Client:GetNetVar("oxygen") or 100;
	
	self.oxygen = oxygen;
end

-- Called when the bars are needed.
function cwOxygen:GetBars(bars)
	local oxygen = Clockwork.Client:GetNetVar("oxygen");
	local frameTime = FrameTime();
	
	if (oxygen) then
		if (!self.oxygen) then
			self.oxygen = oxygen;
		elseif (oxygen != self.oxygen) then
			self.oxygen = math.Approach(self.oxygen, oxygen, frameTime * (16 * math.Clamp(((self.oxygen - oxygen) / 10), 1, 10)));
		end;
		
		if (oxygen < 100) then
			bars:Add("OXYGEN", Color(50, 50, 255), "OXYGEN", self.oxygen, 100, self.oxygen < 10);
		end;
	end;
end;

Clockwork.datastream:Hook("Drown", function(data)
	if (data == true) then
		Clockwork.Client:EmitSound("begotten/score6.mp3", 500);
		Schema:AddBlackFade(10);
	end
	
	Schema.cwDrownEffect = 5;
	Schema:SanityZoom(0.075);
end);