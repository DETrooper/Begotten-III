--[[
	B3 Jessu Weep
--]]

local colors = table.Copy(colors);
local ITEM = Clockwork.item:New(nil)
	ITEM.name = "Food Base";
	ITEM.uniqueID = "food_base";
	ITEM.model = "models/props_junk/garbage_metalcan002a.mdl";
	ITEM.description = "A can of worms."
	ITEM.openTool = {"snowdog", 4}; -- can be opened with snowdog or any equipped begotten weapons with DMG_SLASH damage type
	ITEM.useSound = "common/null.wav";
	ITEM.foodQuantityScale = 0.5; -- master scale for decaying food amount.
	
	ITEM:AddData("sealed", true, true);
	ITEM:AddData("cooked", false, true);
	ITEM:AddData("grade", 1, true);
	ITEM:AddData("quantity", 100, true);
	
	-- A function to make a player eat the item.
	function ITEM:Eat(player)
		hook.Run("PlayerEatFood", player, self);
	end;
	
	-- A function to take some of the item's food amount.
	function ITEM:HandleQuantity(amount, player)
		self:SetData("quantity", math.Clamp((self:GetData("quantity") + amount) * math.Clamp(self.foodQuantityScale or 1, 0, 1), 0, 100));
	end;
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local sealed = self:GetData("sealed");
		
		if (sealed) then
			local requiredTools = self.openTool;
			local tool = nil;
			
			if (!istable(requiredTools)) then
				local newTable = {requiredTools};
				requiredTools = table.Copy(newTable);
			end;
			
			for k, v in pairs (requiredTools) do
				if (!Clockwork.item:FindByID(v)) then
					for k2, v2 in pairs (player:GetWeapons()) do
						local found = false;
						
						if (string.find(v2:GetClass(), "fists")) then
							continue;
						end;
						
						if (v2.PrintName and isstring(v) and string.find(v2.PrintName, v)) then
							found = true
						elseif (v2.Base == "sword_swepbase") then
							local attackTable = GetTable(v2.AttackTable);
							local damageType = attackTable["dmgtype"];
							
							if (isnumber(v) and damageType == v) then
								found = true;
							end;
						end;
						
						if (found) then
							tool = v2.PrintName;
							break;
						end;
					end;
				elseif (!tool) then
					if (player:HasItemByID(v)) then
						tool = Clockwork.item:FindByID(v).name;
						break;
					end;
				end;
			end;
			
			if (tool) then
				Schema:EasyText(player, "olivedrab", "You open your "..self.name.." with your "..tool..".");
				self:Seal(false, player);
			else
				Schema:EasyText(player, "chocolate", "You cannot open this without the proper tool!");
				self:TakeCondition(math.random(1, 4), true)
			end;
			
			return false;
		else
			self:Eat(player);
		end;
	end;
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, itemEntity) end;
	
	-- A function to seal or unseal an item.
	function ITEM:Seal(bSeal, player)
		local bSeal = tobool(bSeal);
		
		self:SetData("sealed", bSeal);
		hook.Run("PlayerSealedFoodItem", player, self, bSeal);
	end;

	-- A function to get the item's use text.
	function ITEM:GetUseText()
		if (self:GetData("sealed")) then
			return "Open";
		end;
		
		return "Eat";
	end;
	
	ITEM.bDisplayWeight = false;
	ITEM.conditionCap = 5;
	ITEM.conditionGrades = {
		[11] = {min = 90, max = 100, color = colors["lime"], text = "Pristine", description = "Perfect to eat.. Should fill me up and it is unlikely I will get any diseases from it..."},
		[10] = {min = 80, max = 90, color = colors["lawngreen"], text = "Excellent", description = "Looks like a good meal... This should keep me going..."},
		[9] =  {min = 70, max = 80, color = colors["springgreen"], text = "Good", description = "A good find... Hopefully I will not catch disease from it..."},
		[8] =  {min = 60, max = 70, color = colors["palegreen"], text = "Well Kept", description = "Well preserved.. I'm sure it's still good.."},
		[7] =  {min = 50, max = 60, color = colors["yellowgreen"], text = "Decent", description = "I'd eat it..."},
		[6] =  {min = 40, max = 50, color = colors["sandybrown"], text = "Palatable", description = "I'd eat it in a pinch.. It will stave off the hunger, but I am not sure if it has held it's quality..."},
		[5] =  {min = 30, max = 40, color = colors["coral"], text = "Slightly Off", description = "Smells... Not my first choice, but a man has got to eat..."},
		[4] =  {min = 20, max = 30, color = colors["chocolate"], text = "Sullied", description = "There is a strange consistency, a raunchy smell present! I am taking a chance with this.."},
		[3] =  {min = 10, max = 20, color = colors["darkorange"], text = "Disgusting", description = "I have seen a cockroach inside... Just one, though..."},
		[2] =  {min = 1, max = 10, color = colors["tomato"], text = "Horrible", description = "Many bugs of differing varieties... Worms and the like have turned this vessel into their home..."},
		[1] =  {min = -1, max = 1, color = colors["orangered"], text = "Fucked", description = "Holy Shit..."},
	};
	--ITEM.staticDescription = "Sex";
	--ITEM.staticColor = colors["blue"];
	
	local damageTypes = {
		["slash"] = 4,
		["blunt"] = 128,
		["pierce"] = 16,
	}
	
	if (SERVER) then
		function ITEM:OnInstantiated()
			if (self.conditionCap) then
				self:SetCondition(math.Clamp((self:GetCondition() or 100), 0, self.conditionCap), true)
			end;
		end;
	else
		function ITEM:SetUpTooltip(x, y, width, height, frame)
			if (self:GetData("sealed") == true) then
				local requiredTools = self.openTool;
				local infoBox = {};
				
				for k, v in pairs (requiredTools) do
					local toolName = string.lower(v);

					if (isnumber(v) or damageTypes[toolName]) then
						if (toolName == "pierce" or v == 16) then
							infoBox[#infoBox + 1] = {text = "A weapon with a sharp point..", color = colors["forestgreen"], font = "Decay_FormText"};
							continue;
						elseif (toolName == "blunt" or v == 128) then
							infoBox[#infoBox + 1] = {text = "A blunt weapon..", color = colors["darkgoldenrod"], font = "Decay_FormText"};
							continue;
						elseif (toolName == "slash" or v == 4) then
							infoBox[#infoBox + 1] = {text = "A weapon with sharp blade..", color = colors["palevioletred"], font = "Decay_FormText"};
							continue;
						end;
					end;
					
					local itemTable = Clockwork.item:FindByID(toolName);
					
					if (itemTable) then
						infoBox[#infoBox + 1] = {text = itemTable("name"), color = colors["lightgray"], font = "Decay_FormText"};
						continue;
					end;
				end;

				frame:AddText("This item is sealed, and must be opened with one of the following...", Color(200, 200, 255), "Subtitle_Whisper", 0.8)
				frame:AddInfoBox(infoBox)
			elseif (!self.bNoGrade) then
				local quantity = self:GetData("quantity");
				local grade = self:GetGrade(self:GetData("condition"));

				if (grade) then
					local gradeColor = self.conditionGrades[grade].color;
					local gradeDescription = self.conditionGrades[grade].description or "";
					
					if (self.staticDescription) then
						gradeDescription = self.staticDescription;
					end;
					
					if (self.staticColor) then
						gradeColor = self.staticColor;
					end;
					
					frame:AddText("\""..gradeDescription.."\"", gradeColor, "Ritual_Button", 0.6);
				end;
				
				if (quantity) then
					--printp(quantity)
					local foodLevel = self:GetQuantityLevel(quantity);
					local quantityTable = self.quantityLevels[foodLevel];
					local quantityText = quantityTable.description;
					local quantityColor = quantityTable.color or Color(150, 150, 150);
					
					if (quantityText and quantityColor) then
						frame:AddText("It is "..quantityText..".", quantityColor:Darken(25), "DermaDefault");
					end;
				end;
			end;

			local weight = self("weight");
			local maximumWeight = Clockwork.inventory:CalculateWeight(Clockwork.inventory:GetClient());
			local percentage = (weight / maximumWeight);

			frame:AddBar(20, {{text = weight.."kg", percentage = percentage * 100, color = Color(96, 96, 128), font = "DermaDefault", leftTextAlign = false, noDisplay = true}}, "Weight", Color(170, 170, 180));
			frame:AddSpacer(2, Color(0, 0, 0, 0));
		end;
	end;

	ITEM.quantityLanguage = {
		[11] = "full",
		[10] = "almost full",
		[9] = "three quarters full",
		[8] = "just under three quarters full",
		[7] = "just over half full",
		[6] = "half full",
		[5] = "under half full",
		[4] = "a quarter full",
		[3] = "less than a quarter full",
		[2] = "almost empty",
		[1] = "empty",
	}
	
	ITEM.quantityLevels = {
		[11] = {min = 90, max = 100, color = colors["lime"], description = ITEM.quantityLanguage[FULL]},
		[10] = {min = 80, max = 90, color = colors["lawngreen"], description = ITEM.quantityLanguage[ALMOST_FULL]},
		[9] =  {min = 70, max = 80, color = colors["springgreen"], description = ITEM.quantityLanguage[THREE_QUARTERS]},
		[8] =  {min = 60, max = 70, color = colors["palegreen"], description = ITEM.quantityLanguage[UNDER_THREE_QUARTERS]},
		[7] =  {min = 50, max = 60, color = colors["yellowgreen"], description = ITEM.quantityLanguage[OVER_HALF]},
		[6] =  {min = 40, max = 50, color = colors["sandybrown"], description = ITEM.quantityLanguage[HALF]},
		[5] =  {min = 30, max = 40, color = colors["coral"], description = ITEM.quantityLanguage[UNDER_HALF]},
		[4] =  {min = 20, max = 30, color = colors["chocolate"], description = ITEM.quantityLanguage[QUARTER]},
		[3] =  {min = 10, max = 20, color = colors["darkorange"], description = ITEM.quantityLanguage[UNDER_QUARTER]},
		[2] =  {min = 1, max = 10, color = colors["tomato"], description = ITEM.quantityLanguage[ALMOST_EMPTY]},
		[1] =  {min = 0, max = 1, color = colors["orangered"], description = ITEM.quantityLanguage[EMPTY]},
	};
	
	-- A function to get a string describing how much is left in the container.
	function ITEM:GetQuantityLevel(quantity)
		local quantityLevel = nil;
		
		for k, v in pairs (self.quantityLevels) do
			if (quantity > v.min and quantity <= v.max) then
				quantityLevel = k;
				break;
			end;
		end;
		
		if (quantityLevel) then
			return quantityLevel;
		end;
	end;

	-- A function to get an item's grade.
	function ITEM:GetGrade(condition)
		if (!condition) then
			return;
		end;
		
		local curTime = CurTime();
		local grade = nil;

		if (self.nextGrade and self.nextGrade > curTime and (self.grade)) then
			return self.grade
		end;

		for k, v in pairs (self.conditionGrades) do
			if (condition > v.min and condition <= v.max) then
				self.grade = k;
				self.nextGrade = curTime + 1;
				break;
			end;
		end;

		return self.grade;
	end;
	
	-- A function to get the item's color.
	function ITEM:GetColor()
		if (self.bNoGrade or self:GetData("sealed")) then
			return;
		end;

		if (self.staticColor) then
			return self.staticColor;
		end;
		
		local grade = self:GetGrade(self:GetData("condition"));

		if (grade) then
			local gradeColor = self.conditionGrades[grade].color;
			
			if (gradeColor) then
				return gradeColor;
			end;
		end;
	end;
	
	-- A function to get the item's name.
	function ITEM:GetName()
		if (self.bNoGrade or self:GetData("sealed")) then
			return self.name;
		end;

		local grade = self:GetGrade(self:GetData("condition"));

		if (grade) then
			local gradeText = self.conditionGrades[grade].text;
			
			if (gradeText) then
				return gradeText.." "..self.name;
			end;
		end;
		
		return self.name
	end;
	
	ITEM:AddQueryProxy("useText", ITEM.GetUseText)
	ITEM:AddQueryProxy("color", ITEM.GetColor)
	ITEM:AddQueryProxy("name", ITEM.GetName)
ITEM:Register();