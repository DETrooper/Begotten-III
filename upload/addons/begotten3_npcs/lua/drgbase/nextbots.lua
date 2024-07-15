-- Registry --

function DrGBase.AddNextbotMixins(ENT)
	if isfunction(ENT.OnTraceAttack) then
		local old_OnTraceAttack = ENT.OnTraceAttack
		function ENT:OnTraceAttack(...)
			local res = self:_HandleTraceAttack(...)
			if res ~= nil then return res end
			return old_OnTraceAttack(self, ...)
		end
	end
	if isfunction(ENT.OnNavAreaChanged) then
		local old_OnNavAreaChanged = ENT.OnNavAreaChanged
		function ENT:OnNavAreaChanged(...)
			local res = self:_HandleNavAreaChanged(...)
			if res ~= nil then return res end
			return old_OnNavAreaChanged(self, ...)
		end
	end
	if isfunction(ENT.OnLeaveGround) then
		local old_OnLeaveGround = ENT.OnLeaveGround
		function ENT:OnLeaveGround(...)
			local res = self:_HandleLeaveGround(...)
			if res ~= nil then return res end
			return old_OnLeaveGround(self, ...)
		end
	end
	if isfunction(ENT.OnLandOnGround) then
		local old_OnLandOnGround = ENT.OnLandOnGround
		function ENT:OnLandOnGround(...)
			local res = self:_HandleLandOnGround(...)
			if res ~= nil then return res end
			return old_OnLandOnGround(self, ...)
		end
	end
	if isfunction(ENT.OnTakeDamage) then
		local old_TakeDamage = ENT.OnTakeDamage
		function ENT:OnTakeDamage(dmg, hitgroup)
			if not isnumber(hitgroup) then return end
			return old_TakeDamage(self, dmg, hitgroup)
		end
	end
end

function DrGBase.AddNextbot(ENT)
	local class = string.Replace(ENT.Folder, "entities/", "")
	if ENT.PrintName == nil or ENT.Category == nil then return false end
	for i, model in ipairs(ENT.Models or {}) do
		if not isstring(model) then continue end
		util.PrecacheModel(model)
	end
	for i, sounds in ipairs({
		ENT.OnSpawnSounds,
		ENT.OnIdleSounds,
		ENT.OnDamageSounds,
		ENT.OnDeathSounds
	}) do
		if not istable(sounds) then continue end
		for h, soundName in ipairs(sounds) do
			if not isstring(soundName) then continue end
			util.PrecacheSound(soundName)
		end
	end
	if CLIENT then
		language.Add(class, ENT.PrintName)
		ENT.Killicon = ENT.Killicon or {
			icon = "HUD/killicons/default",
			color = Color(255, 80, 0, 255)
		}
		killicon.Add(class, ENT.Killicon.icon, ENT.Killicon.color)
	else
		resource.AddFile("materials/entities/"..class..".png")
		DrGBase.AddNextbotMixins(ENT)
	end
	local nextbot = {
		Name = ENT.PrintName,
		Class = class,
		Category = ENT.Category
	}
	if ENT.Spawnable ~= false then
		list.Set("NPC", class, nextbot)
		list.Set("DrGBaseNextbots", class, nextbot)
	end
	DrGBase.Print("Nextbot '"..class.."': loaded.")
	return true
end

hook.Add("PopulateDrGBaseSpawnmenu", "AddDrGBaseNextbots", function(pnlContent, tree, node)
	local list = list.Get("DrGBaseNextbots")
	local categories = {}
	for class, ent in pairs(list) do
		local category = ent.Category or "Other"
		local tab = categories[category] or {}
		tab[class] = ent
		categories[category] = tab
	end
	local nextbotsTree = tree:AddNode("Nextbots", "icon16/monkey.png")
	for categoryName, category in SortedPairs(categories) do
		local icon = DrGBase.GetIcon(categoryName) or "icon16/monkey.png"
		if categoryName == "DrGBase" then icon = DrGBase.Icon end
		local node = nextbotsTree:AddNode(categoryName, icon)
		node.DoPopulate = function(self)
			if self.PropPanel then return end
			self.PropPanel = vgui.Create("ContentContainer", pnlContent)
			self.PropPanel:SetVisible(false)
			self.PropPanel:SetTriggerSpawnlistChange(false)
			for class, ent in SortedPairsByMemberValue(category, "Name") do
				spawnmenu.CreateContentIcon("npc", self.PropPanel, {
					nicename	= ent.Name or class,
					spawnname	= class,
					material = "entities/"..class..".png",
					admin	= ent.AdminOnly or false
				})
			end
		end
		node.DoClick = function(self)
			self:DoPopulate()
			pnlContent:SwitchPanel(self.PropPanel)
		end
	end
	local firstNode = tree:Root():GetChildNode(0)
	if IsValid(firstNode) then
		firstNode:InternalDoClick()
	end
end)

-- Misc --

DrGBase._SpawnedNextbots = DrGBase._SpawnedNextbots or {}
function DrGBase.GetNextbots()
	return DrGBase._SpawnedNextbots
end

DrGBase.DefaultFootsteps = {
	[MAT_ANTLION] = {
		"physics/flesh/flesh_impact_hard1.wav",
		"physics/flesh/flesh_impact_hard2.wav",
		"physics/flesh/flesh_impact_hard3.wav",
		"physics/flesh/flesh_impact_hard4.wav",
		"physics/flesh/flesh_impact_hard5.wav",
		"physics/flesh/flesh_impact_hard6.wav"
	},
	[MAT_BLOODYFLESH] = {
		"physics/flesh/flesh_squishy_impact_hard1.wav",
		"physics/flesh/flesh_squishy_impact_hard2.wav",
		"physics/flesh/flesh_squishy_impact_hard3.wav",
		"physics/flesh/flesh_squishy_impact_hard4.wav"
	},
	[MAT_CONCRETE] = {
		"player/footsteps/concrete1.wav",
		"player/footsteps/concrete2.wav",
		"player/footsteps/concrete3.wav",
		"player/footsteps/concrete4.wav"
	},
	[MAT_DIRT] = {
		"player/footsteps/dirt1.wav",
		"player/footsteps/dirt2.wav",
		"player/footsteps/dirt3.wav",
		"player/footsteps/dirt4.wav"
	},
	[MAT_EGGSHELL] = {
		"physics/flesh/flesh_impact_hard1.wav",
		"physics/flesh/flesh_impact_hard2.wav",
		"physics/flesh/flesh_impact_hard3.wav",
		"physics/flesh/flesh_impact_hard4.wav",
		"physics/flesh/flesh_impact_hard5.wav",
		"physics/flesh/flesh_impact_hard6.wav"
	},
	[MAT_FLESH] = {
		"physics/flesh/flesh_impact_hard1.wav",
		"physics/flesh/flesh_impact_hard2.wav",
		"physics/flesh/flesh_impact_hard3.wav",
		"physics/flesh/flesh_impact_hard4.wav",
		"physics/flesh/flesh_impact_hard5.wav",
		"physics/flesh/flesh_impact_hard6.wav"
	},
	[MAT_GRATE] = {
		"player/footsteps/chainlink1.wav",
		"player/footsteps/chainlink2.wav",
		"player/footsteps/chainlink3.wav",
		"player/footsteps/chainlink4.wav"
	},
	[MAT_ALIENFLESH] = {
		"physics/flesh/flesh_impact_hard1.wav",
		"physics/flesh/flesh_impact_hard2.wav",
		"physics/flesh/flesh_impact_hard3.wav",
		"physics/flesh/flesh_impact_hard4.wav",
		"physics/flesh/flesh_impact_hard5.wav",
		"physics/flesh/flesh_impact_hard6.wav"
	},
	[MAT_SNOW] = {
		"player/footsteps/grass1.wav",
		"player/footsteps/grass2.wav",
		"player/footsteps/grass3.wav",
		"player/footsteps/grass4.wav"
	},
	[MAT_PLASTIC] = {
		"physics/plastic/plastic_box_impact_soft1.wav",
		"physics/plastic/plastic_box_impact_soft2.wav",
		"physics/plastic/plastic_box_impact_soft3.wav",
		"physics/plastic/plastic_box_impact_soft4.wav"
	},
	[MAT_METAL] = {
		"player/footsteps/metal1.wav",
		"player/footsteps/metal2.wav",
		"player/footsteps/metal3.wav",
		"player/footsteps/metal4.wav"
	},
	[MAT_SAND] = {
		"player/footsteps/sand1.wav",
		"player/footsteps/sand2.wav",
		"player/footsteps/sand3.wav",
		"player/footsteps/sand4.wav"
	},
	[MAT_FOLIAGE] = {
		"player/footsteps/grass1.wav",
		"player/footsteps/grass2.wav",
		"player/footsteps/grass3.wav",
		"player/footsteps/grass4.wav"
	},
	[MAT_COMPUTER] = {
		"player/footsteps/metal1.wav",
		"player/footsteps/metal2.wav",
		"player/footsteps/metal3.wav",
		"player/footsteps/metal4.wav"
	},
	[MAT_SLOSH] = {
		"player/footsteps/slosh1.wav",
		"player/footsteps/slosh2.wav",
		"player/footsteps/slosh3.wav",
		"player/footsteps/slosh4.wav"
	},
	[MAT_TILE] = {
		"player/footsteps/tile1.wav",
		"player/footsteps/tile2.wav",
		"player/footsteps/tile3.wav",
		"player/footsteps/tile4.wav"
	},
	[MAT_GRASS] = {
		"player/footsteps/grass1.wav",
		"player/footsteps/grass2.wav",
		"player/footsteps/grass3.wav",
		"player/footsteps/grass4.wav"
	},
	[MAT_VENT] = {
		"player/footsteps/duct1.wav",
		"player/footsteps/duct2.wav",
		"player/footsteps/duct3.wav",
		"player/footsteps/duct4.wav"
	},
	[MAT_WOOD] = {
		"player/footsteps/wood1.wav",
		"player/footsteps/wood2.wav",
		"player/footsteps/wood3.wav",
		"player/footsteps/wood4.wav"
	},
	[MAT_DEFAULT] = {
		"player/footsteps/concrete1.wav",
		"player/footsteps/concrete2.wav",
		"player/footsteps/concrete3.wav",
		"player/footsteps/concrete4.wav"
	},
	[MAT_GLASS] = {
		"physics/glass/glass_sheet_step1.wav",
		"physics/glass/glass_sheet_step2.wav",
		"physics/glass/glass_sheet_step3.wav",
		"physics/glass/glass_sheet_step4.wav"
	},
	[MAT_WARPSHIELD] = {
		"physics/glass/glass_sheet_step1.wav",
		"physics/glass/glass_sheet_step2.wav",
		"physics/glass/glass_sheet_step3.wav",
		"physics/glass/glass_sheet_step4.wav"
	}
}
