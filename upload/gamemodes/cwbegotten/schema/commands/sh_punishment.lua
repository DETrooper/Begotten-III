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
		
		netstream.Start(PlayerCache or _player.GetAll(), "EmitSound", {name = "ambient/weather/thunderstorm/lightning_strike_"..tostring(math.random(1, 4))..".wav", pitch = 100, level = 100});
		Clockwork.chatBox:AddInTargetRadius(target, "me", "is struck by a huge bolt of electricity, their flesh and clothes burning to a crisp as their corpse spasms wildly!", target:GetPos(), config.Get("talk_radius"):Get() * 2);
		Clockwork.chatBox:Add(PlayerCache or _player.GetAll(), nil, "event", "A crack of thunder can be heard throughout the Wasteland, as though someone has been smited by the gods.");
		Schema:EasyText(Schema:GetAdmins(), "icon16/weather_lightning.png", "goldenrod", target:Name().." incurred "..player:Name().."'s divine wrath!");
	else
		Clockwork.player:Notify(player, "Invalid target! Enter a name or look at a player!");
	end
end;

Clockwork.command:Register(COMMAND, "PlySmite");

local COMMAND = Clockwork.command:New("SkyDrop");
COMMAND.tip = "Spawn an object above the head of the fucklet of your choice. Will try to spawn as high up as possible, works best in open areas. The last arguments can be a list of items, including 'cash'/'coins' for a random amount of money, and 'random' for generated loot. You can also add X[num] to the end of an ID to define the number. For example: papa_petes_ice_cold_popX24 will add 24 bottles of delicious Papa Pete's® Ice Cold Pop™!";
COMMAND.text = "<string Name> <string Model> [num CleanupTimeInSeconds] [bool Burning] [Loot ItemIDs or Random or Cash/Coins]";
COMMAND.access = "s";
COMMAND.arguments = 2;
COMMAND.alias = {"PlySkyDrop", "CharSkyDrop"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	local dist = 4000
	local cleanuptime = tonumber(arguments[3]) or 60
	local burning = arguments[4] or "false"
	burning = string.lower(burning) == "true"
	local loot = arguments[5] or "false"
	
	if (target) then
		local model = arguments[2] or "models/props_debris/concrete_cynderblock001.mdl"
		if !IsUselessModel(model) then
			local tgtpos = target:GetPos()
			local spawnpoint = tgtpos + Vector(0, 0, dist)
			local trace = util.TraceLine({
				endpos = spawnpoint,
				filter = target,
				start = tgtpos,
				mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER
			})
			
			if trace.HitWorld then
			   spawnpoint = trace.HitPos + Vector(0, 0, -32)
			end
			
			local dropped=ents.Create("prop_physics")
			dropped:SetModel(arguments[2])
			dropped:SetPos(spawnpoint)
			dropped:Spawn()
			if burning then
				dropped:Ignite(cleanuptime,32)
			end
			dist = tgtpos:Distance( spawnpoint )

			Clockwork.player:Notify(player, "Spawned a prop ["..model.."] "..(dist*0.01905).." meters above "..target:Name()..".");
			timer.Create("SkyDrop"..target:Name()..""..math.Round(CurTime()), cleanuptime, 1, function()
				if IsValid(dropped) then
					dropped:Remove();
				else
					Clockwork.player:Notify(player, "Could not find the recently spawned object: ["..model.."] for cleanup. It might already be removed, or in need of manual cleanup.");
				end
			end);
			
			if loot ~= "false" then
				local itemcount = 0
				dropped.cwInventory = {};
				dropped.cwCash = 0;
				for i=5, #arguments do
					if arguments[i] then
						if arguments[i] == string.lower("random") then
							local itemIncrease = math.random(4, 8);
							for i = 1, math.random(3 + itemIncrease, 6 + itemIncrease) do
								local randomItem = cwItemSpawner:SelectItem(containerCategory, false, true);
								
								if randomItem then
									local itemInstance = Clockwork.item:CreateInstance(randomItem);
									
									if itemInstance then
										local category = itemInstance.category;
										
										if category == "Helms" or category == "Armor" or category == "Melee" or category == "Crafting Materials" then
											-- 75% chance for these items to spawn with less than 100% condition.
											if math.random(1, 4) ~= 1 then
												itemInstance:TakeCondition(math.random(0, 75));
											end
										elseif itemInstance.category == "Shot" and itemInstance.ammoMagazineSize and itemInstance.SetAmmoMagazine then
											itemInstance:SetAmmoMagazine(math.random(1, itemInstance.ammoMagazineSize));
										end
										
										Clockwork.inventory:AddInstance(dropped.cwInventory, itemInstance, 1);
										itemcount = itemcount + 1
									end
								end
							end
							dropped.cwCash = (dropped.cwCash+math.random(10, 50)) or math.random(10, 50);
							if math.random(1, 5) == 1 then
								dropped.cwCash = math.random(50, 100);
							end
						elseif arguments[i] == string.lower("coins") or arguments[i] == string.lower("cash") then
							dropped.cwCash = (dropped.cwCash+math.random(10, 50)) or math.random(10, 50);
						else
							local instr = arguments[i]
							local multiX = string.find(instr, "X")
							local numberof = 1
							if multiX then
								numberof = tonumber(string.sub( instr, multiX+1, -1 )) or 1
								instr = string.sub( instr, 1, multiX-1 )
							end
							local theitem = Clockwork.item:CreateInstance(instr);
							if theitem then
								Clockwork.inventory:AddInstance(dropped.cwInventory, theitem, numberof)
								Clockwork.player:Notify(player, "Added: "..theitem.name.." x"..numberof);
								itemcount = itemcount + 1
							else
								Clockwork.player:Notify(player, instr.." not found.");
							end
						end
					end
				end
				Clockwork.player:Notify(player, "Added "..itemcount.." items and "..dropped.cwCash.." coins to the object's inventory.");
			end
		else
			Clockwork.player:Notify(player, arguments[2].." is not a valid model!");
		end
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();