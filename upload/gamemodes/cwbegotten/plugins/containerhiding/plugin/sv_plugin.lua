--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

-- Called when the player attempts to hide in a container.
function cwContainerHiding:AttemptHide(player, entity, bHide)
	if player:GetPos():Distance(entity:GetPos()) > 128 then
		Schema:EasyText(player, "peru", "You are too far to hide in this container.");
	
		return;
	end

	if (IsValid(entity.occupier) and entity.occupier:GetCharacterData("hidden") == true and entity.occupier != player) then
		self:OpenedStorage(entity.occupier, entity);
		--Schema:EasyText(player, "peru", "This container is currently occupied by another.");

		return;
	end;

	if (bHide) then
		player:SetCharacterData("hidden", true);
		player:SetSharedVar("hidden", true);
		player:SetPos(entity:LocalToWorld(Vector(0, 0, -50)));
		player:SetNoDraw(true);
		player:DrawShadow(false);
		player:GodEnable();
		player:Freeze(true);
		player.hideEntity = entity;
		entity.occupier = player;
		
		timer.Simple(0.2, function()
			if IsValid(player) then
				-- Do it again because it's an inconsistent bitch.
				player:SetPos(entity:LocalToWorld(Vector(0, 0, -50)));
				player:Freeze(false);
			end;
		end);
		
		if (table.HasValue(self.containerProps["black"], string.lower(entity:GetModel()))) then
			if (player:GetSharedVar("blackOut") != true) then
				player:SetSharedVar("blackOut", true);
			end;
		end;
		
		if !player:IsNoClipping() and (!player.GetCharmEquipped or !player:GetCharmEquipped("urn_silence")) then
			Schema:OpenSound(entity, player);
		end
		
		--Clockwork.datastream:Start(player, "cwCustomHint", {string.Split(player:Name(), " ")[1].." Thinks...", "I should be safe in here..."});
	else
		player:SetCharacterData("hidden", false);
		player:SetSharedVar("hidden", false);
		player:SetPos(entity:LocalToWorld(Vector(50, 0, -24)));
		player:SetNoDraw(false);
		player:DrawShadow(true);
		player:GodDisable();
		player:Freeze(false);
		player.hideEntity = nil;
		entity.occupier = nil;
		
		if (table.HasValue(self.containerProps["black"], string.lower(entity:GetModel()))) then
			if (player:GetSharedVar("blackOut") == true) then
				player:SetSharedVar("blackOut", false);
			end;
		end;
		
		if !player:IsNoClipping() and (!player.GetCharmEquipped or !player:GetCharmEquipped("urn_silence")) then
			Schema:CloseSound(entity, player);
		end
	end;
	
	Clockwork.datastream:Start(player, "ContainerHeartbeat", bHide)
end;

-- Called when a player opens an occupied storage container.
function cwContainerHiding:OpenedStorage(player, entity)
	if (entity.occupier == player and player.hideEntity == entity) then
		self:AttemptHide(player, entity, false);
		Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, 6);
		
		Clockwork.chatBox:AddInTargetRadius(player, "me", " falls out of the closet they were hiding in!", player:GetPos(), config.Get("talk_radius"):Get() * 2);
		
		local sound = table.Random(self.startleSounds["female"]);
		
		if (player:GetGender() == GENDER_MALE) then
			sound = table.Random(self.startleSounds["male"])
		end;
		
		player:EmitSound(sound);
		
		local physObj = entity:GetPhysicsObject();
		
		if (IsValid(physObj)) then
			local material = physObj:GetMaterial();
			
			if (string.find(material, "wood")) then
				entity:EmitSound("physics/wood/wood_crate_break"..math.random(1, 5)..".wav", 70);
			elseif (string.find(material, "metal")) then
				entity:EmitSound("physics/metal/metal_box_break"..math.random(1, 2)..".wav", 70);
			end;
		end;
		
		if (player:GetSharedVar("blackOut") == true) then
			player:SetSharedVar("blackOut", false);
		end;
	end;
end;

--[[concommand.Add("HideInEntity", function(player)
	local ent = player:GetEyeTrace().Entity;
	
	if (ent:GetClass() == "prop_physics") then
		cwContainerHiding:AttemptHide(player, ent, true);
	end;
end);]]--