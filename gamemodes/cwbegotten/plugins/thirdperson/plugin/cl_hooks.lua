
Clockwork.config:AddToSystem("Enable third person for players", "enable_thirdperson", "Whether or not players can use the third person.");

Clockwork.ConVars.THIRDPERSON = Clockwork.ConVars.THIRDPERSON or Clockwork.kernel:CreateClientConVar("cwThirdPerson", 0, true, true);
Clockwork.setting:AddCheckBox("Screen effects", "Enable third person.", "cwThirdPerson", "Click to enable third person mode. Can be toggled using 'begotten_thirdperson', 'chasecam', 'ix_togglethirdperson', or 'ark_thirdperson' commands", function()
    return Clockwork.player:IsAdmin(Clockwork.Client) or Clockwork.config:Get("enable_thirdperson"):Get();
end);

local function ToggleThirdPerson()
    if(!Clockwork.player:IsAdmin(Clockwork.Client) and !Clockwork.config:Get("enable_thirdperson"):Get()) then return; end
    
    Clockwork.ConVars.THIRDPERSON:SetBool(!Clockwork.ConVars.THIRDPERSON:GetBool());
    Clockwork.Client:EmitSound("begotten/ui/buttonrollover.wav");

end

concommand.Add("begotten_thirdperson", ToggleThirdPerson);
concommand.Add("chasecam", ToggleThirdPerson);
concommand.Add("ix_togglethirdperson", ToggleThirdPerson);
concommand.Add("ark_thirdperson", ToggleThirdPerson);

function cwThirdPerson:CalcViewAdjustTable(view)
    if(!Clockwork.ConVars.THIRDPERSON:GetBool()) then return; end
    if(!Clockwork.player:IsAdmin(Clockwork.Client) and !Clockwork.config:Get("enable_thirdperson"):Get()) then return; end
    if(Clockwork.character.isOpen) then return; end

    view.drawviewer = true;

    local player = Clockwork.Client;
    local pos = player:GetPos();

    local up, forward, right = 2, -60, 30;

    local data = {
        start = view.origin,
        endpos = view.origin + (view.angles:Forward() * forward) + (view.angles:Up() * up) + (view.angles:Right() * right),
        filter = Clockwork.Client,
        mins = Vector(-10, -10, -10),
        maxs = Vector(10, 10, 10),

    };

    view.origin = util.TraceHull(data).HitPos;

end

function cwThirdPerson:PreDrawViewModel()
    if(Clockwork.ConVars.THIRDPERSON:GetBool() and (Clockwork.config:Get("enable_thirdperson"):Get() or Clockwork.player:IsAdmin(Clockwork.Client)) and !Clockwork.character.isOpen) then return true; end

end
