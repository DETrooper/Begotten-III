--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("menuitems", Clockwork)
Clockwork.menuitems.stored = Clockwork.menuitems.stored or {}

-- A function to get a menu item.
function Clockwork.menuitems:Get(text)
	for k, v in pairs(self.stored) do
		if (v.text == text) then
			return v
		end
	end
end

-- A function to add a menu item.
function Clockwork.menuitems:Add(text, panel, tip, iconData, icon_path)
	self.stored[#self.stored + 1] = {text = text, panel = panel, tip = tip, iconData = iconData, icon_path = icon_path}
end

-- A function to destroy a menu item.
function Clockwork.menuitems:Destroy(text)
	for k, v in pairs(self.stored) do
		if (v.text == text) then
			table.remove(self.stored, k)
		end
	end
end