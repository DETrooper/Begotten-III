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
		if string.sub(v:GetModel(), 1, 21) == "models/begotten/heads" then
			local model = v:GetNWString("clothes");
			local vTab = v:GetTable();
			local clothesEnt = vTab.clothesEnt;
			
			if IsValid(clothesEnt) and clothesEnt:GetModel() ~= model then
				clothesEnt:Remove();
				vTab.clothesEnt = nil;
			end
		
			if !IsValid(clothesEnt) then
				clothesEnt = ClientsideModel(model, RENDERGROUP_BOTH);
				
				if IsValid(clothesEnt) then
					clothesEnt:SetParent(v);
					clothesEnt:AddEffects(EF_BONEMERGE);
					clothesEnt:SetColor(v:GetColor());
					clothesEnt:SetNoDraw(v:GetNoDraw());
					
					vTab.clothesEnt = clothesEnt;
				end
			else
				if clothesEnt:GetModel() ~= v:GetNWString("clothes") then
					clothesEnt:Remove();
					vTab.clothesEnt = ClientsideModel(v:GetNWString("clothes"), RENDERGROUP_BOTH);
				end
			
				if clothesEnt:GetParent() ~= v then
					clothesEnt:SetParent(v);
					clothesEnt:AddEffects(EF_BONEMERGE);
				end
				
				clothesEnt:SetColor(v:GetColor());
				clothesEnt:SetNoDraw(v:GetNoDraw());
				clothesEnt:SetPos(v:GetPos());
			end
		elseif v.clothesEnt then
			if IsValid(v.clothesEnt) then
				v.clothesEnt:Remove();
			end
			
			v.clothesEnt = nil;
		end
	end
end

function PLUGIN:PostPlayerDraw(player, flags)
	if string.sub(player:GetModel(), 1, 21) == "models/begotten/heads" then
		local plyColor = player:GetColor();
	
		if player:Alive() and player:GetMoveType() ~= MOVETYPE_OBSERVER and plyColor.a > 0 then
			local plyTab = player:GetTable();
			local clothes = player:GetClothesEquipped();
			local model;

			if clothes and clothes.group then
				if clothes.genderless then
					model = "models/begotten/"..clothes.group..".mdl";
				else
					model = "models/begotten/"..clothes.group.."_"..string.lower(player:GetGender())..".mdl"
				end
			else
				local faction = player:GetFaction();
				
				if faction then
					if faction == "Children of Satan" then
						faction = player:GetNetVar("kinisgerOverride") or faction;
					end
					
					local factionTable = Clockwork.faction:FindByID(faction);
					
					if factionTable then
						local subfaction = player:GetNetVar("subfaction");
						
						if faction == "Children of Satan" then
							subfaction = player:GetNetVar("kinisgerOverrideSubfaction") or subfaction;
						end

						if subfaction and factionTable.subfactions then
							for i, v in ipairs(factionTable.subfactions) do
								if v.name == subfaction and v.models then
									model = v.models[string.lower(player:GetGender())].clothes;
								
									break;
								end
							end
						end
						
						if !model then
							model = factionTable.models[string.lower(player:GetGender())].clothes;
						end
					end
				end
			end
			
			local clothesEnt = plyTab.clothesEnt;
			
			if IsValid(clothesEnt) and clothesEnt:GetModel() ~= model then
				clothesEnt:Remove();
				plyTab.clothesEnt = nil;
			end
			
			if !IsValid(clothesEnt) then
				if model then
					plyTab.clothesEnt = ClientsideModel(model, RENDERGROUP_BOTH);
					clothesEnt = plyTab.clothesEnt;
				else
					return;
				end
			end
			
			if clothes and clothes.bodygroupCharms then
				for k, v in pairs(clothes.bodygroupCharms) do
					if player:GetCharmEquipped(k) then
						if clothesEnt:GetBodygroup(v[1]) ~= v[2] then
							clothesEnt:SetBodygroup(v[1], v[2]);
						end
					end
				end
			end
			
			if clothesEnt:GetParent() ~= player then
				clothesEnt:SetParent(player);
				clothesEnt:AddEffects(EF_BONEMERGE);
			end

			clothesEnt:SetColor(plyColor);
			clothesEnt:SetNoDraw(player:GetNoDraw());

			plyTab.clothesDrawnThisTick = true;
		end
	end
end

function PLUGIN:Think()
	for _, player in pairs(_player.GetAll()) do
		local plyTab = player:GetTable();
		local clothesEnt = plyTab.clothesEnt;
		
		if clothesEnt and !plyTab.clothesDrawnThisTick then
			if IsValid(clothesEnt) then
				clothesEnt:Remove();
			end
			
			plyTab.clothesEnt = nil;
		end
	end
end

function PLUGIN:EntityRemoved(entity, bFullUpdate)
	if bFullUpdate then return end;

	if entity:IsPlayer() or entity:GetClass() == "prop_ragdoll" then
		if IsValid(entity.clothesEnt) then
			entity.clothesEnt:Remove();
		end
		
		entity.clothesEnt = nil;
	end
end

-- Called when the bars are needed.
function PLUGIN:GetBars(bars)
	local hatred = Clockwork.Client:GetNetVar("Hatred", 0);
	
	if (!self.hatred) then
		self.hatred = hatred;
	else
		self.hatred = math.Approach(self.hatred, hatred, 1);
	end;
	
	local clothesItem = Clockwork.Client:GetClothesEquipped();
	
	if clothesItem and clothesItem.attributes and table.HasValue(clothesItem.attributes, "solblessed") then
		bars:Add("HATRED", Color(255, 69, 0, 255), "HATRED", self.hatred, 100, self.hatred == 100);
	end;
end;