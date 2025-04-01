--[[
	Begotten III: Jesus Wept
--]]

-- A function to load the surface texts.
function cwSurfaceTexts:LoadSurfaceTexts()
	self.storedList = Clockwork.kernel:RestoreSchemaData("plugins/texts/"..game.GetMap());
end;

-- A function to save the surface texts.
function cwSurfaceTexts:SaveSurfaceTexts()
	Clockwork.kernel:SaveSchemaData("plugins/texts/"..game.GetMap(), self.storedList);
end;