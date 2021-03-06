PROJECT := mx10-base
CONFIG  := m50

VHDL_FILES := mx10.vhd
VHDL_FILES += la.vhd
VHDL_FILES += vjtag_registers.vhd
VHDL_FILES += la_trigger.vhd la_control.vhd
VHDL_FILES += clk_div.vhd data_gen.vhd debounce.vhd

PIN_ASSIGNMENTS := mx10-pins.tcl
PIN_ASSIGNMENTS += spider-baseboard-pins.tcl

ASSIGNMENT_FILES := $(PROJECT).qpf $(CONFIG).qsf $(PIN_ASSIGNMENTS)

OUTPUT_DIR := ./output_files

STAMP := echo done >
RM    := rm -f

QUARTUS := quartus

D := /usr/bin/docker

OPENOCD := openocd
OCD_HW_CONFIG := mx10.ocd
OCD_SVF_CMD = "svf -quiet -progress $<"
OCD_COMMAND = $(OPENOCD) -f $(OCD_HW_CONFIG) -c $(OCD_SVF_CMD) -c "shutdown"

.PHONY: all sim view clean simclean distclean

all: $(OUTPUT_DIR)/$(CONFIG).sof $(OUTPUT_DIR)/$(CONFIG).pof

distclean: clean simclean
	$(RM) -r db incremental_db simulation
	$(RM) *~ *.bak

clean:
	$(RM) -r $(OUTPUT_DIR)
	$(RM) *~ *.rpt *.chg *.htm *.txt *.eqn *.pin *.sof *.pof *.summary

sim:
	$(MAKE) -C sim

view:
	$(MAKE) -C sim view

simclean:
	$(MAKE) -C sim clean

.PHONY: vjtag_test vjtag_server

vjtag_test vjtag_server:
	-$(OPENOCD) -f $(OCD_HW_CONFIG) -f $@.ocd

.PHONY: docker

docker: asm.chg fit.chg map.chg
	D=$(D); \
	P=$(notdir $(PWD)); \
	C=$(shell $(D) run --rm -it -e DISPLAY=$${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix -d quartus); \
	(cd .. && $${D} cp $${P} $${C}:/home/quartus); \
	$${D} exec $${C} /bin/bash -l -c "make -C $${P} svf"; \
	$${D} cp $${C}:/home/quartus/$${P}/output_files ./output_files; \
	$${D} stop $${C}

.PHONY: svf pgm cfg

pgm: $(OUTPUT_DIR)/$(CONFIG)_pof.svf
	$(OCD_COMMAND)

cfg: $(OUTPUT_DIR)/$(CONFIG).svf
	$(OCD_COMMAND)

svf: $(OUTPUT_DIR)/$(CONFIG).svf $(OUTPUT_DIR)/$(CONFIG)_pof.svf

%_pof.svf: $(OUTPUT_DIR)/$(CONFIG).asm.rpt
	@true

%.svf: $(OUTPUT_DIR)/$(CONFIG).asm.rpt
	sed -i -e "/SIR 10 TDI (2CC)/,/SIR 10 TDI (002)/d" $@

$(OUTPUT_DIR)/$(CONFIG).sof: asm
$(OUTPUT_DIR)/$(CONFIG).pof: asm

.PHONY: map fit asm sta
map: $(OUTPUT_DIR)/$(CONFIG).map.rpt
fit: $(OUTPUT_DIR)/$(CONFIG).fit.rpt
asm: $(OUTPUT_DIR)/$(CONFIG).asm.rpt
sta: $(OUTPUT_DIR)/$(CONFIG).sta.rpt

Q_ARGS   := --write_settings_file=off $(PROJECT) -c $(CONFIG)

MAP_ARGS := --read_settings_file=on  $(Q_ARGS)
FIT_ARGS := --read_settings_file=off $(Q_ARGS)
ASM_ARGS := --read_settings_file=off $(Q_ARGS)
STA_ARGS := $(PROJECT)

$(OUTPUT_DIR)/$(CONFIG).map.rpt: map.chg $(VHDL_FILES)
	$(QUARTUS)_map $(MAP_ARGS)
	$(STAMP) fit.chg

$(OUTPUT_DIR)/$(CONFIG).fit.rpt: fit.chg $(OUTPUT_DIR)/$(CONFIG).map.rpt $(PIN_ASSIGNMENTS)
	$(QUARTUS)_fit $(FIT_ARGS)
	$(STAMP) asm.chg
	$(STAMP) sta.chg

$(OUTPUT_DIR)/$(CONFIG).asm.rpt: asm.chg $(OUTPUT_DIR)/$(CONFIG).fit.rpt
	$(QUARTUS)_asm $(ASM_ARGS)

$(OUTPUT_DIR)/$(CONFIG).sta.rpt: sta.chg $(OUTPUT_DIR)/$(CONFIG).fit.rpt
	$(QUARTUS)_sta $(STA_ARGS)

map.chg:
	$(STAMP) map.chg
fit.chg:
	$(STAMP) fit.chg
sta.chg:
	$(STAMP) sta.chg
asm.chg:
	$(STAMP) asm.chg
