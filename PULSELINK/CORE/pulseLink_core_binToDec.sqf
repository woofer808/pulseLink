comment "-------------------------------------------------------------------------------------------------------";
comment "										pulseLink, by woofer.											";
comment "																										";
comment "									  pulseLink_core_binToDec											";
comment "																										";
comment "																										";
comment "	Converts a base-2 binary to base-10 integer representation.											";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";

/* n-bit conversion base-2 to base-10

n-bit binary [01...01] --> decimal sum (0 * 2^n) + (1 * 2^(n-1)) + ... + (0 * 2^1) + (1 * 2^0)

*/


private _bin 	= _this;			// Grab inputted binary array
private _dec 	= 0;						// Declare base-10 variable

reverse _bin;								// Calculation requires we do it from the rear...

{
	_dec = _dec + (_x * 2^_forEachIndex); 	// _x and _forEachIndex are magic variables
} forEach _bin;

_dec;										// Return the result

