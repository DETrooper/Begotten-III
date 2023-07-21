if SERVER then return end

function render.DrG_DrawSprite(sprite, pos, size, options)
  options = options or {}
  size = isnumber(size) and math.Clamp(size, 0, math.huge) or 100
  local normal = pos:DrG_Direction(isvector(options.origin) and options.origin or EyePos())
  normal.z = 0
  local material = DrGBase.Material(sprite)
  if material:IsError() then return end
  render.SetMaterial(material)
  local color = options.color or Color(255, 255, 255)
  if options.lighting then
    local light = (render.GetLightColor(pos)*255):ToColor()
    local p = ((light.r + light.g + light.b)/3)/255
    color = Color(color.r*p, color.g*p, color.b*p, color.a)
  end
  render.DrawQuadEasy(pos, normal, size, size, color, (options.rotation or 0) + 180)
end
