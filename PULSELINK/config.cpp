
class CfgPatches 
{
	class PULSELINK
	{
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {"A3_Ui_F"};
		name = pulseLink;
		author = "woofer";
		requiredVersion = 0.1;
		version = 1;
	};

};



class CfgFunctions
{
	class PULSE
	{
		class PULSE_Initialization
		{
			class Init
			{
				postInit = 1;
				file = "\PULSELINK\pulseLink_core_init.sqf";
			};
		};
	};
};



