local pentagram = Material("begotten/pentagram.png");
local button = Material("begotten/ui/bgtbtnrit1.png");
local textColor = Color(180, 15, 15);
local canPerformColor = Color(34, 180, 15);
local hasItemColor = Color(255, 255, 255, 245);
local noItemColor = Color(192, 192, 192, 50);



surface.CreateFont( "ritual_radial_small", {
	font = "Immortal",
	extended = false,
	size = Clockwork.kernel:FontScreenScale(8),
	weight = 900,

});

surface.CreateFont( "ritual_radiala", {
	font = "Immortal",
	extended = false,
	size = Clockwork.kernel:FontScreenScale(9),
	weight = 900,

});

surface.CreateFont( "ritual_radial_large", {
	font = "Immortal",
	extended = false,
	size = Clockwork.kernel:FontScreenScale(12),
	weight = 900,

});

surface.CreateFont( "ritual_radial_xlarge", {
	font = "Immortal",
	extended = false,
	size = Clockwork.kernel:FontScreenScale(20),
	weight = 900,

});

RITUAL_DrawButttons = RITUAL_DrawButttons or false;
RITUAL_ButtonsFadeIn = RITUAL_ButtonsFadeIn or -1;

RITUAL_buttonTables = RITUAL_buttonTables or {};
RITUAL_removingSub = RITUAL_removingSub or -1;

local scale2 = 0.15;
local function GetScaledX2(x, size, index, max)
    local xMin = Lerp((ScrW() * scale2) / ScrW(), x - (size*0.5), x + (size*0.5))
    local xMax = Lerp((ScrW() - (ScrW() * scale2)) / ScrW(), x - (size*0.5), x + (size*0.5))
    local realResult = (index-1)/(max-1)
    local result = Lerp(realResult, xMin, xMax)
    return result;

end

local function RitualFriendlyName(name)
	local _, pos = string.find(name, ")");
	return string.sub(name, pos + 2, #name);

end

local function DrawButton(x, y, size, text, index, uniqueID, items)
    if(!RITUAL_buttonTables[index]) then RITUAL_buttonTables[index] = {hovered = false, down = false, rightdown = false, removeTimer = -1}; end

    local mouseX, mouseY = gui.MouseX(), gui.MouseY();
    local halfSize = (size * 0.5);

    local cooldown = Clockwork.Client:GetNWInt("cwNextRitual") - CurTime();

    if(mouseX <= x + halfSize and
        mouseX >= x - halfSize and
        mouseY <= y + halfSize and
        mouseY >= y - halfSize) then

        local canClick = cooldown <= 0 or index == -1;

        if(canClick and !input.IsMouseDown(MOUSE_LEFT) and !input.IsMouseDown(MOUSE_RIGHT)) then
            size = size + 10;
            halfSize = (size * 0.5);

        end

        if(!input.IsMouseDown(MOUSE_LEFT) and canClick) then
            if(RITUAL_buttonTables[index].down) then
                RITUAL_buttonTables[index] = nil;
                Clockwork.Client:EmitSound("begotten/ui/buttonclick.wav");
                RITUAL_DrawButttons = false;
                gui.EnableScreenClicker(false);

                if(index != -1) then
                    cwRituals:AttemptRitual(uniqueID, items);

                end

                return;

            end

        elseif(!RITUAL_buttonTables[index].down and canClick) then
            RITUAL_buttonTables[index].down = true;

        end

        if(!input.IsMouseDown(MOUSE_RIGHT)) then
            RITUAL_buttonTables[index].rightdown = false;
            RITUAL_buttonTables[index].removeTimer = -1;

        else
            if(index != -1 and RITUAL_buttonTables[index].removeTimer != -1 and RITUAL_buttonTables[index].removeTimer <= CurTime()) then
                RITUAL_buttonTables[index] = nil;
                table.remove(cwRituals.hotkeyRituals, index);
                Clockwork.Client:EmitSound("begotten/flashback_outro.wav");

                return;

            end

            if(!RITUAL_buttonTables[index].rightdown) then
                RITUAL_buttonTables[index].rightdown = true;
                RITUAL_buttonTables[index].removeTimer = CurTime() + 2.5;
                Clockwork.Client:EmitSound("begotten/ui/buttonclick.wav");

            end

        end

        if(!RITUAL_buttonTables[index].hovered and canClick) then
            RITUAL_buttonTables[index].hovered = true;
            Clockwork.Client:EmitSound("begotten/ui/buttonrollover.wav", 75, Lerp(index/#cwRituals.hotkeyRituals, 80, 120));

        end

    else
        if(RITUAL_buttonTables[index].down) then RITUAL_buttonTables[index].down = false; end
        if(RITUAL_buttonTables[index].removeTimer != -1) then RITUAL_buttonTables[index].removeTimer = -1; end
        if(RITUAL_buttonTables[index].rightdown) then RITUAL_buttonTables[index].rightdown = false; end
        if(RITUAL_buttonTables[index].hovered) then RITUAL_buttonTables[index].hovered = false; end

    end

    local rotation = (CurTime() * 25 + (index * 45)) % 360;

    local alphaFrac = (RITUAL_ButtonsFadeIn - CurTime())/0.3;
    local alpha = Lerp(alphaFrac, 245, 0);

    local diff = (cooldown > 0 and index != -1) and 100 or 0;

    surface.SetDrawColor(155 - diff, 26 - diff, 26 - diff, alpha);
    surface.SetMaterial(button);
    surface.DrawTexturedRectRotated(x, y, size, size, -rotation);
    surface.SetMaterial(pentagram);
    surface.DrawTexturedRectRotated(x, y, size - 20, size - 20, rotation);

    if(text) then draw.SimpleTextOutlined(index == -1 and text or RitualFriendlyName(text), index == -1 and "ritual_radial_small" or "ritual_radiala", x, index == -1 and y or y - 35, ColorAlpha(textColor:Darken(diff), alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, ColorAlpha(color_black, Lerp(alphaFrac, 255, 0))); end
    
    if(index != -1 and RITUAL_buttonTables[index].removeTimer != -1) then
        local timeLeft = RITUAL_buttonTables[index].removeTimer - CurTime();

        local removing = "Removing........! ";
        local count = math.ceil(Lerp(timeLeft/2.5, #removing, 0));
        draw.SimpleTextOutlined(string.sub(removing, 0, count), "ritual_radial_small", x, index == -1 and y or y + 50, ColorAlpha(textColor, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, ColorAlpha(color_black, alpha));

        if(RITUAL_removingSub != count and count > 0) then
            RITUAL_removingSub = count;
            Clockwork.Client:EmitSound("buttons/lightswitch2.wav", 75, Lerp(count/#removing, 30, 80));

        end

    end

    if(items) then
        local itemCounts = {};

        for i, v in pairs(items) do
            local item = Clockwork.item:FindByID(v);
            local hasItem = Clockwork.inventory:HasItemCountByID(Clockwork.inventory:GetClient(), v, itemCounts[v] and itemCounts[v] or 1);

            if(hasItem) then
                if(!itemCounts[v]) then itemCounts[v] = 1; end
                itemCounts[v] = itemCounts[v] + 1;

            end

            surface.SetDrawColor(ColorAlpha(hasItem and hasItemColor or noItemColor, Lerp(alphaFrac, hasItem and 245 or 150, 0)):Darken(diff));
            surface.SetMaterial(Material(item.iconoverride))
            surface.DrawTexturedRectRotated(GetScaledX2(x, size, i, #items), y + 5, 60, 60, 0);

        end
        
    end

end

local function GetScaledX(index, max)
    local scale = Lerp(max/8, 0.5, 0.15);
    local minX = (ScrW() * scale);
    local maxX = ScrW() - ScrW() * scale;

    if(max == 1) then return Lerp(0.5, minX, maxX); end

    local frac = max == 1 and (index)/(max) or (index-1)/(max-1)
    return Lerp(frac, minX, maxX);

end

local function GetScaledY(index, max)
    local scale = 0.2;
    local minX = (ScrH() * scale);
    local maxX = ScrH() - ScrH() * scale;

    if(max == 1) then return minX; end

    local half = index/max > 0.5;
    --local func = half and math.ease.InCirc or math.ease.OutCirc;
    local frac = max == 1 and (index)/(max) or (index-1)/(max-1)
    return Lerp((frac), half and minX or maxX, half and maxX or minX) - (ScrH() * 0.3);

end

local function DrawOption(text, index, uniqueID, items)
    local scrW, scrH = ScrW(), ScrH();

    if(index == -1) then
        DrawButton(scrW * 0.5, scrH * 0.6, 125, text, index);

        return;

    end

    DrawButton(GetScaledX(index, #cwRituals.hotkeyRituals), GetScaledY(index, #cwRituals.hotkeyRituals), 150, text, index, uniqueID, items);

end

local function GetScaledX3(index, max)
    local scale = Lerp(max/30, 0.5, 0.15);
    local minX = (ScrW() * scale);
    local maxX = ScrW() - ScrW() * scale;

    if(max == 1) then return Lerp(0.5, minX, maxX); end

    local frac = max == 1 and (index)/(max) or (index-1)/(max-1)
    return Lerp(frac, minX, maxX);

end

hook.Add("HUDPaint", "RadialShitballs", function()
    if(!RITUAL_DrawButttons) then return; end

    local scrW, scrH = ScrW(), ScrH();
    local halfWidth = ScrW() * 0.5;
    local halfHeight = ScrH() * 0.5;

    --[[surface.SetDrawColor(255, 255, 0);
    surface.DrawRect(minX-75, 0, 1, scrH);
    surface.DrawRect(maxX+75, 0, 1, scrH);]]

    DrawOption("CANCEL", -1);

    for i, v in pairs(cwRituals.hotkeyRituals) do
        DrawOption(v.name, i, v.uniqueID, v.items);

    end

    local alphaFrac = (RITUAL_ButtonsFadeIn - CurTime())/0.3;
    local alpha = Lerp(alphaFrac, 245, 0);

    draw.SimpleTextOutlined("Left Mouse - Select", "ritual_radial_small", scrW * 0.95, scrH * 0.9, ColorAlpha(textColor, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 2, ColorAlpha(color_black, Lerp(alphaFrac, 255, 0)));
    draw.SimpleTextOutlined("Right Mouse (Hold) - Remove", "ritual_radial_small", scrW * 0.95, scrH * 0.9 + 25, ColorAlpha(textColor, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 2, ColorAlpha(color_black, Lerp(alphaFrac, 255, 0)));
    draw.SimpleTextOutlined("Middle Mouse (Hold) - View Total Requirements", "ritual_radial_small", scrW * 0.95, scrH * 0.9 + 50, ColorAlpha(textColor, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 2, ColorAlpha(color_black, Lerp(alphaFrac, 255, 0)));


    local player = LocalPlayer()
    local activeRituals = player:GetNetVar("activeRituals", {})

    local baseY = scrH * 0.03
    local yStep = scrH * 0.02
    local index = 0

    for ritualName, endTime in pairs(activeRituals) do
        local timeLeft = math.max(0, endTime - os.time())
        local minutes = math.floor(timeLeft / 60)
        local seconds = math.floor(timeLeft % 60)
        local timeText = string.format("%s: %d minutes %d seconds", ritualName, minutes, seconds)
        
        -- y step
        local yPos = baseY + (index * yStep)
        draw.SimpleTextOutlined(timeText, "ritual_radial_small", scrW * 0.95, yPos, ColorAlpha(textColor, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 2, ColorAlpha(color_black, Lerp(alphaFrac, 255, 0)))
        
        index = index + 1
    end

    local cooldown = math.Round(Clockwork.Client:GetNWInt("cwNextRitual") - CurTime(), 1);

    if(cooldown > 0) then
        draw.SimpleTextOutlined("Cooldown", "ritual_radial_large", scrW * 0.5, scrH * 0.4, ColorAlpha(textColor, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, ColorAlpha(color_black, Lerp(alphaFrac, 255, 0)));
        draw.SimpleTextOutlined(cooldown.."", "ritual_radial_xlarge", scrW * 0.5, scrH * 0.45, ColorAlpha(textColor, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, ColorAlpha(color_black, Lerp(alphaFrac, 255, 0)));

    end

    if(input.IsMouseDown(MOUSE_MIDDLE)) then
        local items = {};

        for _, v in pairs(cwRituals.hotkeyRituals) do
            for _, item in pairs(v.items) do
                if(!items[item]) then items[item] = 0; end

                items[item] = items[item] + 1;

            end

        end

        local index = 1;
        for i, v in pairs(items) do
            local item = Clockwork.item:FindByID(i);
            local x = GetScaledX3(index, table.Count(items));

            surface.SetDrawColor(ColorAlpha(color_white, alpha));
            surface.SetMaterial(Material(item.iconoverride));
            surface.DrawTexturedRectRotated(x, scrH * 0.9, 60, 60, 0);
            
            draw.SimpleTextOutlined(v, "ritual_radial_small", x + 20, scrH * 0.9 + 15, ColorAlpha(color_white, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 2, ColorAlpha(color_black, Lerp(alphaFrac, 255, 0)));

            index = index + 1;

        end

    end
    
end);

concommand.Add("begotten_rituals", function()
    RITUAL_DrawButttons = !RITUAL_DrawButttons;
    Clockwork.Client:EmitSound("begotten/ui/buttonclickrelease.wav");
    gui.EnableScreenClicker(RITUAL_DrawButttons);

    RITUAL_ButtonsFadeIn = RITUAL_DrawButttons and CurTime() + 0.3 or -1;

end);