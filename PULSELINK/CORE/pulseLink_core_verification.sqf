
_input = _this select 0;

// Don't run verification this time if it was just activated
if (pulseLink_var_verificationSkip) exitWith {pulseLink_var_verificationSkip = false};

// Receive function code
_verification = [] call pulseLink_core_interface; // This arrests the current script until interface is done or aborted

if (_verification isEqualTo -1) exitWith {systemchat "pulseLink: Transfer failed";}; // If input timed out during interfacing, exit scope


if (_verification isEqualTo _input) then {			// This is where we run the proper case when verification matched the desired function

	[_input] call pulseLink_fnc_functionSelect;		// Run the function that corresponds to the given word

} else {
	systemChat "pulseLink: Command failed verification"
};
