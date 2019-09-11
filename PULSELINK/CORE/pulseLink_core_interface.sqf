comment "-------------------------------------------------------------------------------------------------------";
comment "											pulseLink, by woofer.										";
comment "																										";
comment "										   pulseLink_core_interface										";
comment "																										";
comment "																										";
comment "	Receives the keypress code from VoiceAttack and converts to base-10 decimal.						";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";

/* PSEUDO CODE
- Script called
- Wait until pulse-key is pressed -OR- script is terminated
- Start while loop to recieve bits
	- if zero-key is pressed, then write a zero to the current bit in word array
	- if one-key is pressed, then write a one to the current bit in word array
	- if pulse-key is pressed, then consider code transfer to be complete
- Convert the base-2 binary word into base-10 decimal number
- Return base-10 decimal number
- If script was interrupted by timeouts or whatnot, return -1 as failstate
*/



private _codeTimeout 	= 1;	// Timeout in seconds between each pulse and bit sent

// Function has been spawned, now we await the first pulse to start the recording
if (pulseLink_var_debug) then {systemChat "pulseLink: ready"};
waitUntil 	{
				pulseLink_var_pulseKey 		||	// Go on when pulse is given
				pulseLink_var_interfaceDone		// Go on to quit if script is set to false
			};


// If the script is terminated manually or by timer
if (pulseLink_var_interfaceDone) exitWith {systemChat "pulseLink: Interface aborted."};





// if debug is on, tell the user what's going on
if (pulseLink_var_debug) then {systemChat "Loop started, please provide key sequence"};


pulseLink_var_pulseKey = false;		// Make sure the pulse key state is set back to false

pulseLink_var_allowInput = true;	// Allow input of zeros and ones to be done

private _word	= [];				// Declare the binary code array
private _bit	= 0; 				// Declare the first bit number place in the binary code array
private _timer	= 0;				// Declare variable used for checking input timeout

while {true} do {
	
	_timer = time + _codeTimeout;				// Start the input timer to control for timeout of the keypresses

	// Hold the loop until either of the proper keys are pressed or the timer has run out
	waitUntil {pulseLink_var_zeroKey || pulseLink_var_oneKey || pulseLink_var_pulseKey || (_timer < time) || pulseLink_var_interfaceDone};

	// If it was the timer that ran out of... well, time. Just exit the script.
	if (_timer < time) exitWith {if (pulseLink_var_debug) then {systemChat "input timeout"};_word = -1;};
	// If the mod has been requested to stop, quit all scripts.
	if (pulseLink_var_interfaceDone) exitWith {if (pulseLink_var_debug) then {systemChat "script was halted"};};

	// If the zero key was pressed, store the bit as 0 at the current bit number
	if (pulseLink_var_zeroKey) then {pulseLink_var_zeroKey = false;_word set [_bit,0];_bit = _bit + 1;};
	// If the one key was pressed, store the bit as 1 at the current bit number
	if (pulseLink_var_oneKey) then {pulseLink_var_oneKey = false;_word set [_bit,1];_bit = _bit + 1;};
	// If pulse key was pressed. Exit the script.
	if (pulseLink_var_pulseKey) exitWith {pulseLink_var_pulseKey = false;if (pulseLink_var_debug) then {systemChat "pulse key was pressed"};};


};


// Input of zeroes and ones is no longer allowed
pulseLink_var_allowInput = false;

// If we timed out, stop here
if (_word isEqualTo -1) exitWith {_word;};

// Convert the word into decimal
private _numberOutput = _word call pulseLink_core_binToDec;

// If debug is on, show the current input
if (pulseLink_var_debug) then {systemChat format ["current _word: %1 and _function ID: %2",_word,_numberOutput]};

// Return the proper value
_numberOutput;
