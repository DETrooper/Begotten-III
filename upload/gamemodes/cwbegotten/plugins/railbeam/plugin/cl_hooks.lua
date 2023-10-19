cwRailBeam.dieTime = 0.35;
cwRailBeam.activeBeams = {};

net.Receive("cwRailgunBeam", function()
    cwRailBeam.activeBeams[#cwRailBeam.activeBeams+1] = {
        start = net.ReadVector(),
        hit = net.ReadVector(),
        startTime = CurTime(),

    };

end)

cwRailBeam.tracerMat = Material("cable/blue_elec");

function cwRailBeam:PostDrawTranslucentRenderables()
    local curTime = CurTime();

    for i, v in pairs(self.activeBeams) do
        local timeSinceStart = curTime - v.startTime;

        render.SetMaterial(self.tracerMat);
        render.DrawBeam(LerpVector(timeSinceStart/self.dieTime, v.start, v.hit), v.hit, 4, math.Rand(0.01,0.25), math.Rand(0.5, 1.01));

        // if we do this at the start it could fuck some things up
        if(timeSinceStart >= self.dieTime) then table.remove(self.activeBeams, i); end

    end

end