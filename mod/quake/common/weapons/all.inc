#include "weapon/axe.qh"
#include "weapon/shotgun.qh"
#include "weapon/super_shotgun.qh"
#include "weapon/nailgun.qh"
#include "weapon/super_nailgun.qh"
#include "weapon/grenade_launcher.qh"
#include "weapon/rocket_launcher.qh"
#include "weapon/thunderbolt.qh"
#include "weapon/laser_cannon.qh"
#include "weapon/mjolnir.qh"
#include "weapon/proximity_gun.qh"
#include "weapon/lava_nailgun.qh"
#include "weapon/lava_super_nailgun.qh"
#include "weapon/multi_grenade.qh"
#include "weapon/multi_rocket.qh"
#include "weapon/plasma_gun.qh"
#include "weapon/super_lightning.qh"
#include "weapon/impaler.qh"
#include "weapon/napalm_gun.qh"
#include "weapon/chainsaw.qh"

// WARNING: also update the weapon priority list in all.qh or your weapon won't work properly!!

// Weapon registry is sorted to allocate the weapons included above first, update the value below to the number of listed weapons
// TODO: remove eventually in a way that does not cause https://gitlab.com/xonotic/xonotic-data.pk3dir/-/issues/2714
#define WEP_HARDCODED_IMPULSES 20