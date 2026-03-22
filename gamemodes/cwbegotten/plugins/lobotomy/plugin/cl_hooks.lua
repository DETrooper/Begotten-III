function cwLobotomy:GetProgressBarInfoAction(action, percentage)
	if (action == "lobotomy") then
		return {text = "You are performing a lobotomy. Click to cancel.", percentage = percentage, flash = percentage > 75};

    end
end

cwLobotomy.endTime = cwLobotomy.endTime or 0;
cwLobotomy.image = cwLobotomy.image or Material("vgui/white");

cwLobotomy.images = {
    Material("manifesto/10.png"),
    Material("manifesto/11.png"),
    Material("manifesto/12.png"),
    Material("manifesto/3.png"),
    Material("manifesto/19.png"),
    Material("manifesto/16.png"),
    Material("manifesto/5.png"),
    Material("manifesto/9.png"),
    Material("manifesto/6.png"),
    Material("satanseq/cpjr2pf.png"),
    Material("satanseq/5ovskfs.png"),
    Material("satanseq/016vcpd.png"),
    Material("satanseq/594eynf.png"),
    Material("satanseq/hell18.png"),
    Material("satanseq/hell19.png"),
    Material("satanseq/hell2.png"),
    Material("satanseq/hell3.png"),
    Material("satanseq/nk7yvrh.png"),
    Material("satanseq/tjjf0ov.png"),
    Material("skitzo/14482738_1830850453827527_3359989994113466368_n.png"),
    Material("skitzo/14712230_1066223233503759_5159174832612442112_n.png"),
    Material("skitzo/15535126_223249671457307_189321080370888704_n.png"),
    Material("skitzo/15624975_356176191423228_1882920092132442112_n.png"),
    Material("skitzo/16465731_1316642118396547_4184642840434835456_n.png"),
    Material("skitzo/16583746_442076376123941_424317102120239104_n.png"),
    Material("skitzo/18646719_217620648744788_4499356977071128576_n.png"),
    Material("skitzo/39020207_516832608775259_3198487103386157056_n.png"),
    Material("skitzo/36980875_419284945256905_5220573026491301888_n.png"),
    Material("skitzo/46773268_2301752116714540_1644288539814430608_n.png"),
};

-- Material() returns two values, so this shit is mandatory.
table.remove(cwLobotomy.images, #cwLobotomy.images);

function cwLobotomy:RenderScreenspaceEffects()
    local curTime = CurTime();

    if(cwLobotomy.endTime <= curTime) then return; end

    local timeLeft = (cwLobotomy.endTime - curTime);

    surface.SetDrawColor(255, 255, 255, (timeLeft - 4) * 255);

    surface.SetMaterial(cwLobotomy.image);
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH());

    local range = (timeLeft / cwLobotomy.effectDuration);

    DrawMotionBlur(0.4, 0.8, 0.05);
    DrawSharpen(range * 30, TimedCos(range * 5, -range * 60, range * 60, 0));

end

function cwLobotomy:ModifyStatusEffects(tab)
    if(Clockwork.Client:HasTrait("lobotomite")) then
		table.insert(tab, {text = "(-) Lobotomite", color = Color(200, 40, 40)});
	end

end

net.Receive("cwLobotomyEffect", function()
    cwLobotomy.endTime = CurTime() + cwLobotomy.effectDuration;
    cwLobotomy.image = cwLobotomy.images[math.random(1, #cwLobotomy.images)];

    Clockwork.Client:EmitSound("begotten/lobotomy2.mp3", 75, math.random(90, 110), 0.65);

end);