--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local map = game.GetMap() == "rp_begotten3";

-- Called when Clockwork has loaded all of the entities.
function cwToothBoy:ClockworkInitPostEntity()
	if (!map) then
		return;
	end;
	
	self:CreateToothboy();
end

-- Called every tick.
function cwToothBoy:Think()
	if (!map) then
		return;
	end;
	
	local curTime = CurTime()
	
	if (!self.nextToothboy or self.nextToothboy < curTime) then
		self.nextToothboy = curTime + math.random(17, 40)
		
		if (IsValid(toothBoy)) then
			for k, v in pairs (ents.FindInSphere(toothBoy:GetPos(), 1024)) do
				if (v:IsPlayer()) then
					netstream.Start(v, "Toothboy")
					--v:HandleSanity(-5)
				end
			end
		end
	end

	if (!self.nextToothboySteam or self.nextToothboySteam <= curTime) then
		self.nextToothboySteam = curTime + math.random(10, 20)

		if (IsValid(toothBoy)) then
			if (math.random(1, 3) == 3) then
				self:ToothBoySteam()

				if (math.random(1, 2) == 2) then
					timer.Simple(math.random(3, 5), function()
						self:ToothBoySteam()
					end)
				end
			else
				if (math.random(1, 2) == 2) then
					toothBoy:EmitSound("ambient/materials/rustypipes"..math.random(1, 3)..".wav", 70, math.random(80, 110))
				else
					toothBoy:EmitSound("ambient/materials/shipgroan"..math.random(1, 4)..".wav", 70, math.random(80, 110))
				end
				
				if (math.random(1, 100) == 10) then
					toothBoy:EmitSound("ambient/creatures/town_muffled_cry1.wav", 100, 120)
				end
			end
		end
	end
end

-- A function to create the toothboy entity.
function cwToothBoy:CreateToothboy()
	if (IsValid(toothBoy)) then
		toothBoy:Remove()
	end
	
	for k, v in pairs (ents.FindByClass("prop_physics_multiplayer")) do
		if (v:GetModel() == "models/props_wasteland/controlroom_monitor001a.mdl") then
			v:Remove()
		end
	end
	
	toothBoy = ents.Create("prop_physics_multiplayer")
	toothBoy:SetModel("models/props_silo/processor.mdl")
	toothBoy:SetPos(Vector(12639, -10671, -1681))
	toothBoy:SetAngles(Angle(0, -90, 0))
	toothBoy:Spawn()
	toothBoy:SetCollisionGroup(0);
	toothBoy.safe = true
	toothBoy.steamJets = {
		Vector(15.141601, -24.378908, 75.709717),
		Vector(14.775390, -24.538332, 36.097778),
		Vector(12.417970, 25.572996, 42.918823),
		Vector(12.036622, 25.686766, 76.399414),
	}
	
	local physicsObject = toothBoy:GetPhysicsObject()
	
	if (IsValid(physicsObject)) then
		physicsObject:EnableMotion(false)
	end
	
	if (IsValid(toothBoyMonitor)) then
		toothBoyMonitor:Remove()
	end	

	toothBoyMonitor = ents.Create("prop_physics_multiplayer")
	toothBoyMonitor:SetModel("models/props_wasteland/controlroom_monitor001a.mdl")
	toothBoyMonitor:SetPos(Vector(12628, -10710, -1608))
	toothBoyMonitor:SetAngles(Angle(0, -90, 0))
	toothBoyMonitor:Spawn()
	toothBoyMonitor:SetCollisionGroup(0);
	toothBoyMonitor:SetNWBool("tb", true)
	toothBoyMonitor.safe = true

	local physicsObject = toothBoyMonitor:GetPhysicsObject()
	
	if (IsValid(physicsObject)) then
		physicsObject:EnableMotion(false)
	end
end

-- A function to make Tooth Boy emit steam.
function cwToothBoy:ToothBoySteam()
	if (IsValid(toothBoy)) then
		local curTime = CurTime()
		
		if (toothBoy.nextSteam and toothBoy.nextSteam > curTime) then
			return
		end

		toothBoy.nextSteam = curTime + 7
		toothBoy:EmitSound("buttons/lever2.wav")
		
		timer.Simple(1, function()
			local randomJet = table.Random(toothBoy.steamJets)
			local steamJet = ents.Create("prop_physics")
			steamJet:SetPos(toothBoy:LocalToWorld(randomJet))
			steamJet:SetModel("models/hunter/blocks/cube025x025x025.mdl")
			steamJet:Spawn()
			steamJet:SetCollisionGroup(COLLISION_GROUP_WORLD)
			steamJet:SetRenderMode(RENDERMODE_TRANSALPHA)
			steamJet:SetColor(Color(0, 0, 0, 0))
			steamJet:DrawShadow(false)
			steamJet:SetNWBool("steamjet", true)
			
			local physicsObject = steamJet:GetPhysicsObject()
			
			if (IsValid(physicsObject)) then
				physicsObject:EnableMotion(false)
			end
			
			for i = 1, 3 do
				ParticleEffect("steam_jet_80_steam", steamJet:GetPos(), AngleRand(), steamJet)
			end

			steamJet.steamLoop = CreateSound(steamJet, "ambient/gas/steam_loop1.wav")
			steamJet.steamLoop:PlayEx(1, math.random(180, 220))
			steamJet.willExplode = math.random(1, 7)
			
			if (steamJet.willExplode == 4) then
				if (!toothBoy.engineSound) then
					toothBoy.engineSound = CreateSound(toothBoy, "ambient/machines/engine4.wav")
					toothBoy.engineSound:PlayEx(1, 120)
				end

				timer.Create(toothBoy:EntIndex().."_Warning", 0.75, 3, function()
					toothBoy:EmitSound("ambient/alarms/klaxon1.wav")
				end)
				
				timer.Simple((0.75 * 4), function()
					--toothBoy:EmitSound("ambient/explosions/explode_3.wav", 500)
					
					if (toothBoy.engineSound) then
						toothBoy.engineSound:Stop()
						toothBoy.engineSound = nil
					end
					
					local effectData = EffectData()
						effectData:SetOrigin(toothBoy:GetPos())
						effectData:SetScale(8)
					  --util.Effect("WaterSurfaceExplosion", effectData)
					
					toothBoy:EmitSound("begotten/tb/tb_haha.wav", 255, math.random(90, 100))
					
					for k, v in pairs (ents.FindInSphere(toothBoy:GetPos(), 128)) do
						if (v:IsPlayer() and v:GetMoveType() != MOVETYPE_NOCLIP and !v:IsRagdolled()) then
							Clockwork.player:SetRagdollState(v, RAGDOLL_FALLENOVER, 8)
							v:SendLua([[Clockwork.Client:EmitSound("begotten/flashback_outro.wav", 500, 80)]])
							
							timer.Simple(0.2, function()
								if (IsValid(v)) then
									local ragdollEntity = v:GetRagdollEntity()
									local physicsObject = ragdollEntity:GetPhysicsObject()
									
									if (IsValid(ragdollEntity) and IsValid(physicsObject)) then
										physicsObject:ApplyForceCenter((v:GetPos() - toothBoy:GetPos()) * 999999999999999999999999999999999999)
									end
									
									v:SendLua([[Clockwork.Client:EmitSound("begotten/score6.mp3", 500)]])
								end
							end)
						elseif (v:IsPlayer()) then
							netstream.Start(v, "Stunned", 1)
						end
					end
				end)
			end
			
			local timeUntilEnd = math.Rand(0.7, 2.4)
			
			timer.Simple(timeUntilEnd - 0.2, function()
				toothBoy:EmitSound("ambient/materials/metal_groan.wav", 75, math.random(77, 110))
			end)
			
			timer.Simple(timeUntilEnd, function()
				if (IsValid(steamJet)) then
					if (steamJet.steamLoop) then
						steamJet.steamLoop:Stop()
						steamJet.steamLoop = nil
					end
					
					steamJet:Remove()
				end
			end)
		end)
	end
end