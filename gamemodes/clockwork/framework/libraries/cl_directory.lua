--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

if (Clockwork.directory) then return end

library.New("directory", Clockwork)

Clockwork.directory.stored = Clockwork.directory.stored or {}

-- A function to get the directory panel.
function Clockwork.directory:GetPanel()
	return self.panel
end

function Clockwork.directory:AddCategory(name, description, adminOnly)
	Clockwork.directory.stored[name] = {
		adminOnly = adminOnly or false,
		description = description,
		pages = {},
	};
end

function Clockwork.directory:AddPage(category, name, parent, panel)
	local stored = Clockwork.directory.stored[category];
	
	if stored then
		stored.pages[name] = {
			parent = parent,
			panel = panel,
		};
	end
end