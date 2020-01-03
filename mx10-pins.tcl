set_location_assignment PIN_H3 -to altera_reserved_tck
set_location_assignment PIN_G1 -to altera_reserved_tdi
set_location_assignment PIN_H1 -to altera_reserved_tdo
set_location_assignment PIN_H2 -to altera_reserved_tms
set_instance_assignment -name IO_STANDARD "2.5 V" -to altera_reserved_tck
set_instance_assignment -name IO_STANDARD "2.5 V" -to altera_reserved_tdi
set_instance_assignment -name IO_STANDARD "2.5 V" -to altera_reserved_tdo
set_instance_assignment -name IO_STANDARD "2.5 V" -to altera_reserved_tms

set_location_assignment PIN_J12 -to clk25
set_instance_assignment -name IO_STANDARD "1.5 V SCHMITT TRIGGER" -to clk25

set_location_assignment PIN_F9 -to clko1
set_instance_assignment -name IO_STANDARD "3.3 V SCHMITT TRIGGER" -to clko1

set_location_assignment PIN_E7 -to led_green
set_location_assignment PIN_C5 -to led_amber
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led_green
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led_amber

set_location_assignment PIN_J3 -to scl
set_location_assignment PIN_J2 -to sda
set_instance_assignment -name IO_STANDARD "2.5 V SCHMITT TRIGGER" -to scl
set_instance_assignment -name IO_STANDARD "2.5 V SCHMITT TRIGGER" -to sda

set_location_assignment PIN_K5 -to spi_sclk
set_location_assignment PIN_L2 -to spi_mosi
set_location_assignment PIN_L6 -to spi_miso
set_location_assignment PIN_N1 -to spi_ss_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_miso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_sclk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_ss_n

set_location_assignment PIN_H6 -to dbg_txd
set_location_assignment PIN_J5 -to dbg_rxd
set_instance_assignment -name IO_STANDARD "2.5 V" -to dbg_txd
set_instance_assignment -name IO_STANDARD "2.5 V" -to dbg_rxd

set_location_assignment PIN_M2 -to sd_vsel
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sd_vsel

set_location_assignment PIN_B13 -to sd_clk
set_location_assignment PIN_E10 -to sd_cmd
set_location_assignment PIN_D12 -to sd_dat0
set_location_assignment PIN_C13 -to sd_dat1
set_location_assignment PIN_E11 -to sd_dat2
set_location_assignment PIN_C12 -to sd_dat3
set_location_assignment PIN_A13 -to sd_rstn

set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to sd_cmd
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to sd_dat0
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to sd_dat1
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to sd_dat2
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to sd_dat3
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to sd_rstn

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sd_clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sd_cmd
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sd_dat0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sd_dat1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sd_dat2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sd_dat3
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sd_rstn

# set_instance_assignment -name IO_STANDARD "1.8 V" -to sd_clk
# set_instance_assignment -name IO_STANDARD "1.8 V" -to sd_cmd
# set_instance_assignment -name IO_STANDARD "1.8 V" -to sd_dat0
# set_instance_assignment -name IO_STANDARD "1.8 V" -to sd_dat1
# set_instance_assignment -name IO_STANDARD "1.8 V" -to sd_dat2
# set_instance_assignment -name IO_STANDARD "1.8 V" -to sd_dat3
# set_instance_assignment -name IO_STANDARD "1.8 V" -to sd_rstn
