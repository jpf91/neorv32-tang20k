####################################################################################################
# Configuration
####################################################################################################
GOWIN_FAMILY = GW2A-18C
GOWIN_DEVICE = GW2AR-LV18QN88C8/I7
BOARD = tangnano20k

TOP_MODULE = top
DESIGN = top
APP_VERILOG = 
APP_VHDL = LEDBlink.vhd \
	BTNReset.vhd \
	top.vhd

NEORV32_VHDL = core/neorv32_package.vhd \
	core/neorv32_sys.vhd \
	core/neorv32_clockgate.vhd \
	core/neorv32_fifo.vhd \
	core/neorv32_cpu_decompressor.vhd \
	core/neorv32_cpu_control.vhd \
	core/neorv32_cpu_regfile.vhd \
	core/neorv32_cpu_cp_shifter.vhd \
	core/neorv32_cpu_cp_muldiv.vhd \
	core/neorv32_cpu_cp_bitmanip.vhd \
	core/neorv32_cpu_cp_fpu.vhd \
	core/neorv32_cpu_cp_cfu.vhd \
	core/neorv32_cpu_cp_cond.vhd \
	core/neorv32_cpu_cp_crypto.vhd \
	core/neorv32_cpu_alu.vhd \
	core/neorv32_cpu_lsu.vhd \
	core/neorv32_cpu_pmp.vhd \
	core/neorv32_cpu.vhd \
	core/neorv32_bus.vhd \
	core/neorv32_cache.vhd \
	core/neorv32_dma.vhd \
	core/neorv32_application_image.vhd \
	core/neorv32_imem.vhd \
	core/neorv32_dmem.vhd \
	../../../src/hdl/neorv32_bootloader_image.vhd \
	core/neorv32_boot_rom.vhd \
	core/neorv32_xip.vhd \
	core/neorv32_xbus.vhd \
	core/neorv32_cfs.vhd \
	core/neorv32_sdi.vhd \
	core/neorv32_gpio.vhd \
	core/neorv32_wdt.vhd \
	core/neorv32_mtime.vhd \
	core/neorv32_uart.vhd \
	core/neorv32_spi.vhd \
	core/neorv32_twi.vhd \
	core/neorv32_pwm.vhd \
	core/neorv32_trng.vhd \
	core/neorv32_neoled.vhd \
	core/neorv32_xirq.vhd \
	core/neorv32_gptmr.vhd \
	core/neorv32_onewire.vhd \
	core/neorv32_slink.vhd \
	core/neorv32_crc.vhd \
	core/neorv32_sysinfo.vhd \
	core/neorv32_debug_dtm.vhd \
	core/neorv32_debug_auth.vhd \
	core/neorv32_debug_dm.vhd \
	core/neorv32_top.vhd

SIMULATION_SETS = i2s_master \
    sine_generator clock_generator fpga_soc_top fpga_standalone_top

NTHREADS ?= 4

####################################################################################################
# Abbreviations
####################################################################################################
OBJDIR=build
RPTDIR=$(OBJDIR)/rpt
SRCDIR=src
CONDIR=$(SRCDIR)/constraints
HDLDIR=$(SRCDIR)/hdl
NEORVDIR=lib/neorv32/rtl

####################################################################################################
# Generated variables
####################################################################################################
SIM_SETS=$(addsuffix .sim,$(SIMULATION_SETS))
SYN_VERILOG_PATHS=$(addprefix $(HDLDIR)/,$(APP_VERILOG))
SYN_VHDL_PATHS=$(addprefix $(HDLDIR)/,$(APP_VHDL)) $(addprefix $(NEORVDIR)/,$(NEORV32_VHDL))

QUIET_FLAG=
ifeq ($(strip $(VERBOSE)),)
	QUIET_FLAG=-q
endif

####################################################################################################
# Tool Commands
####################################################################################################
SCRIPT_SUMMARY="$(abspath ./script/summary.py)"

####################################################################################################
# Rules
####################################################################################################
.PHONY: all synth pnr bitstream summary upload
.PRECIOUS: $(OBJDIR)/%.syn.json $(OBJDIR)/%.pnr.json

# High-level wrapper targets
all: bitstream summary
sim: $(SIM_SETS)

clean:
	rm -rf $(OBJDIR)

synth: $(OBJDIR)/$(DESIGN).syn.json

pnr: $(OBJDIR)/$(DESIGN).pnr.json

bitstream: $(OBJDIR)/$(DESIGN).fs

summary: $(RPTDIR)/$(DESIGN).pnr.json
	@echo
	@echo ========================== Device Summary ==========================
	@echo
	@$(SCRIPT_SUMMARY) $<

upload: $(OBJDIR)/$(DESIGN).fs
	openFPGALoader -b $(BOARD) $<

upload-flash: $(OBJDIR)/$(DESIGN).fs
	openFPGALoader -b $(BOARD) -f $<

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(RPTDIR):
	mkdir -p $(RPTDIR)


####################################################################################################
# Automatic rule patterns: Create output(s) from input(s)
####################################################################################################

# Synthesis. TODO: Support multiple source sets / targets?
$(OBJDIR)/%.syn.json: $(SYN_VERILOG_PATHS) $(SYN_VHDL_PATHS) | $(OBJDIR) $(RPTDIR)
	yosys -m ghdl -p "ghdl --work=neorv32 $(SYN_VHDL_PATHS) -e $(TOP_MODULE); synth_gowin -top $(TOP_MODULE) -json $@" \
	  $(QUIET_FLAG) -l $(RPTDIR)/$*.syn.log --detailed-timing

# Place and route
$(OBJDIR)/%.pnr.json $(RPTDIR)/%.pnr.json &: $(OBJDIR)/%.syn.json $(CONDIR)/%.cst $(CONDIR)/%.py | $(OBJDIR) $(RPTDIR) 
	nextpnr-himbaechel --device $(GOWIN_DEVICE) --json $(OBJDIR)/$*.syn.json --write $(OBJDIR)/$*.pnr.json \
	  --report $(RPTDIR)/$*.pnr.json --vopt family=$(GOWIN_FAMILY) \
	  --vopt cst=$(CONDIR)/$*.cst --pre-pack $(CONDIR)/$*.py $(QUIET_FLAG) -l $(RPTDIR)/$*.pnr.log \
	  --threads $(NTHREADS) --detailed-timing-report

# Bitstream generation / Packing
$(OBJDIR)/%.fs: $(OBJDIR)/%.pnr.json | $(OBJDIR)
	gowin_pack -d $(GOWIN_FAMILY) -o $@ $<
