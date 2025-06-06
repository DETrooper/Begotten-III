--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.kernel:IncludePrefixed("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

local cwAlyTools = cwAlyTools;

local ambient = 0;

local arriveportal = nil;
 
-- Called when the entity initializes.
function ENT:Initialize()
	self:SetNWFloat( "wormholesize", 8 )
	self:SetModel("models/props_phx/ball.mdl");
	self:SetModelScale( 0, 0 )
	self:EmitSound( "beams/beamstart5.wav" )
	local effectData = EffectData()
	effectData:SetScale(1)
	effectData:SetOrigin(self:GetPos())
	effectData:SetMagnitude(1)
	util.Effect("ManhackSparks", effectData, true, true)
	self:SetMoveType(MOVETYPE_NONE);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(0);
	self:SetMaterial( "models/effects/splode1_sheet" )
	self:SetModelScale( 1.5, 0.25 )
	self:SetColor(255,0,0,30)
	--self:SetColor( Color(0, 255, 100, 255) )
	self:AddEffects( EF_BRIGHTLIGHT )
	self:AddEffects( EF_NOSHADOW )
	-- local core = ents.Create("prop_physics")
	-- core:SetModel("models/props_phx/misc/smallcannonball.mdl");
	-- core:SetMoveType(MOVETYPE_NONE);
	-- core:PhysicsInit(SOLID_VPHYSICS);
	-- core:SetMaterial( "models/props_combine/masterinterface01c" )
	-- core:SetSolid(0);
	-- core:SetParent( self );
	-- core:SetPos(self:GetPos());
	-- core:Spawn();
	ambient = self:StartLoopingSound( "hl1/ambience/alien_minddrill.wav" )
	local effectData = EffectData()
	effectData:SetScale(1)
	effectData:SetOrigin(self:GetPos())
	effectData:SetMagnitude(1)
	util.Effect("camera_flash", effectData, true, true)
	util.Effect("cball_explode", effectData, true, true)
	util.Effect("TeslaZap", effectData, true, true)
	self:SetRenderMode( RENDERMODE_GLOW )
	self:SetColor(255,60,60,30)
end;

function ENT:Think()
	local curtime = CurTime();
	self.Emit = self.Emit or 0;
	if self.Emit <= curtime then
		local num = tostring(math.random(1,6))
		local effectData = EffectData()
		effectData:SetScale(1)
		effectPos = self:GetPos()+Vector(0,0,25)
		effectData:SetOrigin(effectPos+Vector(math.random(-28,28),math.random(-28,28),math.random(-28,28)))
		effectData:SetMagnitude(1)
		util.Effect("ManhackSparks", effectData, true, true)
		self:EmitSound("ambient/energy/spark"..num..".wav")
		self.Emit = curtime + (math.random(5,25)/10)
	end
	self.Scream = self.Scream or 0;
	if self.Scream <= curtime then
		local num = tostring(math.random(1,5))
		self:EmitSound("begotten/ambient/atmosphere/apocalypse/horror/horror"..num..".wav")
		self.Scream = curtime + math.random(8,20)
	end
	self.NextTP = self.NextTP or 0;
	self.FinishJump = self.FinishJump or 0;
	self:SetNWBool( "transporting", (self.NextTP > curtime) )
	if self.FinishJump <= curtime then
		if self.NextTP <= curtime then
			self:SetNWFloat( "wormholesize", 12 )
			for k, v in pairs(ents.FindInSphere( self:GetPos() + Vector( 0, 0, 21*self:GetModelScale() ), 24 )) do
				local target = self:GetNWVector( "portaltarget" )
				
				class = v:GetClass()
				physobj = v:GetPhysicsObject()
				if target ~= Vector(0,0,0) then
					if (class == "cw_item") or (class == "prop_physics") or (class == "prop_ragdoll") or (class == "cw_item") or v:IsNPC() or v:IsNextBot() then
						cwAlyTools:FuckedTransport(v, self:GetPos(), target)
						self.FinishJump = curtime + 5;
						arriveportal = ents.Create("cw_fuckedarriveportal")
						arriveportal:SetPos(target);
						arriveportal:Spawn();
						self.NextTP = curtime + 8;
						break
					elseif v:IsPlayer() then
						if v:GetMoveType() == MOVETYPE_WALK or v:IsRagdolled() or v:InVehicle() then
							if not v:GetCharacterData("hidden") then
								v:EmitSound( "ambient/levels/citadel/weapon_disintegrate3.wav")
								v:ShitTeleport(self:GetPos(),target)
								self.FinishJump = curtime + 5;
								arriveportal = ents.Create("cw_fuckedarriveportal")
								arriveportal:SetPos(target);
								arriveportal:Spawn();
								self.NextTP = curtime + 8;
								break;
							end
						end
					end
					local vectx, vecty, vectz = target:Unpack()
				elseif (class == "cw_item") or (class == "prop_physics") or (class == "prop_ragdoll") or (class == "cw_item") or v:IsNPC() or v:IsNextBot() or v:IsPlayer() then
					validtarget = false
					if v:IsPlayer() then
						if v:GetMoveType() == MOVETYPE_WALK or v:IsRagdolled() or v:InVehicle() then
							validtarget = true
						end
					else
						validtarget = true
					end
					if validtarget then
						cwAlyTools:Vaporize(v)
					end
				end
			end
		else
			self:SetNWFloat( "wormholesize", 1 )
			if IsValid(arriveportal) then
				arriveportal:Remove()
			end
		end
	else
		
		self:SetNWFloat( "wormholesize", 46 )
	end
end

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

function ENT:Use(activator, caller)

end;

function ENT:OnRemove()
	if IsValid(arriveportal) then
		arriveportal:Remove()
	end
	self:SetModelScale( 0, 0.25 )
	self:StopLoopingSound( ambient )
	local effectData = EffectData()
	effectData:SetScale(1)
	effectData:SetOrigin(self:GetPos())
	effectData:SetMagnitude(1)
	util.Effect("camera_flash", effectData, true, true)
	util.Effect("AR2Explosion", effectData, true, true)
	util.Effect("TeslaZap", effectData, true, true)
	self:EmitSound("ambient/levels/citadel/weapon_disintegrate1.wav")
end;