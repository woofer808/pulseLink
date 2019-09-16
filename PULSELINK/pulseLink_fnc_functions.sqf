comment "-------------------------------------------------------------------------------------------------------";
comment "										pulseLink, by woofer.											";
comment "																										";
comment "									  pulseLink_fnc_functions											";
comment "																										";
comment "																										";
comment "	Function definitions for each functionID. It's where the code is at.								";
comment "																										";
comment "-------------------------------------------------------------------------------------------------------";


pulseLink_function_2 = {systemChat "pulseLink: Syncing VoiceAttack and Arma...";
pulseLink_var_zeroKey = false;
pulseLink_var_oneKey = false;
pulseLink_var_pulseKey = false;
};
pulseLink_function_3 = {pulseLink_var_numberInput = true;
systemchat "Please provide number.";
private _input = [] call pulseLink_core_interface;        // Receive number through the interface
// We now have either a failstate or a decimal number on hand
// If we don't have a failstate, then store the number input in a global variable for later use
If ( !(_input isEqualTo -1) ) then {
if (pulseLink_var_debug) then {systemChat format ["pulseLink: Number input: %1",_input]};
pulseLink_var_inputNumber = _input;
} else {
if (pulseLink_var_debug) then {systemChat "pulseLink: Failstate detected, no number recieved."};
};
pulseLink_var_numberInput = false;};
pulseLink_function_4 = {systemChat "pulseLink_function_2"};
pulseLink_function_5 = {systemChat "pulseLink_function_3"};
pulseLink_function_6 = {systemChat "pulseLink_function_4"};
pulseLink_function_7 = {systemChat "pulseLink_function_5"};
pulseLink_function_8 = {systemChat "pulseLink_function_6"};
pulseLink_function_9 = {systemChat "pulseLink_function_7"};
pulseLink_function_10 = {systemChat "pulseLink_function_8"};
pulseLink_function_11 = {pulseLink_var_verification = true;systemChat "pulseLink: verification is ON";pulseLink_var_verificationSkipFirstRun = true;};
pulseLink_function_12 = {pulseLink_var_verification = false;systemChat "pulseLink: verification is OFF";};
pulseLink_function_13 = {systemChat "pulseLink_function_11"};
pulseLink_function_14 = {systemChat "pulseLink_function_12"};
pulseLink_function_15 = {if (pulseLink_var_debug) then {pulseLink_var_debug = false;systemchat "pulseLink: debug off"} else {pulseLink_var_debug = true;systemchat "pulseLink: debug on"}};
pulseLink_function_16 = {systemChat "pulseLink_function_14"};
pulseLink_function_17 = {systemChat "pulseLink_function_15"};
pulseLink_function_18 = {systemChat "pulseLink_function_16"};
pulseLink_function_19 = {systemChat "pulseLink_function_17"};
pulseLink_function_20 = {systemChat "pulseLink_function_18"};
pulseLink_function_21 = {systemChat "Hello world!";};
pulseLink_function_22 = {systemChat "pulseLink_function_22"};
pulseLink_function_23 = {systemChat "pulseLink_function_23"};
pulseLink_function_24 = {systemChat "pulseLink_function_24"};
pulseLink_function_25 = {systemChat "pulseLink_function_25"};
pulseLink_function_26 = {systemChat "pulseLink_function_26"};
pulseLink_function_27 = {systemChat "pulseLink_function_27"};
pulseLink_function_28 = {systemChat "pulseLink_function_28"};
pulseLink_function_29 = {systemChat "pulseLink_function_29"};
pulseLink_function_30 = {systemChat "pulseLink_function_30"};
pulseLink_function_31 = {systemChat "pulseLink_function_31"};
pulseLink_function_32 = {systemChat "pulseLink_function_32"};
pulseLink_function_33 = {systemChat "pulseLink_function_33"};