--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- A function to override a markup's draw function.
function cwWeaponSelect:OverrideMarkupDraw(markupObject)
	function markupObject:Draw(xOffset, yOffset, hAlign, vAlign, alphaOverride)
		for k, v in pairs(self.blocks) do
			local alpha = v.colour.a;
			local y = yOffset + (v.height - v.thisY) + v.offset.y;
			local x = xOffset;
			
			if (alphaOverride) then
				alpha = alphaOverride;
			end;
			
			Clockwork.kernel:OverrideMainFont(v.font);
				Clockwork.kernel:DrawSimpleText(v.text, x, y, Color(v.colour.r, v.colour.g, v.colour.b, alpha), hAlign, vAlign);
			Clockwork.kernel:OverrideMainFont(false);
		end;
	end;
end;

-- A function to draw a weapon's information.
function cwWeaponSelect:DrawWeaponInformation(itemTable, weapon, x, y, alpha)
	local informationColor = Clockwork.option:GetColor("information");
	local backgroundColor = Clockwork.option:GetColor("background");
	local clipTwoAmount = Clockwork.Client:GetAmmoCount(weapon:GetSecondaryAmmoType());
	local clipOneAmount = Clockwork.Client:GetAmmoCount(weapon:GetPrimaryAmmoType());
	local mainTextFont = Clockwork.option:GetFont("main_text");
	local secondaryAmmo;
	local primaryAmmo;
	local clipTwo = weapon:Clip2();
	local clipOne = weapon:Clip1();
	
	-- new ammo
	local ammo;
	local ammoText;
	
	if itemTable then
		ammo = itemTable:GetData("Ammo");
	end
	
	if (!weapon.Primary or !weapon.Primary.ClipSize or weapon.Primary.ClipSize > 0) then
		if (clipOne > 0) then
			--primaryAmmo = "Primary: "..clipOne.."/"..clipOneAmount..".";
		end;
	end;
	
	if (!weapon.Secondary or !weapon.Secondary.ClipSize or weapon.Secondary.ClipSize > 0) then
		if (clipTwo > 0) then
			--secondaryAmmo = "Secondary: "..clipTwo.."/"..clipTwoAmount..".";
		end;
	end;
	
	if ammo then
		if #ammo > 0 then
			if itemTable.ammoCapacity > 1 then
				if itemTable.usesMagazine then
					local clipItem = Clockwork.item:FindByID(string.gsub(string.lower(ammo[1]), " ", "_"));
					
					if clipItem then
						ammoText = "Loaded Shot: "..ammo[1].." ("..tostring(#ammo).."/"..tostring(clipItem.ammoMagazineSize or weapon.Primary.ClipSize)..")";
					else
						ammoText = "Loaded Shot: "..ammo[1].." ("..tostring(#ammo).."/"..tostring(weapon.Primary.ClipSize)..")";
					end
				else
					-- Likely is multi-barreled gun.
					ammoText = "Loaded Shot: ";
					
					for i = 1, itemTable.ammoCapacity do
						if i <= #ammo then
							ammoText = ammoText.."\n"..tostring(i)..") "..ammo[i];
						else
							ammoText = ammoText.."\n"..tostring(i)..") Empty Chamber";
						end
					end
				end
			else
				ammoText = "Loaded Shot: "..ammo[1];
			end
		end
	end
	
	if (!weapon.Instructions) then weapon.Instructions = ""; end;
	if (!weapon.Purpose) then weapon.Purpose = ""; end;
	if (!weapon.Contact) then weapon.Contact = ""; end;
	if (!weapon.Author) then weapon.Author = ""; end;
	
	--[[if (itemTable or primaryAmmo or secondaryAmmo or ammoText or (weapon.DrawWeaponInfoBox
	and (weapon.Author != "" or weapon.Contact != "" or weapon.Purpose != ""
	or weapon.Instructions != ""))) then]]--
	
	if (itemTable or primaryAmmo or secondaryAmmo or ammoText) then
		local text = "<font="..mainTextFont..">";
		local textColor = "<color=255,255,255,255>";
		local titleColor = "<color=230,230,230,255>";

		if (informationColor) then
			titleColor = "<color="..informationColor.r..","..informationColor.g..","..informationColor.b..",255>";
		end;
		
		if (itemTable and itemTable.description != "") then
			text = text..titleColor.."DESCRIPTION</color>\n"..textColor..config.Parse(itemTable.description).."</color>\n";
		end;
		
		if (primaryAmmo or secondaryAmmo) then
			text = text..titleColor.."AMMUNITION</color>\n";
			
			if (secondaryAmmo) then
				text = text..textColor..secondaryAmmo.."</color>\n";
			end;
			
			if (primaryAmmo) then
				text = text..textColor..primaryAmmo.."</color>\n";
			end;
		end;
		
		if ammoText then
			text = text.."\n"..textColor..ammoText.."</color>\n";
		end
		
		--[[if (weapon.Instructions != "") then
			text = text..titleColor.."INSTRUCTIONS</color>\n"..textColor..weapon.Instructions.."</color>\n";
		end;
		
		if (weapon.Purpose != "") then
			text = text..titleColor.."PURPOSE</color>\n"..textColor..weapon.Purpose.."</color>\n";
		end;
		
		if (weapon.Contact != "") then
			text = text..titleColor.."CONTACT</color>\n"..textColor..weapon.Contact.."</color>\n";
		end;
		
		if (weapon.Author != "") then
			text = text..titleColor.."AUTHOR</color>\n"..textColor..weapon.Author.."</color>\n";
		end]]--
		
		weapon.InfoMarkup = markup.Parse(text.."</font>", 408);
		self:OverrideMarkupDraw(weapon.InfoMarkup);
		
		local weaponMarkupHeight = weapon.InfoMarkup:GetHeight();
		local realY = y - (weaponMarkupHeight / 2);
		local info = {
			drawBackground = true,
			weapon = weapon,
			height = weaponMarkupHeight + 8,
			width = 420,
			alpha = alpha / 1.5,
			x = x - 4,
			y = realY
		};
		
		hook.Run("PreDrawWeaponSelectionInfo", info);
		
		if (info.drawBackground) then
			Clockwork.kernel:DrawRoundedGradient(4, x - 4, realY, 420, weaponMarkupHeight + 8, Color(backgroundColor.r, backgroundColor.g, backgroundColor.b, math.min(backgroundColor.a, alpha)));
		end;
		
		if (weapon.InfoMarkup) then
			weapon.InfoMarkup:Draw(x + 4, realY + 4, nil, nil, alpha * 2);
		end;
	end;
end;

-- A function to get a weapon's print name.
function cwWeaponSelect:GetWeaponPrintName(weapon)
	local printName = weapon:GetPrintName();
	local class = string.lower(weapon:GetClass());
	
	if (printName and printName != "") then
		self.weaponPrintNames[class] = printName;
	end;
	
	return self.weaponPrintNames[class] or printName;
end;