--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

include("shared.lua")

local rea = (2000 * 2000)
local fuckeddist = (32 * 32);

-- Called each frame.
function ENT:Think()
	if (!Clockwork.entity:HasFetchedItemData(self)) then
		Clockwork.entity:FetchItemData(self)
		self:SetNextClientThink(CurTime() + math.Rand(0.05, 0.25));
		return true;
	end

	local player = self:GetPlayer()
	
	if (IsValid(player)) then
		local playerEyePos = Clockwork.Client:EyePos();
		local eyePos = EyePos();
		local isPlayer = player:IsPlayer()
		local isCloaked = (player:GetColor().a <= 0);

		if ((eyePos:DistToSqr(playerEyePos) > fuckeddist or GetViewEntity() != Clockwork.Client or Clockwork.Client != player or !isPlayer) and (!isPlayer or player:Alive()) and (!isCloaked and !player:GetNoDraw())) then
			self:SetNoDraw(false)
			
			if self.secondaryAttachmentModel then
				self.secondaryAttachmentModel:SetNoDraw(false);
			end
		else
			self:SetNoDraw(true)
			
			if self.secondaryAttachmentModel then
				self.secondaryAttachmentModel:SetNoDraw(true);
			end
		end

		if self.secondaryAttachmentModel then
			if self:GetColor().a == 0 or player:GetMoveType() == 8 or eyePos:DistToSqr(playerEyePos) > rea then
				self.secondaryAttachmentModel:SetNoDraw(true);
			end
		end
	end
	
	self:SetNextClientThink(CurTime() + math.Rand(0.05, 0.25));
	return true;
end

-- Called when the entity should draw.
function ENT:Draw()
	if Clockwork.Client.LoadingText then
		return;
	end
	
	if (!hook.Run("PreGearEntityDraw", self)) then
		if (!Clockwork.entity:HasFetchedItemData(self)) then
			return
		end

		local playerEyePos = Clockwork.Client:EyePos()
		local colorTable = self:GetColor()
		local itemTable = Clockwork.entity:FetchItemTable(self)
		
		if itemTable then
			local modelScale = itemTable.attachmentModelScale or Vector(1, 1, 1)
			local bDrawModel = false
			local eyePos = EyePos()
			local player = self:GetPlayer()

			if (IsValid(player) and (player:GetMoveType() == MOVETYPE_WALK or player:IsRagdolled() or player:InVehicle())) then
				local position, angles = self:GetRealPosition()
				local isPlayer = player:IsPlayer()

				if (position and angles) then
					self:SetPos(position) self:SetAngles(angles)
				end

				if (itemTable.GetAttachmentModelScale) then
					modelScale = itemTable:GetAttachmentModelScale(player, self) or modelScale
				end

				if ((eyePos:DistToSqr(playerEyePos) > fuckeddist or GetViewEntity() != Clockwork.Client or Clockwork.Client != player or !isPlayer) and (!isPlayer or player:Alive()) and colorTable.a > 0) then
					bDrawModel = true
				end
				
				if itemTable.attachmentSkin then
					self:SetSkin(itemTable.attachmentSkin);
				end
				
				if itemTable.bodygroup0 then
					self:SetBodygroup(0, itemTable.bodygroup0 - 1);
				end
				
				if itemTable.bodygroup1 then
					self:SetBodygroup(0, itemTable.bodygroup1 - 1);
				end
				
				if itemTable.bodygroup2 then
					self:SetBodygroup(1, itemTable.bodygroup2 - 1);
				end
				
				if itemTable.bodygroup3 then
					self:SetBodygroup(2, itemTable.bodygroup3 - 1);
				end
				
				if itemTable.secondaryAttachmentBone and bDrawModel then
					if not self.secondaryAttachmentModel then
						if itemTable.secondaryAttachmentModel then
							self.secondaryAttachmentModel = ClientsideModel(itemTable.secondaryAttachmentModel, RENDERGROUP_TRANSLUCENT)
						else
							self.secondaryAttachmentModel = ClientsideModel(itemTable.model, RENDERGROUP_TRANSLUCENT)
						end
					end
					
					local position, angles = self:GetSecondaryRealPosition();
					
					if (position and angles) then
						self.secondaryAttachmentModel:SetPos(position) self.secondaryAttachmentModel:SetAngles(angles)
					end
				end
			end

			if (modelScale) then
				local entityMatrix = Matrix()
					entityMatrix:Scale(modelScale)
				self:EnableMatrix("RenderMultiply", entityMatrix)
			end

			if (bDrawModel and hook.Run("GearEntityDraw", self) != false) then
				self:DrawModel()
				
				if self.secondaryAttachmentModel then
					self.secondaryAttachmentModel:DrawModel();
				end
			end
		end
	end
end

function ENT:OnRemove()
	if self.secondaryAttachmentModel then
		self.secondaryAttachmentModel:Remove();
		self.secondaryAttachmentModel = nil;
	end
end