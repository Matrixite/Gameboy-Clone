// GameBoy FPGA Rev A — SAFE BOARD BRING-UP STUB
// This is NOT a Game Boy implementation. It deliberately leaves the cartridge
// inactive until you replace it with an LR35902/PPU/APU core and correct bus timing.
//
// Electrical rules:
//   * cart_a / control signals are FPGA-side 3.3 V signals feeding U2/U3/U4.
//   * cart_d is FPGA-side bidirectional data feeding U5.
//   * cart_res_od MUST be open-drain: drive 0 or Z only, never drive 1.
//   * U5 DATA_OE_N defaults high on the PCB via R3, preventing contention at power-up.

module gameboy_top (
    input  wire        clk_27m,
    output wire [15:0] cart_a,
    inout  wire [7:0]  cart_d,
    output wire        cart_phi,
    output wire        cart_wr_n,
    output wire        cart_rd_n,
    output wire        cart_cs_n,
    inout  wire        cart_res_od,
    output wire        cart_data_dir,
    output wire        cart_data_oe_n,
    inout  wire        btn_i2c_scl,
    inout  wire        btn_i2c_sda,
    output wire        audio_l_pwm,
    output wire        audio_r_pwm,
    output wire        spare0,
    output wire        spare1
);

    // Safe inactive cartridge bus.
    assign cart_a         = 16'h0000;
    assign cart_d         = 8'hZZ;
    assign cart_phi       = 1'b0;
    assign cart_wr_n      = 1'b1;
    assign cart_rd_n      = 1'b1;
    assign cart_cs_n      = 1'b1;
    assign cart_res_od    = 1'bz;  // open-drain release

    // U5: high = disabled. DIR=0 default selects cartridge->FPGA side when later enabled.
    assign cart_data_dir  = 1'b0;
    assign cart_data_oe_n = 1'b1;

    // PCF8574 I2C lines released. Add an I2C master in your core.
    assign btn_i2c_scl = 1'bz;
    assign btn_i2c_sda = 1'bz;

    assign audio_l_pwm = 1'b0;
    assign audio_r_pwm = 1'b0;
    assign spare0 = 1'b0;
    assign spare1 = 1'b0;

endmodule
