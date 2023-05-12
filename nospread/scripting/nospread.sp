#include <sourcemod>
#include <sdktools>
#include <dhooks>
#include <cstrike>

#pragma newdecls required
#pragma semicolon 1

public Plugin myinfo =
{
	name = "no_spread",
	author = "",
	description = "",
	version = "1.0.0",
	url = ""
};

DHookSetup g_FX_FireBullets = null;
Handle g_hEyeAngles = null;

public void OnPluginStart()
{
	GameData gameconf = new GameData("nospread.gamedata");
	if(gameconf == null)
		SetFailState("Failed to find nospread.gamedata.txt");
	
	g_FX_FireBullets = DHookCreateFromConf(gameconf, "FX_FireBullets");
	if(g_FX_FireBullets == null)
		SetFailState("Failed to create detour \"FX_FireBullets\"");
	
	if(!DHookEnableDetour(g_FX_FireBullets, false, Detour_FX_FireBullets))
		SetFailState("Error enabling detour \"FX_FireBullets\"");
	
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(gameconf, SDKConf_Virtual, "CBasePlayer::EyeAngles");
	PrepSDKCall_SetReturnInfo(SDKType_QAngle, SDKPass_ByRef);
	g_hEyeAngles = EndPrepSDKCall();
	if(g_hEyeAngles == null)
		SetFailState("Error creating SDK Call \"CBasePlayer::EyeAngles\"");
	
	gameconf.Close();

	RegConsoleCmd("test", Cmd_Test);
}

public Action Cmd_Test(int client, int args)
{
	float fAngles[3], fAngles2[3];
	GetClientEyeAngles(client, fAngles);
	GetEyeAngles(client, fAngles2);

	PrintToChat(client, "%f %f %f", fAngles[0], fAngles[1], fAngles[2]);
	PrintToChat(client, "%f %f %f", fAngles2[0], fAngles2[1], fAngles2[2]);
	return Plugin_Handled;
}

void GetEyeAngles(int client, float fAngles[3])
{
	SDKCall(g_hEyeAngles, client, fAngles);
}

/*
void FX_FireBullets( 
	int	iPlayerIndex,
	const Vector &vOrigin,
	const QAngle &vAngles,
	int	iWeaponID,
	int	iMode,
	int iSeed,
	float flSpread
)
*/

public MRESReturn Detour_FX_FireBullets(DHookParam hParams)
{
	/*
	CSWeaponID wpn_id = view_as<CSWeaponID>(DHookGetParam(hParams, 4));
	if(wpn_id == CSWeapon_M3)
		return MRES_Ignored;

	int client = DHookGetParam(hParams, 1);

	float fAngles[3];
	GetClientEyeAngles(client, fAngles);

	for(int i = 0; i < 3; ++i)
		DHookSetParamObjectPtrVar(hParams, 3, (i * 4), ObjectValueType_Float, fAngles[i]);
	*/

	float flSpread = DHookGetParam(hParams, 7);
	DHookSetParam(hParams, 7, flSpread * 0.5);
	return MRES_ChangedHandled;
}

