--[[
	Throwable example
--]]

--[[
	notes for aly
	hope all this shit works. everything relating to throwables is contained in here, as well as the 2 entities.
	some of this is untested, including creating new items which use this one as a base. worst comes to worst you can just create every grenade as a separate item which derives from weapon_base, rather than making a new base.
	I have no reason to believe that it wont work, but I haven't tested it.
	
	There is also not much in terms of sounds and what not, but that shouldn't be hard to do
	function names are really jarbled and not well thought out so change them if you want
--]]

local ITEM = Clockwork.item:New("weapon_base", true);
	ITEM.name = "ThrowableCum Base";
	ITEM.model = "models/items/grenadeammo.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "cw_throwable";
	ITEM.weaponClass = "cw_throwable";
	ITEM.description = "A throwable base.";

	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
	ITEM.attachmentOffsetAngles = Angle(90, 180, 0);
	ITEM.attachmentOffsetVector = Vector(0, 6.55, 8.72);
	ITEM.useSound = "common/null.wav" -- overwrite default sounds
	
	ITEM.fuseless = false; -- disables automatic explosions after a set period of time (waits for physics collide or damage to trigger)
	ITEM:AddData("fuseTime", 5, true); -- time in seconds before the grenade explodes. Cooking a grenade for longer than this length of time will call itemTable:CookExplode.
	
	-- Called from weapon_base:OnEquip, after the weapon has been given to the player.
	function ITEM:OnWeaponEquipped(player, weapon)
		weapon:SetInfo(player, self); -- Pass the player and this item table on to the SWEP to get the variables we need.
	end;

	--[[
		Called when the entity explodes. This is where the actual effects of the explosion should be placed.
		entity: the grenade entity created by the swep which gets thrown.
		player: the player who cooked and threw the grenade
		agitator: the player who triggered the explosion. this may be nil sometimes.
	--]]
	function ITEM:Explode(entity, player, agitator)
		local effectData = EffectData();
			effectData:SetScale(16)
			effectData:SetOrigin(entity:GetPos()); -- set origin to the position of the grenade
		util.Effect("Explosion", effectData, true, true);
	end;
	
	-- Called when the player cooks the grenade for longer than the fuse time. Ideally this would cause an explosion in the players hand, but that must be done in this hook for maximum flexibility.
	function ITEM:CookExplode(weapon, player)
		player:Kill() -- kill the player who cooked the grenade for too long.
	end;
	
	-- Called when the grenade entity takes damage. In this case, player is not the attacker, but just the player who threw the grenade.
	function ITEM:OnTakeDamage(entity, damageInfo, player)
		entity:EmitSound("npc/combine_soldier/die"..math.random(1, 4)..".wav")
		entity:Explode(damageInfo:GetAttacker()) -- trigger the explosion, which then calls itemTable:Explode
		-- the first and only argument for Explode is the agitator, if you wanted that for any reason.
	end;
	
	-- Called when the entity collides with another physical object. In this case, collider is the entity that the grenade collided with. Player is the player who threw the grenade (owner of this item).
	function ITEM:PhysicsCollide(entity, player, collisionData, collider)
	end;
	
	-- Called from the thrown grenade entity's think hook every 0.1 seconds. maybe for gas grenades or effects from grenades with longer fuses. Player is the player who threw the grenade (owner of this item).
	function ITEM:GrenadeEntityThink(entity, player)
	end;
	
	-- Called just after the grenade entity gets this itemtable's information passed to it from the swep that created it. Player is the player who threw the grenade (owner of this item). This is basically called right after the entity is created when ItemTable is first made available.
	function ITEM:GrenadeInitalized(entity, player) 
	end;
	
	-- Called just after the grenade weapon gets this itemtable's information passed to it from OnWeaponEquipped. Player is the player who equipped the grenade (owner of this item). This is basically called right after the entity is created when ItemTable is first made available.
	function ITEM:GrenadeWeaponInitalized(entity, player) 
	end; -- This is where you would ideally set up WElements and VElements
	
	-- Called when a player uses the thrown grenade entity. 
	function ITEM:PlayerUsedGrenade(entity, caller)
	end;
	
	-- Called from the OnRemove hook of the thrown grenade entity. Player is the player who threw the grenade (owner of this item).
	function ITEM:GrenadeEntityRemoved(entity, player)
	end;
	
	-- Called every server think from the sweps think hook. Player is the holder of the grenade.
	function ITEM:GrenadeWeaponThink(weapon, player)
	end;
	
	-- Called when the player deploys the grenade swep.
	function ITEM:OnGrenadeDeploy(weapon, player)
	end;
	
	-- Called when the player holsters the grenade swep.
	function ITEM:OnGrenadeHolster(weapon, player)
	end;
	
	-- Called just after the player presses mouse1 with the grenade in their hands.
	function ITEM:OnPinPull(weapon, player)
	end;
	
	--[[
		For creating the world model and view model out of props. Here is what the two tables look like.
		Don't change "v_grenade" or "w_grenade", doing so will just create new props rather than merge with the ones that exist within the swep already.

		local vElements = {["v_grenade"] = {type = "Model", model = "models/Items/grenadeAmmo.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 0.4, 0), angle = Angle(-8.183, 104.026, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 2, bodygroup = {}}}
		local wElements = {["w_grenade"] = {type = "Model", model = "models/Items/grenadeAmmo.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 3, -2), angle = Angle(-135, 45, 1.169), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 2, bodygroup = {}}}
		
		You can overwrite the swep's VElements and WElements by using this function 
		SWEP:MergeElementsTable(vElements, wElements)
		
		If all is right in the world, the tables will merge and you will see whatever model you set. You may want to switch out the model strings with self("model") or something like that, and turn the angle and pos keys into item variables.
	--]]
ITEM:Register();