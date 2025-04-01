--[[
	Begotten III: Jesus Wept
--]]

function cwCharacterNeeds:ClockworkAddSharedVars(globalVars, playerVars)
	for i = 1, #self.Needs do
		playerVars:Number(self.Needs[i], true);
	end;
end;