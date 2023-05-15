#include <sourcemod>
#include <sdktools>

new Float:Origin[3];

public OnPluginStart()
{
	HookEvent("bullet_impact", ShowImpact);
}

public void ShowImpact(Event event, const char[] name, bool dontBroadcast)
{
	Origin[0] = GetEventFloat(event,"x");
	Origin[1] = GetEventFloat(event,"y");
	Origin[2] = GetEventFloat(event,"z");

	TE_SetupEnergySplash(Origin,Origin,false);
	TE_SendToAll();
	
	return;
}