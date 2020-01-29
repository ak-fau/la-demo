DUT := data_gen
TB  := $(DUT)_tb

TRACE := $(TB).ghw
SIM_TIME := 22us

vpath %.vhd .:..

VHDL_FILES := $(DUT).vhd $(TB).vhd

O_FILES := $(VHDL_FILES:.vhd=.o)

RM := rm -f
GHDL := ghdl
VHDL_STD  := --ieee=standard --std=02
GTKWAVE := gtkwave

.PHONY: all clean trace view

all: $(TRACE)

view: $(TRACE)
	$(GTKWAVE) -A $(TRACE)

clean:
	$(RM) $(TRACE)
	$(GHDL) --remove

$(TRACE): $(TB)
	$(GHDL) -r $(TB) --stop-time=$(SIM_TIME) --wave=$@

%.o: %.vhd
	$(GHDL) -a $(VHDL_STD) $<

$(TB): $(O_FILES)
	$(GHDL) -e -o $@ $(TB)
