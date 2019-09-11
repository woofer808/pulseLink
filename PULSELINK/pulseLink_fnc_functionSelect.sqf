comment "-------------------------------------------------------------------------------------------------------";
comment "										pulseLink, by woofer.											";
comment "																										";
comment "									pulseLink_fnc_functionSelect										";
comment "																										";
comment "																										";
comment "	List of available functions and their corresponding functionID number.								";
comment "	Good place to call, spawn or exeVM.																	";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";

// The reason for having this script is to ease workflow.
// It's also a god place to decide wether scripts should be called or spawned.

private _functionID = _this select 0;	// Declare param

// Now we select the appropriate action from the code.
switch _functionID do {

case 2: {[_functionID] call pulseLink_function_2}; // Store a number in memory for use with mod scripts
case 3: {[_functionID] call pulseLink_function_3}; // 
case 4: {[_functionID] call pulseLink_function_4}; // 
case 5: {[_functionID] call pulseLink_function_5}; // 
case 6: {[_functionID] call pulseLink_function_6}; // Save settings to VA and Arma profiles
case 7: {[_functionID] call pulseLink_function_7}; // Load settings from VA and Arma profiles
case 8: {[_functionID] call pulseLink_function_8}; // Robust down to 20 FPS
case 9: {[_functionID] call pulseLink_function_9}; // Robust down to 15 FPS
case 10: {[_functionID] call pulseLink_function_10}; // Robust down to 10 FPS
case 11: {[_functionID] call pulseLink_function_11}; // Re-synchronizes VA profile and Arma mod
case 12: {[_functionID] call pulseLink_function_12}; // Turns debug on or off
case 13: {[_functionID] call pulseLink_function_13}; // Turns feedback on or off
case 14: {[_functionID] call pulseLink_function_14}; // Turns verification on - INCREASES COMMAND LATENCY
case 15: {[_functionID] call pulseLink_function_15}; // Turns verification off - INCREASES COMMAND LATENCY
case 16: {[_functionID] call pulseLink_function_16}; // 
case 17: {[_functionID] call pulseLink_function_17}; // 
case 18: {[_functionID] call pulseLink_function_18}; // 
case 19: {[_functionID] call pulseLink_function_19}; // 
case 20: {[_functionID] call pulseLink_function_20}; // 
case 21: {[_functionID] call pulseLink_function_21}; // test
case 22: {[_functionID] call pulseLink_function_22}; // 
case 23: {[_functionID] call pulseLink_function_23}; // 
case 24: {[_functionID] call pulseLink_function_24}; // 
case 25: {[_functionID] call pulseLink_function_25}; // 
case 26: {[_functionID] call pulseLink_function_26}; // 
case 27: {[_functionID] call pulseLink_function_27}; // 
case 28: {[_functionID] call pulseLink_function_28}; // 
case 29: {[_functionID] call pulseLink_function_29}; // 
case 30: {[_functionID] call pulseLink_function_30}; // 
case 31: {[_functionID] call pulseLink_function_31}; // 
case 32: {[_functionID] call pulseLink_function_32}; // Call unit or group
// Default case will just display code error since correct functionID couldn't be found
// --------------------------------
default {systemChat "pulseLink: CODE ERROR - functionID not found."};
// --------------------------------
};


