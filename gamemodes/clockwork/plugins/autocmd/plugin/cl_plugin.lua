local PLUGIN = PLUGIN


PLUGIN.argtypes = PLUGIN.argtypes or {}

---Registers a command type
---```
---Clockwork.command:RegisterType("example", function(argument)
---    local matches = {"oh", "hi"}
---
---    return matches
---end)
---
-----later
---
---local COMMAND = Clockwork.command:New("examplecmd");
--	COMMAND.tip = ":0";
--	COMMAND.text = "hi";
--	COMMAND.access = "o";
--	COMMAND.arguments = 1;
--	COMMAND.types = {"example"}
--	COMMAND.alias = {"aliasexample", "examplealias"};
--
--	function COMMAND:OnRun(player, arguments)
--		print(arguments[1])
--	end;
--COMMAND:Register();
---```
---@param id string
---@param callback fun(current_arg: string, args: string[]): string[]
function Clockwork.command:RegisterType(id, callback)
    PLUGIN:RegisterArgumentType(id, callback)
end

---@param id string
function Clockwork.command:RemoveType(id)
    PLUGIN:RemoveArgumentType(id)
end

function PLUGIN:RemoveArgumentType(id)
    self.argtypes[id] = nil
end

function PLUGIN:RegisterArgumentType(id, callback)
    self.argtypes[id] = callback
end

---@param cmd_type string
---@param argument string
---@param args string[]
---@return string[]
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
            if in_quotes then -- for string literals
                table.insert(args, current_arg)
                current_arg = ""
                in_quotes = false
            else
                if current_arg ~= "" then
                    table.insert(args, current_arg)
                    current_arg = ""
                end
                in_quotes = true
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


    if current_arg ~= "" or in_quotes then
        table.insert(args, current_arg .. "*") -- EOF
    end

    return cmd, args
end


function PLUGIN:HandleAutoComplete(cmd, args)
    local cmdtbl = Clockwork.command:FindByAlias(cmd)
    if not cmdtbl then return end

    local argc = (cmdtbl.arguments or 0) + (cmdtbl.optionalArguments or 0)
    for i = 1, argc do
        local argument = args[i] or ""
        local argument_type = cmdtbl.types and cmdtbl.types[i]
        if argument ~= "" and argument:sub(-1) == "*" then
            argument = string.gsub(argument, "%*$", "") -- remove our EOF

            local matches = self:ParseArgumentType(argument_type, argument, args)
            if #matches == 0 then
                return
            else
                return matches
            end
        end
    end
end