
function debugoverlay.DrG_Trajectory(start, velocity, lifetime, color, ignoreZ, options)
  local info = start:DrG_TrajectoryInfo(velocity, options.ballistic)
  options = options or {}
  options.from = options.from or 0
  options.to = options.to or 10
  options.increments = options.increments or 0.01
  if options.colors == nil then options.colors = function() end end
  if options.height == nil then options.height = true end
  local t = options.from
  while t < options.to do
    if isfunction(color) then
      debugoverlay.Line(info.Predict(t), info.Predict(t+options.increments), lifetime, color(t), ignoreZ)
    else debugoverlay.Line(info.Predict(t), info.Predict(t+options.increments), lifetime, color, ignoreZ) end
    t = t+options.increments
  end
  if info.ballistic and options.height then
    local highestPoint = info.Predict(info.highest)
    local tr = util.TraceLine({
      start = highestPoint,
      endpos = highestPoint + Vector(0, 0, -999999999),
      collisiongroup = COLLISION_GROUP_IN_VEHICLE
    })
    if isfunction(color) then
      debugoverlay.Line(highestPoint, tr.HitPos, lifetime, color(info.highest), ignoreZ)
    else debugoverlay.Line(highestPoint, tr.HitPos, lifetime, color, ignoreZ) end
  end
end
