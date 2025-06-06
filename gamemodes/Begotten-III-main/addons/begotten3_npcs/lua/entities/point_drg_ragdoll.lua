ENT.Type = "point"
ENT.Base = "base_entity"
ENT.PrintName = "Ragdoll Attachment"
ENT.Category = "DrGBase"
function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Ragdoll")
	self:NetworkVar("Int", 0, "Bone")
end
if SERVER then
	AddCSLuaFile()
	function ENT:Initialize()
		local ragdoll = self:GetRagdoll()
		if not IsValid(ragdoll) then self:Remove() end
	end
	function ENT:Think()
		local ragdoll = self:GetRagdoll()
		if IsValid(ragdoll) then
			local bone = ragdoll:GetPhysicsObjectNum(ragdoll:TranslateBoneToPhysBone(self:GetBone()))
			if bone then
				bone:SetAngleDragCoefficient(100000)
				bone:SetPos(self:GetPos())
			end
		else self:Remove() end
		self:NextThink(CurTime() + engine.TickInterval())
		return true
	end
else
	local AdjustRagdollsAttachs = CreateClientConVar("drgbase_adjust_ragdoll_attachments", "0")
	function ENT:Think()
		if not AdjustRagdollsAttachs:GetBool() then return end
		local ragdoll = self:GetRagdoll()
		if IsValid(ragdoll) then
			local pos = ragdoll:GetBonePosition(self:GetBone())
			local offset = pos:DrG_Direction(self:GetPos())
			for boneId = 0, (ragdoll:GetBoneCount()-1) do
				if ragdoll:GetBoneName(boneId) == "__INVALIDBONE__" then continue end
				local bonePos, boneAng = ragdoll:GetBonePosition(boneId)
				ragdoll:SetBonePosition(boneId, bonePos+offset, boneAng)
			end
		end
	end
end
