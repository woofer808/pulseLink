comment "-------------------------------------------------------------------------------------------------------";
comment "											pulseLink, by woofer.										";
comment "																										";
comment "										   pulseLink_core_interface										";
comment "																										";
comment "																										";
comment "	Receives the keypress code from the game and converts to decimal.									";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";



private _numberInputTimer = time + 10;
		waitUntil 	{										// Hold the line until one of the modes are started
						pulseLink_var_pulseKey	||
						_numberInputTimer < time
					};
					
		if (_numberInputTimer < time) exitWith {			// If number input times out, exit scope
			systemChat "pulseLink: Number input timed out";
			pulseLink_var_inputNumberMode = false;			
		};


// if debug is on, tell the user what's going on
if (pulseLink_var_debug) then {systemChat "Loop started, please provide key sequence"};

// Pulse key has to be sent before running this function is run
// Make sure the pulse key state is set back to false
pulseLink_var_pulseKey = false;

// Allow input of zeros and ones to be done
pulseLink_var_allowInput = true;



private _word	= [];	// Declare the binary code array
private _bit	= 0; 	// Declare the first bit number place in the binary code array
private _timer	= 0;	// Declare variable used for checking input timeout

while {pulseLink_var_running && !pulseLink_var_pulseKey} do {
	
	// Start the input timer to control for timeout of the keypresses
	_timer = time + 1;

	// Hold the loop until either of the proper keys are pressed or the timer has run out
	waitUntil {pulseLink_var_zeroKey || pulseLink_var_oneKey || pulseLink_var_pulseKey || (_timer < time)};

	// If it was the timer that ran out of... well, time. Just exit the script.
	if (_timer < time) exitWith {if (pulseLink_var_debug) then {_word = -1;systemChat "input timeout"};};
	// If the mod has been requested to stop, quit all scripts.
	if (!pulseLink_var_running) exitWith {if (pulseLink_var_debug) then {systemChat "script was halted"};};

	// If the zero key was pressed, store the bit as 0 at the current bit number
	if (pulseLink_var_zeroKey) then {pulseLink_var_zeroKey = false;_word set [_bit,0];_bit = _bit + 1;if (pulseLink_var_debug) then {systemChat "zeroKey was pressed"};};
	// If the one key was pressed, store the bit as 1 at the current bit number
	if (pulseLink_var_oneKey) then {pulseLink_var_oneKey = false;_word set [_bit,1];_bit = _bit + 1;if (pulseLink_var_debug) then {systemChat "oneKey was pressed"};};
	// If pulse key was pressed. Exit the script.
	if (pulseLink_var_pulseKey) exitWith {pulseLink_var_pulseKey = false;if (pulseLink_var_debug) then {systemChat "pulse key was pressed"};};

	// If debug is on, show the current input as it's being entered.
	if (pulseLink_var_debug) then {systemChat format ["current _word: %1",_word]};

};

// Input of zeroes and ones is no longer allowed
pulseLink_var_allowInput = false;

// If we timed out, stop here
if (_word isEqualTo -1) exitWith {_word;};

// Convert the word into decimal
private _numberOutput = _word call pulseLink_core_binToDec;

// Return the proper value
_numberOutput;
