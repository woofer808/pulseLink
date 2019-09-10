comment "-------------------------------------------------------------------------------------------------------";
comment "											pulseLink, by woofer.										";
comment "																										";
comment "										   pulseLink_core_services										";
comment "																										";
comment "																										";
comment "	Handles background functions. Executed on init.														";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";
/* DIK keycodes
https://community.bistudio.com/wiki/DIK_KeyCodes
DIK_F1	0x3B, DEC_F1 59
F13 - 100 - 0x64
F14 - 101 - 0x65
Ins - 210 - 0xD2
*/



//["pulseLink","zeroKey", "0-key", {_this spawn {if (pulseLink_var_zeroKey) then {pulseLink_var_zeroKey = false} else {pulseLink_var_zeroKey = true}}}, {}, [100, [false, false, false]]] call CBA_fnc_addKeybind;
//["pulseLink","oneKey", "1-key", {_this spawn {if (pulseLink_var_oneKey) then {pulseLink_var_oneKey = false} else {pulseLink_var_oneKey = true}}}, {}, [101, [false, false, false]]] call CBA_fnc_addKeybind;
//["pulseLink","pulseKey", "pulse", {_this spawn {if (pulseLink_var_pulseKey) then {pulseLink_var_pulseKey = false} else {pulseLink_var_pulseKey = true}}}, {}, [199, [false, false, false]]] call CBA_fnc_addKeybind;



[] spawn {
	while {true} do {
	// This should probably be a stackable onEachFrame type deal.
		waituntil { (inputAction "BuldSwitchCamera" > 0)};
		if (pulseLink_var_zeroKey) then {pulseLink_var_zeroKey = false} else {pulseLink_var_zeroKey = true};
		waituntil {inputAction "BuldSwitchCamera" <= 0};
	};
};

[] spawn {
	while {true} do {
	// This should probably be a stackable onEachFrame type deal.
		waituntil {(inputAction "BuldFreeLook" > 0)};
		if (pulseLink_var_oneKey) then {pulseLink_var_oneKey = false} else {pulseLink_var_oneKey = true};
		waituntil {inputAction "BuldFreeLook" <= 0};
	};
};











[] spawn {
	
	// This should probably be a stackable onEachFrame type deal.
		private _timeout 		= 0.5;			// How fast the button needs to be pressed to activate the reset
		private _buttonStackMax = 5;			// How many times the button needs to be pressed within given time to activate the reset
		private _buttonStack 	= 0;			// How many times the button needs to be pressed within given time to activate the reset
		private _lastPress 		= time;			// Declaring a variable
		
		
	while {true} do {
		
		// This should probably be a stackable onEachFrame type deal.
		
		//if (_buttonStack < 1) then {_buttonStack = 0};		// If it didn't, reset it to zero
		
		waituntil {(inputAction "BuldSelect" > 0)};
		if (pulseLink_var_pulseKey) then {pulseLink_var_pulseKey = false} else {pulseLink_var_pulseKey = true};
		waituntil {inputAction "BuldSelect" <= 0};
		
		// Check if this press happened within a short enough period of time since the last one
		if ( (time - _lastPress) < _timeout ) then {
			_buttonStack = _buttonStack + 1;
			if (pulseLink_var_debug) then {systemChat format ["Sync pulse stack +1, now at: %1",_buttonStack];}
		} else {
			_buttonStack = 0;
			if (pulseLink_var_debug) then {systemChat "Sync pulse stack got resetting..."};
		};
		
		// Check if we managed to stack the button enough times
		if (_buttonStack >= _buttonStackMax) then {
			// If key was pressed enough times within a short enough period, run the function
			
			[] spawn pulseLink_function_11;
			
			_buttonStack = 0;	// Reset the keypress stack now that it has happened
		};
		
		// Reset the timer for the last press thing
		_lastPress = time;
		
	};

};


