--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- Called when Clockwork has loaded all of the entities.
function cwDoorCmds:ClockworkInitPostEntity()
	self:LoadParentData()
	self:LoadDoorData()

	if (config.Get("doors_save_state"):Get()) then
		self:LoadDoorStates()
	end
end

function cwDoorCmds:PostSaveData()
	if (config.Get("doors_save_state"):Get() and #player.GetAll() > 0) then
		self:SaveDoorStates()
	end
end