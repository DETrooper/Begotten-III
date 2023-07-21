--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

cwStorage.lockpickMat = Material("begotten/ui/lockpickbg.png");
cwStorage.lockpickMat2 = Material("begotten/ui/lockpickinnerbg.png");
cwStorage.lockpickProgressMat = Material("begotten/ui/lockpickprogressbar.png");

-- Called when an entity's target ID HUD should be painted.
function cwStorage:HUDPaintEntityTargetID(entity, info)
	if entity:GetNetVar("stash") then
		return;
	end
	
	if (entity:GetNWBool("cwNotSearchable", false) == true) then
		return;
	end;
	
	local colorTargetID = Clockwork.option:GetColor("target_id")
	local colorWhite = Clockwork.option:GetColor("white")

	if LockpickInfo and LockpickInfo.DoingLockpick then
		return;
	end

	if (Clockwork.entity:IsPhysicsEntity(entity)) then
		local model = string.lower(entity:GetModel())

		if (self.containerList[model]) then
			local customName = entity:GetNetworkedString("Name");

			if (customName and customName != "") then
				info.y = Clockwork.kernel:DrawInfo(entity:GetNetworkedString("Name"), info.x, info.y, colorTargetID, info.alpha)
				
				if customName == "Supercrate" then
					info.y = Clockwork.kernel:DrawInfo("A collection of ancient military crates, a holy grail...", info.x, info.y, colorWhite, info.alpha)
					
					if (entity:GetNWBool("unlocked", true) == false) then
						info.y = Clockwork.kernel:DrawInfo("[LOCKED]", info.x, info.y, Color(175, 100, 100), info.alpha);
					end;
					
					return;
				end
			else
				info.y = Clockwork.kernel:DrawInfo(self.containerList[model][2], info.x, info.y, colorTargetID, info.alpha)
			end
			
			info.y = Clockwork.kernel:DrawInfo("You can put items in there.", info.x, info.y, colorWhite, info.alpha)
			
			if (entity:GetNWBool("unlocked", true) == false) then
				info.y = Clockwork.kernel:DrawInfo("[LOCKED]", info.x, info.y, Color(175, 100, 100), info.alpha);
			end;
		end
	end
end

-- Called when an entity's menu options are needed.
function cwStorage:GetEntityMenuOptions(entity, options)
	if (Clockwork.entity:IsPhysicsEntity(entity)) then
		if (entity:GetNWBool("cwNotSearchable", false) == true) then
			return;
		end;
		
		local model = string.lower(entity:GetModel());

		if (cwStorage.containerList[model]) then
			--options["Open"] = "cwContainerOpen";
			
			--[[if (entity:GetNWBool("unlocked", true) == true) then
				options["Lock"] = "cwContainerLock";
			end;]]--
			
			if (entity:GetNWBool("unlocked", true) == false) then
				if Clockwork.inventory:HasItemByID(Clockwork.inventory:GetClient(), "lockpick") then
					options["Lockpick"] = "cwContainerLockpick";
				end
				
				if entity:GetNWBool("hasPassword", false) then
					options["Open"] = "cwContainerOpen";
				end
			else
				options["Open"] = "cwContainerOpen";
			end;
		end;
	end;
end;

-- Called when the local player's storage is rebuilt.
function cwStorage:PlayerStorageRebuilt(panel, categories)
	if (panel.storageType == "Container") then
		local entity = Clockwork.storage:GetEntity();
		
		if (IsValid(entity) and entity.cwMessage) then
			local messageForm = vgui.Create("DForm", panel);
			local helpText = messageForm:Help(entity.cwMessage);
				messageForm:SetPadding(5);
				messageForm:SetName("Message");
				helpText:SetFont("Default");
			panel:AddItem(messageForm);
		end;
	end;
end;

-- Called when the post progress bar info is needed.
function cwStorage:GetPostProgressBarInfo()
	if (Clockwork.Client:Alive()) then
		local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);
		
		if (action == "keycutting") then
			return {text = "You are making a copy of a key.", percentage = percentage, flash = percentage > 75};
		end;
	end;
end;

-- Called before the tab menu is shown.
function cwStorage:CanShowTabMenu()
	if (Clockwork.Client:Alive()) then
		local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);
		
		if (action == "keycutting") then
			return false;
		end;
		
		if (LockpickInfo) and (LockpickInfo.DoingLockpick) then
			return false;
		end;
	end;
end;

-- Called when the local player's item functions should be adjusted.
function cwStorage:PlayerAdjustItemFunctions(itemTable, itemFunctions)
	if (itemTable:GetData("KeyID") and itemTable:GetData("bIsCopy") != true) then
		local nearKeyMachine = false;
		
		for k, v in pairs (ents.FindInSphere(Clockwork.Client:GetPos(), 128)) do
			if (v:GetNWBool("key_machine", false) == true and Clockwork.entity:CanSeeEntity(Clockwork.Client, v)) then
				nearKeyMachine = true;
				break;
			end;
		end;
		
		if (nearKeyMachine) then
			itemFunctions[#itemFunctions + 1] = {
				title = "[Machine] Make Copy",
				name = "MakeKeyCopy",
			};
		end;
	end;
end;

-- A function to start a lockpick minigame.
local function StartLockpick(entity, lockTier)
	LockpickInfo = {};
	LockpickInfo.DoingLockpick = true;
	LockpickInfo.StartTime = CurTime();
	LockpickInfo.LockPickTier = lockTier;
	LockpickInfo.LockpickContainer = entity;
	LockpickInfo.RequiredPicks = 3;
	LockpickInfo.SuccessfulPicks = 0;
	
	if (LockpickInfo.LockPickTier == 2) then
		LockpickInfo.RequiredPicks = 4;
	elseif (LockpickInfo.LockPickTier == 3) then
		LockpickInfo.RequiredPicks = 5;
	end;
end;

Clockwork.datastream:Hook("StartLockpick", function(data)
	StartLockpick(data.entity, data.lockTier);
end);

-- A function to finish the lockpick minigame.
local function FinishLockpick(bFailed, bTimeout)
	if (bFailed) then
		Clockwork.datastream:Start("LockpickFail", bTimeout or false);
	elseif (IsValid(LockpickInfo.LockpickContainer)) then
		Clockwork.datastream:Start("FinishLockpick", LockpickInfo.LockpickContainer);
	end;

	if (LockpickInfo and !table.IsEmpty(LockpickInfo)) then
		LockpickInfo = {};
	end;
end;

-- A function to abort the minigame.
local function AbortLockpick()
	if (LockpickInfo and !table.IsEmpty(LockpickInfo)) then
		LockpickInfo = {};
	end;
	
	Clockwork.datastream:Start("AbortLockpick");
end;

-- Called when the player successfully lockpicks a container.
local function SuccessfulPick()
	LockpickInfo.PointsTable = nil;
	
	Clockwork.datastream:Start("SuccessfulPick");
	LockpickInfo.SuccessfulPicks = math.Clamp(LockpickInfo.SuccessfulPicks + 1, 0, LockpickInfo.RequiredPicks);
	local barDivision = 2;
	
	if (LockpickInfo.LockPickTier == 2) then
		barDivision = 1.5;
	elseif (LockpickInfo.LockPickTier == 3) then
		barDivision = 1.9;
	end;
	
	if (LockpickInfo.TimeBarWidth) then
		LockpickInfo.TimeBarWidth = (LockpickInfo.TimeBarWidth / barDivision);
	end;
	
	if (LockpickInfo.SuccessfulPicks >= LockpickInfo.RequiredPicks) then
		FinishLockpick(false, false);
	end;
end;

-- A function to plot a set of lockpick points.
local function PlotPoints(startPoint, endPoint)
	if (LockpickInfo and !table.IsEmpty(LockpickInfo)) then
		local max = 3;
		local points = {};
		
		if (LockpickInfo.LockPickTier == 2) then
			max = 5;
		elseif (LockpickInfo.LockPickTier == 3) then
			max = 7;
		end;

		for i = 1, max do
			local value = math.random(startPoint, endPoint);

			points[i] = value;
		end;

		return points;
	end;
end;

-- Called when the HUD is painted.
function cwStorage:HUDPaint()
	if (LockpickInfo and LockpickInfo.DoingLockpick) then
		local scrW = ScrW();
		local scrH = ScrH();
		local width = 1920 * 0.4;
		local height = 64;
		local x = (scrW / 2) - (width / 2);
		local y = (scrH / 2) - (height / 2);
		
		local startPointX = width + x - 8;
		local endPointX = x + 8;
		
		local backgroundColor = Color(0, 0, 255);
		local barBackground = Color(255, 0, 0);
		local tickColor = Color(100, 100, 100);
		--local pickerColor = Color(0, 0, 0);
		local pickerColor = Color(200, 200, 200);

		--draw.RoundedBox(0, x - 40, y - 40, width + 80, height + 80 + 20, backgroundColor); -- blue
		--draw.RoundedBox(0, x, y, width, height, barBackground); -- red
		
		surface.SetMaterial(self.lockpickMat);
		surface.DrawTexturedRect(x - 40, y - 40, width + 80, height + 100);
		
		surface.SetMaterial(self.lockpickMat2);
		surface.DrawTexturedRect(x, y - 3, width, height + 6);
		
		if (!LockpickInfo.PickerX) then
			LockpickInfo.PickerX = startPointX;
		end;
		
		if (!LockpickInfo.PickerXTarget) then
			LockpickInfo.PickerXTarget = endPointX;
		end;
		
		if (!LockpickInfo.PointsTable) then
			LockpickInfo.PointsTable = PlotPoints(startPointX, endPointX);
		end;
		
		local speed = 320;
		local tickWidth = 12;
		
		if (LockpickInfo.LockPickTier == 2) then
			tickWidth = 10;
			speed = 512;
		elseif (LockpickInfo.LockPickTier == 3) then
			tickWidth = 6;
			speed = 768;
		end;
		
		if LockpickInfo.LockPickTier > 1 and (cwBeliefs and cwBeliefs:HasBelief("thief")) or Clockwork.Client:GetNetVar("princeOfThieves", false) then
			speed = (speed / 2);
		end

		if (LockpickInfo.PickerX != LockpickInfo.PickerXTarget) then
			LockpickInfo.PickerX = math.Approach(LockpickInfo.PickerX, LockpickInfo.PickerXTarget, FrameTime() * speed);
		elseif (LockpickInfo.PickerX >= LockpickInfo.PickerXTarget) then
			if (LockpickInfo.PickerXTarget == endPointX) then
				LockpickInfo.PickerXTarget = startPointX;
			else
				LockpickInfo.PickerXTarget = endPointX;
			end;
		end;
		
		for k, v in pairs (LockpickInfo.PointsTable) do
			--draw.RoundedBox(0, v, y, tickWidth, height, tickColor);
			surface.SetMaterial(Material("begotten/ui/vbar.png"))
			surface.SetDrawColor(tickColor:Darken(30));
			surface.DrawTexturedRect(v, y, tickWidth, height)
		end;

		surface.SetMaterial(Material("begotten/ui/vbar.png"))
		surface.SetDrawColor(pickerColor:Darken(30));
		surface.DrawTexturedRect(LockpickInfo.PickerX, y, 8, height)

		if (LockpickInfo.StartTime) then
			local barDecay = 0.75;
			
			if (!LockpickInfo.TimeBarWidth) then
				LockpickInfo.TimeBarWidth = 0;
			end;

			if (LockpickInfo.LockPickTier == 2) then
				barDecay = 1.1;
			elseif (LockpickInfo.LockPickTier == 3) then
				barDecay = 1.3;
			end;
			
			LockpickInfo.TimeBarWidth = math.Approach(LockpickInfo.TimeBarWidth, width, barDecay);
			--draw.RoundedBox(0, x, y + height + 4, LockpickInfo.TimeBarWidth, height / 2, pickerColor);

			--[[
			surface.SetMaterial(Material("begotten/ui/infotextsquash.png"))
			surface.SetDrawColor(barBackground:Darken(30));
			surface.DrawTexturedRect(x, y + height + 4, LockpickInfo.TimeBarWidth, height / 2)
			--]]
			
			height = height - 4
			x = x
			y = y + 12
			draw.RoundedBox(1, x - 5, (y + height + 4) - 5, width + 10, (height / 2) + 10, Color(0, 0, 0, 170))
			draw.RoundedBox(1, x, y + height + 4, width, height / 2, Color(170, 0, 0, 150))
			draw.RoundedBox(1, x, y + height + 4, LockpickInfo.TimeBarWidth, height / 2, Color(200, 0, 0, 255))
			draw.RoundedBox(1, x, (y + height + 4) + 15, LockpickInfo.TimeBarWidth, (height / 2) - 15, Color(0, 0, 0, 100))
			
			if (LockpickInfo.TimeBarWidth >= width) then
				FinishLockpick(true, true);
				return;
			end;
		end;
		
		local tipY = y + (height * 2 + height - 8) + 8;
		local frameTime = FrameTime();
		
		if (!LockpickInfo.PressedEnterAlpha) then LockpickInfo.PressedEnterAlpha = 255 end;
		if (!LockpickInfo.ExitPositionY) then LockpickInfo.ExitPositionY = tipY + 24; end;
		if (!LockpickInfo.CanTipFade) then LockpickInfo.CanTipFade = false; end;
		
		if (LockpickInfo.PressedEnter and LockpickInfo.CanTipFade != true) then
			LockpickInfo.CanTipFade = true;
		end;

		if (LockpickInfo.CanTipFade) then
			LockpickInfo.PressedEnterAlpha = math.Approach(LockpickInfo.PressedEnterAlpha, 0, frameTime * 256);
		end;

		if (LockpickInfo.PressedEnterAlpha == 0 and LockpickInfo.ExitPositionY != tipY) then
			LockpickInfo.ExitPositionY = math.Approach(LockpickInfo.ExitPositionY, tipY, frameTime * 32)
		end;
		
		if (LockpickInfo.PressedEnterAlpha > 0) then
			draw.SimpleText("Press 'Enter' to lockpick.", "cwMainText", x, tipY, Color(255, 0, 0, LockpickInfo.PressedEnterAlpha));
		end;
		
		draw.SimpleText("Press 'R' to exit.", "cwMainText", x, LockpickInfo.ExitPositionY, Color(255, 0, 0));

		if (LockpickInfo.RequiredPicks and LockpickInfo.SuccessfulPicks) then
			local progress = 1;
			
			if (LockpickInfo.SuccessfulPicks > 1) then
				progress = LockpickInfo.SuccessfulPicks;
			end;
			
			local progressText = "PROGRESS: "..LockpickInfo.SuccessfulPicks.."/"..LockpickInfo.RequiredPicks;
			local fontWidth, fontHeight = Clockwork.kernel:GetCachedTextSize("cwMainText", progressText);
			local fac = LockpickInfo.RequiredPicks / LockpickInfo.SuccessfulPicks;
			local pras = width / fac;
			
			if (!LockpickInfo.ProgressBarWidth) then
				LockpickInfo.ProgressBarWidth = pras;
			elseif (LockpickInfo.ProgressBarWidth != pras) then
				LockpickInfo.ProgressBarWidth = math.Approach(LockpickInfo.ProgressBarWidth, pras, 1)
			end;
			
			local boxY = y + (height * 2) + 12;
			local textX = x + (width / 2) - (fontWidth / 2);
			local height = height / 2 + 16;
			
			surface.SetDrawColor(Color(255, 255, 255, 255));
			surface.SetMaterial(self.lockpickProgressMat);
			surface.DrawTexturedRect(x - 8, boxY - 8, width + 16, height);
			--[[
			surface.SetMaterial(Material("begotten/ui/infotextsquash.png"))
			surface.SetDrawColor(Color(150, 100, 100, 100):Darken(30));
			surface.DrawTexturedRect(x, boxY, LockpickInfo.ProgressBarWidth, (height - 16))
			--]]
			--[[
			
			--]]

			boxY = boxY + 6
			x = x + 2
			draw.RoundedBox(1, x, boxY - 5, pras, 30, Color(0, 0, 0, 170))
			draw.RoundedBox(1, x, boxY, pras, 20, Color(170, 0, 0, 150))
			draw.RoundedBox(1, x, boxY, LockpickInfo.ProgressBarWidth, 20, Color(200, 0, 0, 255))
			draw.RoundedBox(1, x, boxY + 15, LockpickInfo.ProgressBarWidth, 5, Color(0, 0, 0, 100))
			
			draw.SimpleText(progressText, "Subtitle_Whisper", textX, boxY, Color(0, 0, 0));
		end;
	end;
end;

-- Called every frame.
function cwStorage:Think()
	if (LockpickInfo and LockpickInfo.PickerX and LockpickInfo.DoingLockpick) then
		if (input.IsKeyDown(KEY_ENTER)) then
			if (!LockpickInfo.DidGuess) then
				LockpickInfo.PressedEnter = true;
				LockpickInfo.DidGuess = true;
				
				local pointsTable = LockpickInfo.PointsTable;
				local pickerX = LockpickInfo.PickerX;
				local pickerEnd = pickerX + 8;
				local success = false;
				
				for k, v in pairs (pointsTable) do
					local graceZone = 2;
					
					if (LockpickInfo.LockPickTier == 2) then
						graceZone = 4;
					elseif (LockpickInfo.LockPickTier == 3) then
						graceZone = 0;
					end;
					
					local zoneStart = v - graceZone;
					local zoneEnd = v + 16 + graceZone;
	
					if (pickerX >= zoneStart and pickerX <= zoneEnd or pickerEnd >= zoneStart and pickerEnd <= zoneEnd) then
						success = true;
						
						break;
					end;
				end;
				
				if (success) then
					SuccessfulPick();
				else
					FinishLockpick(true, true);
				end;
			end;
		elseif (input.IsKeyDown(KEY_R)) then
			AbortLockpick();
		else
			if (LockpickInfo.DidGuess) then
				LockpickInfo.DidGuess = nil;
			end;
		end;
	end;
end;
--[[
local pos = LocalPlayer():GetPos()
local SCRTOK = 0
local Incre = math.Rand(0.1,0.8) / #CraftBox:GetItems()

hook.Add("HUDPaint","Craftis",function()
	local client = LocalPlayer()
	local caft = ScrW() * 0.4
	

	
	SCRTOK = SCRTOK + Incre
	if pos:Distance(client:GetPos()) < 10 and Craften then
	if  cf + 5 >= caft then
	hook.Remove("HUDPaint","Craftis")
	NEXUS:StartDataStream("ComboItems",Craften) 
	end
	else
	 
	NEXUS:AddNotify("You must stand still in order to craft!",1,10)
	hook.Remove("HUDPaint","Craftis")
	end 
end) 
--]]