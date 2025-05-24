local PLUGIN = PLUGIN

local font = Clockwork.option:GetFont("chat_box_syntax");
local color = Color(128, 0, 0)
local highlight_color = Color(255, 83, 0)
local suggestion_limit = 12

function PLUGIN:HUDPaintForeground()
    local bIsTypingCommand = Clockwork.chatBox:IsTypingCommand()
    if not bIsTypingCommand then return end

    local cmd, args = self:ParseCommand(Clockwork.chatBox.textEntry:GetValue())

    if not cmd then return end

    if #args < 1 then return end

    local x, y = Clockwork.chatBox:GetPosition(2, -335)

    Clockwork.kernel:OverrideMainFont(font)

    local _, matches = self:HandleAutoComplete(cmd, args)
    if not matches or #matches == 0 then return end

    local count = 0

    for i, suggestion in ipairs(matches) do
        if count >= suggestion_limit then
            break
        end

        local _, th = Clockwork.kernel:GetCachedTextSize(font, suggestion)

        local colnew = (i == self.autoCompleteIndex) and highlight_color or color

        Clockwork.kernel:DrawSimpleText(suggestion, x, y, colnew)
        y = y + th
        count = count + 1
    end

    Clockwork.kernel:OverrideMainFont(false)
end

PLUGIN.autoCompleteMatches = {}
PLUGIN.autoCompleteIndex   = 1

function PLUGIN:OnChatTab(text)
    local cmd, args = self:ParseCommand(text)
    if not cmd then
        return text
    end

    local newText, matches = self:HandleAutoComplete(cmd, args)

    if matches and #matches > 1 then
        self.autoCompleteMatches = matches
    else
        self.autoCompleteMatches = matches or {}
    end

    local isShiftDown = input.IsKeyDown(KEY_LSHIFT)
    if #self.autoCompleteMatches > 1 then
        if isShiftDown then
            self.autoCompleteIndex = self.autoCompleteIndex + 1
        end

        if self.autoCompleteIndex < 1 or self.autoCompleteIndex > math.min(#self.autoCompleteMatches, suggestion_limit) then
            self.autoCompleteIndex = 1
        end
    else
        self.autoCompleteIndex = 1
    end

    if not isShiftDown and #self.autoCompleteMatches > 1 then
        local selected_match = self.autoCompleteMatches[self.autoCompleteIndex]
        if selected_match then
            args[#args] = "\"" .. selected_match .. "\""
            text = "/" .. cmd .. " " .. table.concat(args, " ") .. " "
        end
    elseif newText then
        text = newText
    end

    return text
end