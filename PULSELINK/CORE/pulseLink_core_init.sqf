comment "-------------------------------------------------------------------------------------------------------";
comment "							  pulseLink by woofer, based on concept by Reggeaeman						";
comment "																										";
comment "										voice activated function call									";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";

//NOTE- Transfer - or keypress - codes are handeled completely in the background. VA converts decToBin, Arma converts binToDec
//NOTE- In VA it seems to be more important with keypress duration rather than pause duration in relation to FPS
//NOTE- Current normal speed in voice profile @20 fps is 0.02s pause and 0.05 keypress duration.
//NOTE- Verification is in. Best way I have found to mitigate low FPS. Current method is double sending of words.
//NOTE- Currently any word length can be used. Input time and verification method affects choice of word length.
//NOTE- There is a syncing feature that when the pulse key is spammed (by VA command), bot VA and pulseLink will reset to same settings
//NOTE- The script framework is restricted to the CORE folder. Any user additions to the script are unchanged by core updates.

// TODO- RESTRUCTURE: REMOVE ANY CORE FUNCTIONALITY FROM THE FUNCTION LIST - reserve and move at least functions 0-15 to CORE - or leave as is

//TODO- Make a "restart script" command to sync the profile and the mod at the beginning b/c of settings for example (function 11)
//TODO- Audible/visual confirmation of commands and errors internally by the script. Maybe should be modular.
//TODO- Settings storage by using profileNamespace and call saveProfileNamespace. May be that VA need to load it.
//TODO- Make it possible to bind the keys in-game. CBA keybinds doesn't seem to work for me since it's modifier-sensitive


comment "-------------------------------------------------------------------------------------------------------";
comment "											initialization												";
comment "-------------------------------------------------------------------------------------------------------";


// Declare global variables and settings
pulseLink_var_debug 				= true; 	// True will enable debug messages.
pulseLink_var_devMode 				= false; 	// True will use execVM instead of call and spawn for scripts. It's here to help with development.

pulseLink_var_running 				= true;		// False will kill all running functions related to the script.
pulseLink_var_zeroKey 				= false;	// Bool state of a keypress event.
pulseLink_var_oneKey 				= false;	// Bool state of a keypress event.
pulseLink_var_pulseKey 				= false;	// Bool state of a keypress event.
pulseLink_var_allowInput			= false;	// Only allow input of zeros and ones when the main loop is set to receive them
pulseLink_var_verification			= false;	// When true, the script will receive a confirmation word from VA to make sure no bits were garbled

pulseLink_var_inputNumber			= 0;		// Global variable used for passing around number input from input function
pulseLink_var_inputNumberMode		= false;	// Global variable used for passing around number input from input function

pulseLink_var_interfaceDone			= false;	// Used to kill spawned interfaces that are waiting for input


pulseLink_fnc_compileAll = { // Compile functions as a function. Makes it possible to re-compile on the fly. It's here to help with development.

	pulseLink_core_mainLoop 		= compile preprocessFileLineNumbers "PULSELINK\CORE\pulseLink_core_mainLoop.sqf";
	pulseLink_core_services 		= compile preprocessFileLineNumbers "PULSELINK\CORE\pulseLink_core_services.sqf";
	pulseLink_core_interface		= compile preprocessFileLineNumbers "PULSELINK\CORE\pulseLink_core_interface.sqf";
	pulseLink_core_decToBin 		= compile preprocessFileLineNumbers "PULSELINK\CORE\pulseLink_core_decToBin.sqf";
	pulseLink_core_binToDec 		= compile preprocessFileLineNumbers "PULSELINK\CORE\pulseLink_core_binToDec.sqf";

	pulseLink_fnc_functions			= compile preprocessFileLineNumbers "PULSELINK\pulseLink_fnc_functions.sqf";
	pulseLink_fnc_functionSelect 	= compile preprocessFileLineNumbers "PULSELINK\pulseLink_fnc_functionSelect.sqf";
	
	// The function compiler is there for users to add their own scripts to be compiled.
	// Helps with updating the CORE by moving the step out from init
	_functionCompiler = [] execVM "PULSELINK\pulseLink_fnc_functionCompiler.sqf";
	waitUntil {scriptDone _functionCompiler};
	
	if (pulseLink_var_debug) then {systemChat "--> scripts compiled"};
};
[] call pulseLink_fnc_compileAll;


// Spawn the services which means keypresses and other stuff.
if (pulseLink_var_devMode) then {
	[] execVM "PULSELINK\CORE\pulseLink_core_services.sqf";
} else {
	[] spawn pulseLink_core_services;
};


// Call the function list to declare all the functions.
if (pulseLink_var_devMode) then {
	_functionList = [] execVM "PULSELINK\pulseLink_fnc_functions.sqf";
	waitUntil {scriptDone _functionList};
} else {
	[] call pulseLink_fnc_functions;
};


// Spawn the main loop.
if (pulseLink_var_devMode) then {
	[] execVM "PULSELINK\CORE\pulseLink_core_mainLoop.sqf";
} else {
	[] spawn pulseLink_core_mainLoop;
};

if (pulseLink_var_debug) then {systemChat format ["pulseLink: debug is %1",pulseLink_var_debug]};
if (pulseLink_var_debug) then {systemChat format ["pulseLink: devMode is %1",pulseLink_var_devMode]};
if (pulseLink_var_debug) then {systemChat format ["pulseLink: verification is %1",pulseLink_var_verification]};


/* GENERAL PROGRAM FLOW in pseudo code

INIT: ---------------------------------------------------------------------------------------------
- Initialize variables and functions
- Initialize input keys (PULSEKEY, ONEKEY, ZEROKEY)
- Start mainLoop
---------------------------------------------------------------------------------------------------


MAIN LOOP -----------------------------------------------------------------------------------------
- Main loop start
	- wait until PULSEKEY is pressed
	- start INPUTFUNCTION that receives input data from ONEKEY and ZEROKEY. Store input as array "word".

	- if verification is ON, set up to receive it with INPUTFUNCTION. Store input as array "verification".
		- if "word" is equal to "verification", run the FUNCTION CHECK associated to "word".
		- if "word" is not equal to "verification", do nothing and restart MAIN LOOP
	- if verification is OFF, run the function associated to "word".
---------------------------------------------------------------------------------------------------


INPUTFUNCTION -------------------------------------------------------------------------------------
- Input loop start
	- wait until any of the input keys are pressed, or if the timeout is reached
	- when any of the input keys were pressed, find out which one by testing their bool states

	- if ONEKEY was pressed, store a 1 in the current index of the "word" array and move to next index
		- restart loop
	- if ZEROKEY was pressed, store a 0 in the current index of the "word" array and move to next index
		- restart loop
	- if PULSEKEY was pressed, stop the input loop and return the received "word" array.
	- if timeout has been reched, top input loop and revert to main loop start
---------------------------------------------------------------------------------------------------


FUNCTION CHECK ------------------------------------------------------------------------------------
- Compare the received "word" array with the set of functions and call/spawn the appropriate case
---------------------------------------------------------------------------------------------------


FUNCTION LIST -------------------------------------------------------------------------------------
- Stores the contents of each associated function
---------------------------------------------------------------------------------------------------

*/