--[[
	Begotten III: Jesus Wept
--]]

-- Called when Clockwork has loaded all of the entities.
function cwStaticEnts:ClockworkInitPostEntity()
	self:LoadStaticEnts();
end;

-- Called just after data should be saved.
function cwStaticEnts:PostSaveData()
	if (#player.GetAll() > 0) then
		self:SaveStaticEnts();
	end;
end;