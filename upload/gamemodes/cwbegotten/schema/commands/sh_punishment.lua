--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

PrecacheParticleSystem("smoke_exhaust_01")

local COMMAND = Clockwork.command:New();
COMMAND.tip = "Punish a misbehaving player by entering their name or looking at them.";
COMMAND.text = "[string Name]";
COMMAND.access = "s";
COMMAND.alias = {"CharSmite", "Smite"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]) or player:GetEyeTraceNoCursor().Entity;
	
	if (target and target:IsPlayer() and target:Alive()) then
		target:EmitSound("ambient/energy/ion_cannon_shot1.wav")
		target:EmitSound("ambient/energy/newspark11.wav")
		
		local i = Clockwork.inventory:GetAsItemsList(target:GetInventory())
		
		for k, v in pairs (i) do
			for i = 1, Clockwork.inventory:GetItemCountByID(target:GetInventory(), v.uniqueID) do
				target:TakeItemByID(v.uniqueID)
			end;
		end;
		
		local effectdata = EffectData()
		effectdata:SetOrigin(target:GetPos() + Vector(0,0,48))
		effectdata:SetScale( 20 )
		effectdata:SetMagnitude( 30 )
		util.Effect( "ElectricSpark", effectdata )
		
		if cwDeathCauses then
			target:DeathCauseOverride("Smited by the gods.");
		end
		
		target:Kill();
		
		local ragdollEntity = target:GetRagdollEntity();
		
		if (IsValid(ragdollEntity)) then
			ragdollEntity:Fire("startragdollboogie")
			ragdollEntity:Ignite(7,0)
		
			timer.Create( "smite"..target:Name().."smoke", 5, 1, 
				function()
					local model = "models/Humans/Charple01.mdl"
					
					--target:SetCharacterData("Model", model, true);
					target:SetModel(model);

					if (IsValid(ragdollEntity)) then
						local corpse = ents.Create("prop_ragdoll");
							corpse:SetPos(ragdollEntity:GetPos());
							corpse:SetAngles(ragdollEntity:GetAngles());			
							corpse:SetModel(model);
							corpse:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
						corpse:Spawn();

						if (IsValid(corpse)) then
							local headIndex = corpse:LookupBone("ValveBiped.Bip01_Head1");
							local velocity = ragdollEntity:GetVelocity();
							local corpseIndex = corpse:EntIndex()
							local physCount = corpse:GetPhysicsObjectCount();
							
							for i = 1, physCount do
								local physicsObject = corpse:GetPhysicsObjectNum(i);
								local boneIndex = corpse:TranslatePhysBoneToBone(i);
								local position, angle = ragdollEntity:GetBonePosition(boneIndex);
								
								if (IsValid(physicsObject) and position and angle) then
									physicsObject:SetPos(position);
									physicsObject:SetAngles(angle);
									
									if (boneIndex == headIndex) then
										physicsObject:SetVelocity(velocity * 2);
									else
										physicsObject:SetVelocity(velocity);
									end;
									
									if (force) then
										if (boneIndex == headIndex) then
											physicsObject:ApplyForceCenter(force * 2);
										else
											physicsObject:ApplyForceCenter(force);
										end;
									end;
								end;
							end;
							
							corpse:Ignite(7,0)
							ParticleEffectAttach("smoke_exhaust_01", 1, corpse, 1)
							
							timer.Simple(300, function()
								if IsValid(corpse) then
									corpse:Remove();
								end
							end);
						end
						
						ragdollEntity:Remove();
					end
				
					target:EmitSound("ambient/energy/newspark01.wav")
				end
			)
		end
		
		for i = 1, math.random(20,45) do
			timer.Create( "smite"..target:Name()..""..i, math.random(5,50)/10, 1, 
			function()
				num = string.format("%02d",math.random(1,11))
				
				if IsValid(target) then
					target:EmitSound("ambient/energy/newspark"..num..".wav")
					
					local effectdata = EffectData()
					
					effectdata:SetOrigin(target:GetPos() + Vector(0+math.random(-20,20),0+math.random(-20,20),0+math.random(-20,20)))
					util.Effect( "cball_bounce", effectdata )
				end
			end
			)
		end
		
		netstream.Start(_player.GetAll(), "EmitSound", {name = "ambient/weather/thunderstorm/lightning_strike_"..tostring(math.random(1, 4))..".wav", pitch = 100, level = 100});
		Clockwork.chatBox:AddInTargetRadius(target, "me", "is struck by a huge bolt of electricity, their flesh and clothes burning to a crisp as their corpse spasms wildly!", target:GetPos(), config.Get("talk_radius"):Get() * 2);
		Clockwork.chatBox:Add(_player.GetAll(), nil, "event", "A crack of thunder can be heard throughout the Wasteland, as though someone has been smited by the gods.");
		Schema:EasyText(GetAdmins(), "icon16/weather_lightning.png", "goldenrod", target:Name().." incurred "..player:Name().."'s divine wrath!");
	else
		Clockwork.player:Notify(player, "Invalid target! Enter a name or look at a player!");
	end
end;

Clockwork.command:Register(COMMAND, "PlySmite");