--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("hint", Clockwork)

local stored = Clockwork.hint.stored or {}
Clockwork.hint.stored = stored

--[[
	@codebase Server
	@details Add a new hint to the list.
	@param String A unique identifier.
	@param String The body of the hint.
	@param Function A callback with the player as an argument, return false to hide.
--]]
function Clockwork.hint:Add(name, text, Callback)
	stored[name] = {
		Callback = Callback,
		text = text
	}
end

--[[
	@codebase Server
	@details Remove an existing hint from the list.
	@param String A unique identifier.
--]]
function Clockwork.hint:Remove(name)
	stored[name] = nil
end

--[[
	@codebase Server
	@details Find a hint by its identifier.
	@param String A unique identifier.
	@returns Table The hint table matching the identifier.
--]]
function Clockwork.hint:Find(name)
	return stored[name]
end

-- Clear visible hints for a player.
function Clockwork.hint:Clear(player)
	netstream.Start(player, "ClearHints");
end

--[[
	@codebase Server
	@details Distribute a hint to each player.
--]]
function Clockwork.hint:Distribute()
	local hintText, Callback = self:Get()
	local hintInterval = config.Get("hint_interval"):Get()

	if (!hintText) then return end

	for k, v in ipairs(_player.GetAll()) do
		if (v:HasInitialized() and v:GetInfoNum("cwShowHints", 1) == 1
		and !v:IsViewingStarterHints()) then
			if (!Callback or Callback(v) != false) then
				self:Send(v, hintText, 6, nil, true)
			end
		end
	end
end

--[[
	@codebase Server
	@details Send customized and centered hint text to a player.
	@param Player The recipient(s).
	@param String The hint text to send.
	@param Float The delay before it fades.
	@param Color The color of the hint text.
	@option Bool:String Specify a custom sound or false for no sound.
	@option Bool Specify wether to display duplicates of this hint.
--]]
function Clockwork.hint:SendCenter(player, text, delay, color, bNoSound, showDuplicated)
	netstream.Start(player, "Hint", {
		text = Clockwork.kernel:ParseData(text),
		delay = delay,
		color = color,
		center = true,
		noSound = bNoSound,
		showDuplicates = showDuplicated
	})
end

--[[
	@codebase Server
	@details Send customized and centered hint text to all players.
	@param String The hint text to send.
	@param Float The delay before it fades.
	@param Color The color of the hint text.
--]]
function Clockwork.hint:SendCenterAll(text, delay, color)
	for k, v in ipairs(_player.GetAll()) do
		if (v:HasInitialized()) then
			self:SendCenter(v, text, delay, color)
		end
	end
end

--[[
	@codebase Server
	@details Send customized hint text to a player.
	@param Player The recipient(s).
	@param String The hint text to send.
	@param Float The delay before it fades.
	@param Color The color of the hint text.
	@option Bool:String Specify a custom sound or false for no sound.
	@option Bool Specify wether to display duplicates of this hint.
--]]
function Clockwork.hint:Send(player, text, delay, color, bNoSound, showDuplicated)
	netstream.Start(player, "Hint", {
		text = Clockwork.kernel:ParseData(text), delay = delay, color = color, noSound = bNoSound, showDuplicates = showDuplicated
	})
end

--[[
	@codebase Server
	@details Send customized hint text to all players.
	@param String The hint text to send.
	@param Float The delay before it fades.
	@param Color The color of the hint text.
--]]
function Clockwork.hint:SendAll(text, delay, color)
	for k, v in ipairs(_player.GetAll()) do
		if (v:HasInitialized()) then
			self:Send(v, text, delay, color)
		end
	end
end

--[[
	@codebase Server
	@details Pick a random hint from the list.
	@returns String The random hint text.
	@returns Function The random hint callback.
--]]
function Clockwork.hint:Get()
	local hints = {}

	for k, v in pairs(stored) do
		if (!v.Callback or v.Callback() != false) then
			hints[#hints + 1] = v
		end
	end

	if (#hints > 0) then
		local hint = hints[math.random(1, #hints)]

		if (hint) then
			return hint.text, hint.Callback
		end
	end
end
