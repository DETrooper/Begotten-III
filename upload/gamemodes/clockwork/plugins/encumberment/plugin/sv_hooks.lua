--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

-- Called at an interval while a player is connected.
function cwEncumberment:PlayerThink(player, curTime, infoTable, alive, initialized)
	if (alive and initialized) then
		if (!player.nextEncumberedCheck or player.nextEncumberedCheck < curTime) then
			player.nextEncumberedCheck = curTime + 0.5;
			
			if (!player.inventoryWeight or !player.maxWeight) then
				player.nextEncumberedCheck = curTime + 2
				return;
			end;
			
			if (player.inventoryWeight > player.maxWeight) then
				if (!player.OverEncumbered) then
					player.OverEncumbered = true;
					Schema:EasyText(player, "maroon", "You are now overencumbered and your movement speed has decreased!");
				end;
				
				if (cwStamina) then
					if (!player:IsRagdolled() and player.cwObserverMode != true and player:IsRunning()) then
						local stamina = player:GetCharacterData("Stamina");
						
						if ((player.inventoryWeight > player.maxWeight * 2) and stamina <= 40) then
							player:SetCharacterData("Stamina", math.Clamp(stamina + 5, 0, player:GetMaxStamina()));
								Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, math.random(7, 10));
							player:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav", 60);
						end;
					end;
				end;
				
				hook.Run("RunModifyPlayerSpeed", player, infoTable);
			else
				if (player.OverEncumbered) then
					player.OverEncumbered = false;
					Schema:EasyText(player, "lawngreen", "You are no longer overencumbered.");
					
					hook.Run("RunModifyPlayerSpeed", player, infoTable, true);
				end;
			end;
		end;
	end;
end;

-- Called when a player's move data is set up.
function cwEncumberment:SetupMove(player, moveData)
	if (!player:IsNoClipping()) then
		if (moveData:KeyDown(IN_JUMP)) then
			if (player.cwJumpPower and player.cwJumpPower <= 10) then
				moveData:SetButtons(bit.band(moveData:GetButtons(), bit.bnot(IN_JUMP)));
			end
		end
	end
end

function cwEncumberment:ModifyPlayerSpeed(player, infoTable)
	local inventoryWeight = player.inventoryWeight;
	local maxWeight = player.maxWeight;

	if inventoryWeight and maxWeight and (inventoryWeight > maxWeight) then
		infoTable.walkSpeed = infoTable.walkSpeed / (inventoryWeight / maxWeight);
		infoTable.crouchedWalkSpeed = infoTable.crouchedWalkSpeed / (inventoryWeight / maxWeight);
		infoTable.runSpeed = infoTable.walkSpeed;
		
		if inventoryWeight > maxWeight * 2 then
			infoTable.jumpPower = 0;
		else
			infoTable.jumpPower = infoTable.jumpPower / ((inventoryWeight / maxWeight) * 2);
		end
	end
end