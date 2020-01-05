PROJECT := mx10-base
CONFIG  := m50

VHDL_FILES := mx10.vhd

PIN_ASSIGNMENTS := mx10-pins.tcl
PIN_ASSIGNMENTS += spider-baseboard-pins.tcl

ASSIGNMENT_FILES := $(PROJECT).qpf $(CONFIG).qsf $(PIN_ASSIGNMENTS)

OUTPUT_DIR := ./output_files

STAMP := echo done >
RM    := rm -f

QUARTUS := quartus
OPENOCD := openocd

.PHONY: all clean distclean

all: $(OUTPUT_DIR)/$(CONFIG).sof $(OUTPUT_DIR)/$(CONFIG).pof

distclean: clean
	$(RM) -r db incremental_db simulation
	$(RM) *~ *.bak

clean:
	$(RM) -r $(OUTPUT_DIR)
	$(RM) *~ *.rpt *.chg *.htm *.txt *.eqn *.pin *.sof *.pof *.summary

.PHONY: svf pgm cfg

pgm: $(OUTPUT_DIR)/$(CONFIG).pof.svf
	$(OPENOCD) -f mx10.ocd -c "svf $<" -c "shutdown"

cfg: $(OUTPUT_DIR)/$(CONFIG).sof.svf
	$(OPENOCD) -f mx10.ocd -c "svf $<" -c "shutdown"

svf: $(OUTPUT_DIR)/$(CONFIG).sof.svf $(OUTPUT_DIR)/$(CONFIG).pof.svf

QUARTUS_CPF := $(QUARTUS)_cpf --convert --frequency=5MHz --voltage=2.5V

%.pof.svf: %.pof $(OUTPUT_DIR)/$(CONFIG).asm.rpt
	$(QUARTUS_CPF) --operation=pb $< $@

%.sof.svf: %.sof $(OUTPUT_DIR)/$(CONFIG).asm.rpt
	$(QUARTUS_CPF) --operation=v $< $@

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
