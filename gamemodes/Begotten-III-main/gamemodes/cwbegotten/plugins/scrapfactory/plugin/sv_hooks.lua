--[[
	Begotten III: Jesus Wept
--]]

local map = (game.GetMap() == "rp_begotten3" or game.GetMap() == "rp_scraptown" or game.GetMap() == "rp_district21");

-- Called when Clockwork has loaded all of the entities.
function cwScrapFactory:ClockworkInitPostEntity()
	if (!map) then
		return;
	end;
	
	if not self.valves then
		self.valves = {};
	end

	for i = 1, #SCRAP_FACTORY_VALVES do
		local valveEnt = ents.Create("cw_scrapfactoryvalve");
		
		valveEnt:SetPos(SCRAP_FACTORY_VALVES[i].spawnPosition);
		valveEnt:SetAngles(SCRAP_FACTORY_VALVES[i].spawnAngles);
		valveEnt:Spawn();
		
		valveEnt.overheating = false;
		valveEnt.steamAngles = SCRAP_FACTORY_VALVES[i].steamAngles;
		table.insert(self.valves, valveEnt);
	end
	
	self.machineSoundEnt = ents.Create("prop_physics");
	self.machineSoundEnt:SetPos(self.machineSoundVector);
	self.machineSoundEnt:SetModel("models/hunter/blocks/cube025x025x025.mdl");
	self.machineSoundEnt:Spawn();
	self.machineSoundEnt:SetCollisionGroup(COLLISION_GROUP_WORLD);
	self.machineSoundEnt:SetRenderMode(RENDERMODE_TRANSALPHA);
	self.machineSoundEnt:SetColor(Color(0, 0, 0, 0));
	self.machineSoundEnt:DrawShadow(false);
	
	local physicsObject = self.machineSoundEnt:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(false);
	end;
	
	self.miningEnt = ents.Create("cw_scrapfactoryorepile");
	self.miningEnt:SetPos(self.orePilePos);
	self.miningEnt:SetAngles(self.orePileAngles);
	self.miningEnt:Spawn();
	
	local physicsObject = self.miningEnt:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:EnableMotion(false);
	end;
end

function cwScrapFactory:Think()
	if (!map) then
		return;
	end;
	
	if cwScrapFactory.cycleInProgress == true then
		local curTime = CurTime();
		
		if (!self.machineSoundCooldown or self.machineSoundCooldown < curTime) then
			self.machineSoundCooldown = curTime + math.random(5, 10);
			
			local sound = self.machineSounds[math.random(1, #self.machineSounds)];
			CreateSound(self.machineSoundEnt, sound):Play();
		end
	end
end