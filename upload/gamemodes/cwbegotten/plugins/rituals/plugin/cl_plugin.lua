--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local glowMaterial = Material("sprites/glow04_noz");

if not cwRituals.hotkeyRituals then
	cwRituals.hotkeyRituals = --[[Clockwork.kernel:RestoreSchemaData("hotkeys") or]] {};
end

if not cwRituals.storedPlayers then
	cwRituals.storedPlayers = {};
end

function cwRituals:FindRitualByItems(itemList, bReturnRitualTable)
	local allRituals = self:GetAll();
	local ritualTable;
	
	for k, v in pairs (allRituals) do
		if v.requirements then
			local isRitualTable = true;
			
			for i = 1, #v.requirements do
				if v.requirements[i] ~= itemList[i] then
					isRitualTable = false;
					break;
				end
			end
			
			if isRitualTable then
				ritualTable = v;
				break;
			end
		end
	end;

	if ritualTable then
		if bReturnRitualTable then
			return ritualTable;
		else
			return ritualTable.uniqueID;
		end
	end
end

function cwRituals:AttemptRitual(uniqueID, itemIDs)
	local curTime = CurTime();
	
	if !self.nextRitualAttempt or self.nextRitualAttempt < curTime then
		if uniqueID then
			local ritualTable = self.rituals.stored[uniqueID];
			
			if ritualTable then
				--if self:PlayerMeetsRitualItemRequirements(ritualTable) then
					netstream.Start("DoRitual", {uniqueID, itemIDs});
					
					if (IsValid(Clockwork.Client.cwRitualMenu)) then
						Clockwork.Client.cwRitualMenu:Close()
						Clockwork.Client.cwRitualMenu:Remove()
						Clockwork.Client.cwRitualMenu = nil;
						return;
					end
				--end
			else
				Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "No valid ritual for this combination of items could be found!");
			end
		else
			Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "No valid ritual for this combination of items could be found!");
		end
		
		self.nextRitualAttempt = curTime + 2;
	end
end

-- Called to get whether a player can perform a ritual or not.
function cwRituals:PlayerCanPerformRitual(uniqueID)
	local ritualTable = self.rituals.stored[uniqueID];
	local requirements = ritualTable.requirements;
	
	if (table.IsEmpty(requirements)) then
		return;
	end;
	
	local access = ritualTable.access;
	local requiredSubfaction = ritualTable.requiredSubfaction;
	local requiredBeliefsSubfactionOverride = ritualTable.requiredBeliefsSubfactionOverride;
	local onerequiredbelief = ritualTable.onerequiredbelief;
	local subfaction = Clockwork.Client:GetNetVar("subfaction");
	local subfaith = Clockwork.Client:GetNetVar("subfaith");
	
	if Clockwork.Client:IsRagdolled() or !Clockwork.Client:Alive() then
		--Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "Your character cannot perform a ritual at this moment!");
		return false;
	end
	
	if (access) then
		if (!Clockwork.player:HasFlags(Clockwork.Client, access)) then
			return false;
		end;
	end;
	
	if requiredSubfaction then
		if subfaction and not table.HasValue(requiredSubfaction, subfaction) then
			--Schema:EasyText(player, "firebrick", "You are not the correct subfaction to perform this ritual!");
			return false;
		end
	end
	
	if cwBeliefs and cwBeliefs.HasBelief then
		if !subfaith or (subfaith and subfaith == "") then
			return false;
		else
			if requiredBeliefsSubfactionOverride then
				for k, v in pairs(requiredBeliefsSubfactionOverride) do
					if k == subfaction then
						for i = 1, #v do
							if cwBeliefs:HasBelief(v[i]) then
								return true;
							end
						end
					end
				end
			end
		
			if onerequiredbelief then
				for i = 1, #onerequiredbelief do
					if cwBeliefs:HasBelief(onerequiredbelief[i]) then
						return true;
					end
				end
				
				return false;
			end
		end
	end

	return true;
end;

--[[function cwRituals:PlayerMeetsRitualItemRequirements(ritualTable)
	if isstring(ritualTable) then
		ritualTable = self.rituals.stored[ritualTable];
		
		if !ritualTable or isstring(ritualTable) then
			Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "No valid ritual for this combination of items could be found!");
			return false;
		end
	end
	
	local inventory = Clockwork.inventory:GetClient();
	local slottedItems = {};
	local requirements = ritualTable.requirements;
	
	for i = 1, #itemIDs do
		local itemID = itemIDs[i];
		
		for k, v in pairs(inventory) do
			for k2, v2 in pairs(v) do
				if v2.itemID == itemID then
					local itemTable = Clockwork.inventory:FindItemByID(inventory, k, v2.itemID);
					
					table.insert(slottedItems, itemTable);
					break;
				end
			end
		end
	end
	
	local temptab = table.Copy(slottedItems);

	for k, v in pairs(requirements) do
		for i = 1, v.amount do
			local goods_found = false;
			
			for j = 1, #temptab do
				if temptab[j].uniqueID == k then
					table.remove(temptab, j);
					goods_found = true;
					break;
				end
			end
				
			if not goods_found then
				return false;
			end
		end
	end
	
	if #temptab > 0 then
		return false;
	end
	
	return true;
end]]--

-- A function to get all the available recipes.
function cwRituals:GetAvailable()
	local allRituals = self:GetAll();
	local client = Clockwork.Client;
	local available = table.Copy(allRituals);
	
	for k, v in pairs (allRituals) do
		--[[if (!Clockwork.player:HasFlags(client, access) and available[k]) then
			available[k] = nil; continue;
		end;]]--
		
		if (hook.Run("PlayerCanPerformRitual", k) == false) then
			available[k] = nil; continue;
		end;
	end;
	
	return available;
end;

-- Called to check if a player does recognise another player.
function cwRituals:PlayerDoesRecognisePlayer(player, status, isAccurate, realValue)
	if Clockwork.Client:GetNetVar("faith") == "Faith of the Dark" and player:GetNetVar("markedBySatanist") then
		return true;
	end
end;

function cwRituals:GetProgressBarInfoAction(action, percentage)
	if (action == "ritualing") then
		return {text = "You are performing a ritual. Click to cancel.", percentage = percentage, flash = percentage < 0}
	end
end

local powderheelAuraDistance = 512*512;

function cwRituals:PostDrawOpaqueRenderables()
	local curTime = CurTime();

	if !self.nextVFXCheck or self.nextVFXCheck < curTime then
		self.nextVFXCheck = curTime + math.Rand(0.5, 1);
	
		self.storedPlayers = {};
		
		for k, v in pairs(ents.FindInSphere(Clockwork.Client:GetPos(), 1200)) do
			local player;
			
			if v:IsPlayer() then
				player = v;
			elseif Clockwork.entity:IsPlayerRagdoll(v) then
				player = Clockwork.entity:GetPlayer(v);
			end
			
			if player then
				if player:GetNetVar("powderheelActive") then
					table.insert(self.storedPlayers, player);
				end
				
				if player:GetNetVar("enlightenmentActive") then
					table.insert(self.storedPlayers, player);
				end
				
				if player ~= Clockwork.Client then
					if player:GetNetVar("soulscorchActive") or player:GetNetVar("auraMotherActive") then
						table.insert(self.storedPlayers, player);
					end
				end
			end
		end;
	end
	
	for k, v in pairs(self.storedPlayers) do
		if IsValid(v) and v:Alive() and ((v:GetMoveType() == MOVETYPE_WALK or v:GetMoveType() == MOVETYPE_LADDER) or v:IsRagdolled()) then
			local entityPosition = v:GetPos();
			local vEnt = v:GetRagdollEntity() or v;
		
			if v:GetNetVar("soulscorchActive") then
				local headBone = vEnt:LookupBone("ValveBiped.Bip01_Head1");
				
				if (headBone) then
					local bonePosition, boneAngles = vEnt:GetBonePosition(headBone);
					local eyes = vEnt:LookupAttachment("eyes");
					local eyesAttachment = vEnt:GetAttachment(eyes);
					
					if (bonePosition and eyesAttachment) then
						local glowColor = Color(255, 215, 0, 255);
						local position = eyesAttachment.Pos + Vector(0, 0, 4);
						
						render.SetMaterial(glowMaterial);
						render.DrawSprite(position, 32, 32, glowColor);
					end;
				end;
			end
			
			if v:GetNetVar("auraMotherActive") then
				local headBone = vEnt:LookupBone("ValveBiped.Bip01_Head1");
				
				if (headBone) then
					local bonePosition, boneAngles = vEnt:GetBonePosition(headBone);
					local eyes = vEnt:LookupAttachment("eyes");
					local eyesAttachment = vEnt:GetAttachment(eyes);
					
					if (bonePosition and eyesAttachment) then
						local glowColor = Color(0, 255, 0, 255);
						local position = eyesAttachment.Pos + Vector(0, 0, 4);
						
						render.SetMaterial(glowMaterial);
						render.DrawSprite(position, 32, 32, glowColor);
					end;
				end;
			end
			
			if v:GetNetVar("enlightenmentActive") then
				local dynamicLight = DynamicLight(v:EntIndex());
				
				if (dynamicLight) then
					dynamicLight.Pos = entityPosition + Vector(0, 0, 90);
					dynamicLight.r = 255;
					dynamicLight.g = 255;
					dynamicLight.b = 224;
					dynamicLight.Brightness = 1;
					dynamicLight.Size = 2048;
					dynamicLight.DieTime = curTime + 0.1;
					dynamicLight.Style = 0;
				end;
			end
			
			if v:GetNetVar("powderheelActive") and v:GetPos():DistToSqr(localPlayer:GetPos()) < powderheelAuraDistance then
				cam.Start3D2D(v:GetPos(), angle_zero, 1);
					cam.IgnoreZ(true);

					surface.SetDrawColor(0, 150, 0, TimedCos(0.25, 50, 75, 0));
					surface.SetMaterial(glowMaterial);

					local radius = config.Get("talk_radius"):Get();
					local halfRadius = radius*.5;

					surface.DrawTexturedRect(-halfRadius,-halfRadius,radius,radius);

					cam.IgnoreZ(false);
				cam.End3D2D();
			end
		end;
	end
end;

netstream.Hook("HotkeyMenu", function(data)
	if cwPosession and (IsValid(Clockwork.Client.possessor) or IsValid(Clockwork.Client.victim)) then
		return;
	end
	
	Clockwork.Client:ConCommand("begotten_rituals");
	
end);

netstream.Hook("LoadRitualBinds", function(data)
	if data and istable(data) then
		cwRituals.hotkeyRituals = data;
	else
		cwRituals.hotkeyRituals = {};
	end
end);

netstream.Hook("OpenAppearanceAlterationMenu", function(data)
	local menu = vgui.Create("cwRitualAppearanceChange");
	
	menu:MakePopup();
end);

netstream.Hook("OpenRegrowthMenu", function(data)
	local hitgroupToString = {
		[HITGROUP_CHEST] = "Chest",
		[HITGROUP_HEAD] = "Head",
		[HITGROUP_STOMACH] = "Stomach",
		[HITGROUP_LEFTARM] = "Left Arm",
		[HITGROUP_RIGHTARM] = "Right Arm",
		[HITGROUP_LEFTLEG] = "Left Leg",
		[HITGROUP_RIGHTLEG] = "Right Leg",
	};
	local options = {};
	
	for k, v in SortedPairs(hitgroupToString) do
		options[v] = function()
			netstream.Start("RegrowthMenu", k);
		end;
	end
	
	cwRituals.regrowthMenu = Clockwork.kernel:AddMenuFromData(nil, options);
	
	if (IsValid(cwRituals.regrowthMenu)) then
		cwRituals.regrowthMenu:SetPos(
			(ScrW() / 2) - (cwRituals.regrowthMenu:GetWide() / 2),
			(ScrH() / 2) - (cwRituals.regrowthMenu:GetTall() / 2)
		);
	end;
end);