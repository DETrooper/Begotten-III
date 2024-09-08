
Clockwork.config:AddToSystem("Enable the crosshair for players", "enable_crosshair", "Whether or not players can use the crosshair.");

Clockwork.ConVars.CROSSHAIR = Clockwork.ConVars.CROSSHAIR or Clockwork.kernel:CreateClientConVar("cwCrosshair", 0, true, true);
Clockwork.setting:AddCheckBox("Screen effects", "Enable the crosshair when weapons are raised.", "cwCrosshair", "Click to enable the crosshair when your weapon is raised.", function()
    return Clockwork.player:IsAdmin(Clockwork.Client) or Clockwork.config:Get("enable_crosshair"):Get();
end);

function cwCrosshair:HUDPaint()
    local width, height = ScrW(), ScrH();

    if(!Clockwork.ConVars.CROSSHAIR:GetBool()) then return; end
    if(!Clockwork.player:IsAdmin(Clockwork.Client) and !Clockwork.config:Get("enable_crosshair"):Get()) then return; end
    if(!Clockwork.Client:IsWeaponRaised()) then return; end
    if(Clockwork.character.isOpen) then return; end

    surface.SetDrawColor(255,255,255);

    local pos = Clockwork.Client:GetEyeTrace().HitPos:ToScreen();

    surface.DrawRect(pos.x-2,pos.y-2,4,4);

end