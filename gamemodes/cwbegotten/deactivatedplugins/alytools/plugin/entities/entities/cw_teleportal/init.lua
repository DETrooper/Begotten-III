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
	self:SetMoveType(MOVETYPE_NONE);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(0);
	self:SetMaterial( "models/props_c17/fisheyelens" )
	self:SetModelScale( 1.5, 0.25 )
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
	ambient = self:StartLoopingSound( "ambient/machines/combine_terminal_loop1.wav" )
	local effectData = EffectData()
	effectData:SetScale(1)
	effectData:SetOrigin(self:GetPos())
	effectData:SetMagnitude(1)
	util.Effect("camera_flash", effectData, true, true)
	util.Effect("cball_explode", effectData, true, true)
	util.Effect("TeslaZap", effectData, true, true)
	
end;

function ENT:Think()
	local curtime = CurTime();
	self.NextTP = self.NextTP or 0;
	self.FinishJump = self.FinishJump or 0;
	self:SetNWBool( "transporting", (self.FinishJump > curtime) )
	if self.FinishJump <= curtime then
		if self.NextTP <= curtime then
			self:SetNWFloat( "wormholesize", 12 )
			local targetdata = cwAlyTools:UpdateMarkerTrace(self:GetNetVar("portaltarget", {}))
			self:SetNetVar("portaltarget", targetdata)
			if targetdata.valid then
				for k, v in pairs(ents.FindInSphere( self:GetPos() + Vector( 0, 0, 21*self:GetModelScale() ), 24 )) do
				
					class = v:GetClass()
					physobj = v:GetPhysicsObject()
					selfpos = self:GetPos()
					target = targetdata.plytgt
					if (class == "cw_item") or (class == "prop_physics") or (class == "prop_ragdoll") or (class == "cw_item") or v:IsNPC() or v:IsNextBot() then
						print("isNOTplayer")
						local tgtent = targetdata.entity or self
						local ragdollPlayer = Clockwork.entity:GetPlayer(v)
						self.FinishJump = curtime + 2;
						arriveportal = ents.Create("cw_arriveportal")
						arriveportal:SetPos(target);
						arriveportal:Spawn();
						if (selfpos:Distance(target)<60) or (targetdata.entity == v) then
							for k, v in pairs(ents.FindInSphere( self:GetPos() + Vector( 0, 0, 21*self:GetModelScale() ), config.Get("talk_radius"):Get()*2 )) do
								if v:IsPlayer() then
									Schema:EasyText(v, "cornflowerblue", "The portal implodes as it teleports into itself, turning inside out and disappearing in a spacetime prolapse!")
								end
							end
							util.BlastDamage( self, self, selfpos, 32, 99999 )
							util.BlastDamage( self, self, target, 32, 99999 )
							self:Remove()
							arriveportal:Remove()
						else
							if ragdollPlayer then
								ragdollPlayer:Teleport(self:GetPos(),target)
								cwAlyTools:Transport(v, self:GetPos(), target, true)
							else
								cwAlyTools:Transport(v, self:GetPos(), target)
							end
						end
						self.NextTP = curtime + 3;
						break;
					elseif v:IsPlayer() then
						print("isplayer")
						if (v:GetMoveType() == MOVETYPE_WALK) or v:IsRagdolled() or v:InVehicle() then
							if not v:GetCharacterData("hidden") then
								local playerRagdoll = v:GetRagdollEntity()
								v:EmitSound( "ambient/levels/citadel/weapon_disintegrate3.wav")
								self.FinishJump = curtime + 2;
								arriveportal = ents.Create("cw_arriveportal")
								arriveportal:SetPos(target);
								arriveportal:Spawn();
								if (selfpos:Distance(target)<60) or (targetdata.entity == v) then
									Clockwork.chatBox:AddInRadius(v, "me", "only has a moment to realize something is wrong before being teleported into and inside themselves, violently exploding outwards in a wave of gore and torn spacetime!", v:GetPos(), config.Get("talk_radius"):Get() * 2);
									util.BlastDamage( self, self, selfpos, 32, 99999 )
									util.BlastDamage( self, self, target, 32, 99999 )
									self:Remove()
									arriveportal:Remove()
								else
									if playerRagdoll then
										cwAlyTools:Transport(playerRagdoll, self:GetPos(), target, true)
									end
									v:Teleport(self:GetPos(),target)
								end

								self.NextTP = curtime + 3;
								break;
							end
						end
					end
				end
			else
				self:Remove()
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