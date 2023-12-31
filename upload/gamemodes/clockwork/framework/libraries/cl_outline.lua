--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

--[[ We need the plugin library to add this as a module! --]]
if (!plugin) then
	include("clockwork/framework/libraries/sh_plugin.lua")
end

library.New("outline", Clockwork)

-- A function to add an entity outline.
function Clockwork.outline:Add(entity, glowColor, glowSize, bIgnoreZ)
	if (!glowSize) then glowSize = 2; end

	if (type(entity) != "table") then
		entity = {entity}
	end
	
	halo.Add(
		entity, glowColor, glowSize, glowSize, 1, true, bIgnoreZ
	)
end

-- A function to add a fading entity outline.
function Clockwork.outline:Fader(entity, glowColor, iDrawDist, bShowAnyway, tIgnoreEnts, glowSize, bIgnoreZ)
	local fOutlineAlpha = glowColor.a

	if (iDrawDist) then
		local distance = Clockwork.Client:GetPos():Distance(entity:GetPos())
		fOutlineAlpha = fOutlineAlpha - ((fOutlineAlpha / iDrawDist) * math.min(distance, iDrawDist))
	end

	if (!Clockwork.player:CanSeeEntity(Clockwork.Client, entity, 0.9, tIgnoreEnts)
	and !bShowAnyway) then
		fOutlineAlpha = 0
	end

	if (!entity.cwLastOutlineAlpha) then
		entity.cwLastOutlineAlpha = 0
	end

	entity.cwLastOutlineAlpha = math.Approach(
		entity.cwLastOutlineAlpha, fOutlineAlpha, FrameTime() * 64
	)

	if (entity.cwLastOutlineAlpha > 0) then
		self:Add(
			entity, Color(glowColor.r, glowColor.g, glowColor.b, entity.cwLastOutlineAlpha),
			glowSize, bIgnoreZ
		)
	end
end

-- Called when GMod halos should be added.
function Clockwork.outline:PreDrawHalos()
	hook.Run("AddEntityOutlines", self)
end

--[[
	Register the library as a module. We're doing this because
	we want the PreDrawHalos function to be called
	before anything else.
--]]

plugin.Add("Outline", Clockwork.outline)