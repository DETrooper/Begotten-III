--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("bars", Clockwork)

Clockwork.bars.x = 0
Clockwork.bars.y = 0
Clockwork.bars.width = 0
Clockwork.bars.height = 16
Clockwork.bars.padding = 18
Clockwork.bars.stored = Clockwork.bars.stored or {}

-- A function to get a top bar.
function Clockwork.bars:FindByID(uniqueID)
	for k, v in ipairs(self.stored) do
		if (v.uniqueID == uniqueID) then
			return v
		end
	end
end

-- A function to add a top bar.
function Clockwork.bars:Add(uniqueID, color, text, value, maximum, flash, priority, precedingVal)
	table.insert(self.stored, {
		uniqueID = uniqueID,
		priority = priority or 0,
		maximum = maximum,
		color = color,
		class = class,
		value = value,
		precedingVal = precedingVal,
		flash = flash,
		text = text,
	})
end

-- A function to destroy a top bar.
function Clockwork.bars:Destroy(uniqueID)
	for k, v in ipairs(self.stored) do
		if (v.uniqueID == uniqueID) then
			table.remove(self.stored, k)
		end
	end
end