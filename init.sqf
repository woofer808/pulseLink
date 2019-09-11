


[] spawn { // This stops Niipaa's workshop from displaying a hint at startup
	sleep 1;
	hint "";
};

/*
// Running this a little late to make sure it overwrites whatever the settings in settings file are
[] spawn {
	sleep 1;
	voiceMod_var_devMode = false; // false will use compiled scripts
	systemChat format ["--> DevMode is %1...",voiceMod_var_devMode];
};
*/

// Initiate pulseLink script
[] execVM "PULSELINK\CORE\pulseLink_core_init.sqf";

