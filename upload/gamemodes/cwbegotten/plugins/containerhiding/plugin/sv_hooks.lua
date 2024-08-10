--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

-- Called when Clockwork has initialized.
function cwContainerHiding:ClockworkInitialized()
	for k, v in pairs (ents.FindByClass("prop_physics")) do
		local model = v:GetModel();
		
		if (table.HasValue(self.containerProps["white"], string.lower(model)) or table.HasValue(self.containerProps["black"], string.lower(model))) then
			local physObj = v:GetPhysicsObject();
			
			if (IsValid(physObj)) then
				physObj:EnableMotion(false);
			end;
		end;
	end;
end;

-- Called when an entity's menu option should be handled.
function cwContainerHiding:EntityHandleMenuOption(player, entity, option, arguments)
	local class = entity:GetClass();

	if (class == "prop_physics") then
		local model = entity:GetModel();
		
		if (table.HasValue(self.containerProps["white"], string.lower(model)) or table.HasValue(self.containerProps["black"], string.lower(model))) then
			if (arguments == "cw_entityHide") and (entity:GetNWBool("unlocked", true) == true) then
				if (game.GetMap() != "rp_begotten3") then
					return;
				end;
	
				local badPositon = Vector(10865.556640625, 94.998146057129, 298.03125);
				local oldPosition = player:GetPos();
				local caller = player;
				
				--[[if (oldPosition:Distance(badPositon) < 196) then
					if (caller.InSideTortureHouse) then
						if (entity:GetPos():Distance(badPositon) < 196) then
							if (caller.CanEscapeTheCabin) then
								if (!player:HasItemByID("key_shack")) then
									player:GiveItem(Clockwork.item:CreateInstance("key_shack"), true);
									netstream.Start(player, "cwPrintExamineText", {"A-a-..A K-key came o-out... T-The door!"});
									netstream.Start(player, "Stunned", 1);
									
									return;
								end;
							else
								netstream.Start(player, "cwPrintExamineText", {"Strange.. The cabinet is locked.... I think I hear breathing from inside.."});

								return;
							end;
						end;
					end;
				end;]]--
				
				local curTime = CurTime();
				local physObj = entity:GetPhysicsObject();
				
				if (IsValid(physObj)) then
					if (physObj:IsMotionEnabled()) then
						--netstream.Start(player, "cwCustomHint", {string.Split(player:Name(), " ")[1].." Thinks...", "This thing looks too wobbly. I bet I'd fall over if I got in.."});
						
						return;
					end;
				end;
				
				if (entity:IsOnFire()) then
					--netstream.Start(player, "cwCustomHint", {string.Split(player:Name(), " ")[1].." Thinks...", "Why would I get in this thing while it's up in flames!"});
					
					return;
				end;
				
				if (!entity.nextHideUse or curTime > entity.nextHideUse) then
					entity.nextHideUse = curTime + 5;
					
					if (player.cwObserverMode != true) then
						if (player:GetCharacterData("hidden") == true and IsValid(entity.occupier) and entity.occupier == player) then
							self:OpenedStorage(player, entity);
						else
							Clockwork.player:SetAction(player, "hide", 2.5, nil, function()				
								self:AttemptHide(player, entity, true);
							end);
						end;
					else
						Schema:EasyText(player, "firebrick", "You cannot get into a container while in observer!");
					end;
				else
					if (!entity.nextCooldown or curTime > entity.nextCooldown) then
						entity.nextCooldown = curTime + 1;
						
						Schema:EasyText(player, "firebrick", "You cannot hide in this container for another "..math.ceil(entity.nextHideUse - curTime).." seconds!");
					end;
				end;
			elseif (arguments == "cw_entityUnHide") then
				if (entity:GetNWBool("unlocked", true) == true) then
					Clockwork.player:SetAction(player, "unhide", 1.5, nil, function()			
						self:AttemptHide(player, entity, false);
					end);
				else
					Schema:EasyText(player, "maroon", "You are locked inside this container!");
				end
			--[[elseif (arguments == "cwContainerOpen") and (entity:GetNWBool("unlocked", true) == false) then
				if (player:GetCharacterData("hidden") == true) then
					Schema:EasyText(player, "firebrick", "You cannot do this right now!");
					
					return false;
				elseif IsValid(entity.occupier) and entity.occupier ~= player then
					self:OpenedStorage(entity.occupier, entity);
				end;]]--
			end;
		end;
	end;
end;

-- Called at an interval while the player is connected to the server.
function cwContainerHiding:PlayerThink(player, curTime, infoTable, alive, initialized, plyTab)
	if (!plyTab.containerSound) then
		plyTab.containerSound = curTime + math.random(8, 16); 
	elseif (curTime > plyTab.containerSound) then
		if (plyTab.hideEntity) then
			local entity = plyTab.hideEntity;
			local physObj = entity:GetPhysicsObject();
			
			if (IsValid(physObj)) then
				local material = physObj:GetMaterial();
				
				if (string.find(material, "wood")) then
					entity:EmitSound("physics/wood/wood_crate_impact_soft"..math.random(1, 3)..".wav", 55);
				elseif (string.find(material, "metal")) then
					entity:EmitSound("physics/metal/metal_box_impact_soft"..math.random(1, 3)..".wav", 55);
				end;
			end;
		end;
		
		plyTab.containerSound = nil;
	end;
end;

-- Called when an entity is removed.
function cwContainerHiding:EntityRemoved(entity)
	local class = entity:GetClass();
	
	if (IsValid(entity) and class == "prop_physics") then
		if (entity.occupier) then
			self:OpenedStorage(entity.occupier, entity);
		end;
	end;
end;

-- Called when attempts to use a command.
function cwContainerHiding:PlayerCanUseCommand(player, commandTable, arguments)
	local hidden = player:GetCharacterData("hidden");
	
	if (hidden) then
		local blacklisted = {
			"OrderShipment",
			"CharFallover"
		};
		
		if (table.HasValue(blacklisted, commandTable.name)) then
			Schema:EasyText(player, "firebrick", "You cannot use this command while you are hiding in a prop!");
			
			return false;
		end;
	end;
end;

-- Called when a player attempts to switch to a character.
function cwContainerHiding:PlayerCanSwitchCharacter(player, character)
	local hidden = player:GetCharacterData("hidden");
	
	if (hidden) then
		return false, "You cannot switch characters while hiding in a closet!";
	end;
end;

-- Called when a player attempts to drop an item.
function cwContainerHiding:PlayerCanDropItem(player, itemTable, noMessage)
	local hidden = player:GetCharacterData("hidden");
	
	if (hidden) then
		if (!noMessage) then
			Schema:EasyText(player, "firebrick", "You cannot drop items while you are hiding in a closet!");
		end;
		
		return false;
	end;
end;

-- Called when a player attempts to use an item.
function cwContainerHiding:PlayerCanUseItem(player, itemTable, noMessage)
	local hidden = player:GetCharacterData("hidden");
	
	if (hidden) then
		if (!noMessage) then
			Schema:EasyText(player, "firebrick", "You cannot use items while you are hiding in a closet!");
		end;
		
		return false;
	end;
end;

-- Called when the player's character data should be saved.
function cwContainerHiding:PlayerSaveCharacterData(player, data)
	if (data["hidden"]) then
		data["hidden"] = false;
	end;
end;

-- Called when the a player's character data should be restored.
function cwContainerHiding:PlayerRestoreCharacterData(player, data)
	data["hidden"] = false;
end;

-- Called when the shared vars shoud be set.
--[[function cwContainerHiding:OnePlayerHalfSecond(player, curTime)
	player:SetSharedVar("hidden", player:GetCharacterData("hidden"));
end;]]--