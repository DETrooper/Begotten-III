--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local COMMAND = Clockwork.command:New("SalesmanAdd")
COMMAND.tip = "Add a salesman at your target position."
COMMAND.text = "[number Animation]"
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "s"
COMMAND.optionalArguments = 1

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	player.cwSalesmanSetup = true
	player.cwSalesmanAnim = tonumber(arguments[1])
	player.cwSalesmanHitPos = player:GetEyeTraceNoCursor().HitPos

	if (!player.cwSalesmanAnim and type(arguments[1]) == "string") then
		player.cwSalesmanAnim = tonumber(_G[arguments[1]])
	end

	netstream.Start(player, "SalesmanAdd", true)
end

COMMAND:Register()