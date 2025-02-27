// Derive a 108 MHz clock from the 27 MHz system clock
module SysPLL ( 
        input sys_clk,
        input enable,
        output clk,
        output locked
    );

    // https://juj.github.io/gowin_fpga_code_generators/pll_calculator.html
    rPLL #(
        .DEVICE("GW2AR-18"),
        .FCLKIN("27"),
        .IDIV_SEL(0), // -> PFD = 27 MHz (range: 3-400 MHz)
        .FBDIV_SEL(3), // -> CLKOUT = 108 MHz (range: 3.125-600 MHz)
        .ODIV_SEL(8), // -> VCO = 864 MHz (range: 400-1200 MHz)
        .DYN_ODIV_SEL("false"),
        .DYN_FBDIV_SEL("false"),
        .DYN_IDIV_SEL("false"),
        .PSDA_SEL("0000"),
        .DYN_DA_EN("false"),
        .DUTYDA_SEL("1000"),
        .CLKOUT_FT_DIR(1'b1),
        .CLKOUTP_FT_DIR(1'b1),
        .CLKOUT_DLY_STEP(0),
        .CLKOUTP_DLY_STEP(0),
        .CLKFB_SEL("internal"),
        .CLKOUT_BYPASS("false"),
        .CLKOUTP_BYPASS("false"),
        .CLKOUTD_BYPASS("false"),
        .DYN_SDIV_SEL(2),
        .CLKOUTD_SRC("CLKOUT"),
        .CLKOUTD3_SRC("CLKOUT")
    ) pll (
        .CLKOUT(clk),
        .LOCK(locked),
        .CLKOUTP(),
        .CLKOUTD(),
        .CLKOUTD3(),
        .RESET(1'b0),
        .RESET_P(1'b0),
        .CLKIN(sys_clk),
        .CLKFB(1'b0),
        .FBDSEL(6'b00000),
        .IDSEL(6'b00000),
        .ODSEL(6'b0),
        .PSDA(4'b0),
        .DUTYDA(4'b0),
        .FDLY(4'b0)
    );

endmodule