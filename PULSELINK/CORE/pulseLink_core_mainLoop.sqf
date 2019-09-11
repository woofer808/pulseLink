comment "-------------------------------------------------------------------------------------------------------";
comment "											pulseLink, by woofer.										";
comment "																										";
comment "										   pulseLink_core_services										";
comment "																										";
comment "																										";
comment "	Waits for impulse to start the general funcionality of receiving key inputs from voice interface.	";
comment "	Handles verification of inputs.							  											";
comment "	Handles specialized modes, such as number inputs.		  											";
comment "																										":
comment "-------------------------------------------------------------------------------------------------------";


private _mainInputTimeout = 8;		// Timeout in seconds for the script to wait for input to start after first pulse

private _input 			= 0;		// Declare code array
private _verification 	= 0;		// Declare verification code array

// This is the main loop that iterates through keypress inputs to build the complete binary function code
while {pulseLink_var_running} do {

	scopeName "mainLoop";
	
	// Receive function code
	_input = [] call pulseLink_core_interface; 		// This arrests the current script until interface is done or aborted
	[_input] call pulseLink_fnc_functionSelect;	// Run the received function
	
	
	
comment "-------------------------------------------------------------------------------------------------------";
comment "										Number input													";
comment "-------------------------------------------------------------------------------------------------------";

	if (pulseLink_var_inputNumberMode) then {				// Input number mode
	
		private _numberInputTimer = time + 10;
		waitUntil 	{										// Hold the line until one of the modes are started
						pulseLink_var_pulseKey	||
						_numberInputTimer < time
					};
					
		if (_numberInputTimer < time) exitWith {			// If number input times out, exit scope
			systemChat "pulseLink: Number input timed out";
			pulseLink_var_inputNumberMode = false;			
		};
		
		_input = [] call pulseLink_core_interface;			// Run the function that receives the word
		
		if (_input isEqualTo -1) exitWith {systemchat "pulseLink: Number transfer failed";};
		
		if (!pulseLink_var_verification) then {				// If verification isn't on, then just store the value globally
			pulseLink_var_inputNumber = _input;				// Make input available to other scripts 
			systemChat format ["received number: %1",pulseLink_var_inputNumber];
			pulseLink_var_inputNumberMode = false;			
		} else {
			pulseLink_var_inputNumberMode = true;			// If verification is on, keep the number input mode active
		};
		
	};
	
	
	
comment "-------------------------------------------------------------------------------------------------------";
comment "									Regular function execution											";
comment "-------------------------------------------------------------------------------------------------------";

	if (pulseLink_var_pulseKey && !pulseLink_var_inputNumberMode) then {						// Regular running mode, function execution

		_input = [] call pulseLink_core_interface;			// Run the function that receives the word
		
		if (_input isEqualTo -1) exitWith {					// If input timed out during interfacing, exit scope
				systemchat "input timed out";
			};
		
		if (!pulseLink_var_verification) then {				// If verification isn't on, just run the desired function
			[_input] call pulseLink_fnc_functionSelect;
		};
		
	};
	
	
	
comment "-------------------------------------------------------------------------------------------------------";
comment "												Verification											";
comment "-------------------------------------------------------------------------------------------------------";


	if (pulseLink_var_verification) then {
	
		// Don't run verification this time if it was just activated
		if (pulseLink_var_verificationSkipFirstRun) exitWith {pulseLink_var_verificationSkipFirstRun = false};
		
		// Receive function code
		_verification = [] call pulseLink_core_interface; // This arrests the current script until interface is done or aborted
		
		if (_verification isEqualTo -1) exitWith {systemchat "pulseLink: Transfer failed";}; // If input timed out during interfacing, exit scope


		if (_verification isEqualTo _input) then {							// This is where we run the proper case
			
			switch (true) do {												// Switch to whatever case resolves to true
			
				case (!pulseLink_var_inputNumberMode): {
				
					[_input] call pulseLink_fnc_functionSelect;			// Run the function that corresponds to the given word
				};
			
				case (pulseLink_var_inputNumberMode): {
				
					pulseLink_var_inputNumber = _input;					// Set the global inputNumber variable
					systemChat format ["received number after verification: %1",pulseLink_var_inputNumber];
					pulseLink_var_inputNumberMode = false;
					
				};
			
			};
		
		} else {
			systemChat "pulseLink: Command failed verification"
		};

	};
	
	pulseLink_var_pulseKey = false;										// Reset pulse key in case it's stuck
	
};

pulseLink_var_running = false;											// If we somehow get outside the loop, stop all other scripts
if (pulseLink_var_debug) then {systemChat "pulseLink: Script stopped"};	// Tell the user all scripts have quite





/* VERIFICATION METHODS KEPT AROUND FOR POSTERITY

Double sending: (current)
Send the same verification number again. If _input == _verification, then all is good

---

One verification number for each intended word length
4-bit has 4 as verification number:

if (count _word == _verfification) then {all good};

*/