local PLUGIN = PLUGIN

local font = Clockwork.option:GetFont("chat_box_syntax");

local color = Color(128, 0, 0)

function PLUGIN:HUDPaintForeground()
    local bIsTypingCommand = Clockwork.chatBox:IsTypingCommand()

    if bIsTypingCommand then
        local x, y = Clockwork.chatBox:GetPosition(2, -100)

        local cmd, args = self:ParseCommand(Clockwork.chatBox.textEntry:GetValue())

        if !cmd then return end

        if #args < 1 then return end

        Clockwork.kernel:OverrideMainFont(font)
        local _, matches = self:HandleAutoComplete(cmd, args)
        local count = 0

            if matches and #matches > 0 then
                for k, v in pairs(matches) do

                    if count >= 12 then
                        break
                    end
                    
                    Clockwork.kernel:DrawSimpleText(v, x, y - 175, color)
                    y = y + 15
                    count = count + 1
                end
            end

        Clockwork.kernel:OverrideMainFont(false)


    end
    
end

function PLUGIN:OnChatTab(text)
    local cmd, args = self:ParseCommand(text)

    if !cmd then return text end

    local cmdstr = self:HandleAutoComplete(cmd, args)

    if cmdstr then //TODO: integrate selecting between multiple results
        text = cmdstr
    end

    return text
end