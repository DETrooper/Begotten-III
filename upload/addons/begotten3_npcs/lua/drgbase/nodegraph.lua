-- NODES TABLE --

local DRG_NODES = {}
local DRG_NODES_POS = {}

-- NODE CLASS --

local Node = {}
Node.__index = Node
function Node:New(id, type, pos)
  local node = {}
  node._id = id
  node._type = type
  node._pos = pos
  node._links = {}
  setmetatable(node, self)
  return node
end

function Node:GetID()
  return self._id
end
function Node:GetType()
  return self._type
end
function Node:GetPos()
  return self._pos
end
function Node:__tostring()
  return "Node["..self:GetID().."]"
end

function Node:Link(node)
  self._links[node:GetID()] = true
  node._links[self:GetID()] = true
end
function Node:Unlink(node)
  self._links[node:GetID()] = false
  node._links[self:GetID()] = false
end
function Node:IsLinked(node)
  return self._links[node:GetID()] or false
end
function Node:GetLinked()
  local nodes = {}
  for id, linked in pairs(self._links) do
    if not linked then continue end
    table.insert(nodes, DRG_NODES[id])
  end
  return nodes
end

function Node:Distance(pos)
  if not isvector(pos) then pos = pos:GetPos() end
  return self:GetPos():Distance(pos)
end
function Node:DistToSqr(pos)
  if not isvector(pos) then pos = pos:GetPos() end
  return self:GetPos():DistToSqr(pos)
end

function Node:__tostring()
  local start = "Node"
  local type = self:GetType()
  if type == NODE_TYPE_GROUND then
    start = "Ground Node"
  elseif type == NODE_TYPE_AIR then
    start = "Air Node"
  elseif type == NODE_TYPE_CLIMB then
    start = "Climb Node"
  elseif type == NODE_TYPE_WATER then
    start = "Water Node"
  end
  local linked = self:GetLinked()
  local ids = {}
  for id, node in pairs(linked) do
    table.insert(ids, id)
  end
  return start.."["..self:GetID().."]=>["..table.concat(ids, ",").."]"
end

-- ACCESS NODEGRAPH --

function DrGBase.GetNodegraph()
  return DRG_NODES
end
function DrGBase.ClosestNode(pos)
  local goal
  local distSqr = math.huge
  for id, node in ipairs(DRG_NODES) do
    if node:DistToSqr(pos) >= distSqr then continue end
    distSqr = node:DistToSqr(pos)
    goal = node
  end
  return goal
end
function DrGBase.NodegraphAstar(pos, goal, callback)
  local closest = DrGBase.ClosestNode(pos)
  local toreach = DrGBase.ClosestNode(goal)
  local path, success = DrGBase.Astar(closest:GetPos(), toreach:GetPos(), {
    neighbours = function(pos)
      local node = DRG_NODES_POS[tostring(pos)]
      if node then
        local i = 1
        local linked = node:GetLinked()
        return function()
          local next = linked[i]
          i = i+1
          if next then return next:GetPos() end
        end
      else return function() end end
    end
  }, isfunction(callback) and function(pos1, pos2, ...)
    return callback(DRG_NODES_POS[tostring(pos1)], DRG_NODES_POS[tostring(pos2)], ...)
  end)
  table.remove(path, #path)
  table.insert(path, goal)
  return path, success
end

-- INIT NODEGRAPH --

if SERVER then
  util.AddNetworkString("DrGBaseNodegraph")

  -- thx Silverlan!
  local NUM_HULLS = 10
  local SIZEOF_INT = 4
  local SIZEOF_SHORT = 2
  local AINET_VERSION_NUMBER = 37
  local function toUShort(b)
  	local i = {string.byte(b,1,SIZEOF_SHORT)}
  	return i[1]+i[2]*256
  end
  local function toInt(b)
  	local i = {string.byte(b,1,SIZEOF_INT)}
  	i = i[1]+i[2]*256+i[3]*65536+i[4]*16777216
  	if i > 2147483647 then return i-4294967296 end
  	return i
  end
  local function ReadInt(f) return toInt(f:Read(SIZEOF_INT)) end
  local function ReadUShort(f) return toUShort(f:Read(SIZEOF_SHORT)) end
  local function InitNodegraph()
    f = file.Open("maps/graphs/"..game.GetMap()..".ain", "rb", "GAME")
    if not f then return false end
    DRG_NODES = {}
    DRG_NODES_POS = {}
    local ainet_ver = ReadInt(f)
    if ainet_ver ~= AINET_VERSION_NUMBER then return false end
    local map_ver = ReadInt(f)
    local nbnodes = ReadInt(f)
    for i = 1, nbnodes do
      local pos = Vector(f:ReadFloat(), f:ReadFloat(), f:ReadFloat())
    	local yaw = f:ReadFloat()
    	local offsets = {}
    	for h = 1, NUM_HULLS do
    		offsets[h] = f:ReadFloat()
    	end
    	local type = f:ReadByte()
    	local info = ReadUShort(f)
    	local zone = f:ReadShort()
      local node = Node:New(i, type, pos)
    	table.insert(DRG_NODES, node)
      DRG_NODES_POS[tostring(pos)] = node
    end
    local nblinks = ReadInt(f)
		for i = 1, nblinks do
			local srcID = f:ReadShort()
			local destID = f:ReadShort()
			local nodesrc = DRG_NODES[srcID+1]
			local nodedest = DRG_NODES[destID+1]
      local move = {}
			for i = 1, NUM_HULLS do
				move[i] = f:ReadByte()
			end
      nodesrc:Link(nodedest)
		end
    f:Close()
    return true
  end

  local PARSED = false
  function DrGBase.RefreshNodegraph()
    PARSED = InitNodegraph()
  end

  local function NetNodegraph()
    net.Start("DrGBaseNodegraph")
    local compressed = util.Compress(util.TableToJSON(DRG_NODES))
    net.WriteData(compressed, #compressed)
  end
  function DrGBase.BroadcastNodegraph()
    if not PARSED then return end
    --NetNodegraph()
    --net.Broadcast()
  end
  function DrGBase.SendNodegraph(ply)
    if not PARSED then return end
    --NetNodegraph()
    --net.Send(ply)
  end

  DrGBase.RefreshNodegraph()
  DrGBase.BroadcastNodegraph()
  hook.Add("PlayerInitialSpawn", "DrGBaseSendNodegraph", function(ply)
    DrGBase.SendNodegraph(ply)
  end)

else

  net.Receive("DrGBaseNodegraph", function(len)
    DRG_NODES = {}
    local nodes = util.JSONToTable(util.Decompress(net.ReadData(len/8)))
    for i, data in ipairs(nodes) do
      local node = Node:New(data._id, data._type, data._pos)
      table.insert(DRG_NODES, node)
    end
    for i, data in ipairs(nodes) do
      local node = DRG_NODES[i]
      for id, linked in pairs(data._links) do
        if not linked then continue end
        node:Link(DRG_NODES[id])
      end
    end
  end)

  local DisplayNodegraph = CreateConVar("drgbase_nodegraph_display", "0")
  local DisplayDistance = CreateConVar("drgbase_nodegraph_distance", "1500")
  local DisplayType = CreateConVar("drgbase_nodegraph_type", "2")
  local DisplayTransparent = CreateConVar("drgbase_nodegraph_transparent", "0")
  local COLORS = {
    [NODE_TYPE_GROUND] = DrGBase.CLR_GREEN,
    [NODE_TYPE_AIR] = DrGBase.CLR_CYAN,
    [NODE_TYPE_CLIMB] = DrGBase.CLR_PURPLE,
    [NODE_TYPE_WATER] = DrGBase.CLR_BLUE
  }

  hook.Add("PostDrawOpaqueRenderables", "DrGBaseDrawNodegraph", function()
    if not GetConVar("developer"):GetBool() then return end
    if not DisplayNodegraph:GetBool() then return end
    local ply = LocalPlayer()
    local tr = ply:GetEyeTrace()
    for id, node in ipairs(DRG_NODES) do
      if node:GetType() ~= DisplayType:GetInt() then continue end
      if node:DistToSqr(tr.HitPos) > DisplayDistance:GetFloat()^2 then continue end
      render.DrawWireframeBox(node:GetPos(), Angle(0, 0, 0), Vector(-15, -15, -5), Vector(15, 15, 5), COLORS[node:GetType()], not DisplayTransparent:GetBool())
      for id, next in ipairs(node:GetLinked()) do
        render.DrawLine(node:GetPos(), next:GetPos(), DrGBase.CLR_WHITE, not DisplayTransparent:GetBool())
      end
    end
  end)

end
