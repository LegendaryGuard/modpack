#ifndef IMPLEMENTATION

#ifndef MENUQC
MODEL(CHAINSAW_VIEW,                     W_Model("h_chainsaw.iqm"));
MODEL(CHAINSAW_WORLD,                    W_Model("v_chainsaw.md3"));
MODEL(CHAINSAW_ITEM,                     W_Model("g_chainsaw.md3"));

SOUND(CHAINSAW_IDLE, W_Sound("chainsaw_idle"));
SOUND(CHAINSAW_MELEE, W_Sound("chainsaw_melee"));
SOUND(CHAINSAW_SWING, W_Sound("chainsaw_swing"));

SOUND(IMPACT_STONE, "object/impact_stone_2");
SOUND(IMPACT_FLESH, "object/impact_flesh_2");
SOUND(IMPACT_METAL, "object/impact_metal_2");

EFFECT(0, IMPACT_STONE,           "impact_stone")
EFFECT(0, IMPACT_FLESH,           "impact_flesh")
EFFECT(0, IMPACT_METAL,           "impact_metal")
#endif

float autocvar_g_balance_chainsaw_reload_ammo = 0;
float autocvar_g_balance_chainsaw_reload_time = 2;
float autocvar_g_balance_chainsaw_melee_ammo = 1;
float autocvar_g_balance_chainsaw_melee_animtime = 0.15;
float autocvar_g_balance_chainsaw_melee_damage = 20;
float autocvar_g_balance_chainsaw_melee_force = 50;
float autocvar_g_balance_chainsaw_melee_nonplayerdamage = 20;
float autocvar_g_balance_chainsaw_melee_range = 160;
float autocvar_g_balance_chainsaw_melee_refire = 0.2;
float autocvar_g_balance_chainsaw_swing_ammo = 10;
float autocvar_g_balance_chainsaw_swing_animtime = 1.15;
float autocvar_g_balance_chainsaw_swing_damage = 15;
float autocvar_g_balance_chainsaw_swing_force = 75;
float autocvar_g_balance_chainsaw_swing_delay = 0.25;
float autocvar_g_balance_chainsaw_swing_nonplayerdamage = 10;
float autocvar_g_balance_chainsaw_swing_range = 140;
float autocvar_g_balance_chainsaw_swing_side = 120;
float autocvar_g_balance_chainsaw_swing_up = 30;
float autocvar_g_balance_chainsaw_swing_time = 0.3;
float autocvar_g_balance_chainsaw_swing_traces = 10;
float autocvar_g_balance_chainsaw_swing_refire = 1.25;
float autocvar_g_balance_chainsaw_switchdelay_drop = 0.2;
float autocvar_g_balance_chainsaw_switchdelay_raise = 0.2;
string autocvar_g_balance_chainsaw_weaponreplace = "";
float autocvar_g_balance_chainsaw_weaponstart = 0;
float autocvar_g_balance_chainsaw_weaponstartoverride = -1;
float autocvar_g_balance_chainsaw_weaponthrowable = 1;

CLASS(Chainsaw, Weapon)
/* ammotype  */ ATTRIB(Chainsaw, ammo_field, .int, ammo_fuel)
/* impulse   */ ATTRIB(Chainsaw, impulse, int, 5)
/* flags     */ ATTRIB(Chainsaw, spawnflags, int, WEP_FLAG_NORMAL | WEP_FLAG_RELOADABLE | WEP_TYPE_HITSCAN);
/* rating    */ ATTRIB(Chainsaw, bot_pickupbasevalue, float, BOT_PICKUP_RATING_LOW);
/* color     */ ATTRIB(Chainsaw, wpcolor, vector, '0.5 0.45 0.25');
/* modelname */ ATTRIB(Chainsaw, mdl, string, "chainsaw");
#ifndef MENUQC
/* model     */ ATTRIB(Chainsaw, m_model, Model, MDL_CHAINSAW_ITEM);
#endif
/* crosshair */ ATTRIB(Chainsaw, w_crosshair, string, "gfx/crosshairrpc");
/* crosshair */ ATTRIB(Chainsaw, w_crosshair_size, float, 0.75);
/* wepimg    */ ATTRIB(Chainsaw, model2, string, "weaponrpc");
/* refname   */ ATTRIB(Chainsaw, netname, string, "chainsaw");
/* wepname   */ ATTRIB(Chainsaw, m_name, string, _("Chainsaw"));

#define X(BEGIN, P, END, class, prefix) \
	BEGIN(class) \
		P(class, prefix, melee_ammo, float, NONE) \
		P(class, prefix, melee_animtime, float, NONE) \
		P(class, prefix, melee_damage, float, NONE) \
		P(class, prefix, melee_force, float, NONE) \
		P(class, prefix, melee_nonplayerdamage, float, NONE) \
		P(class, prefix, melee_range, float, NONE) \
		P(class, prefix, melee_refire, float, NONE) \
		P(class, prefix, swing_ammo, float, NONE) \
		P(class, prefix, swing_animtime, float, NONE) \
		P(class, prefix, swing_damage, float, NONE) \
		P(class, prefix, swing_force, float, NONE) \
		P(class, prefix, swing_delay, float, NONE) \
		P(class, prefix, swing_nonplayerdamage, float, NONE) \
		P(class, prefix, swing_range, float, NONE) \
		P(class, prefix, swing_side, float, NONE) \
		P(class, prefix, swing_up, float, NONE) \
		P(class, prefix, swing_time, float, NONE) \
		P(class, prefix, swing_traces, float, NONE) \
		P(class, prefix, swing_refire, float, NONE) \
		P(class, prefix, reload_ammo, float, NONE) \
        P(class, prefix, reload_time, float, NONE) \
        P(class, prefix, switchdelay_drop, float, NONE) \
        P(class, prefix, switchdelay_raise, float, NONE) \
        P(class, prefix, weaponreplace, string, NONE) \
        P(class, prefix, weaponstartoverride, float, NONE) \
        P(class, prefix, weaponstart, float, NONE) \
        P(class, prefix, weaponthrowable, float, NONE) \
	END()
    W_MOD_PROPS(X, Chainsaw, chainsaw)
#undef X

ENDCLASS(Chainsaw)
REGISTER_WEAPON(CHAINSAW, chainsaw, NEW(Chainsaw));

MSG_INFO_NOTIF(WEAPON_CHAINSAW_MURDER,      1, 3, 2, "spree_inf s1 s2 s3loc spree_end", "s2 s1",  "weaponrpc",   _("^BG%s%s^K1 was sawn in half by ^BG%s^K1's Chainsaw%s%s"), "")
MSG_INFO_NOTIF(WEAPON_CHAINSAW_SUICIDE,     1, 2, 1, "s1 s2loc spree_lost", "s1",                 "weaponrpc",   _("^BG%s^K1 played with their Chainsaw%s%s"), "")

MSG_MULTI_NOTIF(WEAPON_CHAINSAW_MURDER,      1, NULL,        INFO_WEAPON_CHAINSAW_MURDER,      NULL)
MSG_MULTI_NOTIF(WEAPON_CHAINSAW_SUICIDE,     1, NULL,        INFO_WEAPON_CHAINSAW_SUICIDE,     CENTER_DEATH_SELF_GENERIC)

#endif
#ifdef IMPLEMENTATION
#ifdef SVQC
spawnfunc(weapon_chainsaw) { weapon_defaultspawnfunc(this, WEP_CHAINSAW); }


void W_Chainsaw_Attack1(Weapon thiswep, entity actor, .entity weaponentity, int fire)
{
	weapon_thinkf(actor, weaponentity, WFRAME_FIRE1, WEP_CVAR(chainsaw, melee_animtime), w_ready);

	W_DecreaseAmmo(thiswep, actor, WEP_CVAR(chainsaw, melee_ammo));

	W_SetupShot_Range(actor, true, 0, SND_Null, 0, WEP_CVAR(chainsaw, melee_damage), WEP_CVAR(chainsaw, melee_range));

	vector targpos = (actor.origin + actor.view_ofs
			+ (v_forward * WEP_CVAR(chainsaw, melee_range)));

	WarpZone_traceline_antilag(actor, actor.origin + actor.view_ofs, targpos, false, actor, ANTILAG_LATENCY(actor));

	// draw lightning beams for debugging
	//te_lightning2(NULL, targpos, actor.origin + actor.view_ofs + v_forward * 5 - v_up * 5);
	//te_customflash(targpos, 40,  2, '1 1 1');

	bool is_player = (IS_PLAYER(trace_ent) || trace_ent.classname == "body" || IS_MONSTER(trace_ent));
	float melee_damage;

	if(trace_ent.solid == SOLID_BSP || trace_ent.solid == SOLID_SLIDEBOX)
	{
		if(is_player) // this allows us to be able to nerf the non-player damage done in e.g. assault or onslaught.
			melee_damage = WEP_CVAR(chainsaw, melee_damage);
		else
			melee_damage = WEP_CVAR(chainsaw, melee_nonplayerdamage);
		Damage_DamageInfo(trace_endpos, melee_damage, 0, 0, v_forward * WEP_CVAR(chainsaw, melee_force), WEP_CHAINSAW.m_id, trace_ent.species, actor);
	}

	entity target_victim;
	if((trace_fraction < 1) // if trace is good, apply the damage and remove this
		&& (trace_ent.takedamage == DAMAGE_AIM)
		//&& (trace_ent != this.swing_alreadyhit)
		&& (is_player || WEP_CVAR(chainsaw, melee_nonplayerdamage)))
	{
		target_victim = trace_ent; // so it persists through other calls

		if(is_player) // this allows us to be able to nerf the non-player damage done in e.g. assault or onslaught.
			melee_damage = WEP_CVAR(chainsaw, melee_damage);
		else
			melee_damage = WEP_CVAR(chainsaw, melee_nonplayerdamage);

		//print(strcat(actor.netname, " hitting ", target_victim.netname, " with ", strcat(ftos(melee_damage), " damage (factor: ", ftos(swing_factor), ") at "), ftos(time), " seconds.\n"));

		Damage(target_victim, actor, actor,
			melee_damage, WEP_CHAINSAW.m_id,
			actor.origin + actor.view_ofs,
			v_forward * WEP_CVAR(chainsaw, melee_force));

		if(accuracy_isgooddamage(actor, target_victim)) { accuracy_add(actor, WEP_CHAINSAW.m_id, 0, melee_damage); }
	}
}

.float swing_prev;
.entity swing_alreadyhit;
void W_Chainsaw_Melee_Think(entity this)
{
	// declarations
	float i, f, swing, swing_factor, swing_damage, meleetime, is_player;
	entity target_victim;
	vector targpos;

	if(!this.cnt) // set start time of melee
	{
		this.cnt = time;
		W_PlayStrengthSound(this.realowner);
	}

	makevectors(this.realowner.v_angle); // update values for v_* vectors

	// calculate swing percentage based on time
	meleetime = WEP_CVAR(chainsaw, swing_time) * W_WeaponRateFactor(this.realowner);
	swing = bound(0, (this.cnt + meleetime - time) / meleetime, 10);
	f = ((1 - swing) * WEP_CVAR(chainsaw, swing_traces));

	// check to see if we can still continue, otherwise give up now
	if(IS_DEAD(this.realowner))
	{
		remove(this);
		return;
	}

	// if okay, perform the traces needed for this frame
	for(i=this.swing_prev; i < f; ++i)
	{
		swing_factor = ((1 - (i / WEP_CVAR(chainsaw, swing_traces))) * 2 - 1);

		targpos = (this.realowner.origin + this.realowner.view_ofs
			+ (v_forward * WEP_CVAR(chainsaw, swing_range))
			+ (v_up * swing_factor * WEP_CVAR(chainsaw, swing_up))
			+ (v_right * swing_factor * WEP_CVAR(chainsaw, swing_side)));

		WarpZone_traceline_antilag(this, this.realowner.origin + this.realowner.view_ofs, targpos, false, this.realowner, ANTILAG_LATENCY(this.realowner));

		// draw lightning beams for debugging
		//te_lightning2(NULL, targpos, this.realowner.origin + this.realowner.view_ofs + v_forward * 5 - v_up * 5);
		//te_customflash(targpos, 40,  2, '1 1 1');

		is_player = (IS_PLAYER(trace_ent) || trace_ent.classname == "body" || IS_MONSTER(trace_ent));

		if(trace_ent.solid == SOLID_BSP || trace_ent.solid == SOLID_SLIDEBOX)
		{
			if(is_player) // this allows us to be able to nerf the non-player damage done in e.g. assault or onslaught.
				swing_damage = (WEP_CVAR(chainsaw, swing_damage) * min(1, swing_factor + 1));
			else
				swing_damage = (WEP_CVAR(chainsaw, swing_nonplayerdamage) * min(1, swing_factor + 1));
			Damage_DamageInfo(trace_endpos, swing_damage, 0, 0, v_forward * WEP_CVAR(chainsaw, swing_force), WEP_CHAINSAW.m_id | HITTYPE_SECONDARY, trace_ent.species, this.realowner);
		}

		if((trace_fraction < 1) // if trace is good, apply the damage and remove this
			&& (trace_ent.takedamage == DAMAGE_AIM)
			//&& (trace_ent != this.swing_alreadyhit)
			&& (is_player || WEP_CVAR(chainsaw, swing_nonplayerdamage)))
		{
			target_victim = trace_ent; // so it persists through other calls

			if(is_player) // this allows us to be able to nerf the non-player damage done in e.g. assault or onslaught.
				swing_damage = (WEP_CVAR(chainsaw, swing_damage) * min(1, swing_factor + 1));
			else
				swing_damage = (WEP_CVAR(chainsaw, swing_nonplayerdamage) * min(1, swing_factor + 1));

			//print(strcat(this.realowner.netname, " hitting ", target_victim.netname, " with ", strcat(ftos(swing_damage), " damage (factor: ", ftos(swing_factor), ") at "), ftos(time), " seconds.\n"));

			Damage(target_victim, this.realowner, this.realowner,
				swing_damage, WEP_CHAINSAW.m_id | HITTYPE_SECONDARY,
				this.realowner.origin + this.realowner.view_ofs,
				v_forward * WEP_CVAR(chainsaw, swing_force));

			if(accuracy_isgooddamage(this.realowner, target_victim)) { accuracy_add(this.realowner, WEP_CHAINSAW.m_id, 0, swing_damage); }

			// draw large red flash for debugging
			//te_customflash(targpos, 200, 2, '15 0 0');

			/*if(WEP_CVAR(chainsaw, swing_multihit)) // allow multiple hits with one swing, but not against the same player twice.
			{
				this.swing_alreadyhit = target_victim;
				continue; // move along to next trace
			}
			else
			{
				remove(this);
				return;
			}
			*/
			continue;
		}
	}

	if(time >= this.cnt + meleetime)
	{
		// melee is finished
		remove(this);
		return;
	}
	else
	{
		// set up next frame
		this.swing_prev = i;
		this.nextthink = time;
	}
}

void W_Chainsaw_Attack2(Weapon thiswep, entity actor, .entity weaponentity, int fire)
{
	sound(actor, CH_WEAPON_A, SND_CHAINSAW_SWING, VOL_BASE, ATTEN_NORM);
	weapon_thinkf(actor, weaponentity, WFRAME_FIRE2, WEP_CVAR(chainsaw, swing_animtime), w_ready);

	if(WEP_CVAR(chainsaw, swing_animtime))
		animdecide_setaction(actor, ANIMACTION_MELEE, true);

	W_DecreaseAmmo(thiswep, actor, WEP_CVAR(chainsaw, swing_ammo));

	entity meleetemp = new_pure(meleetemp);
	meleetemp.realowner = actor;
	setthink(meleetemp, W_Chainsaw_Melee_Think);
	meleetemp.nextthink = time + WEP_CVAR(chainsaw, swing_delay) * W_WeaponRateFactor(actor);
	W_SetupShot_Range(actor, true, 0, SND_Null, 0, WEP_CVAR(chainsaw, swing_damage), WEP_CVAR(chainsaw, swing_range));
}

.float chainsaw_ammorot;
.bool chainsaw_held_down;
.float chainsaw_snd_time;

METHOD(Chainsaw, wr_aim, void(entity thiswep, entity actor))
{
    if(vdist(actor.origin - actor.enemy.origin, <=, WEP_CVAR(chainsaw, swing_range)))
        PHYS_INPUT_BUTTON_ATCK2(actor) = bot_aim(actor, 1000000, 0, 0.001, false);
    else
        PHYS_INPUT_BUTTON_ATCK(actor) = bot_aim(actor, 1000000, 0, 0.001, false);
}
METHOD(Chainsaw, wr_think, void(entity thiswep, entity actor, .entity weaponentity, int fire))
{
	if(WEP_CVAR(chainsaw, reload_ammo)) // forced reload // WEAPONTODO
    {
        float ammo_amount = 0;
        if(actor.clip_load >= WEP_CVAR(chainsaw, melee_ammo))
            ammo_amount = 1;
        if(actor.clip_load >= WEP_CVAR(chainsaw, swing_ammo))
            ammo_amount += 1;

        if(!ammo_amount)
        {
            thiswep.wr_reload(thiswep, actor, weaponentity);
            return;
        }
    }

    if(actor.clip_load >= 0)
    if(fire & 1)
    if(weapon_prepareattack(thiswep, actor, weaponentity, false, WEP_CVAR(chainsaw, melee_refire)))
    {
    	W_Chainsaw_Attack1(thiswep, actor, weaponentity, fire);
    	if(!actor.chainsaw_held_down)
    	{
    		actor.chainsaw_snd_time = 0;
    		sound(actor, CH_SHOTS_SINGLE, SND_Null, VOL_BASE, ATTEN_NORM);
    	}
    	actor.chainsaw_held_down = true;
    }

    if(!(fire & 1) && actor.chainsaw_held_down)
    {
    	sound(actor, CH_SHOTS_SINGLE, SND_Null, VOL_BASE, ATTEN_NORM);
    	actor.chainsaw_held_down = false;
    	actor.chainsaw_snd_time = 0;
    }

    if(PS(actor).m_switchweapon != WEP_CHAINSAW)
    {
    	actor.chainsaw_snd_time = 0;
    	sound(actor, CH_SHOTS_SINGLE, SND_Null, VOL_BASE, ATTEN_NORM);
    }
    else if(time >= actor.chainsaw_snd_time)
    {
    	if(actor.chainsaw_held_down)
    	{
    		actor.chainsaw_snd_time = time + 0.691;
    		sound(actor, CH_SHOTS_SINGLE, SND_CHAINSAW_MELEE, VOL_BASE, ATTEN_NORM);
    	}
    	else
    	{
    		actor.chainsaw_snd_time = time + 1.201;
    		sound(actor, CH_SHOTS_SINGLE, SND_CHAINSAW_IDLE, VOL_BASE, ATTEN_NORM);
    	}
    }

    if(actor.clip_load >= 0) // we are not currently reloading
    if(!actor.crouch) // no crouchmelee please
    if(fire & 2)
    if(weapon_prepareattack(thiswep, actor, weaponentity, true, WEP_CVAR(chainsaw, swing_refire)))
    {
        // attempt forcing playback of the anim by switching to another anim (that we never play) here...
        weapon_thinkf(actor, weaponentity, WFRAME_FIRE1, 0, W_Chainsaw_Attack2);
    }

    if(time >= actor.chainsaw_ammorot)
    {
    	actor.chainsaw_ammorot = time + 1;
    	if(actor.(thiswep.ammo_field) > 0 && !(actor.items & IT_UNLIMITED_WEAPON_AMMO))
    		actor.(thiswep.ammo_field) -= 1; // we lose a bit of fuel every second
    }
}
METHOD(Chainsaw, wr_checkammo1, bool(entity thiswep, entity actor))
{
    float ammo_amount = actor.(thiswep.ammo_field) >= WEP_CVAR(chainsaw, melee_ammo);
    ammo_amount += actor.(weapon_load[WEP_CHAINSAW.m_id]) >= WEP_CVAR(chainsaw, melee_ammo);
    return ammo_amount;
}
METHOD(Chainsaw, wr_checkammo2, bool(entity thiswep, entity actor))
{
    if(IS_BOT_CLIENT(actor))
    if(vdist(actor.origin - actor.enemy.origin, >, WEP_CVAR(chainsaw, swing_range)))
        return false; // bots cannot use secondary out of range (fixes constant melee when out of ammo)
    float ammo_amount = actor.(thiswep.ammo_field) >= WEP_CVAR(chainsaw, swing_ammo);
    ammo_amount += actor.(weapon_load[WEP_CHAINSAW.m_id]) >= WEP_CVAR(chainsaw, swing_ammo);
    return ammo_amount;
}
METHOD(Chainsaw, wr_reload, void(entity thiswep, entity actor, .entity weaponentity))
{
    W_Reload(actor, min(WEP_CVAR(chainsaw, melee_ammo), WEP_CVAR(chainsaw, swing_ammo)), SND_RELOAD); // WEAPONTODO
}
METHOD(Chainsaw, wr_suicidemessage, Notification(entity thiswep))
{
    return WEAPON_CHAINSAW_SUICIDE;
}
METHOD(Chainsaw, wr_killmessage, Notification(entity thiswep))
{
    return WEAPON_CHAINSAW_MURDER;
}
METHOD(Chainsaw, wr_drop, void(entity thiswep, entity actor))
{
	sound(actor, CH_SHOTS_SINGLE, SND_Null, VOL_BASE, ATTEN_NORM);
}

#endif
#ifdef CSQC
.float prevric;

METHOD(Chainsaw, wr_impacteffect, void(entity thiswep, entity actor))
{
    vector org2 = w_org + w_backoff * 2;
    if(trace_dphitq3surfaceflags & Q3SURFACEFLAG_METALSTEPS)
    	pointparticles(EFFECT_IMPACT_METAL, org2, w_backoff * 1000, 1);
    else if(trace_networkentity)
    	pointparticles(EFFECT_IMPACT_FLESH, org2, w_backoff * 1000, 1);
    else if(trace_dphitcontents)
    	pointparticles(EFFECT_IMPACT_STONE, org2, w_backoff * 1000, 1);
    if(!w_issilent && time - actor.prevric > 0.25)
    {
    	if(trace_dphitq3surfaceflags & Q3SURFACEFLAG_METALSTEPS)
	    	sound(actor, CH_SHOTS, SND_IMPACT_METAL, VOL_BASE, ATTEN_NORM);
	    else if(trace_networkentity)
	    	sound(actor, CH_SHOTS, SND_IMPACT_FLESH, VOL_BASE, ATTEN_NORM);
	    else if(trace_dphitcontents)
	    	sound(actor, CH_SHOTS, SND_IMPACT_STONE, VOL_BASE, ATTEN_NORM);
        actor.prevric = time;
    }
}

#endif
#endif