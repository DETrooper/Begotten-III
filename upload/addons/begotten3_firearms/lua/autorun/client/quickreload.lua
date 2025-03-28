local button = Material("begotten/ui/bgtbtnrit1.png");
local textColor = Color(180, 15, 15);
local hasItemColor = Color(255, 255, 255, 245);

AMMO_DrawButttons = AMMO_DrawButttons or false;
AMMO_ButtonsFadeIn = CurTime() + 0.15;
AMMO_ButtonsLerp = CurTime() + 0.35

AMMO_buttonTables = AMMO_buttonTables or {};

local ammoButtons = {}
local clipIcons = {}
local hoveredItem
local unloadable = false

local function DrawButton(x, y, size, index, max, item, noInteraction, noButton)
    local localPlayer = LocalPlayer()

    if(!noInteraction and !AMMO_buttonTables[index]) then AMMO_buttonTables[index] = {hovered = false}; end

    local spinFrac = math.Clamp((AMMO_ButtonsLerp - CurTime())/0.5, 0, 1)
    local alphaFrac = (AMMO_ButtonsFadeIn - CurTime())/0.15;
    local alpha = Lerp(alphaFrac, 245, 0);

    local mouseX, mouseY = input.GetCursorPos();
    local halfSize = (size * 0.5);

    if(!noInteraction and spinFrac <= 0 and mouseX <= x + halfSize and
        mouseX >= x - halfSize and
        mouseY <= y + halfSize and
        mouseY >= y - halfSize) then

        size = size + 25;
        halfSize = (size * 0.5);

        if(!AMMO_buttonTables[index].hovered) then
            AMMO_buttonTables[index].hovered = true;
            hoveredItem = item
            localPlayer:EmitSound("begotten/ui/buttonrollover.wav", 75, Lerp(index/max, 80, 120));

        end

    elseif(!noInteraction) then
        if(AMMO_buttonTables[index].hovered) then AMMO_buttonTables[index].hovered = false; end

    end

    local rotation = (CurTime() * 10 + (index * 45)) % 360;

    surface.SetDrawColor(100, 150, 150, alpha);

    if(!noButton) then
        surface.SetMaterial(button);
        surface.DrawTexturedRectRotated(x, y, size, size, -rotation);
        --surface.SetMaterial(pentagram);
        --surface.DrawTexturedRectRotated(x, y, size - 20, size - 20, rotation);

    end

    if(istable(item)) then
        surface.SetDrawColor(ColorAlpha(hasItemColor, Lerp(alphaFrac, 245, 0)));
        surface.SetMaterial(Material(item.iconoverride))
        surface.DrawTexturedRectRotated(x, y, size - 10, size - 10, 0);

    elseif(isstring(item)) then
        local font = ((!noInteraction and AMMO_buttonTables[index].hovered) and "ritual_radial_large" or "ritual_radial_small")
        draw.SimpleTextOutlined(item, font, x, y, ColorAlpha(textColor, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, ColorAlpha(color_black, Lerp(alphaFrac, 255, 0)))

    end

end

local function DrawButtons(w, h, halfWidth, halfHeight)
    local mouseX, mouseY = input.GetCursorPos()

    local size = 150
    local somethingsHovered = false

    for i, v in pairs(ammoButtons) do
        local increment = Lerp(i/#ammoButtons, 180, -180)

        local frac = math.Clamp((AMMO_ButtonsLerp - CurTime())/0.35, 0, 1)

        increment = Lerp(math.ease.InSine(frac), increment, increment + 180)

        local x = halfWidth + (math.sin(math.rad(increment)) * size)
        local y = halfHeight + (math.cos(math.rad(increment)) * size)

        x = Lerp(math.ease.InCubic(frac), x, halfWidth)
        y = Lerp(math.ease.InCubic(frac), y, halfHeight)

        DrawButton(x, y, 80, i, #ammoButtons, v)

        if(AMMO_buttonTables[i].hovered) then somethingsHovered = true end

    end

    if(unloadable) then
        DrawButton(halfWidth, h * 0.95, 80, #ammoButtons + 1, #ammoButtons + 1, "Unload", false, true)
        if(AMMO_buttonTables[#ammoButtons + 1].hovered) then somethingsHovered = true end

    end

    if(!somethingsHovered) then hoveredItem = nil end

    size = 50

    local clipHeight = h * 0.8

    for i, v in pairs(clipIcons) do
        local increment = Lerp(i/#clipIcons, 180, -180)

        local frac = math.Clamp((AMMO_ButtonsLerp - CurTime())/0.35, 0, 1)

        increment = Lerp(math.ease.InSine(frac), increment, increment - 180)

        local x = halfWidth + (math.sin(math.rad(increment)) * size)
        local y = clipHeight + (math.cos(math.rad(increment)) * size)

        x = Lerp(math.ease.InCubic(frac), x, halfWidth)
        y = Lerp(math.ease.InCubic(frac), y, clipHeight)

        DrawButton(x, y, 40, 5, -1, v, true)

    end

end

hook.Add("HUDPaint", "Begotten.HUDPaint.QuickReload", function()
    if(!AMMO_DrawButttons) then return end

    local w, h = ScrW(), ScrH()
    local halfWidth, halfHeight = w * 0.5, h * 0.5

    DrawButtons(w, h, halfWidth, halfHeight)

end)

local keyDownTime = -1
local dontMenu = false
local noButtons = false

local function HasFirearm(player)
    local activeWeapon = player:GetActiveWeapon()

    return activeWeapon:IsValid() and (activeWeapon.Base == "begotten_firearm_base" or (activeWeapon.isMeleeFirearm and !player:GetNetVar("ThrustStance")))

end

local function TryLoad(itemTable, inventory, firearmItemTable)
    if(itemTable == "Unload") then
        Clockwork.inventory:InventoryAction("ammo", firearmItemTable.uniqueID, firearmItemTable.itemID);

        return

    end

    local itemInstances = inventory[itemTable.uniqueID] or {}
	local validItemInstances = {}
	
	for k, v in pairs(itemInstances) do
		if(!v.ammoMagazineSize or v:GetAmmoMagazine() > 0) then table.insert(validItemInstances, v) end
	end
	
	if(!table.IsEmpty(validItemInstances)) then
		local randomItem = table.Random(validItemInstances)

        netstream.Start("UseAmmo", {randomItem.uniqueID, randomItem.itemID, firearmItemTable("uniqueID"), firearmItemTable("itemID")})
		
		return true

	end

    return false

end

local function ReallyQuickReload(ply, firearmItemTable, inventory)
	local lastLoadedShot = ply:GetLocalVar("lastLoadedShot")
	
	if(lastLoadedShot) then
		local itemTable = item.FindByID(lastLoadedShot)
        if(itemTable and TryLoad(itemTable, inventory, firearmItemTable)) then return true end

	end
	
	-- Select a random ammo type if a previous one has not been found.
	for i, v in RandomPairs(firearmItemTable.ammoTypes) do
		local itemTable = item.FindByID(string.lower(v))
		if(!itemTable) then continue end
		if(firearmItemTable.usesMagazine and !itemTable.ammoMagazineSize) then continue end
		
		if(TryLoad(itemTable, inventory, firearmItemTable)) then return true end
		
	end

	-- Go over again for magazined firearms to select single shots if no magazines are found.
	if(firearmItemTable.usesMagazine) then
		for i, v in RandomPairs(firearmItemTable.ammoTypes) do
			local itemTable = item.FindByID(string.lower(v));
			if(!itemTable) then continue end

			if(TryLoad(itemTable, inventory, firearmItemTable)) then return true end
			
		end

	end

    return false

end

local function VerifyMenu(curTime)
    local ply = Clockwork.Client
    if(!HasFirearm(ply)) then dontMenu = true return end

    local firearmItemTable = item.GetByWeapon(ply:GetActiveWeapon())
	
	if(!firearmItemTable) then dontMenu = true return end
	if(!firearmItemTable.ammoTypes) then dontMenu = true return end
	
	local inventory = Clockwork.inventory:GetClient()
	
	if(!inventory) then dontMenu = true return end
	
	local ammo = firearmItemTable:GetData("Ammo")

    if(ammo and #ammo > 0) then unloadable = true end
	if(ammo and #ammo > ((firearmItemTable.ammoCapacity - 1) or 0)) then noButtons = true return end

end

local function ReloadPressed(curTime)
    local ply = Clockwork.Client
    if(!HasFirearm(ply)) then dontMenu = true return end

    local firearmItemTable = item.GetByWeapon(ply:GetActiveWeapon())
	
	if(!firearmItemTable) then dontMenu = true return end
	if(!firearmItemTable.ammoTypes) then dontMenu = true return end
	
	local inventory = Clockwork.inventory:GetClient()
	
	if(!inventory) then dontMenu = true return end
	
	local ammo = firearmItemTable:GetData("Ammo")
	
	if(ammo and #ammo > ((firearmItemTable.ammoCapacity - 1) or 0)) then dontMenu = true return end
	
    if(ReallyQuickReload(ply, firearmItemTable, inventory)) then dontMenu = true return end

end

local function PopulateAmmoButtons()
    local localPlayer = Clockwork.Client
    local weapon = localPlayer:GetActiveWeapon()
    local firearmItemTable = item.GetByWeapon(weapon)
    local inventory = Clockwork.inventory:GetClient()

    ammoButtons = {}
    clipIcons = {}

    if(!noButtons) then
        for i, v in SortedPairsByValue(firearmItemTable.ammoTypes) do
            local ammoItemTable = item.FindByID(string.lower(v));
            if(!ammoItemTable) then continue end

            if(!inventory[ammoItemTable.uniqueID] or table.IsEmpty(inventory[ammoItemTable.uniqueID])) then continue end

            table.insert(ammoButtons, ammoItemTable)

        end

    end

    if(firearmItemTable.ammoCapacity > 1 and !firearmItemTable.usesMagazine) then
        local ammo = firearmItemTable:GetData("Ammo")

        for i, v in pairs(ammo) do
            local ammoItemTable = item.FindByID(string.lower(v));
            if(!ammoItemTable) then continue end

            table.insert(clipIcons, ammoItemTable)

        end

        for i = 1, (firearmItemTable.ammoCapacity - #ammo) do
            table.insert(clipIcons, "")
            
        end

    end

end

local buttonsUp = false

local function ToggleButtons(enabled, curTime)
    buttonsUp = enabled

    PopulateAmmoButtons()

    AMMO_DrawButttons = enabled
    gui.EnableScreenClicker(enabled)
    AMMO_ButtonsFadeIn = (enabled and curTime + 0.15 or -1)
    AMMO_ButtonsLerp = (enabled and curTime + 0.35 or -1)

end

local function ReloadReleased(curTime)
    ToggleButtons(false, curTime)

    if(curTime < keyDownTime + 0.2) then ReloadPressed(curTime) return end

    local localPlayer = Clockwork.Client
    local firearmItemTable = item.GetByWeapon(localPlayer:GetActiveWeapon())
    local inventory = Clockwork.inventory:GetClient()

    if(hoveredItem) then TryLoad(hoveredItem, inventory, firearmItemTable) end

end

hook.Add("Think", "Begotten.Think.QuickReload", function()
    local curTime = CurTime()
    local reloadPressed = input.IsKeyDown(input.GetKeyCode(input.LookupBinding("+reload")))

    if(reloadPressed and keyDownTime == -1 and !vgui.CursorVisible()) then
        VerifyMenu(curTime)
        keyDownTime = curTime

    elseif(!reloadPressed and keyDownTime != -1) then
        if(!dontMenu) then ReloadReleased(curTime) end

        keyDownTime = -1
        dontMenu = false
        noButtons = false
        unloadable = false

    end

    if(!dontMenu and keyDownTime != -1 and curTime >= keyDownTime + 0.2 and !buttonsUp) then
        ToggleButtons(true, curTime)

    end

end)