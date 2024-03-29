# Copyright (C) 2021 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause

############################################################################
##
##   HTG-ZRF4-XUP Rev0.2 - Minimal XDC 07/27/2020
##
##   This *.xdc file combines the constraints from:
##   HTG 2020 design, DC-Eval, Radio ML and uses ZCU111 Master as reference
##
##   Includes:
##   Display Port, LEDs, RGBLEDs, push buttons, dip switches, DDR4, PMODs
##
############################################################################

## control
set_property PACKAGE_PIN AT9      [get_ports "lmk_reset[0]"]
set_property IOSTANDARD LVCMOS18  [get_ports "lmk_reset[0]"]
set_property PACKAGE_PIN AR13     [get_ports "syzygy_vio_en[0]"]
set_property IOSTANDARD LVCMOS18  [get_ports "syzygy_vio_en[0]"]

## lmk4832 clocks - 16MHz, 122.88MHz
#set_property PACKAGE_PIN AN11 [get_ports "lmk_clk1_clk_p"]
#set_property IOSTANDARD DIFF_HSTL_I_12 [get_ports "lmk_clk1_clk_p"]
#set_property PACKAGE_PIN AP18 [get_ports "lmk_clk2_clk_p"]
#set_property IOSTANDARD DIFF_HSTL_I_12 [get_ports "lmk_clk2_clk_p"]

set_property PACKAGE_PIN AN11 [get_ports "fpga_refclk_in_clk_p"]
set_property PACKAGE_PIN AP11 [get_ports "fpga_refclk_in_clk_n"]
set_property IOSTANDARD DIFF_HSTL_I_12 [get_ports "fpga_refclk_in_clk_p"]
set_property IOSTANDARD DIFF_HSTL_I_12 [get_ports "fpga_refclk_in_clk_n"]

set_property PACKAGE_PIN AP18 [get_ports "pl_sysref_clk_p"]
set_property PACKAGE_PIN AR18 [get_ports "pl_sysref_clk_n"]
set_property IOSTANDARD DIFF_HSTL_I_12 [get_ports "pl_sysref_clk_p"]
set_property IOSTANDARD DIFF_HSTL_I_12 [get_ports "pl_sysref_clk_n"]

## display port
set_property PACKAGE_PIN AF19     [get_ports "dp_aux_data_in"]
set_property PACKAGE_PIN AF20     [get_ports "dp_aux_data_oe[0]"]
set_property PACKAGE_PIN AG18     [get_ports "dp_aux_data_out"]
set_property PACKAGE_PIN AH18     [get_ports "dp_hot_plug_detect"]
set_property IOSTANDARD LVCMOS18  [get_ports "dp_hot_plug_detect"]
set_property IOSTANDARD LVCMOS18  [get_ports "dp_aux_data_out"]
set_property IOSTANDARD LVCMOS18  [get_ports "dp_aux_data_oe[0]"]
set_property IOSTANDARD LVCMOS18  [get_ports "dp_aux_data_in"]

## leds, rgbleds
set_property PACKAGE_PIN AW11     [get_ports {rgbleds_6bits[0]}]; # blue
set_property PACKAGE_PIN AT11     [get_ports {rgbleds_6bits[1]}]; # green
set_property PACKAGE_PIN AV11     [get_ports {rgbleds_6bits[2]}]; # red
set_property PACKAGE_PIN AR11     [get_ports {rgbleds_6bits[3]}]; # blue
set_property PACKAGE_PIN AN12     [get_ports {rgbleds_6bits[4]}]; # green
set_property PACKAGE_PIN AN13     [get_ports {rgbleds_6bits[5]}]; # red
set_property IOSTANDARD LVCMOS18  [get_ports {rgbleds_6bits[?]}];
set_property PACKAGE_PIN AR12     [get_ports {leds_4bits[0]}];
set_property PACKAGE_PIN AT12     [get_ports {leds_4bits[1]}];
set_property PACKAGE_PIN AV12     [get_ports {leds_4bits[2]}];
set_property PACKAGE_PIN AU12     [get_ports {leds_4bits[3]}];
set_property IOSTANDARD LVCMOS18  [get_ports {leds_4bits[?]}];

## push buttons, dip switches
set_property PACKAGE_PIN AM7      [get_ports {push_button_4bits[0]}];
set_property PACKAGE_PIN AM8      [get_ports {push_button_4bits[1]}];
set_property PACKAGE_PIN AN8      [get_ports {push_button_4bits[2]}];
set_property PACKAGE_PIN AP8      [get_ports {push_button_4bits[3]}];
set_property IOSTANDARD LVCMOS18  [get_ports {push_button_4bits[?]}];
set_property PACKAGE_PIN AT10     [get_ports {dip_switch_4bits[0]}];
set_property PACKAGE_PIN AU10     [get_ports {dip_switch_4bits[1]}];
set_property PACKAGE_PIN AV10     [get_ports {dip_switch_4bits[2]}];
set_property PACKAGE_PIN AW10     [get_ports {dip_switch_4bits[3]}];
set_property IOSTANDARD LVCMOS18  [get_ports {dip_switch_4bits[?]}];

## pmod0, pmod1
set_property PACKAGE_PIN AT16 [get_ports {pmod0[0]}]
set_property PACKAGE_PIN AW16 [get_ports {pmod0[1]}]
set_property PACKAGE_PIN AV16 [get_ports {pmod0[2]}]
set_property PACKAGE_PIN AU15 [get_ports {pmod0[3]}]
set_property PACKAGE_PIN AV13 [get_ports {pmod0[4]}]
set_property PACKAGE_PIN AU13 [get_ports {pmod0[5]}]
set_property PACKAGE_PIN AU14 [get_ports {pmod0[6]}]
set_property PACKAGE_PIN AT15 [get_ports {pmod0[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {pmod0[?]}]
set_property PULLUP true [get_ports {pmod0[2]}]
set_property PULLUP true [get_ports {pmod0[3]}]
set_property PULLUP true [get_ports {pmod0[6]}]
set_property PULLUP true [get_ports {pmod0[7]}]

set_property PACKAGE_PIN AJ15 [get_ports {pmod1[0]}]
set_property PACKAGE_PIN AL15 [get_ports {pmod1[1]}]
set_property PACKAGE_PIN AJ16 [get_ports {pmod1[2]}]
set_property PACKAGE_PIN AK16 [get_ports {pmod1[3]}]
set_property PACKAGE_PIN AM17 [get_ports {pmod1[4]}]
set_property PACKAGE_PIN AP15 [get_ports {pmod1[5]}]
set_property PACKAGE_PIN AL16 [get_ports {pmod1[6]}]
set_property PACKAGE_PIN AK17 [get_ports {pmod1[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {pmod1[?]}]
set_property PULLUP true [get_ports {pmod1[2]}]
set_property PULLUP true [get_ports {pmod1[3]}]
set_property PULLUP true [get_ports {pmod1[6]}]
set_property PULLUP true [get_ports {pmod1[7]}]

## PL ddr4
set_property PACKAGE_PIN G13 [get_ports "sys_clk_ddr4_clk_p"]
set_property IOSTANDARD DIFF_HSTL_I_12 [get_ports "sys_clk_ddr4_clk_p"]
create_clock -period 5.000 -name sys_clk_ddr4 [get_ports "sys_clk_ddr4_clk_p"]
set_property PACKAGE_PIN H6       [get_ports "ddr4_pl_adr[0]"]
set_property PACKAGE_PIN G7       [get_ports "ddr4_pl_adr[1]"]
set_property PACKAGE_PIN B13      [get_ports "ddr4_pl_adr[2]"]
set_property PACKAGE_PIN F10      [get_ports "ddr4_pl_adr[3]"]
set_property PACKAGE_PIN F11      [get_ports "ddr4_pl_adr[4]"]
set_property PACKAGE_PIN D13      [get_ports "ddr4_pl_adr[5]"]
set_property PACKAGE_PIN J7       [get_ports "ddr4_pl_adr[6]"]
set_property PACKAGE_PIN A15      [get_ports "ddr4_pl_adr[7]"]
set_property PACKAGE_PIN A12      [get_ports "ddr4_pl_adr[8]"]
set_property PACKAGE_PIN A14      [get_ports "ddr4_pl_adr[9]"]
set_property PACKAGE_PIN H11      [get_ports "ddr4_pl_adr[10]"]
set_property PACKAGE_PIN A11      [get_ports "ddr4_pl_adr[11]"]
set_property PACKAGE_PIN E12      [get_ports "ddr4_pl_adr[12]"]
set_property PACKAGE_PIN B14      [get_ports "ddr4_pl_adr[13]"]
set_property PACKAGE_PIN K13      [get_ports "ddr4_pl_adr[14]"]
set_property PACKAGE_PIN D14      [get_ports "ddr4_pl_adr[15]"]
set_property PACKAGE_PIN E13      [get_ports "ddr4_pl_adr[16]"]

set_property PACKAGE_PIN H13      [get_ports "ddr4_pl_act_n"]
#set_property PACKAGE_PIN G8      [get_ports "ddr4_pl_alert_n"]
set_property PACKAGE_PIN E14      [get_ports "ddr4_pl_ba[0]"]
set_property PACKAGE_PIN H10      [get_ports "ddr4_pl_ba[1]"]
set_property PACKAGE_PIN H12      [get_ports "ddr4_pl_bg[0]"]
#set_property PACKAGE_PIN D11     [get_ports "ddr4_pl_bg[1]"]

set_property PACKAGE_PIN J10       [get_ports "ddr4_pl_ck_c[0]"]
set_property PACKAGE_PIN J11       [get_ports "ddr4_pl_ck_t[0]"]

#set_property PACKAGE_PIN J13       [get_ports "ddr4_pl_ck_c[1]"]
#set_property PACKAGE_PIN J14       [get_ports "ddr4_pl_ck_t[1]"]

set_property PACKAGE_PIN F12   [get_ports "ddr4_pl_cke[0]"]
#set_property PACKAGE_PIN A15   [get_ports "ddr4_pl_cke[1]"]

set_property PACKAGE_PIN E11   [get_ports "ddr4_pl_cs_n[0]"]
#set_property PACKAGE_PIN E14   [get_ports "ddr4_pl_cs_n[1]"]
#set_property PACKAGE_PIN K11   [get_ports "ddr4_pl_cs_n[2]"]
#set_property PACKAGE_PIN F12   [get_ports "ddr4_pl_cs_n[3]"]

set_property PACKAGE_PIN J15   [get_ports "ddr4_pl_dm_n[0]"]
set_property PACKAGE_PIN N14   [get_ports "ddr4_pl_dm_n[1]"]
set_property PACKAGE_PIN D18   [get_ports "ddr4_pl_dm_n[2]"]
set_property PACKAGE_PIN G17   [get_ports "ddr4_pl_dm_n[3]"]
set_property PACKAGE_PIN F21   [get_ports "ddr4_pl_dm_n[4]"]
set_property PACKAGE_PIN J23   [get_ports "ddr4_pl_dm_n[5]"]
set_property PACKAGE_PIN C23   [get_ports "ddr4_pl_dm_n[6]"]
set_property PACKAGE_PIN N20   [get_ports "ddr4_pl_dm_n[7]"]
#set_property PACKAGE_PIN J8   [get_ports "ddr4_pl_dm_n[8]"]

set_property PACKAGE_PIN H17      [get_ports "ddr4_pl_dq[0]"]
set_property PACKAGE_PIN J16      [get_ports "ddr4_pl_dq[1]"]
set_property PACKAGE_PIN H16      [get_ports "ddr4_pl_dq[2]"]
set_property PACKAGE_PIN K16      [get_ports "ddr4_pl_dq[3]"]
set_property PACKAGE_PIN J18      [get_ports "ddr4_pl_dq[4]"]
set_property PACKAGE_PIN K17      [get_ports "ddr4_pl_dq[5]"]
set_property PACKAGE_PIN J19      [get_ports "ddr4_pl_dq[6]"]
set_property PACKAGE_PIN L17      [get_ports "ddr4_pl_dq[7]"]

set_property PACKAGE_PIN N17      [get_ports "ddr4_pl_dq[8]"]
set_property PACKAGE_PIN M13      [get_ports "ddr4_pl_dq[9]"]
set_property PACKAGE_PIN M15      [get_ports "ddr4_pl_dq[10]"]
set_property PACKAGE_PIN M12      [get_ports "ddr4_pl_dq[11]"]
set_property PACKAGE_PIN M17      [get_ports "ddr4_pl_dq[12]"]
set_property PACKAGE_PIN L12      [get_ports "ddr4_pl_dq[13]"]
set_property PACKAGE_PIN N15      [get_ports "ddr4_pl_dq[14]"]
set_property PACKAGE_PIN N13      [get_ports "ddr4_pl_dq[15]"]

set_property PACKAGE_PIN A19      [get_ports "ddr4_pl_dq[16]"]
set_property PACKAGE_PIN A16      [get_ports "ddr4_pl_dq[17]"]
set_property PACKAGE_PIN C17      [get_ports "ddr4_pl_dq[18]"]
set_property PACKAGE_PIN C16      [get_ports "ddr4_pl_dq[19]"]
set_property PACKAGE_PIN B19      [get_ports "ddr4_pl_dq[20]"]
set_property PACKAGE_PIN D16      [get_ports "ddr4_pl_dq[21]"]
set_property PACKAGE_PIN A17      [get_ports "ddr4_pl_dq[22]"]
set_property PACKAGE_PIN D15      [get_ports "ddr4_pl_dq[23]"]

set_property PACKAGE_PIN E18      [get_ports "ddr4_pl_dq[24]"]
set_property PACKAGE_PIN F16      [get_ports "ddr4_pl_dq[25]"]
set_property PACKAGE_PIN E17      [get_ports "ddr4_pl_dq[26]"]
set_property PACKAGE_PIN G15      [get_ports "ddr4_pl_dq[27]"]
set_property PACKAGE_PIN G18      [get_ports "ddr4_pl_dq[28]"]
set_property PACKAGE_PIN F15      [get_ports "ddr4_pl_dq[29]"]
set_property PACKAGE_PIN E16      [get_ports "ddr4_pl_dq[30]"]
set_property PACKAGE_PIN H18      [get_ports "ddr4_pl_dq[31]"]

set_property PACKAGE_PIN E24      [get_ports "ddr4_pl_dq[32]"]
set_property PACKAGE_PIN D21      [get_ports "ddr4_pl_dq[33]"]
set_property PACKAGE_PIN E22      [get_ports "ddr4_pl_dq[34]"]
set_property PACKAGE_PIN E21      [get_ports "ddr4_pl_dq[35]"]
set_property PACKAGE_PIN F24      [get_ports "ddr4_pl_dq[36]"]
set_property PACKAGE_PIN F20      [get_ports "ddr4_pl_dq[37]"]
set_property PACKAGE_PIN E23      [get_ports "ddr4_pl_dq[38]"]
set_property PACKAGE_PIN G20      [get_ports "ddr4_pl_dq[39]"]

set_property PACKAGE_PIN K24      [get_ports "ddr4_pl_dq[40]"]
set_property PACKAGE_PIN G22      [get_ports "ddr4_pl_dq[41]"]
set_property PACKAGE_PIN J21      [get_ports "ddr4_pl_dq[42]"]
set_property PACKAGE_PIN G23      [get_ports "ddr4_pl_dq[43]"]
set_property PACKAGE_PIN L24      [get_ports "ddr4_pl_dq[44]"]
set_property PACKAGE_PIN H22      [get_ports "ddr4_pl_dq[45]"]
set_property PACKAGE_PIN H23      [get_ports "ddr4_pl_dq[46]"]
set_property PACKAGE_PIN H21      [get_ports "ddr4_pl_dq[47]"]

set_property PACKAGE_PIN C21      [get_ports "ddr4_pl_dq[48]"]
set_property PACKAGE_PIN A24      [get_ports "ddr4_pl_dq[49]"]
set_property PACKAGE_PIN C22      [get_ports "ddr4_pl_dq[50]"]
set_property PACKAGE_PIN B24      [get_ports "ddr4_pl_dq[51]"]
set_property PACKAGE_PIN B20      [get_ports "ddr4_pl_dq[52]"]
set_property PACKAGE_PIN A21      [get_ports "ddr4_pl_dq[53]"]
set_property PACKAGE_PIN C20      [get_ports "ddr4_pl_dq[54]"]
set_property PACKAGE_PIN A20      [get_ports "ddr4_pl_dq[55]"]

set_property PACKAGE_PIN M20      [get_ports "ddr4_pl_dq[56]"]
set_property PACKAGE_PIN L20      [get_ports "ddr4_pl_dq[57]"]
set_property PACKAGE_PIN L22      [get_ports "ddr4_pl_dq[58]"]
set_property PACKAGE_PIN L21      [get_ports "ddr4_pl_dq[59]"]
set_property PACKAGE_PIN N19      [get_ports "ddr4_pl_dq[60]"]
set_property PACKAGE_PIN M19      [get_ports "ddr4_pl_dq[61]"]
set_property PACKAGE_PIN L23      [get_ports "ddr4_pl_dq[62]"]
set_property PACKAGE_PIN L19      [get_ports "ddr4_pl_dq[63]"]

#set_property PACKAGE_PIN F9      [get_ports "ddr4_pl_dq[64]"]
#set_property PACKAGE_PIN G7      [get_ports "ddr4_pl_dq[65]"]
#set_property PACKAGE_PIN H6      [get_ports "ddr4_pl_dq[66]"]
#set_property PACKAGE_PIN G6      [get_ports "ddr4_pl_dq[67]"]
#set_property PACKAGE_PIN G9      [get_ports "ddr4_pl_dq[68]"]
#set_property PACKAGE_PIN H7      [get_ports "ddr4_pl_dq[69]"]
#set_property PACKAGE_PIN K9      [get_ports "ddr4_pl_dq[70]"]
#set_property PACKAGE_PIN J9      [get_ports "ddr4_pl_dq[71]"]

set_property PACKAGE_PIN K18       [get_ports "ddr4_pl_dqs_c[0]"]
set_property PACKAGE_PIN L14       [get_ports "ddr4_pl_dqs_c[1]"]
set_property PACKAGE_PIN B17       [get_ports "ddr4_pl_dqs_c[2]"]
set_property PACKAGE_PIN F19       [get_ports "ddr4_pl_dqs_c[3]"]
set_property PACKAGE_PIN D24       [get_ports "ddr4_pl_dqs_c[4]"]
set_property PACKAGE_PIN H20       [get_ports "ddr4_pl_dqs_c[5]"]
set_property PACKAGE_PIN A22       [get_ports "ddr4_pl_dqs_c[6]"]
set_property PACKAGE_PIN K22       [get_ports "ddr4_pl_dqs_c[7]"]
#set_property PACKAGE_PIN G8       [get_ports "ddr4_pl_dqs_c[8]"]

set_property PACKAGE_PIN K19       [get_ports "ddr4_pl_dqs_t[0]"]
set_property PACKAGE_PIN L15       [get_ports "ddr4_pl_dqs_t[1]"]
set_property PACKAGE_PIN B18       [get_ports "ddr4_pl_dqs_t[2]"]
set_property PACKAGE_PIN G19       [get_ports "ddr4_pl_dqs_t[3]"]
set_property PACKAGE_PIN D23       [get_ports "ddr4_pl_dqs_t[4]"]
set_property PACKAGE_PIN J20       [get_ports "ddr4_pl_dqs_t[5]"]
set_property PACKAGE_PIN B22       [get_ports "ddr4_pl_dqs_t[6]"]
set_property PACKAGE_PIN K21       [get_ports "ddr4_pl_dqs_t[7]"]
#set_property PACKAGE_PIN H8       [get_ports "ddr4_pl_dqs_t[8]"]

set_property PACKAGE_PIN F14    [get_ports "ddr4_pl_odt[0]"]
#set_property PACKAGE_PIN H11   [get_ports "ddr4_pl_odt[1]"]
#set_property PACKAGE_PIN B12   [get_ports "ddr4_pl_par"]
set_property PACKAGE_PIN G6     [get_ports "ddr4_pl_reset_n"]
#set_property PACKAGE_PIN G14   [get_ports "ddr4_event_n"]

## SYZYGY expansion connector - bank 84 and bank 87
set_property PACKAGE_PIN AT7  [get_ports {syzygy_std0_tri_io[0]}];   # S0_D0P, Pin 5
set_property PACKAGE_PIN F6   [get_ports {syzygy_std0_tri_io[1]}];   # S1_D1P, Pin 6
set_property PACKAGE_PIN AT6  [get_ports {syzygy_std0_tri_io[2]}];   # S2_D0N, Pin 7
set_property PACKAGE_PIN E6   [get_ports {syzygy_std0_tri_io[3]}];   # S3_D1N, Pin 8
set_property PACKAGE_PIN AU2  [get_ports {syzygy_std0_tri_io[4]}];   # S4_D2P, Pin 9
set_property PACKAGE_PIN E9   [get_ports {syzygy_std0_tri_io[5]}];   # S5_D3P, Pin 10
set_property PACKAGE_PIN AU1  [get_ports {syzygy_std0_tri_io[6]}];   # S6_D2N, Pin 11
set_property PACKAGE_PIN E8   [get_ports {syzygy_std0_tri_io[7]}];   # S7_D3N, Pin 12
set_property PACKAGE_PIN AW4  [get_ports {syzygy_std0_tri_io[8]}];   # S8_D4P, Pin 13
set_property PACKAGE_PIN A7   [get_ports {syzygy_std0_tri_io[9]}];   # S9_D5P, Pin 14
set_property PACKAGE_PIN AW3  [get_ports {syzygy_std0_tri_io[10]}];  # S10_D4N, Pin 15
set_property PACKAGE_PIN A6   [get_ports {syzygy_std0_tri_io[11]}];  # S11_D5N, Pin 16
set_property PACKAGE_PIN AV3  [get_ports {syzygy_std0_tri_io[12]}];  # S12_D6P, Pin 17
set_property PACKAGE_PIN C8   [get_ports {syzygy_std0_tri_io[13]}];  # S13_D7P, Pin 18
set_property PACKAGE_PIN AV2  [get_ports {syzygy_std0_tri_io[14]}];  # S14_D6N, Pin 19
set_property PACKAGE_PIN C7   [get_ports {syzygy_std0_tri_io[15]}];  # S15_D7N, Pin 20
set_property PACKAGE_PIN AV7  [get_ports {syzygy_std0_tri_io[16]}];  # S16, Pin 21
set_property PACKAGE_PIN B8   [get_ports {syzygy_std0_tri_io[17]}];  # S17, Pin 22
set_property PACKAGE_PIN AV8  [get_ports {syzygy_std0_tri_io[18]}];  # S18, Pin 23
set_property PACKAGE_PIN C5   [get_ports {syzygy_std0_tri_io[19]}];  # S19, Pin 24
set_property PACKAGE_PIN AU8  [get_ports {syzygy_std0_tri_io[20]}];  # S20, Pin 25
set_property PACKAGE_PIN A5   [get_ports {syzygy_std0_tri_io[21]}];  # S21, Pin 26
set_property PACKAGE_PIN AU7  [get_ports {syzygy_std0_tri_io[22]}];  # S22, Pin 27
set_property PACKAGE_PIN D6   [get_ports {syzygy_std0_tri_io[23]}];  # S23, Pin 28
set_property PACKAGE_PIN AR7  [get_ports {syzygy_std0_tri_io[24]}];  # S24, Pin 29
set_property PACKAGE_PIN B5   [get_ports {syzygy_std0_tri_io[25]}];  # S25, Pin 30
set_property PACKAGE_PIN AR6  [get_ports {syzygy_std0_tri_io[26]}];  # S26, Pin 31
set_property PACKAGE_PIN C6   [get_ports {syzygy_std0_tri_io[27]}];  # S27, Pin 32
set_property PACKAGE_PIN AV6  [get_ports {syzygy_std0_tri_io[28]}];  # P2C_CLKP, Pin 33
set_property PACKAGE_PIN B10  [get_ports {syzygy_std0_tri_io[29]}];  # C2P_CLKP, Pin 34
set_property PACKAGE_PIN AV5  [get_ports {syzygy_std0_tri_io[30]}];  # P2C_CLKN, Pin 35
set_property PACKAGE_PIN B9   [get_ports {syzygy_std0_tri_io[31]}];  # C2P_CLKN, Pin 36
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 84]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 87]];

set_clock_groups -asynchronous \
-group {RFADC0_CLK RFADC0_CLK_dummy} \
-group {RFADC1_CLK RFADC1_CLK_dummy} \
-group {RFADC1_FABCLK0 RFADC1_FABCLK1 RFADC1_FABCLK2 RFADC1_FABCLK3} \
-group {RFADC2_CLK RFADC2_CLK_dummy} \
-group {RFADC3_CLK RFADC3_CLK_dummy} \
-group {RFADC3_FABCLK0 RFADC3_FABCLK1 RFADC3_FABCLK2 RFADC3_FABCLK3} \
-group {RFDAC0_CLK RFDAC0_CLK_dummy} \
-group {clk_pl_0} \
-group {clk_pl_1} \
-group {clk_pl_2} \
-group {clk_pl_3} \
-group {system_i/c_clk_mmcm_256/inst/clk_in1 clk_out1_system_c_clk_mmcm_256_0} \
-group {sys_clk_ddr4 mmcm_clkout0 mmcm_clkout5 mmcm_clkout6 pll_clk[0] pll_clk[0]_DIV pll_clk[1] pll_clk[1]_DIV pll_clk[2] pll_clk[2]_DIV}\
;
