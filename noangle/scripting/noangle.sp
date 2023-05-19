#include <sourcemod>

#pragma newdecls required
#pragma semicolon 1

public Plugin myinfo = 
{
	name = "",
	author = "",
	description = "",
	version = "",
	url = ""
};

float Angle[3] = {0.0, 0.0, 0.0};

public void OnPluginStart()
{
	HookEvent("weapon_fire", EventWeaponFire);
}
public Action EventWeaponFire(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(!client)
		return Plugin_Handled;
	
	SetEntProp(client, Prop_Send, "m_iShotsFired", 0);
	SetEntPropVector(client, Prop_Send, "m_vecPunchAngle", view_as<float>(Angle));
	SetEntPropVector(client, Prop_Send, "m_vecPunchAngleVel", view_as<float>(Angle));
	
	return Plugin_Continue;
}