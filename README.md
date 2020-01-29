# la-demo

Logic Analyzer inside an FPGA (Altera/Intel MAX10) for FOSDEM 2020 demo.

## Quick Start

The project is pre-configured to run on the
[MX10-U](https://www.aries-embedded.com/system-on-module/fpga/max-10-intel-fpga-mx10-som-adc-instant-on-freertos-linux)
module from ARIES Embedded GmbH, but can be easily ported to any other
hardware based on the Intel PSG (Altera) MAX10 FPGA or, with
adaptation of the JTAG interface part, to FPGA chips from other
families or vendors.

1. Install Intel PSG (Altera) development tools (Quartus)
   `quartus_{map,fit,asm,cpf}` executables should be in your
   `PATH`. Alternatively `QUARTUS` variable in the `Makefile` may be
   updated to point to the actual location of the tools

1. Run `make` command, if everything goes well in 1..2 minutes there
   will be a `.pof` and `.sof` files in the `./output_files/`
   subdirectory. These files may be used to configure or program
   hardware with Intel USB Blaster programmer

1. Additionally, the configuration files may be converted to an `SVF`
   format with `make svf` format and downloaded to the MX10 module
   using a built-in USB-to-JTAG interface and OpenOCD software. Proper
   OpenOCD command invocation may be performed with `make cfg` or
   `make pgm` commands

## User's Interface

The demo project provides an 8-bit pattern generator with two modes:
simple counter and linear-feedback shift register (LFSR). The modes
are switched with an SW4 push-button on the SpiderBase board and are
indicated with an amber LED. Output signals of the generator are
routed to the built-in logic analyzer and to the Pmod J4 connector.
The signals on the connector may be displayed with an attached Pmod
LED8 module.

Count rate of the pattern generator may be switched between a
single-step mode (controlled by SW3 push-button), 2Hz and system
frequency (25MHz). The switching is performed by pressing SW4 while
SW3 is depressed.

## Built-in Logic Analyzer

The analyzer control and status registers are accessible via the
module JTAG interface and may be exercised via OpenOCD interfacing to
the on-module USB-to-JTAG interface. An access to the registers may be
performed from an OpenOCD tcl script or via RPC interface from other
software, such as `pulseview` [sigrok](https://sigrok.org/).
