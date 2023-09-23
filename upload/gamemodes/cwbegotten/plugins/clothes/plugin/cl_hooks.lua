local overlay;

-- Called when helmet (bodygroup 1) screen space effects should be rendered.
function PLUGIN:RenderScreenspaceEffects()
	local curTime = CurTime();
	
	if Clockwork.Client:HasInitialized() and !Clockwork.kernel:IsChoosingCharacter() and Clockwork.Client:Alive() then
		if !cwDayNight.moonHallucination and !Clockwork.Client.CosmicRuptureRender then
			if !Clockwork.Client.OverlayCheck or Clockwork.Client.OverlayCheck < curTime then
				overlay = nil;
				
				if !Clockwork.Client:IsNoClipping() then
					local item_found = false;
					
					if Clockwork.Client.bgClothesData then
						for k, v in pairs(Clockwork.Client.bgClothesData) do
							local clothesData = v;
							
							if clothesData then
								if (clothesData.uniqueID and clothesData.itemID) then
									local item = Clockwork.item:FindByID(clothesData.uniqueID, clothesData.realID);
									
									if item and item.overlay then
										item_found = true;
										overlay = item.overlay;
									end;
								end;
							end
						end
					end
					
					if !item_found and Clockwork.ClothesData then
						local item = Clockwork.player:GetClothesItem();
						
						if item and item.overlay then
							item_found = true;
							overlay = item.overlay;
						end;
					end
				end
				
				Clockwork.Client.OverlayCheck = curTime + 0.1;
			end
			
			if overlay then
				DrawMaterialOverlay(overlay, 0.1);
			end
		end
	end
end;

netstream.Hook("BGClothes", function(data)
	Clockwork.Client.bgClothesData = data or {};
end);