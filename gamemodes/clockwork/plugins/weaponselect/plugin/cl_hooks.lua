--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- Called when a HUD element should be drawn.
function cwWeaponSelect:HUDShouldDraw(name)
	if (name == "CHudWeaponSelection") then
		return false;
	end;
end;

-- Called when the important HUD should be painted.
function cwWeaponSelect:HUDPaintImportant()
	if (hook.Run("PlayerDrawWeaponSelect") != false) then
		local informationColor = Clockwork.option:GetColor("information");
		local activeWeapon = Clockwork.Client:GetActiveWeapon();
		local colorWhite = Clockwork.option:GetColor("white");
		local frameTime = FrameTime();
		local curTime = UnPredictedCurTime();
		local x = ScrW() / 3;
		local y = ScrH() / 3;
		local weapons = {};
		
		if IsValid(Clockwork.Client.victim) then
			weapons = Clockwork.Client.victim:GetWeapons();
		else
			weapons = Clockwork.Client:GetWeapons();
		end
		
		if (!self.weaponDisplayAlpha) then
			self.weaponDisplayAlpha = 0;
		end;

		if (activeWeapon:IsValid()) then
			if (self.weaponDisplayAlpha <= 0 and self.displayAlpha <= 0) then
				return;
			end;
			
			Clockwork.kernel:OverrideMainFont(Clockwork.option:GetFont("menu_text_tiny"));
				if (self.displaySlot < 1) then
					self.displaySlot = #weapons;
				elseif (self.displaySlot > #weapons) then
					self.displaySlot = 1;
				end;
				
				local currentWeapon = weapons[self.displaySlot];
				local beforeWeapons = {};
				local afterWeapons = {};
				local weaponLimit = math.Clamp(#weapons, 2, 4);
				
				for k, v in ipairs(weapons) do
					if (k < self.displaySlot) then
						table.insert(beforeWeapons, v);
					elseif (k > self.displaySlot) then
						table.insert(afterWeapons, v);
					end;
				end;
				
				if (#beforeWeapons < weaponLimit) then
					local i = 0;
					
					while (#beforeWeapons < weaponLimit) do
						local possibleWeapon = weapons[#weapons - i];
						
						if (possibleWeapon) then
							table.insert(beforeWeapons, 1, possibleWeapon);
							
							i = i + 1;
						else
							i = 0;
						end;
					end;
				end;
				
				if (#afterWeapons < weaponLimit) then
					local i = 0;
					
					while (#afterWeapons < weaponLimit) do
						local possibleWeapon = weapons[1 + i];
						
						if (possibleWeapon) then
							table.insert(afterWeapons, possibleWeapon);
							
							i = i + 1;
						else
							i = 0;
						end;
					end;
				end;
				
				while (#beforeWeapons > weaponLimit) do
					table.remove(beforeWeapons, 1);
				end;
				
				while (#afterWeapons > weaponLimit) do
					table.remove(afterWeapons, #afterWeapons);
				end;

				for k, v in ipairs(beforeWeapons) do
					local printName = hook.Run("ModifyWeaponPrintName", v, self:GetWeaponPrintName(v));
					local useColor = hook.Run("GetWeaponNameColor", v, printName) or colorWhite;

					y = Clockwork.kernel:DrawInfo(string.upper(printName), x, y, useColor, math.min((255 / weaponLimit) * (k * 0.75), self.displayAlpha), true);
				end;
				
				if (IsValid(currentWeapon)) then
					local currentWeaponName = hook.Run("ModifyWeaponPrintName", currentWeapon, self:GetWeaponPrintName(currentWeapon));
					local useColor = hook.Run("GetWeaponNameColor", currentWeapon, currentWeaponName, true) or informationColor;
					
					local weaponInfoY = y;
					local weaponInfoX;
					
					weaponInfoX = x - 436;

					y = Clockwork.kernel:DrawInfo(string.upper(currentWeaponName), x, y, useColor, self.displayAlpha, true);
					
					Clockwork.kernel:OverrideMainFont(false);
						self:DrawWeaponInformation(item.GetByWeapon(currentWeapon), currentWeapon, weaponInfoX, weaponInfoY, self.weaponDisplayAlpha);
						
						if (self.weaponDisplayAlpha != self.weaponDisplayAlphaTarget) then
							local interval = 320;
								if (self.weaponDisplayAlphaTarget == 0) then
									interval = 512;
								end;
							self.weaponDisplayAlpha = math.Approach(self.weaponDisplayAlpha, self.weaponDisplayAlphaTarget, frameTime * (self.displayAlphaTime or 512));
						end;
						
						if (#weapons == 1) then
							y = Clockwork.kernel:DrawInfo("There are no other weapons.", x, y, colorWhite, self.displayAlpha, true);
						end;
					Clockwork.kernel:OverrideMainFont(Clockwork.option:GetFont("menu_text_tiny"));
				end;
				
				if (#weapons > 1) then
					for k, v in ipairs(afterWeapons) do
						local printName = hook.Run("ModifyWeaponPrintName", v, self:GetWeaponPrintName(v));
						local useColor = hook.Run("GetWeaponNameColor", v, printName) or colorWhite;

						y = Clockwork.kernel:DrawInfo(string.upper(printName), x, y, useColor, math.min(255 - ((255 / weaponLimit) * (k * 0.75)), self.displayAlpha), true);
					end;
				end;
			Clockwork.kernel:OverrideMainFont(false);
		end;
		
		if (!self.displayAlphaTarget) then
			self.displayAlphaTarget = 0;
		end;
		
		if (!self.weaponDisplayAlphaTarget) then
			self.weaponDisplayAlphaTarget = 255;
		end;

		if (curTime >= self.displayFade) then
			self.displayAlphaTarget = 0;
			self.weaponDisplayAlphaTarget = 0;
		end;

		if (self.displayAlpha != self.displayAlphaTarget) then
			self.displayAlpha = math.Approach(self.displayAlpha, self.displayAlphaTarget, frameTime * (self.displayAlphaTime or 512));
		else
			if (self.displayAlphaTime) then
				self.displayAlphaTime = nil;
			end;
		end;
	end;
end;

-- Called when the color of a weapon is needed.
function cwWeaponSelect:GetWeaponNameColor(weapon, printName, highlighted)
	return nil;
end;

-- Called just before the weapons printname should be displayed.
function cwWeaponSelect:ModifyWeaponPrintName(weapon, default)
	local lowerPrintName = string.lower(default);
	
	if (string.find(lowerPrintName, "tool") and !string.find(lowerPrintName, "admin")) then
		return "TOOL GUN";
	end;
	
	return default;
end;

-- Called when a player presses a bind at the top level.
function cwWeaponSelect:TopLevelPlayerBindPress(player, bind, press)
	if (Clockwork.ConVars.CINEMATICVIEW and Clockwork.ConVars.CINEMATICVIEW:GetInt() == 1) then
		if (!nextRemind or nextRemind < CurTime()) then
			nextRemind = CurTime() + 10;
			MsgC(colors["tomato"], "Cinematic view is currently enabled! Disable it to use weapon select!\n");
		end;
		
		return;
	end;
	
	if (hook.Run("PlayerDrawWeaponSelect") != false) then
		local activeWeapon;
		local curTime = UnPredictedCurTime();
		local weapons = {};
		
		if IsValid(Clockwork.Client.victim) then
			activeWeapon = Clockwork.Client.victim:GetActiveWeapon();
			weapons = Clockwork.Client.victim:GetWeapons();
		else
			activeWeapon = Clockwork.Client:GetActiveWeapon();
			weapons = Clockwork.Client:GetWeapons();
		end
		
		if (!activeWeapon:IsValid()) then
			return;
		end;
		
		if (Clockwork.Client:InVehicle()) then
			return;
		end;
		
		if (activeWeapon:GetClass() == "weapon_physgun") then
			if (player:KeyDown(IN_ATTACK)) then
				return;
			end;
		end;

		if (string.find(bind, "invnext") or string.find(bind, "slot2")) then
			if (curTime >= self.displayDelay and !press) then
				if (#weapons > 1) then
					surface.PlaySound("common/talk.wav");
				end;
				
				self.displayDelay = curTime + 0.05;
				self.displayAlphaTarget = 255;
				self.displayFade = curTime + 2;
				self.displaySlot = self.displaySlot + 1;
				self.weaponDisplayAlpha = 10;
				self.weaponDisplayAlphaTarget = 255;
				
				if (self.displaySlot > #weapons) then
					self.displaySlot = 1;
				end;
			end;
			
			return true;
		elseif (string.find(bind, "invprev") or string.find(bind, "slot1")) then
			if (curTime >= self.displayDelay and !press) then
				if (#weapons > 1) then
					surface.PlaySound("common/talk.wav");
				end;
				
				self.displayDelay = curTime + 0.05;
				self.displayAlphaTarget = 255;
				self.displayFade = curTime + 2;
				self.displaySlot = self.displaySlot - 1;
				self.weaponDisplayAlpha = 10;
				self.weaponDisplayAlphaTarget = 255;
				
				if (self.displaySlot < 1) then
					self.displaySlot = #weapons;
				end;
			end;
			
			return true;
		elseif (string.find(bind, "+attack")) then
			if (#weapons > 1) then
				if (self.displayAlpha >= 128 and IsValid(weapons[self.displaySlot])) then
					if !self.nextWeaponSelect or self.nextWeaponSelect < curTime then
						self.nextWeaponSelect = curTime + 0.1;
					
						if IsValid(Clockwork.Client.victim) then
							netstream.Start("SelectWeaponVictim", weapons[self.displaySlot]:GetClass());
						else
							netstream.Start("SelectWeapon", weapons[self.displaySlot]:GetClass());
						end
						
						--surface.PlaySound("begotten/ui/buttonclickrelease.wav");
						surface.PlaySound("begotten/ui/buttonrollover.wav");

						self.displayAlphaTarget = 0;
						self.displayAlphaTime = 1024;
						self.weaponDisplayAlphaTarget = 0;
						
						return true
					end
				end;
			end;
		end;
	end;
end