
comment "-------------------------------------------------------------------------------------------------------";
comment "											pulseLink, by woofer.										";
comment "																										";
comment "										   brief_fnc_groupCall										";
comment "																										";
comment "																										";
comment "									";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";


// Set up to receive the two numbers that we want
systemChat "pulseLink: waiting for NATO phonetic";
waitUntil 	{											// Hold the line until one of the modes are started
				pulseLink_var_pulseKey 					// Regular function execution
			};
// Pulse key was pressed, receive the first number
private _natoPhonetic = [] call pulseLink_core_interface;		// Run the function that receives the word

systemChat "pulseLink: waiting for group or unit identifier";
waitUntil 	{											// Hold the line until one of the modes are started
				pulseLink_var_pulseKey 					// Regular function execution
			};
			
// Pulse key was pressed, receive the first number
private _unitDesignation = [] call pulseLink_core_interface;		// Run the function that receives the word




switch _natoPhonetic do {
		case 1: {_natoPhonetic = "Alpha"};
		case 2: {_natoPhonetic = "Beta"};
		case 3: {_natoPhonetic = "Charlie"};
		case 4: {_natoPhonetic = "Delta"};
		case 5: {_natoPhonetic = "Echo"};
		case 6: {_natoPhonetic = "Foxtrot"};
		case 7: {_natoPhonetic = "Golf"};
		case 8: {_natoPhonetic = "Hotel"};
		case 9: {_natoPhonetic = "India"};
		case 10: {_natoPhonetic = "Juliet"};
	}; // End of switch

	
	// Extract squad and fireteam number
	_str = str _unitDesignation;
	//TODO- This is where we need a check if we only called Bravo 1 to catch all fireteams in Bravo
	//TODO- I likely need to be able to just say Bravo as well. Not supported in VA yet
	_squadNumber = (_str select [0,1]);
	_fireteamNumber = (_str select [1,1]);
	
	// Test if it works
	_groupSelect = format ["B %1 %2-%3",_natoPhonetic,_squadNumber,_fireteamNumber];
	systemChat str _groupSelect;
	
	// Now to somehow tie these two numbers to useful and actual in-game groups
	_allGroups = allGroups;