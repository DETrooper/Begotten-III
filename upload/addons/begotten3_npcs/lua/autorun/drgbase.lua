DrGBase = DrGBase or {}
DrGBase.Icon = "drgbase/icon16.png"

-- Print --

function DrGBase.Print(msg, options)
  --[[options = options or {}
  if SERVER and options.chat then
    net.Start("DrGBaseChatPrint")
    net.WriteString(msg)
    net.WriteBool(options.title ~= nil)
    if options.title ~= nil then
      net.WriteColor(options.title)
    end
    net.WriteBool(options.color ~= nil)
    if options.color ~= nil then
      net.WriteColor(options.color)
    end
    if IsValid(options.player) then
      net.Send(options.player)
    else net.Broadcast() end
  else
    local title = DrGBase.CLR_GREEN
    if options.title then title = options.title
    elseif SERVER or options._server then
      title = DrGBase.CLR_CYAN
    elseif CLIENT then title = DrGBase.CLR_ORANGE end
    local color = options.color or DrGBase.CLR_WHITE
    if options.chat and CLIENT then
      chat.AddText(title, "[DrGBase] ", color, msg)
    else MsgC(title, "[DrGBase] ", color, msg, "\n") end
  end]]--
end
function DrGBase.Info(msg, options)
  --[[options = options or {}
  options.title = DrGBase.CLR_GREEN
  return DrGBase.Print(msg, options)]]--
end
function DrGBase.Error(msg, options)
  --[[options = options or {}
  options.color = DrGBase.CLR_RED
  return DrGBase.Print(msg, options]]--
end
function DrGBase.ErrorInfo(msg, options)
  --[[options = options or {}
  options.title = DrGBase.CLR_GREEN
  options.color = DrGBase.CLR_RED
  return DrGBase.Print(msg, options)]]--
end
if CLIENT then
  net.Receive("DrGBaseChatPrint", function()
    local msg = net.ReadString()
    local options = {_server = true, chat = true}
    if net.ReadBool() then
      options.title = net.ReadColor()
    end
    if net.ReadBool() then
      options.color = net.ReadColor()
    end
    DrGBase.Print(msg, options)
  end)
end

-- Manage files --

local function IncludeFile(fileName)
  DrGBase.Print("Include file '"..fileName.."'.")
  return include(fileName)
end
function DrGBase.IncludeFile(fileName)
  local explode = string.Explode("[/\\]", fileName, true)
  local last = explode[#explode]
  if string.StartWith(last, "sv_") then
    if SERVER then return IncludeFile(fileName) end
  elseif string.StartWith(last, "cl_") then
    if CLIENT then return IncludeFile(fileName) end
  else
    AddCSLuaFile(fileName)
    return IncludeFile(fileName)
  end
end
function DrGBase.IncludeFiles(fileNames)
  local tbl = {}
  for i, fileName in ipairs(fileNames) do
    tbl[fileName] = DrGBase.IncludeFile(fileName)
  end
  return tbl
end
function DrGBase.IncludeFolder(folder)
  DrGBase.Print("Include folder '"..folder.."'.")
  local tbl = {}
  for i, fileName in ipairs(file.Find(folder.."/*.lua", "LUA")) do
    tbl[folder.."/"..fileName] = DrGBase.IncludeFile(folder.."/"..fileName)
  end
  return tbl
end
function DrGBase.RecursiveInclude(folder)
  local tbl = DrGBase.IncludeFolder(folder)
  local files, folders = file.Find(folder.."/*", "LUA")
  for i, folderName in ipairs(folders) do
    table.Merge(tbl, DrGBase.RecursiveInclude(folder.."/"..folderName))
  end
  return tbl
end

-- Autorun --

DrGBase.IncludeFolder("drgbase")
DrGBase.IncludeFolder("drgbase/meta")
DrGBase.IncludeFolder("drgbase/modules")

if SERVER then
  util.AddNetworkString("DrGBaseChatPrint")
else

  --[[hook.Add("Initialize", "DrGBaseHello", function()
    DrGBase.Info("Hi! :)")
  end)]]--

end
