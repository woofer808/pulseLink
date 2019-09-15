comment "-------------------------------------------------------------------------------------------------------";
comment "										pulseLink, by woofer.											";
comment "																										";
comment "									pulseLink_fnc_functionCompiler										";
comment "																										";
comment "																										";
comment "	Will run during intialization. Put any functions to compile in here.								";
comment "	This is not a requirement though.																	";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";

/* Example
pulseLink_fnc_yourScript = compile preprocessFileLineNumbers "PULSELINK\functions\pulseLink_fnc_yourScript.sqf";
*/



brief_fnc_groupCall	= compile preprocessFileLineNumbers "PULSELINK\functions\brief_fnc_groupCall.sqf";