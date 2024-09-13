--[[
	Begotten III: Jesus Wept
--]]

local playerMeta = FindMetaTable("Player");

-- A function to handle a player's implants.
function playerMeta:HandleSenses()
--[[	local senses = self:GetWeapon("cw_senses");

	if (IsValid(senses) and !self.sensesOn and self:Alive() and !self:IsRagdolled()) then
		self:SetLocalVar("senses", true);
self.sensesOn = true
		netstream.Start(self, "Stunned", 1.5);
		netstream.Start(self, "PlaySound", table.Random({"ambient/machines/teleport1.wav", "ambient/machines/teleport3.wav", "ambient/machines/teleport4.wav"}));
	else
		self:SetLocalVar("senses", false);
self.sensesOn = nil
		netstream.Start(self, "Stunned", 1.5);
		netstream.Start(self, "PlaySound", table.Random({"ambient/machines/teleport1.wav", "ambient/machines/teleport3.wav", "ambient/machines/teleport4.wav"}));
	end;--]]
end;

-- A function to handle a player's senses.
function playerMeta:SensesOn(bRightClick)
	local senses = self:GetWeapon("cw_senses");

	if (IsValid(senses) and self:Alive() and !self:IsRagdolled()) then
		local clothesItem = self:GetClothesEquipped();
		local nightVision = bRightClick and clothesItem and clothesItem.attributes and table.HasValue(clothesItem.attributes, "night_vision");
		local thermalVision = !bRightClick and clothesItem and clothesItem.attributes and table.HasValue(clothesItem.attributes, "thermal_vision");
		
		if self:GetCharmEquipped("thermal_implant") then
			if bRightClick then
				nightVision = true;
			else
				thermalVision = true;
			end
		end
		
		if (nightVision or thermalVision) then
			if (nightVision) then
				if self:GetNetVar("hasThermal") then
					self:SetLocalVar("hasThermal", false);
				end
			
				self:SetLocalVar("hasNV", true);
			elseif (thermalVision) then
				if self:GetNetVar("hasNV") then
					self:SetLocalVar("hasNV", false);
				end
			
				self:SetLocalVar("hasThermal", true);
			end
			
			if !self.cwObserverMode then
				self:EmitSound("items/nvg_on.wav");
				
				if !self.opponent and cwBeliefs and cwCharacterNeeds and self:HasBelief("yellow_and_black") then
					self:HandleNeed("sleep", 1);
				end
			end
			
			self:SetLocalVar("senses", true);
		else
			netstream.Start(self, "BlackStunned", 1);
			--netstream.Start(self, "PlaySound", table.Random({"ambient/machines/teleport1.wav", "ambient/machines/teleport3.wav", "ambient/machines/teleport4.wav"}));
			
			timer.Simple(1, function()
				if IsValid(self) and ((self.HasBelief and self:HasBelief("creature_of_the_dark")) or (IsValid(self:GetActiveWeapon()) and self:GetActiveWeapon():GetClass() == "cw_senses")) then
					netstream.Start(self, "PlaySound", "begotten/ambient/req/whoosh_02.wav");
					self:SetLocalVar("senses", true);
					self:SetDSP(114);
				end
			end);
		end
		
		self.sensesOn = true;
	end
end;

-- A function to handle a player's senses.
function playerMeta:SensesOff()
	if self:GetNetVar("hasThermal") or self:GetNetVar("hasNV") then
		if self:GetNetVar("hasThermal") then
			self:SetLocalVar("hasThermal", false);
		end
		
		if self:GetNetVar("hasNV") then
			self:SetLocalVar("hasNV", false);
		end
		
		if !self.cwObserverMode and self:Alive() then
			self:EmitSound("items/nvg_off.wav");
		end
		
		self:SetLocalVar("senses", false);
		self:SetDSP(0);
	elseif self:GetNetVar("senses") then
		if self:Alive() then
			netstream.Start(self, "BlackStunned", 1);
			
			timer.Simple(1, function()
				if IsValid(self) then
					netstream.Start(self, "PlaySound", "begotten/ambient/hits/disappear.mp3");
					self:SetLocalVar("senses", false);
					self:SetDSP(0);
				end
			end);
		else
			self:SetLocalVar("senses", false);
			self:SetDSP(0);
		end
	end
		
	self.sensesOn = nil;
end;
