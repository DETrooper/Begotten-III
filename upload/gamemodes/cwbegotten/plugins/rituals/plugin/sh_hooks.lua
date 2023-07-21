--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

library.New("rituals", cwRituals);
cwRituals.rituals.stored = cwRituals.rituals.stored or {};
local RITUAL_TABLE = {__index = RITUAL_TABLE};

-- Called when the item is converted to a string.
function RITUAL_TABLE:__tostring()
	return self.uniqueID;
end;

-- Called when the item is invoked as a function.
function RITUAL_TABLE:__call(varName, failSafe)
	return self[varName] or failSafe;
end;

-- A function to register a ritual table.
function RITUAL_TABLE:Register()
	cwRituals.rituals:Register(self);
end;

-- A function to get a new ritual.
function cwRituals.rituals:New(uniqueID)
	if (!uniqueID) then
		return;
	end;
	
	local object = Clockwork.kernel:NewMetaTable(RITUAL_TABLE);
		object.uniqueID = cwRituals:SafeName(uniqueID);
	return object;
end;

-- A function to register a ritual.
function cwRituals.rituals:Register(ritual)
	if (ritual) then
		local bInvalid = false;
		
		if (!ritual.uniqueID or !ritual.requirements) then
			return;
		else
			ritual.uniqueID = cwRituals:SafeName(ritual.uniqueID);
			
			for i = 1, #ritual.requirements do
				local itemTable = item.FindByID(ritual.requirements[i]);
				
				if (!itemTable) then
					bInvalid = true; break;
				end;
			end;
		end;

		if (bInvalid) then
			return;
		end;
		
		if (SERVER) then
			--hook.Run("ModifyRitualTable", ritual);
			
			function ritual:PerformRitual(player, itemIDs, bMetRequirements)
				if !bMetRequirements then
					local bHasFlags, bHasRequirements = hook.Run("PlayerCanPerformRitual", player, self.uniqueID);
				
					if bHasFlags == false or bHasRequirements == false then
						return;
					end
				
					if !cwRituals:PlayerMeetsRitualItemRequirements(player, self, itemIDs, true) then
						return;
					end
				end
				
				if self.result then
					local trace = player:GetEyeTraceNoCursor();
					
					if (trace.Hit) then
						for k, v in pairs (self.result) do
							for i = 1, math.abs(v.amount) do
								local itemTable = Clockwork.item:CreateInstance(k);
								
								if itemTable then
									local entity = Clockwork.entity:CreateItem(player, itemTable, trace.HitPos);
									
									if IsValid(entity) then
										entity:SetRenderMode(RENDERMODE_TRANSCOLOR);
										entity:SetColor(Color(255, 255, 255, 0));
										
										timer.Create("summonitem_ritual_"..itemTable.itemID, 0.75, 1, function()
											if (IsValid(entity)) then
												Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
												entity:SetColor(Color(255, 255, 255, 255));
												
												Clockwork.chatBox:AddInTargetRadius(player, "it", "A "..itemTable.name.." materializes in a ring of fire.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
											end;
										end);
									end
								end
							end
						end
						
						ParticleEffect("teleport_fx", trace.HitPos, Angle(0,0,0), entity);
						sound.Play("misc/summon.wav", trace.HitPos, 100, 100);
						
						timer.Simple(0.75, function()
							util.Decal("PentagramBurn", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal);
						end);
					else
						Schema:EasyText(player, "firebrick", "You must be looking at a closer position to summon this ritual's item.");
						return;
					end;
				end
				
				if (self.finishSound) then
					player:EmitSound(self.finishSound, 70);
				end;
				
				if (self.OnPerformed) then
					self:OnPerformed(player);
				end;
				
				hook.Run("PlayerFinishedRitual", player, self);
			end;
		end;
		
		self.stored[ritual.uniqueID] = ritual;
	end;
end;

-- A function to convert a string to a uniqueID.
function cwRituals:SafeName(uniqueID)
	return string.lower(string.gsub(uniqueID, "['%.]", ""));
end;

-- A function to get all of the rituals on the server.
function cwRituals:GetAll()
	return self.rituals.stored;
end;

-- A function to find a specific ritual.
function cwRituals:FindByID(identifier)
	if (self.rituals.stored[identifier]) then
		return self.rituals.stored[identifier];
	else
		for k, v in pairs (self.rituals.stored) do
			if (string.lower(v.name) == string.lower(identifier)) then
				return self.rituals.stored[k];
			end;
		end;
	end;
end;