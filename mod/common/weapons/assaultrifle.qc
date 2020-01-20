//FEATURE: New weapon: Assault Rifle, a machinegun-like weapon with high accuracy

#include "assaultrifle.qh"

#ifdef CSQC
.entity muzzle_flash;

void W_AssaultRifle_AttachToShotorg(entity wepent, entity flash, vector offset)
{
	flash.owner = wepent;
	flash.angles_z = random() * 360;

	if (gettagindex(wepent, "shot")) setattachment(flash, wepent, "shot");
	else setattachment(flash, wepent, "tag_shot");
	setorigin(flash, offset);
}
#endif

void W_AssaultRifle_MuzzleFlash_Think(entity this)
{
	this.frame += 2;
	this.scale *= 0.5;
	this.alpha -= 0.25;
	this.nextthink = time + 0.05;

	if(this.alpha <= 0)
	{
		setthink(this, SUB_Remove);
		this.nextthink = time;
		this.realowner.muzzle_flash = NULL;
		return;
	}

}

void W_AssaultRifle_MuzzleFlash(entity wepent)
{
	if(wepent.muzzle_flash == NULL)
		wepent.muzzle_flash = spawn();

	// muzzle flash for 1st person view
	setmodel(wepent.muzzle_flash, MDL_ASSAULTRIFLE_MUZZLEFLASH); // precision set below

	wepent.muzzle_flash.scale = 0.75;
	setthink(wepent.muzzle_flash, W_AssaultRifle_MuzzleFlash_Think);
	wepent.muzzle_flash.nextthink = time + 0.02;
	wepent.muzzle_flash.frame = 2;
	wepent.muzzle_flash.alpha = 0.75;
	wepent.muzzle_flash.angles_z = random() * 180;
	wepent.muzzle_flash.effects = EF_ADDITIVE | EF_FULLBRIGHT;
	wepent.muzzle_flash.owner = wepent.muzzle_flash.realowner = wepent;

#ifdef CSQC
	wepent.muzzle_flash.drawmask = MASK_NORMAL;
#endif
}

#ifdef SVQC
void W_AssaultRifle_AttachToShotorg(entity actor, .entity weaponentity, entity flash, vector offset)
{
	flash.owner = actor;
	flash.angles_z = random() * 360;

	entity view = actor.(weaponentity);
	entity exterior = actor.exteriorweaponentity;

	if (view.oldorigin.x > 0)
	{
		setattachment(flash, exterior, "");
		setorigin(flash, view.oldorigin + offset);
	}
	else
	{
		if (gettagindex(exterior, "shot")) setattachment(flash, exterior, "shot");
		else setattachment(flash, exterior, "tag_shot");
		setorigin(flash, offset);
	}
}
#endif

REGISTER_NET_TEMP(assaultrifle_muzzleflash)
#ifdef CSQC
NET_HANDLE(assaultrifle_muzzleflash, bool isnew)
{
	return = true;
	vector a = '5 0 0';
	//a = ReadVectir();
    int slot = ReadByte();
    if(!autocvar_r_drawviewmodel || autocvar_chase_active) return;
	entity wepent = viewmodels[slot];
	W_AssaultRifle_MuzzleFlash(wepent);
	W_AssaultRifle_AttachToShotorg(wepent, wepent.muzzle_flash, a);
}
#endif
#ifdef SVQC
void assaultrifle_muzzleflash_send(entity actor, entity wepent)
{
	if (!IS_REAL_CLIENT(actor)) return;
	int channel = MSG_ONE;
	msg_entity = actor;
	WriteHeader(channel, assaultrifle_muzzleflash);
	//WriteVector(channel, a);
	WriteByte(channel, weaponslot(wepent.weaponentity_fld));
}
#endif

#ifdef SVQC

void W_AssaultRifle_Attack(Weapon thiswep, int deathtype, entity actor, .entity weaponentity)
{
	W_SetupShot(actor, weaponentity, true, 0, SND_ASSAULTRIFLE_FIRE, CH_WEAPON_A, 
								((actor.(weaponentity).misc_bulletcounter == 1) ? WEP_CVAR(assaultrifle, first_damage) : WEP_CVAR(assaultrifle, sustained_damage)), deathtype);
	if(!autocvar_g_norecoil)
	{
		actor.punchangle_x = random() - 0.5;
		actor.punchangle_y = random() - 0.5;
	}
	// this attack_finished just enforces a cooldown at the end of a burst
	ATTACK_FINISHED(actor, weaponentity) = time + WEP_CVAR(assaultrifle, first_refire) * W_WeaponRateFactor(actor);

	if(actor.(weaponentity).misc_bulletcounter == 1)
	{
		fireBullet(actor, weaponentity, w_shotorg, w_shotdir, WEP_CVAR(assaultrifle, first_spread), WEP_CVAR(assaultrifle, solidpenetration), 
															  WEP_CVAR(assaultrifle, first_damage), WEP_CVAR(assaultrifle, first_force), deathtype, EFFECT_BULLET);
	}
	else
	{
		fireBullet(actor, weaponentity, w_shotorg, w_shotdir, WEP_CVAR(assaultrifle, sustained_spread), WEP_CVAR(assaultrifle, solidpenetration), 
															  WEP_CVAR(assaultrifle, sustained_damage), WEP_CVAR(assaultrifle, sustained_force), deathtype, EFFECT_BULLET);
	}

	Send_Effect(EFFECT_MACHINEGUN_MUZZLEFLASH, w_shotorg, w_shotdir * 1000, 1);

	W_AssaultRifle_MuzzleFlash(actor.exteriorweaponentity);
	W_AssaultRifle_AttachToShotorg(actor, weaponentity, actor.exteriorweaponentity.muzzle_flash, '5 0 0');

	FOREACH_CLIENT(it == actor || (IS_SPEC(it) && it.enemy == actor),
	{
		assaultrifle_muzzleflash_send(it, actor.(weaponentity));
	});

	// casing code
	if(autocvar_g_casings >= 2)
	{
		makevectors(actor.v_angle); // for some reason, this is lost
		SpawnCasing(((random() * 50 + 50) * v_right) - (v_forward * (random() * 25 + 25)) - ((random() * 5 - 70) * v_up), 2, vectoangles(v_forward),'0 250 0', 100, 3, actor, weaponentity);
	}

	if(actor.(weaponentity).misc_bulletcounter == 1)
		W_DecreaseAmmo(thiswep, actor, WEP_CVAR(assaultrifle, first_ammo), weaponentity);
	else
		W_DecreaseAmmo(thiswep, actor, WEP_CVAR(assaultrifle, sustained_ammo), weaponentity);
}

// weapon frames
void W_AssaultRifle_Attack_Frame(Weapon thiswep, entity actor, .entity weaponentity, int fire)
{
	if(actor.(weaponentity).m_weapon != actor.(weaponentity).m_switchweapon) // abort immediately if switching
	{
		w_ready(thiswep, actor, weaponentity, fire);
		return;
	}
	if(PHYS_INPUT_BUTTON_ATCK(actor))
	{
		if(!thiswep.wr_checkammo2(thiswep, actor, weaponentity))
		if(!(actor.items & IT_UNLIMITED_AMMO))
		{
			W_SwitchWeapon_Force(actor, w_getbestweapon(actor, weaponentity), weaponentity);
			w_ready(thiswep, actor, weaponentity, fire);
			return;
		}
		actor.(weaponentity).misc_bulletcounter = actor.(weaponentity).misc_bulletcounter + 1;
		W_AssaultRifle_Attack(WEP_ASSAULTRIFLE, WEP_ASSAULTRIFLE.m_id, actor, weaponentity);
		weapon_thinkf(actor, weaponentity, WFRAME_FIRE1, WEP_CVAR(assaultrifle, sustained_refire), W_AssaultRifle_Attack_Frame);
	}
	else
		weapon_thinkf(actor, weaponentity, WFRAME_FIRE1, WEP_CVAR(assaultrifle, sustained_refire), w_ready);
}


void W_AssaultRifle_Attack_Auto(Weapon thiswep, entity actor, .entity weaponentity, int fire)
{
	float assaultrifle_spread;

	if(!(fire & 2))
	{
		w_ready(thiswep, actor, weaponentity, fire);
		return;
	}

	if(!thiswep.wr_checkammo1(thiswep, actor, weaponentity))
	if(!(actor.items & IT_UNLIMITED_AMMO))
	{
		W_SwitchWeapon_Force(actor, w_getbestweapon(actor, weaponentity), weaponentity);
		w_ready(thiswep, actor, weaponentity, fire);
		return;
	}

	W_DecreaseAmmo(WEP_ASSAULTRIFLE, actor, WEP_CVAR(assaultrifle, sustained_ammo), weaponentity);

	W_SetupShot(actor, weaponentity, true, 0, SND_ASSAULTRIFLE_FIRE, CH_WEAPON_A, WEP_CVAR(assaultrifle, sustained_damage), WEP_ASSAULTRIFLE.m_id);
	if(!autocvar_g_norecoil)
	{
		actor.punchangle_x = random() - 0.5;
		actor.punchangle_y = random() - 0.5;
	}

	assaultrifle_spread = bound(WEP_CVAR(assaultrifle, spread_min), 
							    WEP_CVAR(assaultrifle, spread_min) + (WEP_CVAR(assaultrifle, spread_add) * actor.(weaponentity).misc_bulletcounter), 
							    WEP_CVAR(assaultrifle, spread_max));
	fireBullet(actor, weaponentity, w_shotorg, w_shotdir, assaultrifle_spread, WEP_CVAR(assaultrifle, solidpenetration), 
																			   WEP_CVAR(assaultrifle, sustained_damage), WEP_CVAR(assaultrifle, sustained_force), WEP_ASSAULTRIFLE.m_id, EFFECT_BULLET);

	actor.(weaponentity).misc_bulletcounter = actor.(weaponentity).misc_bulletcounter + 1;

	Send_Effect(EFFECT_MACHINEGUN_MUZZLEFLASH, w_shotorg, w_shotdir * 1000, 1);

	W_AssaultRifle_MuzzleFlash(actor.exteriorweaponentity);
	W_AssaultRifle_AttachToShotorg(actor, weaponentity, actor.exteriorweaponentity.muzzle_flash, '5 0 0');

	FOREACH_CLIENT(it == actor || (IS_SPEC(it) && it.enemy == actor),
	{
		assaultrifle_muzzleflash_send(it, actor.(weaponentity));
	});

	if(autocvar_g_casings >= 2) // casing code
	{
		makevectors(actor.v_angle); // for some reason, this is lost
		SpawnCasing(((random() * 50 + 50) * v_right) - (v_forward * (random() * 25 + 25)) - ((random() * 5 - 70) * v_up), 2, vectoangles(v_forward),'0 250 0', 100, 3, actor, weaponentity);
	}

	ATTACK_FINISHED(actor, weaponentity) = time + WEP_CVAR(assaultrifle, first_refire) * W_WeaponRateFactor(actor);
	weapon_thinkf(actor, weaponentity, WFRAME_FIRE1, WEP_CVAR(assaultrifle, sustained_refire), W_AssaultRifle_Attack_Auto);
}

void W_AssaultRifle_Attack_Burst(Weapon thiswep, entity actor, .entity weaponentity, int fire)
{
	W_SetupShot(actor, weaponentity, true, 0, SND_ASSAULTRIFLE_FIRE, CH_WEAPON_A, WEP_CVAR(assaultrifle, sustained_damage), WEP_ASSAULTRIFLE.m_id);
	if(!autocvar_g_norecoil)
	{
		actor.punchangle_x = random() - 0.5;
		actor.punchangle_y = random() - 0.5;
	}

	fireBullet(actor, weaponentity, w_shotorg, w_shotdir, WEP_CVAR(assaultrifle, burst_speed), WEP_CVAR(assaultrifle, solidpenetration), 
														  WEP_CVAR(assaultrifle, burst_damage), WEP_CVAR(assaultrifle, sustained_force), WEP_ASSAULTRIFLE.m_id, EFFECT_BULLET);

	Send_Effect(EFFECT_MACHINEGUN_MUZZLEFLASH, w_shotorg, w_shotdir * 1000, 1);

	W_AssaultRifle_MuzzleFlash(actor.exteriorweaponentity);
	W_AssaultRifle_AttachToShotorg(actor, weaponentity, actor.exteriorweaponentity.muzzle_flash, '5 0 0');

	FOREACH_CLIENT(it == actor || (IS_SPEC(it) && it.enemy == actor),
	{
		assaultrifle_muzzleflash_send(it, actor.(weaponentity));
	});

	if(autocvar_g_casings >= 2) // casing code
	{
		makevectors(actor.v_angle); // for some reason, this is lost
		SpawnCasing(((random() * 50 + 50) * v_right) - (v_forward * (random() * 25 + 25)) - ((random() * 5 - 70) * v_up), 2, vectoangles(v_forward),'0 250 0', 100, 3, actor, weaponentity);
	}

	actor.(weaponentity).misc_bulletcounter = actor.(weaponentity).misc_bulletcounter + 1;
	if(actor.(weaponentity).misc_bulletcounter == 0)
	{
		ATTACK_FINISHED(actor, weaponentity) = time + WEP_CVAR(assaultrifle, burst_refire2) * W_WeaponRateFactor(actor);
		weapon_thinkf(actor, weaponentity, WFRAME_FIRE2, WEP_CVAR(assaultrifle, burst_animtime), w_ready);
	}
	else
	{
		weapon_thinkf(actor, weaponentity, WFRAME_FIRE2, WEP_CVAR(assaultrifle, burst_refire), W_AssaultRifle_Attack_Burst);
	}

}

METHOD(AssaultRifle, wr_aim, void(entity thiswep, entity actor, .entity weaponentity))
{
    if(vdist(actor.origin - actor.enemy.origin, <, 3000 - bound(0, skill, 10) * 200))
        PHYS_INPUT_BUTTON_ATCK(actor) = bot_aim(actor, weaponentity, 1000000, 0, 0.001, false);
    else
        PHYS_INPUT_BUTTON_ATCK2(actor) = bot_aim(actor, weaponentity, 1000000, 0, 0.001, false);
}
METHOD(AssaultRifle, wr_think, void(entity thiswep, entity actor, .entity weaponentity, int fire))
{
    if(WEP_CVAR(assaultrifle, reload_ammo) && actor.(weaponentity).clip_load < min(max(WEP_CVAR(assaultrifle, sustained_ammo), WEP_CVAR(assaultrifle, first_ammo)), WEP_CVAR(assaultrifle, burst_ammo))) { // forced reload
        thiswep.wr_reload(thiswep, actor, weaponentity);
    } else
    if(WEP_CVAR(assaultrifle, mode) == 1)
    {
    	if(fire & 1)
        if(weapon_prepareattack(thiswep, actor, weaponentity, true, 0))
        {
            if(!thiswep.wr_checkammo2(thiswep, actor, weaponentity))
            if(!(actor.items & IT_UNLIMITED_AMMO))
            {
                W_SwitchWeapon_Force(actor, w_getbestweapon(actor, weaponentity), weaponentity);
                w_ready(thiswep, actor, weaponentity, fire);
                return;
            }

            W_DecreaseAmmo(thiswep, actor, WEP_CVAR(assaultrifle, burst_ammo), weaponentity);

            actor.(weaponentity).misc_bulletcounter = WEP_CVAR(assaultrifle, burst) * -1;
            W_AssaultRifle_Attack_Burst(thiswep, actor, weaponentity, fire);
        }

        if(fire & 2)
        if(weapon_prepareattack(thiswep, actor, weaponentity, false, 0))
        {
            actor.(weaponentity).misc_bulletcounter = 0;
            W_AssaultRifle_Attack_Auto(thiswep, actor, weaponentity, fire);
        }
    }
    else
    {
    	if((fire & 1) && WEP_CVAR(assaultrifle, first))
        if(weapon_prepareattack(thiswep, actor, weaponentity, true, 0))
        {
            actor.(weaponentity).misc_bulletcounter = 1;
            W_AssaultRifle_Attack(WEP_ASSAULTRIFLE, WEP_ASSAULTRIFLE.m_id | HITTYPE_SECONDARY, actor, weaponentity); // sets attack_finished
            weapon_thinkf(actor, weaponentity, WFRAME_FIRE2, WEP_CVAR(assaultrifle, first_refire), w_ready);
        }

        if(fire & 2)
        if(weapon_prepareattack(thiswep, actor, weaponentity, false, 0))
        {
            actor.(weaponentity).misc_bulletcounter = 1;
            W_AssaultRifle_Attack(WEP_ASSAULTRIFLE, WEP_ASSAULTRIFLE.m_id, actor, weaponentity); // sets attack_finished
            weapon_thinkf(actor, weaponentity, WFRAME_FIRE1, WEP_CVAR(assaultrifle, sustained_refire), W_AssaultRifle_Attack_Frame);
        }
    }
}
METHOD(AssaultRifle, wr_checkammo1, bool(entity thiswep, entity actor, .entity weaponentity))
{
    float ammo_amount;
    if(WEP_CVAR(assaultrifle, mode) == 1)
        ammo_amount = GetResource(actor, thiswep.ammo_type) >= WEP_CVAR(assaultrifle, burst_ammo);
    else
        ammo_amount = GetResource(actor, thiswep.ammo_type) >= WEP_CVAR(assaultrifle, first_ammo);

    if(WEP_CVAR(assaultrifle, reload_ammo))
    {
        if(WEP_CVAR(assaultrifle, mode) == 1)
            ammo_amount += actor.(weaponentity).(weapon_load[WEP_ASSAULTRIFLE.m_id]) >= WEP_CVAR(assaultrifle, burst_ammo);
        else
            ammo_amount += actor.(weaponentity).(weapon_load[WEP_ASSAULTRIFLE.m_id]) >= WEP_CVAR(assaultrifle, first_ammo);
    }
    return ammo_amount;
}
METHOD(AssaultRifle, wr_checkammo2, bool(entity thiswep, entity actor, .entity weaponentity))
{
    float ammo_amount;
    if(WEP_CVAR(assaultrifle, mode) == 1)
        ammo_amount = GetResource(actor, thiswep.ammo_type) >= WEP_CVAR(assaultrifle, sustained_ammo);
    else
        ammo_amount = GetResource(actor, thiswep.ammo_type) >= WEP_CVAR(assaultrifle, first_ammo);

    if(WEP_CVAR(assaultrifle, reload_ammo))
    {
        if(WEP_CVAR(assaultrifle, mode) == 1)
            ammo_amount += actor.(weaponentity).(weapon_load[WEP_ASSAULTRIFLE.m_id]) >= WEP_CVAR(assaultrifle, sustained_ammo);
        else
            ammo_amount += actor.(weaponentity).(weapon_load[WEP_ASSAULTRIFLE.m_id]) >= WEP_CVAR(assaultrifle, first_ammo);
    }
    return ammo_amount;
}
METHOD(AssaultRifle, wr_reload, void(entity thiswep, entity actor, .entity weaponentity))
{
    W_Reload(actor, weaponentity, min(max(WEP_CVAR(assaultrifle, sustained_ammo), WEP_CVAR(assaultrifle, first_ammo)), WEP_CVAR(assaultrifle, burst_ammo)), SND_RELOAD);
}
METHOD(AssaultRifle, wr_suicidemessage, Notification(entity thiswep))
{
    return WEAPON_THINKING_WITH_PORTALS;
}
METHOD(AssaultRifle, wr_killmessage, Notification(entity thiswep))
{
    if(w_deathtype & HITTYPE_SECONDARY)
        return WEAPON_ASSAULTRIFLE_MURDER_SNIPE;
    else
        return WEAPON_ASSAULTRIFLE_MURDER_SPRAY;
}

#endif
#ifdef CSQC

METHOD(AssaultRifle, wr_impacteffect, void(entity thiswep, entity actor))
{
    vector org2;
    org2 = w_org + w_backoff * 2;
    pointparticles(EFFECT_MACHINEGUN_IMPACT, org2, w_backoff * 1000, 1);
    if(!w_issilent)
        sound(actor, CH_SHOTS, SND_RIC_RANDOM(), VOL_BASE, ATTN_NORM);
}

#endif