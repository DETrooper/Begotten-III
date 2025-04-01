--[[
	created by cash wednesday.
--]]


if (game.GetMap() != "rp_damnation") then
	cwZombies.checkDistance = 1550;
	cwZombies.searchDistance = 1500;
	cwZombies.dangerDistance = 1000;
	cwZombies.attackDistance = 500;
else
	cwZombies.checkDistance = 2250;
	cwZombies.searchDistance = 2200;
	cwZombies.dangerDistance = 1600;
	cwZombies.attackDistance = 800;
end;

--cwZombies.battleMusicTime = 0;

cwZombies.glowMaterial = Material("sprites/glow04_noz");

Clockwork.setting:AddCheckBox("Admin ESP", "Show Begotten thrall & animal NPCs.", "cwZombieESP", "Whether or not to show thralls on the admin ESP.", function()
	return Clockwork.player:IsAdmin(Clockwork.Client);
end);

--[[Clockwork.setting:AddCheckBox("Screen Effects", "Enable the battle music.", "cwZombieMusic", "Whether or not to enable battle music.", function()
	return Clockwork.player:IsAdmin(Clockwork.Client);
end);

-- Called to check if the client can hear battle music.
function cwZombies:CanHearBattle()
	local curTime = CurTime();
	
	if (curTime < self.battleMusicTime or Clockwork.ConVars.ZOMBIEMUSIC:GetInt() != 1) then
		return false;
	end;
	
	return true;
end;

netstream.Hook("EndChaser", function(data)
	Clockwork.Client:EmitSound("begotten/npc/chaser_success.mp3");
	
	if (monsterPatch) then
		monsterPatch:Stop();
	end;
end);

netstream.Hook("KilledZombie", function()
	if (!Clockwork.Client.zombiesKilled) then
		Clockwork.Client.zombiesKilled = 0;
	end;
	
	Clockwork.Client.zombiesKilled = Clockwork.Client.zombiesKilled + 1;
end);

netstream.Hook("StopMusic", function(data)
	if (monsterPatch) then
		monsterPatch:Stop();
		monsterPatch = nil;
	end;
	
	if (terrorPatch) then
		terrorPatch:Stop();
		terrorPatch = nil;
	end;
	
	if (whinePatch) then
		whinePatch:Stop();
		whinePatch = nil;
	end;
end);

netstream.Hook("DelayBattleMusic", function(data)
	cwZombies.battleMusicTime = CurTime() + (data or 60);
end);]]--