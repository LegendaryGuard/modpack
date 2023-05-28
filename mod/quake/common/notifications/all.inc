// ====================================
//  Notifications List and Information
// ====================================
/*
 List of all notifications (including identifiers and display information)
 Possible Tokens:
    default, name, strnum, flnum,
    channel, sound, volume, position,
    args, hudargs, icon, cpid, durcnt, normal, gentle,
    anncename, infoname, centername,
    challow, chtype, optiona, optionb
 Format Specifications:
    name: VAR: Name of notification
    MSG_INFO:
      default: FLOAT: Default setting for whether the notification is enabled or not
         ^-> 0 = disabled, 1 = enabled, 2 = also print to chat box
      strnum: FLOAT: Number of STRING arguments (so that networking knows how many to send/receive)
      flnum: FLOAT: Number of FLOAT arguments (so that networking knows how many to send/receive)
      args: STRING: Arguments for Local_Notification_sprintf()
      hudargs: STRING: Arguments for Local_Notification_HUD_Notify_Push()
      icon: STRING: icon string name for the hud notify panel, "" if no icon is used
      normal: STRING: Normal message (string for sprintf when gentle messages are NOT enabled)
      gentle: STRING: Gentle message (string for sprintf when gentle messages ARE enabled)
    MSG_CENTER:
      default: FLOAT: Default setting for whether the notification is enabled or not
         ^-> 0 = disabled, 1 = enabled
      strnum: FLOAT: Number of STRING arguments (so that networking knows how many to send/receive)
      flnum: FLOAT: Number of FLOAT arguments (so that networking knows how many to send/receive)
      args: STRING: Arguments for Local_Notification_sprintf()
      cpid: FLOAT: centerprint ID number (CPID_*), CPID_Null if no CPID is needed
      durcnt: XPD(FLOAT, FLOAT): Duration/Countdown: extra arguments for centerprint messages
      normal: STRING: Normal message (string for sprintf when gentle messages are NOT enabled)
      gentle: STRING: Gentle message (string for sprintf when gentle messages ARE enabled)
    MSG_MULTI:
      default: FLOAT: Default setting for whether the notification is enabled or not
         ^-> 0 = disabled, 1 = enabled
      anncename: VAR: Name of announcer notification for reference
      infoname: VAR: Name of info notification for reference
      centername: VAR: Name of centerprint notification for reference
    MSG_CHOICE:
      default: FLOAT: Default setting for whether the notification is enabled or not
         ^-> 0 = disabled, 1 = select option A, 2 = selection option B
      challow: FLOAT: Default setting for server allowing choices other than A
         ^-> 0 = no choice, 1 = allowed in warmup, 2 = always allowed
      chtype: VAR: Notification message type for options
      optiona: VAR: Name of choice "A" notification for reference
      optionb: VAR: Name of choice "B" notification for reference

 Messages with ^F1, ^BG, ^TC, etc etc in them will replace those strings
 with colors according to the cvars the user has chosen. This allows for
 users to create unique color profiles for their HUD, giving more customization
 options to HUD designers and end users who want such a feature.

 Check out the definitions in util.qc/util.qh/teams.qh for string CCR(...) and
 string TCR(...) to better understand how these code replacements work.

 Additionally, you can find all the definitions and explanations for
 the argument values and what they return down below in this file.

 Guidlines for notification declaration (please try and follow these):
  Specific rules:
    - ALWAYS start the string with a color, preferably background.
    - ALWAYS reset a color after a name (this way they don't set it for the whole string).
    - NEVER add or remove tokens from the format, it SHOULD already work.
    - MSG_INFO hudargs must always be ATTACKER -> VICTIM
    - MSG_INFO and MSG_CENTER should NOT end with a new line

 General rules:
    - Be clean and simple with your notification naming,
     nothing too long for the name field... Abbreviations are your friend. :D
    - Keep the spacing as clean as possible... if the arguments are abnormally long,
      it's okay to go out of line a bit... but try and keep it clean still.
    - Use ONLY spaces for spacing in the notification list, tabs are too inconsistent
      with keeping alignment on different mediums.
    - Sort the notifications in the most appropriate order for their tasks.

 Final note: DO NOT PROVIDE MORE ARGUMENTS THAN NECESSARY FOR THE NOTIFICATION YOU'RE CALLING!
      The system is designed to save as much networking bandwidth as possible,
      so please dynamically control your argument sending to fit *exactly* what is required.
      If you send a notification with mismatching arguments, Send_Notification() will error.
*/

// NOTE: leaving BOLD_OPERATOR outside of translatable messages has 2 advantages:
// 1. translators don't have to deal with it
// 2. messages can be changed to bold / normal without the need to translate them again
#define BOLD(translatable_msg) strcat(BOLD_OPERATOR, translatable_msg)

// default value for info notification cvars (notification_INFO_*):
// 0: off, 1: display in console, 2: display in chatbox and console
#define N_DISABLE 0
#define N_CONSOLE 1
#define N_CHATCON 2

// MSG_INFO_NOTIFICATIONS

    MSG_INFO_NOTIF(CONNECTING,                              N_CONSOLE,  1, 0, "s1", "",        "",                     _("^BG%s^BG is connecting..."), "")
    MSG_INFO_NOTIF(JOIN_CONNECT,                            N_CHATCON,  1, 0, "s1", "",        "",                     _("^BG%s^F3 entered the game"), "")

    MSG_INFO_NOTIF(DEATH_MURDER_CRUSH,                      N_CONSOLE,  2, 0, "s1 s2", "",     "",                     _("^BG%s^K1 was pushed under something heavy by ^BG%s"), "")
    MSG_INFO_NOTIF(DEATH_MURDER_DISCHARGE,                  N_CONSOLE,  2, 0, "s1 s2", "",     "",                     _("^BG%s^K1 had a taste of ^BG%s^K1's discharge"), "")
    MSG_INFO_NOTIF(DEATH_MURDER_DROWN,                      N_CONSOLE,  2, 0, "s1 s2", "",     "",                     _("^BG%s^K1 was drowned by ^BG%s"), "")
    MSG_INFO_NOTIF(DEATH_MURDER_FALL,                       N_CONSOLE,  2, 0, "s1 s2", "",     "",                     _("^BG%s^K1 was grounded by ^BG%s"), "")
    MSG_INFO_NOTIF(DEATH_MURDER_FIRE,                       N_CONSOLE,  2, 0, "s1 s2", "",     "",                     _("^BG%s^K1 was burnt up into a crisp by ^BG%s"), _("^BG%s^K1 felt a little hot from ^BG%s^K1's fire"))
    MSG_INFO_NOTIF(DEATH_MURDER_LAVA,                       N_CONSOLE,  2, 0, "s1 s2", "",     "",                     _("^BG%s^K1 was cooked by ^BG%s"), "")
    MSG_INFO_NOTIF(DEATH_MURDER_MONSTER,                    N_CONSOLE,  2, 0, "s1 s2", "",     "",                     _("^BG%s^K1 was killed by a monster with help from ^BG%s"), "")
    MSG_INFO_NOTIF(DEATH_MURDER_SLIME,                      N_CONSOLE,  2, 0, "s1 s2", "",     "",                     _("^BG%s^K1 was slimed by ^BG%s"), "")
    MSG_INFO_NOTIF(DEATH_MURDER_SPHERE,                     N_CONSOLE,  2, 0, "s1 s2", "",     "",                     _("^BG%s^K1 was blasted by ^BG%s^K1's Spike Mine"), "")
    MSG_INFO_NOTIF(DEATH_MURDER_SHIELD,                     N_CONSOLE,  2, 0, "s1 s2", "",     "",                     _("^BG%s^K1 smashed against ^BG%s^K1's Power Shield"), "")
    MSG_INFO_NOTIF(DEATH_MURDER_TELEFRAG,                   N_CONSOLE,  2, 0, "s1 s2", "",     "",                     _("^BG%s^K1 was telefragged by ^BG%s^K1%s%s"), _("^BG%s^K1 tried to occupy ^BG%s^K1's teleport destination space"))
    MSG_INFO_NOTIF(DEATH_MURDER_TRAP,                       N_CONSOLE,  2, 0, "s1 s2", "",     "",                     _("^BG%s^K1 was trapped by ^BG%s"), "")
    MSG_INFO_NOTIF(DEATH_MURDER_VOID,                       N_CONSOLE,  2, 0, "s1 s2", "",     "",                     _("^BG%s^K1 was thrown into a world of hurt by ^BG%s"), "")

    MSG_INFO_NOTIF(DEATH_SELF_BETRAYAL,                     N_CONSOLE,  2, 0, "s1 s2", "",        "",                     _("^BG%s%s^K1 helps the other team"), "")
    MSG_INFO_NOTIF(DEATH_SELF_CRUSH,                        N_CONSOLE,  2, 0, "s1 s2", "",        "",                     _("^BG%s%s^K1 was squashed"), "")
    MSG_INFO_NOTIF(DEATH_SELF_DISCHARGE,                    N_CONSOLE,  2, 0, "s1 s2", "",        "",                     _("^BG%s%s^K1 discharged into the liquid"), "")
    MSG_INFO_NOTIF(DEATH_SELF_DROWN,                        N_CONSOLE,  2, 0, "s1 s2", "",        "",                     _("^BG%s%s^K1 sleeps with the rotfishes"), "")
    MSG_INFO_NOTIF(DEATH_SELF_FALL,                         N_CONSOLE,  2, 0, "s1 s2", "",        "",                     _("^BG%s%s^K1 fell to their death"), _("^BG%s%s^K1 learned about Newton's laws of gravity"))
    MSG_INFO_NOTIF(DEATH_SELF_FIRE,                         N_CONSOLE,  2, 0, "s1 s2", "",        "",                     _("^BG%s%s^K1 burst into flames"), _("^BG%s%s^K1 felt a little hot"))
    MSG_INFO_NOTIF(DEATH_SELF_GENERIC,                      N_CONSOLE,  2, 0, "s1 s2", "",        "",                     _("^BG%s%s^K1 died"), "")
    MSG_INFO_NOTIF(DEATH_SELF_LAVA,                         N_CONSOLE,  2, 0, "s1 s2", "",        "",                     _("^BG%s%s^K1 turned into hot slag"), "")
    MSG_INFO_NOTIF(DEATH_SELF_NOEXIT,                       N_CONSOLE,  2, 0, "s1 s2", "",        "",                     _("^BG%s%s^K1 tried to leave"), "")
    MSG_INFO_NOTIF(DEATH_SELF_PULSERIFLE,                   N_CONSOLE,  2, 0, "s1 s2", "",        "",                     _("^BG%s%s^K1 pointed their Armor Laser System in the wrong direction"), "")
    MSG_INFO_NOTIF(DEATH_SELF_ROT,                          N_CONSOLE,  2, 0, "s1 s2", "",        "",                     _("^BG%s%s^K1 lost too much blood"), "")
    MSG_INFO_NOTIF(DEATH_SELF_SLIME,                        N_CONSOLE,  2, 0, "s1 s2", "",        "",                     _("^BG%s%s^K1 was slimed"), "")
    MSG_INFO_NOTIF(DEATH_SELF_SPHERE,                       N_CONSOLE,  2, 0, "s1 s2", "",        "",                     _("^BG%s%s^K1 was blasted by a Spike Mine"), "")
    MSG_INFO_NOTIF(DEATH_SELF_SUICIDE,                      N_CONSOLE,  2, 0, "s1 s2", "",        "",                     _("^BG%s%s^K1 suicides"), "")
    MSG_INFO_NOTIF(DEATH_SELF_TRAP,                         N_CONSOLE,  2, 0, "s1 s2", "",        "",                     _("^BG%s%s^K1 fell prey to a trap"), "")
    MSG_INFO_NOTIF(DEATH_SELF_VOID,                         N_CONSOLE,  2, 0, "s1 s2", "",        "",                       "^BG%s^K1 %s", "")
    MSG_INFO_NOTIF(DEATH_SELF_WRATH,                        N_CONSOLE,  2, 0, "s1 s2", "",        "",                     _("^BG%s%s^K1 angered a powerful being"), "")

    MSG_INFO_NOTIF(ITEM_AMMO_PICKUP,                        N_DISABLE,  0, 0, "", "",                           "",              _("^BGYou picked up some ammo"), "")
    MSG_INFO_NOTIF(ITEM_BACKPACK_GOT,                       N_DISABLE,  1, 0, "s1", "",                                  "",     _("^BGYou get %s"), "")
    MSG_INFO_NOTIF(ITEM_BACKPACK_GOT_WEAPON,                N_DISABLE,  2, 0, "s1 s2", "",                               "",     _("^BGYou get the ^F1%s^BG and %s"), "")
    MSG_INFO_NOTIF(ITEM_KEY_GOT,                            N_CONSOLE,  2, 0, "s1 s2", "",                               "",     _("^BG%s^BG picked up %s"), "")
    MSG_INFO_NOTIF(ITEM_KEY_GOT_SELF,                       N_CONSOLE,  1, 0, "s1", "",                                  "",     _("^BGYou picked up %s"), "")
    MSG_INFO_NOTIF(ITEM_POWERUP_GOT,                        N_DISABLE,  1, 0, "s1", "",                                  "",     _("^BGYou got the ^F1%s"), "")
    MSG_INFO_NOTIF(ITEM_WEAPON_GOT,                         N_DISABLE,  1, 0, "s1", "",                                  "",     _("^BGYou got the ^F1%s"), "")
    MSG_INFO_NOTIF(ITEM_WEAPON_STOLE,                       N_DISABLE,  1, 0, "s1", "",                                  "",     _("^BGGremlin stole your ^F1%s"), "")
    MSG_INFO_NOTIF(ITEM_WEAPON_PICKUP,                      N_DISABLE,  0, 0, "", "",                                    "",     _("^BGYou picked up a weapon"), "")

    MSG_INFO_NOTIF(POWERDOWN_ANTIGRAV,                      N_DISABLE,  0, 0, "", "",                                    "",     _("^K2Antigrav failing..."), "")
    MSG_INFO_NOTIF(POWERDOWN_BIOSUIT,                       N_DISABLE,  0, 0, "", "",                                    "",     _("^K2Air supply in Biosuit expiring"), "")
    MSG_INFO_NOTIF(POWERDOWN_EMPATHY,                       N_DISABLE,  0, 0, "", "",                                    "",     _("^K2Empathy Shields are running out"), "")
    MSG_INFO_NOTIF(POWERDOWN_FIREFLOWER,                    N_DISABLE,  0, 0, "", "",                                    "",     _("^K2Fire Flower is fading..."), "")
    MSG_INFO_NOTIF(POWERDOWN_INVISIBLE,                     N_DISABLE,  0, 0, "", "",                                    "",     _("^K2Ring of Shadows magic is fading"), "")
    MSG_INFO_NOTIF(POWERDOWN_PROTECTION,                    N_DISABLE,  0, 0, "", "",                                    "",     _("^K2Protection is almost burned out"), "")
    MSG_INFO_NOTIF(POWERDOWN_SHIELD,                        N_DISABLE,  0, 0, "", "",                                    "",     _("^K2Shield failing..."), "")
    MSG_INFO_NOTIF(POWERDOWN_QUAD_DAMAGE,                   N_DISABLE,  0, 0, "", "",                                    "",     _("^K2Quad Damage is wearing off"), "")
    MSG_INFO_NOTIF(POWERDOWN_WETSUIT,                       N_DISABLE,  0, 0, "", "",                                    "",     _("^K2Air supply in Wetsuit is running out"), "")

    MSG_INFO_NOTIF(QUIT_DISCONNECT,                         N_CHATCON,  1, 1, "s1 f1", "",      "",             _("^BG%s^F3 left the game with %s frag(s)"), "")

    MSG_INFO_NOTIF(WEAPON_THINKING_WITH_PORTALS,            N_CONSOLE,  2, 0, "s1 s2", "",                      "",          _("^BG%s%s^K1 is now thinking with portals"), "")

#undef N_DISABLE
#undef N_CONSOLE
#undef N_CHATCON

// default value for centerprint notification cvars (notification_CENTER_*):
// 0: off, 1: centerprint
#define N_DISABL 0
#define N_ENABLE 1

// MSG_CENTER_NOTIFICATIONS
    //MSG_CENTER_NOTIF(ALONE,                             N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  _("^F4You are now alone!"), "")

    MSG_CENTER_NOTIF(COUNTDOWN_BEGIN,                   N_ENABLE,    0, 0, "",               CPID_ROUND,             "2 0",  BOLD(_("^BGFight!")), "")
    MSG_CENTER_NOTIF(COUNTDOWN_BEGIN_BOSSWAVE,          N_ENABLE,    0, 0, "",               CPID_ROUND,             "2 0",  BOLD(_("^K1Boss wave!")), "")
    MSG_CENTER_NOTIF(COUNTDOWN_ROUNDSTART,              N_ENABLE,    0, 2, "f1",             CPID_ROUND,             "1 f2", strcat(_("^BGRound %s starts in"), "\n", BOLD("^COUNT")), "")

    MSG_CENTER_NOTIF(DEATH_MURDER_FRAG,                 N_ENABLE,  1, 0, "s1",             CPID_Null,              "0 0",  BOLD(_("^K3You killed ^BG%s")), "")
    MSG_CENTER_NOTIF(DEATH_MURDER_FRAGGED,              N_ENABLE,  1, 0, "s1",             CPID_Null,              "0 0",  BOLD(_("^K1You were killed by ^BG%s^K1!")), "")
    MSG_CENTER_NOTIF(DEATH_MURDER_FRAG_EMPATHY,         N_ENABLE,  1, 0, "s1",             CPID_Null,              "0 0",  BOLD(_("^K3You shared your pain with ^BG%s")), "")
    MSG_CENTER_NOTIF(DEATH_MURDER_FRAGGED_EMPATHY,      N_ENABLE,  1, 0, "s1",             CPID_Null,              "0 0",  BOLD(_("^K1You feel ^BG%s^K1's pain!")), "")

    MSG_CENTER_NOTIF(DEATH_SELF_BETRAYAL,               N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1You were punished for attacking your team mates!")), "")
    MSG_CENTER_NOTIF(DEATH_SELF_CRUSH,                  N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1You were crushed!")), "")
    MSG_CENTER_NOTIF(DEATH_SELF_CHEAT,                  N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1You unfairly eliminated yourself!")), "")
    MSG_CENTER_NOTIF(DEATH_SELF_DROWN,                  N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1You couldn't catch your breath!")), "")
    MSG_CENTER_NOTIF(DEATH_SELF_DISCHARGE,              N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1You submerged your electrical weapon!")), "")
    MSG_CENTER_NOTIF(DEATH_SELF_FALL,                   N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1You hit the ground with a crunch!")), "")
    MSG_CENTER_NOTIF(DEATH_SELF_FIRE,                   N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1You got a little bit too crispy!")), BOLD(_("^K1You felt a little too hot!")))
    MSG_CENTER_NOTIF(DEATH_SELF_GENERIC,                N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1You fragged yourself!")), BOLD(_("^K1You need to be more careful!")))
    MSG_CENTER_NOTIF(DEATH_SELF_LAVA,                   N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1You couldn't stand the heat!")), "")
    MSG_CENTER_NOTIF(DEATH_SELF_MONSTER,                N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1You were killed by a monster!")), BOLD(_("^K1You need to watch out for monsters!")))
    MSG_CENTER_NOTIF(DEATH_SELF_NOEXIT,                 N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1There is no escape")), "")
    MSG_CENTER_NOTIF(DEATH_SELF_PULSERIFLE,             N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1Watch where you aim that thing!")), "")
    MSG_CENTER_NOTIF(DEATH_SELF_ROT,                    N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1You lost too much blood")), BOLD(_("^K1You need to preserve your health")))
    MSG_CENTER_NOTIF(DEATH_SELF_SHOOTING_STAR,          N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1You became a shooting star!")), "")
    MSG_CENTER_NOTIF(DEATH_SELF_SLIME,                  N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1You melted away in slime!")), "")
    MSG_CENTER_NOTIF(DEATH_SELF_SPHERE,                 N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1You were blasted by a Spike Mine!")), "")
    MSG_CENTER_NOTIF(DEATH_SELF_SUICIDE,                N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1You committed suicide!")), BOLD(_("^K1You ended it all!")))
    MSG_CENTER_NOTIF(DEATH_SELF_TRAP,                   N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^BGYou stepped on a trap!")), "")
    MSG_CENTER_NOTIF(DEATH_SELF_VOID,                   N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1Watch your step!")), "")
    MSG_CENTER_NOTIF(DEATH_SELF_WRATH,                  N_ENABLE,    0, 0, "",               CPID_Null,              "0 0",  BOLD(_("^K1You angered the Gods!")), "")

    MSG_CENTER_NOTIF(ITEM_BACKPACK_GOT,                 N_ENABLE,    1, 0, "s1",                       CPID_ITEM, "2 0", _("^BGYou get %s"), "")
    MSG_CENTER_NOTIF(ITEM_BACKPACK_GOT_WEAPON,          N_ENABLE,    2, 0, "s1 s2",                    CPID_ITEM, "2 0", _("^BGYou get the ^F1%s^BG and %s"), "")
    MSG_CENTER_NOTIF(ITEM_KEY_GOT,                      N_DISABL,    2, 0, "s1 s2",                    CPID_KEY,  "1.5 0", _("^BG%s^BG got the %s"), "")
    MSG_CENTER_NOTIF(ITEM_KEY_GOT_SELF,                 N_ENABLE,    1, 0, "s1",                       CPID_KEY,  "1.5 0", _("^BGYou got the %s"), "")
    MSG_CENTER_NOTIF(ITEM_POWERUP_GOT,                  N_ENABLE,    1, 0, "s1",                       CPID_POWER,"1.5 0", _("^BGYou got the ^F1%s"), "")
    MSG_CENTER_NOTIF(ITEM_WEAPON_GOT,                   N_ENABLE,    1, 0, "s1",                       CPID_ITEM, "1.5 0", _("^BGYou got the ^F1%s"), "")
    MSG_CENTER_NOTIF(ITEM_WEAPON_STOLE,                 N_ENABLE,    1, 0, "s1",                       CPID_ITEM, "1.5 0", _("^BGGremlin stole your ^F1%s"), "")

    MSG_CENTER_NOTIF(NO_AMMO,                           N_ENABLE,     0, 0, "",                         CPID_AMMO, "0 0", _("^BGOut of ammo"), "")
    MSG_CENTER_NOTIF(NO_WEAPON,                         N_ENABLE,     0, 0, "",                         CPID_AMMO, "0 0", _("^BGNo weapon"), "")

    MSG_CENTER_NOTIF(SHOP_OPEN,                         N_ENABLE,     0, 0, "",                         CPID_SHOP, "5.5 0", _("^BGShop is open, speak to the ^F1Gremlin^BG!"), "")

    MSG_CENTER_NOTIF(POWERDOWN_ANTIGRAV,                N_ENABLE,     0, 0, "",                         CPID_POWER,"0 0", _("^K2Antigrav failing..."), "")
    MSG_CENTER_NOTIF(POWERDOWN_BIOSUIT,                 N_ENABLE,     0, 0, "",                         CPID_POWER,"0 0", _("^K2Air supply in Biosuit expiring"), "")
    MSG_CENTER_NOTIF(POWERDOWN_EMPATHY,                 N_ENABLE,     0, 0, "",                         CPID_POWER,"0 0", _("^K2Empathy Shields are running out"), "")
    MSG_CENTER_NOTIF(POWERDOWN_FIREFLOWER,              N_ENABLE,     0, 0, "",                         CPID_POWER,"0 0", _("^K2Fire Flower is fading..."), "")
    MSG_CENTER_NOTIF(POWERDOWN_INVISIBLE,               N_ENABLE,     0, 0, "",                         CPID_POWER,"0 0", _("^K2Ring of Shadows magic is fading"), "")
    MSG_CENTER_NOTIF(POWERDOWN_PROTECTION,              N_ENABLE,     0, 0, "",                         CPID_POWER,"0 0", _("^K2Protection is almost burned out"), "")
    MSG_CENTER_NOTIF(POWERDOWN_SHIELD,                  N_ENABLE,     0, 0, "",                         CPID_POWER,"0 0", _("^K2Shield failing..."), "")
    MSG_CENTER_NOTIF(POWERDOWN_QUAD_DAMAGE,             N_ENABLE,     0, 0, "",                         CPID_POWER,"0 0", _("^K2Quad Damage is wearing off"), "")
    MSG_CENTER_NOTIF(POWERDOWN_WETSUIT,                 N_ENABLE,     0, 0, "",                         CPID_POWER,"0 0", _("^K2Air supply in Wetsuit is running out"), "")

    MSG_CENTER_NOTIF(SEQUENCE_COMPLETED,                N_ENABLE,    0, 0, "",                          CPID_COUNT,"0 0", _("^BGSequence completed!"), "")
    MSG_CENTER_NOTIF(SEQUENCE_COUNTER,                  N_ENABLE,    0, 0, "",                          CPID_COUNT,"0 0", _("^BGThere are more to go..."), "")
    MSG_CENTER_NOTIF(SEQUENCE_COUNTER_FEWMORE,          N_ENABLE,    0, 1, "f1",                        CPID_COUNT,"0 0", _("^BGOnly %s^BG more to go..."), "")

#undef N_DISABL
#undef N_ENABLE

    // default value for multi notification cvars:
// 0: off, 1: enable this multiple notification
#define N_DISABL 0
#define N_ENABLE 1

// MSG_MULTI_NOTIFICATIONS
    //MSG_MULTI_NOTIF(COUNTDOWN_BEGIN,                    N_ENABLE,  ANNCE_BEGIN,    NULL,                                   CENTER_COUNTDOWN_BEGIN)

    MSG_MULTI_NOTIF(DEATH_MURDER_CRUSH,                 N_ENABLE,  NULL,           INFO_DEATH_MURDER_CRUSH,                NULL)
    MSG_MULTI_NOTIF(DEATH_MURDER_DROWN,                 N_ENABLE,  NULL,           INFO_DEATH_MURDER_DROWN,                NULL)
    MSG_MULTI_NOTIF(DEATH_MURDER_DISCHARGE,             N_ENABLE,  NULL,           INFO_DEATH_MURDER_DISCHARGE,            NULL)
    MSG_MULTI_NOTIF(DEATH_MURDER_FALL,                  N_ENABLE,  NULL,           INFO_DEATH_MURDER_FALL,                 NULL)
    MSG_MULTI_NOTIF(DEATH_MURDER_FIRE,                  N_ENABLE,  NULL,           INFO_DEATH_MURDER_FIRE,                 NULL)
    MSG_MULTI_NOTIF(DEATH_MURDER_LAVA,                  N_ENABLE,  NULL,           INFO_DEATH_MURDER_LAVA,                 NULL)
    MSG_MULTI_NOTIF(DEATH_MURDER_MONSTER,               N_ENABLE,  NULL,           INFO_DEATH_MURDER_MONSTER,              CENTER_DEATH_SELF_MONSTER)
    MSG_MULTI_NOTIF(DEATH_MURDER_SLIME,                 N_ENABLE,  NULL,           INFO_DEATH_MURDER_SLIME,                NULL)
    MSG_MULTI_NOTIF(DEATH_MURDER_SHIELD,                N_ENABLE,  NULL,           INFO_DEATH_MURDER_SHIELD,               NULL)
    MSG_MULTI_NOTIF(DEATH_MURDER_SPHERE,                N_ENABLE,  NULL,           INFO_DEATH_MURDER_SPHERE,               NULL)
    MSG_MULTI_NOTIF(DEATH_MURDER_TELEFRAG,              N_ENABLE,  NULL,           INFO_DEATH_MURDER_TELEFRAG,             NULL)
    MSG_MULTI_NOTIF(DEATH_MURDER_TRAP,                  N_ENABLE,  NULL,           INFO_DEATH_MURDER_TRAP,                 NULL)
    MSG_MULTI_NOTIF(DEATH_MURDER_VOID,                  N_ENABLE,  NULL,           INFO_DEATH_MURDER_VOID,                 NULL)

    MSG_MULTI_NOTIF(DEATH_SELF_BETRAYAL,                N_ENABLE,  NULL,           INFO_DEATH_SELF_BETRAYAL,               CENTER_DEATH_SELF_BETRAYAL)
    MSG_MULTI_NOTIF(DEATH_SELF_CRUSH,                   N_ENABLE,  NULL,           INFO_DEATH_SELF_CRUSH,                  CENTER_DEATH_SELF_CRUSH)
    MSG_MULTI_NOTIF(DEATH_SELF_DROWN,                   N_ENABLE,  NULL,           INFO_DEATH_SELF_DROWN,                  CENTER_DEATH_SELF_DROWN)
    MSG_MULTI_NOTIF(DEATH_SELF_DISCHARGE,               N_ENABLE,  NULL,           INFO_DEATH_SELF_DISCHARGE,              CENTER_DEATH_SELF_DISCHARGE)
    MSG_MULTI_NOTIF(DEATH_SELF_FALL,                    N_ENABLE,  NULL,           INFO_DEATH_SELF_FALL,                   CENTER_DEATH_SELF_FALL)
    MSG_MULTI_NOTIF(DEATH_SELF_FIRE,                    N_ENABLE,  NULL,           INFO_DEATH_SELF_FIRE,                   CENTER_DEATH_SELF_FIRE)
    MSG_MULTI_NOTIF(DEATH_SELF_GENERIC,                 N_ENABLE,  NULL,           INFO_DEATH_SELF_GENERIC,                CENTER_DEATH_SELF_GENERIC)
    MSG_MULTI_NOTIF(DEATH_SELF_LAVA,                    N_ENABLE,  NULL,           INFO_DEATH_SELF_LAVA,                   CENTER_DEATH_SELF_LAVA)
    MSG_MULTI_NOTIF(DEATH_SELF_NOEXIT,                  N_ENABLE,  NULL,           INFO_DEATH_SELF_NOEXIT,                 CENTER_DEATH_SELF_NOEXIT)
    MSG_MULTI_NOTIF(DEATH_SELF_PULSERIFLE,              N_ENABLE,  NULL,           INFO_DEATH_SELF_PULSERIFLE,             CENTER_DEATH_SELF_PULSERIFLE)
    MSG_MULTI_NOTIF(DEATH_SELF_ROT,                     N_ENABLE,  NULL,           INFO_DEATH_SELF_ROT,                    CENTER_DEATH_SELF_ROT)
    MSG_MULTI_NOTIF(DEATH_SELF_SLIME,                   N_ENABLE,  NULL,           INFO_DEATH_SELF_SLIME,                  CENTER_DEATH_SELF_SLIME)
    MSG_MULTI_NOTIF(DEATH_SELF_SPHERE,                  N_ENABLE,  NULL,           INFO_DEATH_SELF_SPHERE,                 CENTER_DEATH_SELF_SPHERE)
    MSG_MULTI_NOTIF(DEATH_SELF_SUICIDE,                 N_ENABLE,  NULL,           INFO_DEATH_SELF_SUICIDE,                CENTER_DEATH_SELF_SUICIDE)
    MSG_MULTI_NOTIF(DEATH_SELF_TRAP,                    N_ENABLE,  NULL,           INFO_DEATH_SELF_TRAP,                   CENTER_DEATH_SELF_TRAP)
    MSG_MULTI_NOTIF(DEATH_SELF_VOID,                    N_ENABLE,  NULL,           INFO_DEATH_SELF_VOID,                   CENTER_DEATH_SELF_VOID)
    MSG_MULTI_NOTIF(DEATH_SELF_WRATH,                   N_ENABLE,  NULL,           INFO_DEATH_SELF_WRATH,                  CENTER_DEATH_SELF_WRATH)

    MSG_MULTI_NOTIF(ITEM_BACKPACK_GOT,                  N_ENABLE,  NULL,           INFO_ITEM_BACKPACK_GOT,                 CENTER_ITEM_BACKPACK_GOT)
    MSG_MULTI_NOTIF(ITEM_BACKPACK_GOT_WEAPON,           N_ENABLE,  NULL,           INFO_ITEM_BACKPACK_GOT_WEAPON,          CENTER_ITEM_BACKPACK_GOT_WEAPON)
    MSG_MULTI_NOTIF(ITEM_KEY_GOT,                       N_ENABLE,  NULL,           INFO_ITEM_KEY_GOT,                      CENTER_ITEM_KEY_GOT)
    MSG_MULTI_NOTIF(ITEM_KEY_GOT_SELF,                  N_ENABLE,  NULL,           INFO_ITEM_KEY_GOT_SELF,                 CENTER_ITEM_KEY_GOT_SELF)
    MSG_MULTI_NOTIF(ITEM_POWERUP_GOT,                   N_ENABLE,  NULL,           INFO_ITEM_POWERUP_GOT,                  CENTER_ITEM_POWERUP_GOT)
    MSG_MULTI_NOTIF(ITEM_WEAPON_GOT,                    N_ENABLE,  NULL,           INFO_ITEM_WEAPON_GOT,                   CENTER_ITEM_WEAPON_GOT)
    MSG_MULTI_NOTIF(ITEM_WEAPON_STOLE,                  N_ENABLE,  NULL,           INFO_ITEM_WEAPON_STOLE,                 CENTER_ITEM_WEAPON_STOLE)

    MSG_MULTI_NOTIF(POWERDOWN_ANTIGRAV,                 N_ENABLE,  NULL,           INFO_POWERDOWN_ANTIGRAV,                CENTER_POWERDOWN_ANTIGRAV)
    MSG_MULTI_NOTIF(POWERDOWN_BIOSUIT,                  N_ENABLE,  NULL,           INFO_POWERDOWN_BIOSUIT,                 CENTER_POWERDOWN_BIOSUIT)
    MSG_MULTI_NOTIF(POWERDOWN_EMPATHY,                  N_ENABLE,  NULL,           INFO_POWERDOWN_EMPATHY,                 CENTER_POWERDOWN_EMPATHY)
    MSG_MULTI_NOTIF(POWERDOWN_FIREFLOWER,               N_ENABLE,  NULL,           INFO_POWERDOWN_FIREFLOWER,              CENTER_POWERDOWN_FIREFLOWER)
    MSG_MULTI_NOTIF(POWERDOWN_INVISIBLE,                N_ENABLE,  NULL,           INFO_POWERDOWN_INVISIBLE,               CENTER_POWERDOWN_INVISIBLE)
    MSG_MULTI_NOTIF(POWERDOWN_PROTECTION,               N_ENABLE,  NULL,           INFO_POWERDOWN_PROTECTION,              CENTER_POWERDOWN_PROTECTION)
    MSG_MULTI_NOTIF(POWERDOWN_SHIELD,                   N_ENABLE,  NULL,           INFO_POWERDOWN_SHIELD,                  CENTER_POWERDOWN_SHIELD)
    MSG_MULTI_NOTIF(POWERDOWN_QUAD_DAMAGE,              N_ENABLE,  NULL,           INFO_POWERDOWN_QUAD_DAMAGE,             CENTER_POWERDOWN_QUAD_DAMAGE)
    MSG_MULTI_NOTIF(POWERDOWN_WETSUIT,                  N_ENABLE,  NULL,           INFO_POWERDOWN_WETSUIT,                 CENTER_POWERDOWN_WETSUIT)

    MSG_MULTI_NOTIF(WEAPON_THINKING_WITH_PORTALS,       N_ENABLE,  NULL,           INFO_WEAPON_THINKING_WITH_PORTALS,      CENTER_DEATH_SELF_GENERIC)

#undef N_DISABL
#undef N_ENABLE

// default value for choice notification cvars (notification_CHOICE_*):
// 0: off, 1: display default message, 2: display verbose message
#define N_DISABLE 0
#define N__NORMAL 1
#define N_VERBOSE 2

// default value for allowed choice notification cvars (notification_CHOICE_*_ALLOWED):
// 0: never allowed, 1: allowed in warmup, 2: always allowed
#define A__NEVER 0
#define A_WARMUP 1
#define A_ALWAYS 2

// MSG_CHOICE_NOTIFICATIONS
    //MSG_CHOICE_NOTIF(FRAG,                      N__NORMAL, A_WARMUP,  MSG_CENTER, CENTER_DEATH_MURDER_FRAG,           CENTER_DEATH_MURDER_FRAG_VERBOSE)

#undef N_DISABLE
#undef N__NORMAL
#undef N_VERBOSE

// default value for allowed choice notification cvars (notification_CHOICE_*_ALLOWED):
// 0: never allowed, 1: allowed in warmup, 2: always allowed
#undef A__NEVER
#undef A_WARMUP
#undef A_ALWAYS