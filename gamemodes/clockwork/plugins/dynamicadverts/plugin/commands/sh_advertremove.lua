--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local COMMAND = Clockwork.command:New("AdvertRemove")
COMMAND.tip = "Remove a dynamic advert."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local position = player:GetEyeTraceNoCursor().HitPos
	local removed = 0

	for k, v in pairs(cwDynamicAdverts.storedList) do
		if (v.position:Distance(position) <= 256) then
			netstream.Start(nil, "DynamicAdvertRemove", v.position)
				table.remove(cwDynamicAdverts.storedList, k)
			removed = removed + 1
		end
	end

	if (removed > 0) then
		if (removed == 1) then
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..removed.." dynamic advert.")
		else
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..removed.." dynamic adverts.")
		end
	else
		Schema:EasyText(player, "darkgrey", "["..self.name.."] There were no dynamic adverts near this position.")
	end

	cwDynamicAdverts:SaveDynamicAdverts()
end

COMMAND:Register()