comment "-------------------------------------------------------------------------------------------------------";
comment "										pulseLink, by woofer.											";
comment "																										";
comment "									  pulseLink_core_decToBin											";
comment "																										";
comment "																										";
comment "	Converts a base-10 integer to base-2 binary representation.											";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";


/* base-10 to base-2 conversion algorithm

BASE10(123) = BASE2(1111011)

Step by step solution
Step 1: Divide (123)10 successively by 2 until the quotient is 0:

123/2 = 61, remainder is 1
61/2 = 30, remainder is 1
30/2 = 15, remainder is 0
15/2 = 7, remainder is 1
7/2 = 3, remainder is 1
3/2 = 1, remainder is 1
1/2 = 0, remainder is 1

Step 2: Read from the bottom (MSB) to top (LSB) as 1111011. This is the binary equivalent of decimal number 123 (Answer).
*/


private _dec			= _this select 0;			// Get the passed base-10 integer
private _bit			= (_this select 1) - 1;		// Get the passed base-2 word length and adjust for 0
private _bin			= [];						// Declare and set the binary number array

while {_bit >= 0} do {								// Could be a for-loop
	
	if (_dec%2 == 0) then { 						// Check it is even or one by looking at the modulus

		_dec = _dec / 2;							// Divide the decimal number in two
		_bin set [_bit,0];							// Set the current binary bit to zero
	
	} else {

		_dec = _dec - 1;							// Remove the rest value
		_dec = _dec / 2;							// Divide the decimal number in two
		_bin set [_bit,1];							// Set the current binary bit to zero

	};
	
	_bit = _bit - 1;								// Step the index down one notch on each pass
	
};

_bin;												// Return the array
