local PLUGIN = PLUGIN


PLUGIN.argtypes = PLUGIN.argtypes or {}

function Clockwork.command:RegisterType(id, callback)
    PLUGIN:RegisterArgumentType(id, callback)
end

function PLUGIN:RegisterArgumentType(id, callback)
    self.argtypes[id] = callback
end


function PLUGIN:ParseArgumentType(cmd_type, argument, args)
    local parser = self.argtypes[cmd_type]

    if parser then
        return parser(argument, args)
    end

    return {}
end

function PLUGIN:ParseCommand(str)
    local cmd, args_str = string.match(str, "^" .. config.GetVal("command_prefix") .. "(%S+)%s+(.*)$") // >:^(
    local args = {}
    local current_arg = ""
    local in_quotes = false

    if !args_str then
        args_str = ""
    end

    for i = 1, #args_str do
        local char = args_str:sub(i, i)

        if char == "\"" then
            if in_quotes then //for string literals
                current_arg = current_arg .. char
                table.insert(args, current_arg)
                current_arg = ""
                in_quotes = false
            else
                if current_arg ~= "" then
                    table.insert(args, current_arg)
                    current_arg = ""
                end
                in_quotes = true
                current_arg = current_arg .. char
            end
        elseif char == " " and !in_quotes then
            if current_arg ~= "" then
                table.insert(args, current_arg)
                current_arg = ""
            end
        else
            current_arg = current_arg .. char
        end
    end


    if current_arg ~= "" then
        table.insert(args, current_arg .. "*") // EOF
    end

    return cmd, args

    //return cmd, string.Split(args_str, " ")
end


function PLUGIN:HandleAutoComplete(cmd, args)
    local cmdtbl = Clockwork.command:FindByAlias(cmd)

    if !cmdtbl then return end
    
    local argc = (cmdtbl.arguments or 0) + (cmdtbl.optionalArguments or 0)

    for i = 1, argc do
        local argument = args[i] or ""
        local argument_type = cmdtbl.types and cmdtbl.types[i]
        if argument ~= "" and argument:sub(-1) == "*" then
            argument = string.gsub(argument, "*", "", 1) // remove our EOF
            argument = string.gsub(argument, "\"", "", 2) //long strings ie [' /cmd "spaced string '] ->  [ '/cmd "spaced string autocompleted" ']
            local matches = self:ParseArgumentType(argument_type, argument, args)

            if #matches == 1 then
                args[i] = "\"" .. matches[1] .. "\""
                return "/" .. cmd .. " " .. table.concat(args, " ") .. " ", matches
            elseif #matches > 1 then
                return nil, matches
            end
        end
    end

end