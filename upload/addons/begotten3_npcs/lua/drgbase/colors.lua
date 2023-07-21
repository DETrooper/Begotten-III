-- Opaque --

DrGBase.CLR_WHITE = Color(255, 255, 255)
DrGBase.CLR_GREEN = Color(150, 255, 40)
DrGBase.CLR_RED = Color(255, 50, 50)
DrGBase.CLR_CYAN = Color(0, 200, 200)
DrGBase.CLR_PURPLE = Color(220, 40, 115)
DrGBase.CLR_BLUE = Color(50, 100, 255)
DrGBase.CLR_ORANGE = Color(255, 150, 30)
DrGBase.CLR_DARKGRAY = Color(20, 20, 20)
DrGBase.CLR_LIGHTGRAY = Color(200, 200, 200)

-- Transparent --

local function Transparent(color)
  color = color:ToVector():ToColor()
  color.a = 0
  return color
end

DrGBase.CLR_WHITE_TR = Transparent(DrGBase.CLR_WHITE)
DrGBase.CLR_GREEN_TR = Transparent(DrGBase.CLR_GREEN)
DrGBase.CLR_RED_TR = Transparent(DrGBase.CLR_RED)
DrGBase.CLR_CYAN_TR = Transparent(DrGBase.CLR_CYAN)
DrGBase.CLR_PURPLE_TR = Transparent(DrGBase.CLR_PURPLE)
DrGBase.CLR_BLUE_TR = Transparent(DrGBase.CLR_BLUE)
DrGBase.CLR_ORANGE_TR = Transparent(DrGBase.CLR_ORANGE)
DrGBase.CLR_DARKGRAY_TR = Transparent(DrGBase.CLR_DARKGRAY)
DrGBase.CLR_LIGHTGRAY_TR = Transparent(DrGBase.CLR_LIGHTGRAY)
