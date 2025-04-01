--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- A function to load the dynamic adverts.
function cwDynamicAdverts:LoadDynamicAdverts()
	self.storedList = Clockwork.kernel:RestoreSchemaData("plugins/adverts/"..game.GetMap())
end

-- A function to save the dynamic adverts.
function cwDynamicAdverts:SaveDynamicAdverts()
	Clockwork.kernel:SaveSchemaData("plugins/adverts/"..game.GetMap(), self.storedList)
end