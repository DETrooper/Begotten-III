Clockwork.ConVars.HITINDICATOR = Clockwork.ConVars.HITINDICATOR or Clockwork.kernel:CreateClientConVar("cwHitIndicator", 1, true, true);
Clockwork.setting:AddCheckBox("Screen effects", "Enable ranged hit indicator.", "cwHitIndicator", "Click to enable hit indicators when using ranged weapons.");

net.Receive("cwReadSound", function()
    local snd = net.ReadString();
    local level = net.ReadUInt(8);
    local pitch = net.ReadUInt(16);
    local volume = net.ReadDouble(8);
    local conVar = net.ReadString();
	
    if(conVar != "" and !GetConVar(conVar):GetBool()) then return; end

    Clockwork.Client:EmitSound(snd, level, pitch, volume);
end)