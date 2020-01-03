set_location_assignment PIN_B10 -to rstn
set_instance_assignment -name IO_STANDARD "3.3 V SCHMITT TRIGGER" -to rstn

set_location_assignment PIN_T12 -to led[0]
set_location_assignment PIN_T6 -to led[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led[1]

set_location_assignment PIN_T7 -to button[0]
set_location_assignment PIN_T13 -to button[1]
set_instance_assignment -name IO_STANDARD "3.3 V SCHMITT TRIGGER" -to button[0]
set_instance_assignment -name IO_STANDARD "3.3 V SCHMITT TRIGGER" -to button[1]

set_location_assignment PIN_B4 -to pmod_J2[0]; # IO8_RX49_P
set_location_assignment PIN_A5 -to pmod_J2[1]; # IO8_RX49_N
set_location_assignment PIN_L7 -to pmod_J2[2]; # IO3_TX3_P
set_location_assignment PIN_M6 -to pmod_J2[3]; # IO3_TX3_N
set_location_assignment PIN_A2 -to pmod_J2[4]; # IO8_RX51_N
set_location_assignment PIN_A3 -to pmod_J2[5]; # IO8_RX51_P
set_location_assignment PIN_P4 -to pmod_J2[6]; # IO3_TX1_N
set_location_assignment PIN_N5 -to pmod_J2[7]; # IO3_TX1_P

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J2[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J2[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J2[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J2[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J2[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J2[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J2[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J2[7]

set_location_assignment PIN_L8 -to pmod_J3[0]; # IO3_TX15_P
set_location_assignment PIN_M7 -to pmod_J3[1]; # IO3_TX15_N
set_location_assignment PIN_R6 -to pmod_J3[2]; # IO3_TX13_N
set_location_assignment PIN_R5 -to pmod_J3[3]; # IO3 TX13_P
set_location_assignment PIN_P5 -to pmod_J3[4]; # IO3_TX5_P
set_location_assignment PIN_R4 -to pmod_J3[5]; # IO3_TX5_N
set_location_assignment PIN_P6 -to pmod_J3[6]; # IO3_TX16_P
set_location_assignment PIN_R7 -to pmod_J3[7]; # IO3_TX16_N

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J3[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J3[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J3[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J3[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J3[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J3[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J3[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J3[7]

set_location_assignment PIN_P9  -to pmod_J4[0]; # IO3_TX18_N
set_location_assignment PIN_P8  -to pmod_J4[1]; # IO3_TX18_P
set_location_assignment PIN_P13 -to pmod_J4[2]; # IO4_TX37_N
set_location_assignment PIN_P12 -to pmod_J4[3]; # IO4_TX37_P
set_location_assignment PIN_T11 -to pmod_J4[4]; # IO3_TX22_N
set_location_assignment PIN_R10 -to pmod_J4[5]; # IO3_TX22_P
set_location_assignment PIN_M8  -to pmod_J4[6]; # IO3_TX20_N
set_location_assignment PIN_M9  -to pmod_J4[7]; # IO3_TX20_P

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J4[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J4[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J4[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J4[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J4[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J4[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J4[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J4[7]

set_location_assignment PIN_L10 -to pmod_J5[0]; # IO4_TX57_P
set_location_assignment PIN_M11 -to pmod_J5[1]; # IO4_TX57_N
set_location_assignment PIN_L9  -to pmod_J5[2]; # IO4_TX36_P
set_location_assignment PIN_M10 -to pmod_J5[3]; # IO4_TX36_N
set_location_assignment PIN_T9  -to pmod_J5[4]; # IO3_RX19_N
set_location_assignment PIN_R9  -to pmod_J5[5]; # IO3_RX19_P
set_location_assignment PIN_T8  -to pmod_J5[6]; # IO3_RX17_N
set_location_assignment PIN_R8  -to pmod_J5[7]; # IO3_RX17_P

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J5[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J5[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J5[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J5[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J5[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J5[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J5[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pmod_J5[7]
