#include <sourcemod>
#include <sdktools>

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

float Origin[3];

public void OnPluginStart()
{
	HookEvent("bullet_impact", ShowImpact);
}

public Action ShowImpact(Event event, const char[] name, bool dontBroadcast)
{
	Origin[0] = GetEventFloat(event,"x");
	Origin[1] = GetEventFloat(event,"y");
	Origin[2] = GetEventFloat(event,"z");

	TE_SetupEnergySplash(Origin,Origin,false);
	TE_SendToAll();
	
	return Plugin_Continue;
}