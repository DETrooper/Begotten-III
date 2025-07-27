--[[
	Begotten III: Jesus Wept
--]]

-- Called when a player attempts to force feed a target.
function cwForceFeeding:ForceFeedPlayer(player, target, itemTable)
	if (!IsValid(player) or !IsValid(target) or !itemTable or !player:HasItemInstance(itemTable) or !player:Alive() or !target:Alive()) then
		return;
	end;
	
	local actionPlayer = Clockwork.player:GetAction(player);
	local consumeTime = 10;
	
	if player:HasBelief("dexterity") then
		consumeTime = consumeTime * 0.67;
	end
	
	if target:GetNetVar("tied", 0) == 0 then
		Schema:EasyText(player, "peru", "This character needs to be tied in order to be force fed!");
	
		return false;
	end
	
	if target:GetRagdollState() == RAGDOLL_KNOCKEDOUT then
		Schema:EasyText(player, "peru", "This character cannot be force fed while unconscious!");
	
		return false;
	end
	
	if (actionPlayer != "force_feeding" and !target:GetNetVar("beingForceFed")) then
		player:SetWeaponRaised(false);
		
		target:SetNetVar("beingForceFed", true);
		
		Clockwork.player:SetAction(player, "force_feeding", consumeTime + 0.1, 1);
		
		if player.cloaked then
			player:Uncloak();
		end
		
		Clockwork.chatBox:AddInTargetRadius(player, "me", "begins force feeding a "..itemTable.name.." to the person before them.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
		
		Clockwork.player:EntityConditionTimer(player, target, nil, consumeTime, 192, function()
			if target:Alive() and player:Alive() and !player:IsRagdolled() and Clockwork.player:GetAction(player) == "force_feeding" then
				return true;
			end;
		end, function(success)
			if (success) then
				if (itemTable.OnUse) then
					itemTable:OnUse(target);
				end;
				
				if itemTable.useSound and !target:IsNoClipping() and (!target.GetCharmEquipped or !target:GetCharmEquipped("urn_silence")) then
					local useSound = itemTable.useSound;
					
					if (useSound) then
						if (type(useSound) == "table") then
							target:EmitSound(useSound[math.random(1, #useSound)]);
						else
							target:EmitSound(useSound);
						end;
					elseif (useSound != false) then
						target:EmitSound("begotten/items/first_aid.wav");
					end;
				end
				
				player:TakeItem(itemTable, true);
			end;

			if IsValid(player) then
				Clockwork.player:SetAction(player, false);
			end
			
			if (IsValid(target)) then
				target:SetNetVar("beingForceFed", false);
			end;
		end);
	else
		Schema:EasyText(player, "peru", "This character is already being force fed!");
	end;
end;

-- Called when a player uses an unknown item function.
function cwForceFeeding:PlayerUseUnknownItemFunction(player, itemTable, itemFunction)
	if (itemFunction == "force_feeding") then
		local entity = player:GetEyeTraceNoCursor().Entity;
		local target = Clockwork.entity:GetPlayer(entity);
		
		if (target) then
			self:ForceFeedPlayer(player, target, itemTable);
			return;
		else
			Schema:EasyText(player, "firebrick", "You must look at a character!");
		end;
	end;
end;