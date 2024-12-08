cwMusic.enabled = true;

local map = game.GetMap() == "rp_begotten3" or game.GetMap() == "rp_begotten_redux" or game.GetMap() == "rp_scraptown" or game.GetMap() == "rp_district21";

function cwMusic:EntityTakeDamageNew(entity, damageInfo)
	if (!map) then
		return;
	end;
	
	local class = entity:GetClass();
	
	if (class == "func_breakable" or class == "func_movelinear") then
		return;
	end

	if (!IsValid(entity.opponent)) then -- if player is dueling battle music is automatic
		if (entity:IsPlayer() or entity:IsNPC() or entity:IsNextBot()) then
			local damageType = damageInfo:GetDamageType();
			local damageAmount = damageInfo:GetDamage();
			local attacker = damageInfo:GetAttacker();
			local amount = damageInfo:GetDamage();
			
			if IsValid(attacker) then		
				if (attacker:GetClass() == "cw_item") then
					return;
				end
				
				if (attacker:GetClass() == "prop_physics") then
					return;
				end
			else
				return;
			end
			
			local health = entity:Health()
			
			if (amount > (health * 0.1)) then
				if (attacker:IsPlayer() or attacker:IsNPC() or attacker:IsNextBot()) and attacker ~= entity then
					if (entity:IsPlayer()) then 
						netstream.Start(entity, "StartBattleMusic")
					end
					
					if (attacker:IsPlayer()) then
						netstream.Start(attacker, "StartBattleMusic")
					end
					
					for k, v in pairs (ents.FindInSphere(entity:GetPos(), 512)) do
						if (v:IsPlayer() and v ~= player and v ~= attacker) then
							netstream.Start(v, "StartBattleMusic")
						end
					end
				end
				
				-- below is what caused that demonic red flash when you'd get hit. as of right now it is unused
				--local bSharpen = true -- by default we want to play the effect

				--if (!self.SharpenDamageTypes[damageType]) then -- let's check the damagetype of the damage just taken by the entity, if it doesn't exist in the table which causes a red flash, we won't play the effect
					--bSharpen = false -- nope.avi
				--end

				--netstream.Start(entity, "Damaged", bSharpen) -- send the netstream telling the client to play a red flash effect
			end
			
			if (attacker:IsPlayer()) then
				local curTime = CurTime()
				local index = attacker:EntIndex()
				
				if (!entity.enemies) then
					entity.enemies = {}
				elseif (!entity.enemies[index]) then
					entity.enemies[index] = curTime + 60
				else
					entity.enemies[index] = entity.enemies[index] + 20
				end
			end
		end
	end
	
	if (!entity:IsOnFire()) then
		if (entity:IsPlayer() or entity:IsNPC() or entity:IsNextBot()) then
			if (!entity.cwObserverMode) then
				local damageType = damageInfo:GetDamageType();
				local damageAmount = damageInfo:GetDamage();
			
				if (damageType == DMG_BURN) and (damageAmount >= 50) then
					entity:Ignite(8, 0)
					entity:EmitSound("ambient/fire/ignite.wav", 500)
				end
			end
		end
	end
end

function cwMusic:PlayerCharacterLoaded(player)
	if self.enabled then
		netstream.Start(player, "EnableDynamicMusic");
	else
		netstream.Start(player, "DisableDynamicMusic");
	end
end