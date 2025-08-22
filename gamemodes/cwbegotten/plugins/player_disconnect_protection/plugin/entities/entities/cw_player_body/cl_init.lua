
Clockwork.kernel:IncludePrefixed("shared.lua");

function ENT:OnNVarChanged(netVar, _, newValue)
	if (netVar != "Clothes") then
		return
	end


	-- it seems someone (or somewho) broke `NetworkVar` func, so it is being changed multiplie times on single call (may be caused by NW2 system usage)
	if (newValue != "") then
		if (IsValid(self.clothes)) then
			self.clothes:Remove()
		end

		self.clothes = ClientsideModel(newValue, RENDERGROUP_BOTH)

		if (IsValid(self.clothes)) then
			self.clothes:SetParent(self)
			self.clothes:AddEffects(EF_BONEMERGE)
			self.clothes:SetSkin(self:GetSkin())
			self.clothes:SetColor(self:GetColor())
			self.clothes:SetMaterial(self:GetMaterial())
		end
	elseif (IsValid(self.clothes)) then
		self.clothes:Remove()
	end
end

function ENT:OnRemove()
	if (IsValid(self.clothes)) then
		self.clothes:Remove()
	end
end

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = Clockwork.option:GetColor("target_id")

	y = Clockwork.kernel:DrawInfo("Тело", x, y, colorTargetID, alpha)
	y = Clockwork.kernel:DrawInfo("Дышит, но пребывает во сне.", x, y, color_white, alpha)
end