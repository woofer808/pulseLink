comment "-------------------------------------------------------------------------------------------------------";
comment "											pulseLink, by woofer.										";
comment "																										";
comment "										   pulseLink_core_services										";
comment "																										";
comment "																										";
comment "	Waits for impulse to start the general funcionality of receiving key inputs from voice interface.	";
comment "	Handles verification of command inputs.					  											";
comment "																										":
comment "-------------------------------------------------------------------------------------------------------";


private _mainInputTimeout = 8;		// Timeout in seconds for the script to wait for input to start after first pulse

private _input 			= 0;		// Declare code array
private _verification 	= 0;		// Declare verification code array

// This is the main loop that iterates through keypress inputs to build the complete binary function code
while {pulseLink_var_running} do {

	scopeName "mainLoop";
	
	// Wait and receive function code
	_input = [] call pulseLink_core_interface;
	
	// We now know that we have either a failstate or a decimal value, verified or non-verified.
	
	// If we have a failstate, then don't go and lookup the function, because this is the main loop son
	If ( _input == -1 ) then {
		if (pulseLink_var_debug) then {systemChat "pulseLink: Failstate detected, restarting main loop."};
	} else {
		[_input] call pulseLink_fnc_functionSelect;
	};
	
	pulseLink_var_pulseKey = false;												// Reset pulse key in case it's stuck
	
};

pulseLink_var_running = false;													// If we somehow get outside the loop, stop all other scripts

if (pulseLink_var_debug) then {systemChat "pulseLink: Script stopped"};			// Tell the user all scripts have quite




/* VERIFICATION METHODS KEPT AROUND FOR POSTERITY

Double sending: (current)
Send the same verification number again. If _input == _verification, then all is good

---

One verification number for each intended word length
4-bit has 4 as verification number:

if (count _word == _verfification) then {all good};

*/