--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

-- Called at an interval while a player is connected.
function cwEncumberment:PlayerThink(player, curTime, infoTable, alive, initialized, plyTab)
	if (alive and initialized) then
		if (!plyTab.nextEncumberedCheck or plyTab.nextEncumberedCheck < curTime) then
			plyTab.nextEncumberedCheck = curTime + 0.5;
			
			if (!plyTab.inventoryWeight or !plyTab.maxWeight) then
				plyTab.nextEncumberedCheck = curTime + 2
				return;
			end;
			
			if (plyTab.inventoryWeight > plyTab.maxWeight) then
				if (!plyTab.OverEncumbered) then
					plyTab.OverEncumbered = true;
					Schema:EasyText(player, "maroon", "You are now overencumbered and your movement speed has decreased!");
				end;
				
				if (cwStamina) then
					if (!player:IsRagdolled() and plyTab.cwObserverMode != true and player:IsRunning()) then
						local stamina = player:GetCharacterData("Stamina");
						
						if ((plyTab.inventoryWeight > plyTab.maxWeight * 2) and stamina <= 40) then
							player:SetCharacterData("Stamina", math.Clamp(stamina + 5, 0, player:GetMaxStamina()));
								Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, math.random(7, 10));
							player:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav", 60);
						end;
					end;
				end;
				
				hook.Run("RunModifyPlayerSpeed", player, infoTable);
			else
				if (plyTab.OverEncumbered) then
					plyTab.OverEncumbered = false;
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