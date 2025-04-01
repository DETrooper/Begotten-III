Clockwork.ConVars.INTROENABLED = Clockwork.kernel:CreateClientConVar("cwIntroEnabled", 1, true, true)

surface.CreateFont("nx_IntroTextSmalls", {font = "Day Roman", size = ScaleToWideScreen(75), weight = 700, antialiase = true, shadow = true})
surface.CreateFont("nov_IntroTextSmallaaaa", {font = "Day Roman", size = ScaleToWideScreen(150), weight = 700, antialiase = true, shadow = true})
surface.CreateFont("nov_IntroTextSmallaaaaa", {font = "Day Roman", size = ScaleToWideScreen(50), weight = 700, antialiase = true, shadow = false})
surface.CreateFont("nov_IntroTextSmallfaaaaa", {font = "Day Roman", size = ScaleToWideScreen(50), weight = 700, antialiase = true, shadow = false})
surface.CreateFont("nov_IntroTextSmallaaafaa", {font = "Day Roman", size = ScaleToWideScreen(37), weight = 700, antialiase = true, shadow = true})
surface.CreateFont("nov_IntroTextSmallDETrooper", {font = "Day Roman", size = ScaleToWideScreen(24), weight = 700, antialiase = true, shadow = true})

Clockwork.setting:AddCheckBox("Introduction", "Enable main menu intro sequence.", "cwIntroEnabled", "Click to toggle the main menu introduction sequence.")