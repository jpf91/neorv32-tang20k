export DESIGN_NAME = neorv32_ihp
export DESIGN_PATH := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
export PLATFORM    = ihp-sg13g2

export ADDITIONAL_LEFS += $(PLATFORM_DIR)/lef/RM_IHPSG13_1P_4096x8_c3_bm_bist.lef
export ADDITIONAL_LIBS += $(PLATFORM_DIR)/lib/RM_IHPSG13_1P_4096x8_c3_bm_bist_typ_1p20V_25C.lib
export ADDITIONAL_GDS += $(PLATFORM_DIR)/gds/RM_IHPSG13_1P_4096x8_c3_bm_bist.gds

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
	../../../src/hdl/core/neorv32_imem.vhd \
	../../../src/hdl/core/neorv32_dmem.vhd \
	../../../src/hdl/neorv32/neorv32_bootloader_image.vhd \
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

HDLDIR=$(DESIGN_PATH)src/hdl
NEORVDIR=$(DESIGN_PATH)lib/neorv32/rtl

export VERILOG_FILES = 
export VHDL_FILES = $(addprefix $(HDLDIR)/,$(APP_VHDL)) $(addprefix $(NEORVDIR)/,$(NEORV32_VHDL))
export VHDL_LIBRARY = neorv32
export SDC_FILE = $(DESIGN_PATH)constraint.sdc

export USE_FILL = 1

#export PLACE_DENSITY ?= 0.88
export CORE_UTILIZATION = 60
export TNS_END_PERCENT = 100