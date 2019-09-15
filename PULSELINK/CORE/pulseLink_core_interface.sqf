
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


scopeName "topLevel";

private _scriptTimeStart = 0;
private _output = 0;


comment "-------------------------------------------------------------------------------------------------------";
comment "												setup													";
comment "-------------------------------------------------------------------------------------------------------";


private _transferTimeout = 1.5;					// Timeout in seconds between each pulse and bit sent

if (pulseLink_var_debug) then {systemChat "pulseLink: ready"};

waitUntil 	{								// Wait for the pulse key to be pressed
				pulseLink_var_pulseKey ||	// Go on when pulse is given
				!pulseLink_var_running		// If pulseLink is terminated, go on to kill this script
			};
private _scriptTimeStart = time;
			
	waitUntil {!pulseLink_var_pulseKey};						// Wait here until the pulse key is set back to false
			
if (!pulseLink_var_running) exitWith {};	// Kill all scripts on this request


if (pulseLink_var_debug) then {systemChat "pulseLink: Loop started, please provide key sequence"};


pulseLink_var_allowInput = true;			// Allow input of zeros and ones to be done

private _word	= [];						// Declare the binary code array
private _bit	= 0; 						// Declare the first bit number place in the binary code array
private _timer	= 0;						// Declare variable used for checking input timeout
private _verificationLoop = 1;				// Declare iteration number in case we are verifying

private _nonVerified = 0;					// Declare the non-verified output
private _verification = 0;					// Declare the verified output in case verification is on



// On verification, VA shouldn't send the first pulse

comment "-------------------------------------------------------------------------------------------------------";
comment "									input loop and verification											";
comment "-------------------------------------------------------------------------------------------------------";

// If verification is on, then just let the input loop run twice
// If we decide that verification should use a method other than double sending, this entire block might have to be overhauled
if (pulseLink_var_verification) then {_verificationLoop = 2} else {_verificationLoop = 1};

for "_i" from 1 to _verificationLoop step 1 do {

	if (_i == 2) then {							// In case of verification,
		waitUntil {pulseLink_var_pulseKey};		// wait for the first pulse of the second code transfer
		pulseLink_var_pulseKey = false;			// Also set the pulse back to false immediately instead of waiting for it
	};
	
	_word = [];									// Reset the word after each run of the for-loop
	
	while {true} do { 							// This is the actual code transfer loop that receives each bit and ending pulse
		
		_timer = time + _transferTimeout; 		// Start the input timer to control for timeout of the keypresses
		
		// Hold the loop until either of the proper keys are pressed or the timer has run out
		waitUntil {pulseLink_var_zeroKey || pulseLink_var_oneKey || pulseLink_var_pulseKey || (_timer < time)};

		if (_timer < time) then {													// Timer ran out of... well, time. It timed out.
			systemchat "pulseLink: Input timeout! Try slowing down the profile.";	// Tell the user
			_word = -1;																// Set the word variable to failstate value of -1
			breakTo "topLevel";														// Exit outside all loop scopes.
		};
		
		// If the zero key was pressed, store the bit as 0 at the current bit number
		if (pulseLink_var_zeroKey) then {pulseLink_var_zeroKey = false;_word set [_bit,0];_bit = _bit + 1;};
		// If the one key was pressed, store the bit as 1 at the current bit number
		if (pulseLink_var_oneKey) then {pulseLink_var_oneKey = false;_word set [_bit,1];_bit = _bit + 1;};
		// If pulse key was pressed. Exit the script.
		if (pulseLink_var_pulseKey) exitWith {if (pulseLink_var_debug) then {systemChat "Transfer done."};};
	
	}; // End of while loop
	
	if (_i == 1) then {_nonVerified = _word};					// Store the first run of the code loop into a variable
	
	if (_i == 2) then {											// If verification is on and we got a second code...
		_verification = _word;									// ... store it in a variable and...
		
		if (
			(_nonVerified isEqualTo _verification)  &&
			!(_nonVerified isEqualTo -1)
			
		) then {		// ... check if code is verified. (This line can be switched to more efficient tests)
		
			breakTo "topLevel";									// If verification worked, exit outside all loop scopes.
			if (pulseLink_var_debug) then {systemChat "verification passed"};
			
		} else {												// If verfication and code didn't match...
			breakTo "topLevel";									// ... exit to outside of loop scopes.
		};
		
	};
	
	waitUntil {!pulseLink_var_pulseKey};						// Wait here until the pulse key is set back to false
	
}; // End of for loop


comment "-------------------------------------------------------------------------------------------------------";
comment "											Return values												";
comment "-------------------------------------------------------------------------------------------------------";

pulseLink_var_allowInput = false;									// No need to receive anymore. Input of zeroes and ones is no longer allowed

if ( (_nonVerified isEqualTo -1) || (_word isEqualTo -1) ) exitWith {-1};						// If we timed out or verification failed, stop here and return failstate value

_output = _nonVerified call pulseLink_core_binToDec;	// If code came through, convert the word into decimal

_scriptTime = time - _scriptTimeStart;								// Calculate the amount of time it took for the interface to complete

// If debug is on, show the current output and completion time
if (pulseLink_var_debug) then {systemChat format ["pulseLink: word: %1, function ID: %2, command time: %3, verified: %4",_nonVerified,_output,_scriptTime,pulseLink_var_verification]};

pulseLink_var_pulseKey = false;

// Return the proper value
_output;
