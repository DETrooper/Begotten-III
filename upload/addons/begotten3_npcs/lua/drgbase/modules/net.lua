-- Util --

local function IsPlayer(arg)
  if not isentity(arg) then return false end
  if not IsValid(arg) then return false end
  if not arg:IsPlayer() then return false end
  return true
end

function net.DrG_WriteMessage(...)
  local args, n = table.DrG_Pack(...)
  net.WriteUInt(n, 32)
  for i = 1, n do
    net.WriteType(args[i])
  end
end
function net.DrG_ReadMessage()
  local n = net.ReadUInt(32)
  local args = {}
  for i = 1, n do
    args[i] = net.ReadType()
  end
  return args, n
end

-- Messages --

if SERVER then
  util.AddNetworkString("DrGBaseNetMessage")
end

local NET_MESSAGES = {}
function net.DrG_Receive(name, callback)
  if isfunction(callback) then NET_MESSAGES[name] = callback
  else NET_MESSAGES[name] = nil end
end
function net.DrG_Send(name, ...)
  if not isstring(name) then return false end
  net.Start("DrGBaseNetMessage")
  net.WriteString(name)
  net.DrG_WriteMessage(...)
  if SERVER then net.Broadcast()
  else net.SendToServer() end
  return true
end
net.Receive("DrGBaseNetMessage", function(len, ply)
  local name = net.ReadString()
  if not isfunction(NET_MESSAGES[name]) then return end
  local args, n = net.DrG_ReadMessage()
  if SERVER then NET_MESSAGES[name](ply, table.DrG_Unpack(args, n))
  else NET_MESSAGES[name](table.DrG_Unpack(args, n)) end
end)

-- Callbacks --

local NET_REQ_ID = 0

if SERVER then
  util.AddNetworkString("DrGBaseNetCallbackReq")
  util.AddNetworkString("DrGBaseNetCallbackRes")
end

local NET_CALLBACKS = {}
function net.DrG_DefineCallback(name, callback)
  if not isstring(name) then return end
  if isfunction(callback) then
    NET_CALLBACKS[name] = callback
  else NET_CALLBACKS[name] = nil end
end
function net.DrG_RemoveCallback(name)
  return net.DrG_DefineCallback(name, nil)
end

local NET_REQ_WAITING = {}
net.Receive("DrGBaseNetCallbackRes", function()
  local id = net.ReadUInt(32)
  if not isfunction(NET_REQ_WAITING[id]) then return end
  local args, n = net.DrG_ReadMessage()
  NET_REQ_WAITING[id](table.DrG_Unpack(args, n))
  NET_REQ_WAITING[id] = nil
end)
function net.DrG_UseCallback(name, callback, ...)
  if not isstring(name) then return false end
  local args, n
  if SERVER then
    args, n = table.DrG_Pack(...)
    local ply = args[1]
    if not IsPlayer(ply) then return false end
  end
  local id = NET_REQ_ID
  NET_REQ_ID = NET_REQ_ID+1
  NET_REQ_WAITING[id] = callback
  net.Start("DrGBaseNetCallbackReq")
  net.WriteUInt(id, 32)
  net.WriteString(name)
  if SERVER then
    net.DrG_WriteMessage(table.DrG_Unpack(table.DrG_Pack(args, n, 2)))
    net.Send(ply)
  else
    net.DrG_WriteMessage(...)
    net.SendToServer()
  end
  return true
end
net.Receive("DrGBaseNetCallbackReq", function(len, ply)
  local id = net.ReadUInt(32)
  local name = net.ReadString()
  if not isfunction(NET_CALLBACKS[name]) then return end
  local args, n = net.DrG_ReadMessage()
  net.Start("DrGBaseNetCallbackRes")
  net.WriteUInt(id, 32)
  net.DrG_WriteMessage(NET_CALLBACKS[name](table.DrG_Unpack(args, n)))
  if SERVER then net.Send(ply)
  else net.SendToServer() end
end)
