--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

PLUGIN:SetGlobalAlias("cwShacks");

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

cwShacks.maxCoowners = 10;

-- Called when the Clockwork shared variables are added.
function cwShacks:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Number("shack");
end;

local coinslotSounds = {"buttons/lever1.wav", "buttons/lever4.wav"};

local COMMAND = Clockwork.command:New("CoinslotPurchase");
	COMMAND.tip = "Purchase property from the Coinslot.";
	COMMAND.text = "<string Shack>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_coinslot") then
				if player:GetFaction() == "Holy Hierarchy" then
					Schema:EasyText(player, "peru", "The Holy Hierarchy cannot purchase property!");
					return false;
				end
				
				if cwShacks then
					cwShacks:ShackPurchased(player, arguments[1]);
					
					entity:EmitSound(coinslotSounds[math.random(#coinslotSounds)]);
					
					timer.Simple(0.5, function()
						if IsValid(entity) then
							entity:EmitSound("ambient/levels/labs/coinslot1.wav");
						end
					end);
					
					return;
				end
			end;
		end;
		
		Schema:EasyText(player, "peru", "You must be looking at the Coinslot to purchase property!");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CoinslotSell");
	COMMAND.tip = "Sell your property to the Coinslot.";
	COMMAND.text = "<string Shack>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_coinslot") then
				if cwShacks then
					cwShacks:ShackSold(player, arguments[1]);
					
					entity:EmitSound(coinslotSounds[math.random(#coinslotSounds)]);
					
					timer.Simple(0.5, function()
						if IsValid(entity) then
							entity:EmitSound("ambient/levels/labs/coinslot1.wav");
						end
					end);
					
					return;
				end
			end;
		end;
		
		Schema:EasyText(player, "peru", "You must be looking at the Coinslot to sell property!");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CoinslotAddCoowner");
	COMMAND.tip = "Add a character as a co-owner to your property for a 100 coin fee.";
	COMMAND.flags = CMD_DEFAULT;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_coinslot") then
				if cwShacks then
					local shack = player:GetOwnedShack();
					
					if shack then
						Clockwork.dermaRequest:RequestString(player, "Add Co-Owner (100 Coin Charge)", "Who would you like to add as a co-owner for this property?", "", function(result)
							local target = Clockwork.player:FindByID(result);
							
							if target and target:Alive() and target ~= player then
								local characterKey = target:GetCharacterKey();
								local faction = target:GetSharedVar("kinisgerOverride") or target:GetFaction();
								local targetShack = target:GetOwnedShack();
								
								if faction == "Holy Hierarchy" or faction == "Goreic Warrior" then
									Schema:EasyText(player, "peru", "You do not have enough coin to add a co-owner!");
								
									return;
								end;
								
								if targetShack then
									Schema:EasyText(player, "peru", target:Name().." is already an owner of another property!");
								
									return;
								end
								
								for k, v in pairs(cwShacks.shacks) do
									if v.coowners then
										for k2, v2 in pairs(v.coowners) do
											if k2 == characterKey then
												Schema:EasyText(player, "peru", target:Name().." is already a co-owner of another property!");
											
												return;
											end;
										end
									end
								end
								
								if Clockwork.player:CanAfford(player, 100) then
									Clockwork.player:GiveCash(player, -100, "Added Co-Owner");
									Schema:ModifyTowerTreasury(100);

									cwShacks:ShackCoownerAdded(target, shack);
									
									Schema:EasyText(player, "olivedrab", "You have added "..target:Name().." as a co-owner to your property.");
									Schema:EasyText(target, "olivedrab", "You have been added as a co-owner to a property ("..shack..") by: "..player:Name()..".");
									
									entity:EmitSound(coinslotSounds[math.random(#coinslotSounds)]);
									
									timer.Simple(0.5, function()
										if IsValid(entity) then
											entity:EmitSound("ambient/levels/labs/coinslot1.wav");
										end
									end);
									
								else
									Schema:EasyText(player, "peru", "You do not have enough coin to add a co-owner!");
								end
							else
								Schema:EasyText(player, "peru", result.." is not a valid character!");
							end
						end);
						
						return;
					else
						Schema:EasyText(player, "peru", "You do not own any property!");
					end
				end
			end;
		end;
		
		Schema:EasyText(player, "peru", "You must be looking at the Coinslot to sell property!");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CoinslotRemoveCoowner");
	COMMAND.tip = "Remove a co-owner from your property.";
	COMMAND.text = "<string Character>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_coinslot") then
				if cwShacks then
					local shack = player:GetOwnedShack();
					
					if shack then
						cwShacks:ShackCoownerRemoved(tonumber(arguments[1]), shack);
						
						Schema:EasyText(player, "olivedrab", "You have removed "..target:Name().." as a co-owner from your property.");
						Schema:EasyText(target, "olivedrab", "You have been removed as a co-owner from a property ("..shack..") by: "..player:Name()..".");
						
						entity:EmitSound(coinslotSounds[math.random(#coinslotSounds)]);
						
						return;
					else
						Schema:EasyText(player, "peru", "You do not own any property!");
					end
				end
			end;
		end;
		
		Schema:EasyText(player, "peru", "You must be looking at the Coinslot to sell property!");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("OpenStash");
	COMMAND.tip = "Open your property's stash. Your stash is not accessible by anyone else except for admins and the inqusition.";
	COMMAND.flags = CMD_DEFAULT;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwShacks:ShackStashOpen(player);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ClearProperty");
	COMMAND.tip = "Clear a property that you are looking at or inside.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local playerPos = player:GetPos();
		local trace = player:GetEyeTrace();
		local entity = trace.Entity;
		local shack;
	
		for k, v in pairs(cwShacks.shacks) do
			if (playerPos:WithinAABox(v.pos1, v.pos2)) or (IsValid(entity) and v.doorEnt == entity) then
				shack = v;
				break;
			end
		end
		
		if shack then
			for k, v in pairs (_player.GetAll()) do
				if v:GetCharacterKey() == shack.owner then
					v:SetSharedVar("shack", nil);
					
					if v:GetFaction() ~= "Holy Hierarchy" then
						Clockwork.player:TakeSpawnWeapon(v, "cw_keys");
					end
				end
			end
			
			shack.owner = nil;
			shack.stash = nil;
			shack.stashCash = nil;
			
			Clockwork.entity:ClearProperty(shack.doorEnt);
			
			cwShacks:NetworkShackData(_player.GetAll());
			cwShacks:SaveShackData();
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have cleared this property.");
		else
			Schema:EasyText(player, "grey", "A valid property could not be found!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("GetPropertyInfo");
	COMMAND.tip = "Get information about a property when looking at the property's front door or while standing inside of it. Will only work for the Holy Hierarchy.";
	COMMAND.flags = CMD_DEFAULT;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwShacks:GetPropertyInfo(player);
	end;
COMMAND:Register();