--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("TargetPlayerText", Clockwork)

Clockwork.TargetPlayerText.stored = Clockwork.TargetPlayerText.stored or {}

-- A function to add some target player text.
function Clockwork.TargetPlayerText:Add(uniqueID, text, color, scale)
	self.stored[#self.stored + 1] = {
		uniqueID = uniqueID,
		color = color,
		scale = scale,
		text = text
	}
end

-- A function to get some target player text.
function Clockwork.TargetPlayerText:Get(uniqueID)
	for k, v in pairs(self.stored) do
		if (v.uniqueID == uniqueID) then
			return v
		end
	end
end

-- A function to destroy some target player text.
function Clockwork.TargetPlayerText:Destroy(uniqueID)
	for k, v in pairs(self.stored) do
		if (v.uniqueID == uniqueID) then
			table.remove(self.stored, k)
		end
	end
end