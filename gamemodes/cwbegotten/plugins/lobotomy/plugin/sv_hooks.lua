function cwLobotomy:KeyPress(player, key)
	if (key == IN_ATTACK) then
		local action = Clockwork.player:GetAction(player);
		
		if (action == "lobotomy") then
			Clockwork.player:SetAction(player, nil);
		end

	end

end

util.AddNetworkString("cwLobotomyEffect");

function cwLobotomy:PlayerThink(player, curTime)
    if(player.nextLobotomyCheck and player.nextLobotomyCheck > curTime) then return; end
    
    player.nextLobotomyCheck = curTime + math.random(cwLobotomy.minimumLobotomyDelay, cwLobotomy.maximumLobotomyDelay);

    if(!player:HasTrait("lobotomite")) then return; end

    cwLobotomy:LobotomyEffect(player, curTime);

end

local voltistSounds = {
	["death"] = {"npc/fast_zombie/wake1.wav", "npc/fast_zombie/leap1.wav", "npc/fast_zombie/fz_alert_close1.wav", "npc/fast_zombie/fz_frenzy1.wav", "npc/headcrab/attack2.wav", "npc/headcrab/attack3.wav", "npc/headcrab_poison/ph_rattle3.wav", "npc/headcrab_poison/ph_poisonbite3.wav"},
	["pain"] = {"npc/headcrab/die2.wav", "npc/headcrab_poison/ph_warning1.wav", "npc/headcrab_poison/ph_scream2.wav", "npc/antlion/pain1.wav", "npc/antlion/pain2.wav", "npc/assassin/ball_zap1.wav", "npc/barnacle/barnacle_die1.wav", "npc/scanner/cbot_discharge1.wav", "npc/scanner/cbot_energyexplosion1.wav"},
};

function cwLobotomy:PlayScream(player)
    local gender = player:GetGender() == GENDER_MALE and "his" or "her";
    local faction = (player:GetNetVar("kinisgerOverride") or player:GetFaction());
	local subfaction = (player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction());
	local pitch = 100;

    if IsValid(player.possessor) then
		pitch = 50;
	elseif gender == "his" then
		pitch = math.random(95, 110);
	else
		pitch = math.random(100, 115);
	end

    if (!Clockwork.player:HasFlags(player, "M")) then
		if player:GetSubfaith() == "Voltism" and cwBeliefs and (player:HasBelief("the_storm") or player:HasBelief("the_paradox_riddle_equation")) then
			player:EmitSound(voltistSounds["pain"][math.random(1, #voltistSounds["pain"])], 90, 150);
		else
			if player:GetModel() == "models/begotten/satanists/darklanderimmortal.mdl" then
				player:EmitSound("piggysqueals/death/"..math.random(1, 3)..".ogg", 90, pitch)
			elseif (faction == "Gatekeeper" or faction == "Pope Adyssa's Gatekeepers") then
				if (gender == "his") then
					player:EmitSound("voice/man2/man2_stun0"..math.random(1, 4)..".wav", 90, pitch)
				else
					player:EmitSound("voice/female1/female1_stun0"..math.random(1, 4)..".wav", 90, pitch)
				end
			elseif (faction == "Holy Hierarchy") then
				if (gender == "his") then
					if subfaction == "Low Ministry" then
						player:EmitSound("lmpainsounds/lm_stun" .. math.random(1, 4) .. ".mp3", 90, pitch)
					else
						player:EmitSound("voice/man4/man4_stun0"..math.random(1, 4)..".wav", 90, pitch)
					end
				else
					player:EmitSound("voice/female1/female1_stun0"..math.random(1, 4)..".wav", 90, pitch)
				end
			elseif (faction == "The Third Inquisition") then
				if (gender == "his") then
					player:EmitSound("voice/man4/man4_stun0"..math.random(1, 4)..".wav", 90, pitch)
				else
					player:EmitSound("voice/female1/female1_stun0"..math.random(1, 4)..".wav", 90, pitch)
				end
			elseif (faction == "Goreic Warrior") then
				if (gender == "his") then
					player:EmitSound("voice/man1/man1_stun0"..math.random(1, 4)..".wav", 90, pitch)
				else
					player:EmitSound("voice/female2/female2_stun0"..math.random(1, 4)..".wav", 90, pitch)
				end
			elseif (faction == "Hillkeeper") then
				if (gender == "his") then
					player:EmitSound("hkpainsounds/hk_stun"..math.random(1, 4)..".mp3", 90, pitch)
				else
					player:EmitSound("voice/female2/female2_stun0"..math.random(1, 4)..".wav", 90, pitch)
				end
			elseif (faction == "Smog City Pirate") then
				if (gender == "his") then
					player:EmitSound("voice/man1/man1_stun0"..math.random(1, 4)..".wav", 90, pitch)
				else
					player:EmitSound("voice/female2/female2_stun0"..math.random(1, 4)..".wav", 90, pitch)
				end
			else
				if (gender == "his") then
					player:EmitSound("voice/man3/man3_stun0"..math.random(1, 4)..".wav", 90, pitch)
				else
					player:EmitSound("voice/female2/female2_stun0"..math.random(1, 4)..".wav", 90, pitch)
				end
			end
		end
	end

end

function cwLobotomy:LobotomyEffect(player, curTime)
    if(player:IsRagdolled() or !player:Alive() or player.cwObserverMode) then return; end

    player:SetAnimSequence("Bg3Lobotomy"..tostring(math.random(1, 2)));
    cwLobotomy:PlayScream(player);

    net.Start("cwLobotomyEffect");
    net.Send(player);

end