#include <sourcemod>

public OnPluginStart()
{
	HookEvent("weapon_fire", EventWeaponFire);
}
public void EventWeaponFire(Event event, const char[] name, bool dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(!client)
		return;
	
	SetEntProp(client, Prop_Send, "m_iShotsFired", 0);
	SetEntPropVector(client, Prop_Send, "m_vecPunchAngle", Float:{0.0, 0.0, 0.0});
	SetEntPropVector(client, Prop_Send, "m_vecPunchAngleVel", Float:{0.0, 0.0, 0.0});
	return;
}