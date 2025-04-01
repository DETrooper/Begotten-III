--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

util.Include("shared.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	if (hook.Run("SalesmanTargetID", self, x, y, alpha)) then
		local colorTargetID = Clockwork.option:GetColor("target_id")
		local colorWhite = Clockwork.option:GetColor("white")
		local physDesc = self:GetNetworkedString("PhysDesc")
		local name = self:GetNetworkedString("Name")

		y = Clockwork.kernel:DrawInfo(name, x, y, colorTargetID, alpha)

		if (physDesc != "") then
			y = Clockwork.kernel:DrawInfo(physDesc, x, y, colorWhite, alpha)
		end
	end
end

-- Called when the entity initializes.
function ENT:Initialize()
	self.AutomaticFrameAdvance = true
end

-- Called every frame.
function ENT:Think()
	self:FrameAdvance(FrameTime())
	self:NextThink(CurTime())
end

function ENT:Draw()
	self:DrawModel()

	local head = self:GetNWString("head");
	
	if head and head:len() > 0 then
		if !IsValid(self.headEntity) then
			local headEntity = ClientsideModel(head, RENDERGROUP_BOTH);
			
			if IsValid(headEntity) then
				headEntity:SetParent(self);
				headEntity:AddEffects(EF_BONEMERGE);
				headEntity:SetColor(self:GetColor());
				headEntity:SetNoDraw(self:GetNoDraw());
			
				self.headEntity = headEntity;
			end
		elseif self.headEntity:GetModel() ~= head then
			if IsValid(self.headEntity) then
				self.headEntity:Remove();
				self.headEntity = nil;
			end
		end
	elseif IsValid(self.headEntity) then
		self.headEntity:Remove();
		self.headEntity = nil;
	end
end

function ENT:OnRemove()
	if IsValid(self.headEntity) then
		self.headEntity:Remove();
		self.headEntity = nil;
	end
end