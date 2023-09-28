local overlay;

-- Called when helmet (bodygroup 1) screen space effects should be rendered.
function PLUGIN:RenderScreenspaceEffects()
	local curTime = CurTime();
	
	if Clockwork.Client:HasInitialized() and !Clockwork.kernel:IsChoosingCharacter() and Clockwork.Client:Alive() then
		if !cwDayNight.moonHallucination and !Clockwork.Client.CosmicRuptureRender then
			if !Clockwork.Client.OverlayCheck or Clockwork.Client.OverlayCheck < curTime then
				overlay = nil;
				
				if !Clockwork.Client:IsNoClipping() then
					local helmetItem = Clockwork.Client:GetHelmetEquipped();

					if helmetItem and helmetItem.overlay then
						overlay = helmetItem.overlay;
					else
						local clothesItem = Clockwork.Client:GetClothesEquipped();
						
						if clothesItem and clothesItem.overlay then
							overlay = clothesItem.overlay;
						end
					end;
				end
				
				Clockwork.Client.OverlayCheck = curTime + 0.1;
			end
			
			if overlay then
				DrawMaterialOverlay(overlay, 0.1);
			end
		end
	end
end;

function PLUGIN:Tick()
	for _, player in pairs(_player.GetAll()) do
		player.clothesDrawnThisTick = false;
	end
	
	for k, v in pairs(ents.FindByClass("prop_ragdoll")) do
		if v:GetNWString("clothes") then
			if !IsValid(v.clothesEnt) then
				v.clothesEnt = ClientsideModel(v:GetNWString("clothes"), RENDERGROUP_BOTH);
				
				if IsValid(v.clothesEnt) then
					v.clothesEnt:SetParent(v);
					v.clothesEnt:AddEffects(EF_BONEMERGE);
					v:SetColor(v:GetColor());
					v:SetNoDraw(v:GetNoDraw());
				end
			else
				if v.clothesEnt:GetModel() ~= v:GetNWString("clothes") then
					v.clothesEnt:Remove();
					v.clothesEnt = ClientsideModel(v:GetNWString("clothes"), RENDERGROUP_BOTH);
				end
			
				if v.clothesEnt:GetParent() ~= v then
					v.clothesEnt:SetParent(v);
					v.clothesEnt:AddEffects(EF_BONEMERGE);
				end
				
				v:SetColor(v:GetColor());
				v:SetNoDraw(v:GetNoDraw());
			end
		end
	end
end

function PLUGIN:PostPlayerDraw(player, flags)
	local shouldBeVisible = player:Alive() and ((player:GetMoveType() == MOVETYPE_WALK and player:GetColor().a > 0) or player:InVehicle());

	if shouldBeVisible and string.find(player:GetModel(), "models/begotten/heads") then
		local clothes = player:GetClothesEquipped();
		local model;

		if clothes and clothes.group then
			if clothes.genderless then
				model = "models/begotten/"..clothes.group..".mdl";
			else
				model = "models/begotten/"..clothes.group.."_"..string.lower(player:GetGender())..".mdl"
			end
		else
			local faction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();
			local factionTable = Clockwork.faction:FindByID(faction);
			local subfaction = player:GetSharedVar("kinisgerOverrideSubfaction") or player:GetSharedVar("subfaction");
			
			if subfaction and factionTable.subfactions then
				for k, v in pairs(factionTable.subfactions) do
					if k == subfaction and v.models then
						model = v.models[string.lower(player:GetGender())].clothes;
					
						break;
					end
				end
			end
			
			if !model then
				model = factionTable.models[string.lower(player:GetGender())].clothes;
			end
		end
		
		if IsValid(player.clothesEnt) and player.clothesEnt:GetModel() ~= model then
			player.clothesEnt:Remove();
			player.clothesEnt = nil;
		end
		
		if !IsValid(player.clothesEnt) then
			player.clothesEnt = ClientsideModel(model, RENDERGROUP_BOTH);
		end
		
		if player.clothesEnt:GetParent() ~= player then
			player.clothesEnt:SetParent(player);
			player.clothesEnt:AddEffects(EF_BONEMERGE);
		end
		
		local clothesEnt = player.clothesEnt;

		clothesEnt:SetColor(player:GetColor());
		clothesEnt:SetNoDraw(player:GetNoDraw());

		player.clothesDrawnThisTick = true;
	end
end

function PLUGIN:Think()
	for _, player in pairs(_player.GetAll()) do
		local clothesEnt = player.clothesEnt;
		
		if clothesEnt and !player.clothesDrawnThisTick then
			if IsValid(clothesEnt) then
				clothesEnt:Remove();
			end
			
			player.clothesEnt = nil;
		end
	end
end

function PLUGIN:EntityRemoved(entity, bFullUpdate)
	if entity:GetClass() == "prop_ragdoll" then
		if IsValid(entity.clothesEnt) then
			entity.clothesEnt:Remove();
			entity.clothesEnt = nil;
		end
	end
end