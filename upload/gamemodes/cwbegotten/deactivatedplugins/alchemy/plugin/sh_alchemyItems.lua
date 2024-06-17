local ITEM = Clockwork.item:New(nil, true);

	ITEM.name = "Container Base";

	ITEM.uniqueID = "container_base";

	ITEM.model = "models/props_interiors/pot02a.mdl";

	ITEM.description = "Container Base";

	ITEM.baseWeight = 1;

	ITEM.weight = ITEM.baseWeight;

	ITEM.chemcontents = {};

	ITEM.capacity = 2000; -- mL

	ITEM.category = "Containers";

	ITEM.useText = "Drink";

	ITEM.chemInitialized = false;

	ITEM.customFunctions = {"Chug","Dump Contents","Pour On Self"};

	

	function ITEM:OnInstantiated()

		self:AddData("ChemContents", self.chemcontents, true);

		self:ModifyContainerWeight();

	end

	

	-- Called when the tooltip is displayed.

	function ITEM:SetUpTooltip(x, y, width, height, parent)

		local barTable = self:BuildBarTable();



		if (barTable and !table.IsEmpty(barTable)) then

			parent:AddText("Contents:", Color(200, 0, 0), "Subtitle_Whisper");

			parent:AddBar(24, barTable);

		end;

	end;



	-- A function to build the tool tip bar table.

	function ITEM:BuildBarTable()

		local barTable = cwAlchemy:CreateBarTable(self);

		return barTable;

	end;

	

	-- Called whent he item entity's menu options are needed.

	-- function ITEM:GetEntityMenuOptions(entity, options)

		-- local ammo = self:GetData("Ammo");

	-- end;



	-- A function to get the item's weight.

	--[[function ITEM:GetItemWeight()

		local baseWeight = self.weight;

		baseWeight = baseWeight + (2);

		return math.Round(baseWeight, 2);

	end;]]--

	

	function ITEM:IsPlayer()

		return false

	end

	

	-- A function to get the name of the liquid with the highest volume in the container.

	function ITEM:GetHighestVolume()

		local curTime = CurTime();

		

		if (!self.highestVolume or !self.nextVolumeTime or self.nextVolumeTime < curTime) then

			self.nextVolumeTime = curTime + 1;



			local contents = self:GetData("ChemContents") or {};

			local sortedContents = {};

			

			for k, v in pairs (contents) do

				if (v > 0) then

					sortedContents[#sortedContents + 1] = {name = k, amount = v};

				end;

			end;

			

			if (#sortedContents > 0) then

				table.sort(sortedContents, function(a, b)

					return a.amount > b.amount;

				end);



				self.highestVolume = sortedContents[1].name;

			else

				self.highestVolume = "Empty";

			end;

		end;

		

		return self.highestVolume or "";

	end;

	

	-- A function to modify the weight of the container based on the amount of liquid inside.

	function ITEM:ModifyContainerWeight()

		local weightAdd = 0;

		local contents = self:GetData("ChemContents") or {};

		local data = cwAlchemy:GetTotalLiquidData(contents)

		-- do weight calculations here;

		

		self.weight = math.Round(self.baseWeight + data.mass,2);

	end

	

	function ITEM:OnCustomFunction(player, name)

		local contents = self:GetData("ChemContents") or {};

		local data = cwAlchemy:GetTotalLiquidData(contents)

		if (name == "Chug") then

			if data.volume > 0 then

				Clockwork.chatBox:AddInTargetRadius(player, "me", "lifts their "..string.utf8lower(self.name).." to their lips and starts chugging.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

				cwAlchemy:DisturbContainer(player, self, data.volume/1000)

				local drink = cwAlchemy:SubtractFromContents(contents, data.volume, self);

				cwAlchemy:DrinkChem(player,drink)

				self:SetData("ChemContents",drink.remaining)

				Clockwork.player:Notify(player, "You drink "..cwAlchemy:ConvertUnits(drink.total)..".");

			else

				Clockwork.player:Notify(player, "This container is completely empty.");

			end

		elseif (name == "Dump Contents") then

			if data.volume > 0 then

				Clockwork.chatBox:AddInTargetRadius(player, "me", "tips their "..string.utf8lower(self.name).." and pours out the contents onto the ground.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

				cwAlchemy:DisturbContainer(player, self, data.volume/500)

				local drink = cwAlchemy:SubtractFromContents(contents, data.volume, self);

				--cwAlchemy:SplashChem(player,drink) --if the player fucks up, for use later

				self:SetData("ChemContents",drink.remaining)

				Clockwork.player:Notify(player, "You dump "..cwAlchemy:ConvertUnits(drink.total)..".");

			else

				Clockwork.player:Notify(player, "This container is already empty!");

			end

		elseif (name == "Pour On Self") then

			if data.volume > 0 then

				Clockwork.chatBox:AddInTargetRadius(player, "me", "raises their "..string.utf8lower(self.name).." over their head and dumps the contents all over themselves!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

				cwAlchemy:DisturbContainer(player, self, data.volume)

				local drink = cwAlchemy:SubtractFromContents(contents, data.volume, self);

				self:SetData("ChemContents",drink.remaining)

				cwAlchemy:SplashChem(player,drink)

				

				Clockwork.player:Notify(player, "You drink "..cwAlchemy:ConvertUnits(drink.total)..".");

			else

				Clockwork.player:Notify(player, "This container is already empty!");

			end

		end

		

		return false;

	end

	



	-- Called when a player uses the item.

	function ITEM:OnUse(player, itemEntity)

		local contents = self:GetData("ChemContents") or {};

		local data = cwAlchemy:GetTotalLiquidData(contents)

		if data.volume > 0 then

			cwAlchemy:DisturbContainer(player, self, data.volume/1000)

			local drink = cwAlchemy:SubtractFromContents(contents, 500, self);

			cwAlchemy:DrinkChem(player,drink)

			self:SetData("ChemContents",drink.remaining)

			Clockwork.chatBox:AddInTargetRadius(player, "me", "takes a drink from their "..string.utf8lower(self.name)..".", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

			Clockwork.player:Notify(player, "You drink "..cwAlchemy:ConvertUnits(drink.total)..".");

		else

			Clockwork.player:Notify(player, "This container is completely empty.");

		end

		

		return false;

	end;

	

	-- Called when the item is dropped.

	function ITEM:OnDrop(player, itemEntity)

		return;

	end;



	--ITEM:AddQueryProxy("weight", ITEM.GetItemWeight);

	ITEM:AddQueryProxy("totalLiquid", ITEM.GetTotalLiquid);

	ITEM:AddQueryProxy("highestVolume", ITEM.GetHighestVolume);

ITEM:Register();



local ITEM = Clockwork.item:New(nil, true);

	ITEM.name = "Dissolvable Base";

	ITEM.uniqueID = "dissolvable_base";

	ITEM.model = "models/props_interiors/pot02a.mdl";

	ITEM.description = "Dissolvable Base";

	ITEM.baseWeight = 1;

	ITEM.weight = ITEM.baseWeight;

	ITEM.chemcontents = {};

	ITEM.capacity = 2000; -- mL

	ITEM.category = "Dissolvables";

	ITEM.useText = "Eat";

	ITEM.chemInitialized = false;

	

	function ITEM:OnInstantiated()

		self:AddData("ChemContents", self.chemcontents, true);

		self:ModifyContainerWeight();

	end

	

	-- Called when the tooltip is displayed.

	function ITEM:SetUpTooltip(x, y, width, height, parent)

		local barTable = self:BuildBarTable();



		if (barTable and !table.IsEmpty(barTable)) then

			parent:AddText("Contents:", Color(200, 0, 0), "Subtitle_Whisper");

			parent:AddBar(24, barTable);

		end;

	end;



	-- A function to build the tool tip bar table.

	function ITEM:BuildBarTable()

		local barTable = cwAlchemy:CreateBarTable(self);

		return barTable;

	end;

	

	-- Called whent he item entity's menu options are needed.

	-- function ITEM:GetEntityMenuOptions(entity, options)

		-- local ammo = self:GetData("Ammo");

	-- end;



	-- A function to get the item's weight.

	--[[function ITEM:GetItemWeight()

		local baseWeight = self.weight;

		baseWeight = baseWeight + (2);

		return math.Round(baseWeight, 2);

	end;]]--

	

	function ITEM:IsPlayer()

		return false

	end

	

	-- A function to get the name of the liquid with the highest volume in the container.

	function ITEM:GetHighestVolume()

		local curTime = CurTime();

		

		if (!self.highestVolume or !self.nextVolumeTime or self.nextVolumeTime < curTime) then

			self.nextVolumeTime = curTime + 1;



			local contents = self:GetData("ChemContents") or {};

			local sortedContents = {};

			

			for k, v in pairs (contents) do

				if (v > 0) then

					sortedContents[#sortedContents + 1] = {name = k, amount = v};

				end;

			end;

			

			if (#sortedContents > 0) then

				table.sort(sortedContents, function(a, b)

					return a.amount > b.amount;

				end);



				self.highestVolume = sortedContents[1].name;

			else

				self.highestVolume = "Empty";

			end;

		end;

		

		return self.highestVolume or "";

	end;

	

	-- A function to modify the weight of the container based on the amount of liquid inside.

	function ITEM:ModifyContainerWeight()

		local weightAdd = 0;

		local contents = self:GetData("ChemContents") or {};

		local data = cwAlchemy:GetTotalLiquidData(contents)

		-- do weight calculations here;

		

		self.weight = math.Round(self.baseWeight + data.mass,2);

	end

	



	-- Called when a player uses the item.

	function ITEM:OnUse(player, itemEntity)

		local contents = self:GetData("ChemContents") or {};

		local data = cwAlchemy:GetTotalLiquidData(contents)

		if data.volume > 0 then

			cwAlchemy:DisturbContainer(player, self, data.volume/1000)

			local drink = cwAlchemy:SubtractFromContents(contents, 500, self);

			cwAlchemy:DrinkChem(player,drink)

			self:SetData("ChemContents",drink.remaining)

		end

		Clockwork.chatBox:AddInTargetRadius(player, "me", "swallows a "..string.utf8lower(self.name)..".", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

	end;

	

	-- Called when the item is dropped.

	function ITEM:OnDrop(player, itemEntity)

		return;

	end;



	--ITEM:AddQueryProxy("weight", ITEM.GetItemWeight);

	ITEM:AddQueryProxy("totalLiquid", ITEM.GetTotalLiquid);

	ITEM:AddQueryProxy("highestVolume", ITEM.GetHighestVolume);

ITEM:Register();



local ITEM = Clockwork.item:New("container_base");

ITEM.name = "Jerry Can";

ITEM.uniqueID = "jerry_can";

ITEM.model = "models/props_junk/metalgascan.mdl";

ITEM.description = "An old, plastic jerrycan.";

ITEM.baseWeight = 1;

ITEM.chemcontents = {};

ITEM.capacity = 20000;

ITEM:Register();



local ITEM = Clockwork.item:New("container_base");

ITEM.name = "Sample Vial";

ITEM.uniqueID = "alch_transfer_bottle";

ITEM.model = "models/damnation/pride/rifle_shell.mdl";

ITEM.description = "A tiny vial made out of an ancient shell casing.";

ITEM.weight = 0.02;

ITEM.contents = {};

ITEM.capacity = 100;

	

ITEM:Register();



local ITEM = Clockwork.item:New("container_base");

ITEM.name = "Piss-Filled Jerry Can";

ITEM.uniqueID = "pissjerry";

ITEM.model = "models/props_junk/metalgascan.mdl";

ITEM.description = "A sizable jerrycan. It reeks of piss.";

ITEM.baseWeight = 1;

ITEM.chemcontents = {

["water"]=19000,

["ammonia"]=1000

};

ITEM.capacity = 20000;

ITEM:Register();



local ITEM = Clockwork.item:New("container_base");

ITEM.name = "Yum Chug Bottle";

ITEM.uniqueID = "alch_yumchug";

ITEM.model = "models/props_junk/garbage_plasticbottle001a.mdl";

ITEM.description = "A bottle of yummy chug. Drink it. It's tasty. Do it.";

ITEM.baseWeight = 1;

ITEM.chemcontents = {

["water"]=1900,

["chlorine"]=100

};

ITEM.capacity = 2000;

ITEM:Register();