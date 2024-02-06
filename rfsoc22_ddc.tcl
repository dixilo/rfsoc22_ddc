# DAQ2 alpha version

## Utility
source ./util.tcl

## Device setting (RFSoC 2x2)
set p_device "xczu28dr-ffvg1517-2-e"
set p_board "xilinx.com:rfsoc2x2:part0:1.1"

set project_name "rfsoc22_ddc"

create_project -force $project_name ./${project_name} -part $p_device
set_property board_part $p_board [current_project]

add_files -norecurse -fileset sources_1 {\
    "./hdl/bw_expander.v" \
    "./hdl/tlast_gen.v" \
    "./hdl/sync_cdc.v" \
    "./hdl/packet_gate.v" \
}

#add_files -norecurse -fileset sources_1 {\
#    "./src/ad_iobuf.v" \
#    "./src/adc_deframer.v" \
#    "./src/daq2_spi.v" \
#    "./src/system_top.v" \
#}

add_files -fileset constrs_1 -norecurse {\
    "./constraints/base.xdc" \
}

## IP repository
set_property  ip_repo_paths  {\
    ../axi_ddc_oct \
    ../RFSoC2x2-PYNQ/board/ip \
    ../axi_rewind/ip_repo \
    ../axi_rewind/hls/proj_rewind \
    ../axi_trigger/ip_repo \
    ../axi_trigger/hls/proj_buffer \
    ../axi_trigger/hls/proj_trigger \
} [current_project]

#set_property ip_repo_paths $lib_dirs [current_fileset]
update_ip_catalog

## create board design
create_bd_design "system"


## port definitions
#### Interfaces
set Vp_Vn [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn ]

set adc0_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 adc0_clk ]
set_property -dict [ list \
CONFIG.FREQ_HZ {409600000.0} \
] $adc0_clk

set adc2_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 adc2_clk ]
set_property -dict [ list \
CONFIG.FREQ_HZ {409600000.0} \
] $adc2_clk

set dac0_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dac0_clk ]
set_property -dict [ list \
CONFIG.FREQ_HZ {409600000.0} \
] $dac0_clk

set dac1_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dac1_clk ]
set_property -dict [ list \
CONFIG.FREQ_HZ {409600000.0} \
] $dac1_clk

set ddr4_pl [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_pl ]

set sys_clk_ddr4 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk_ddr4 ]
set_property -dict [ list \
CONFIG.FREQ_HZ {200000000} \
] $sys_clk_ddr4

set sysref_in [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_usp_rf_data_converter:diff_pins_rtl:1.0 sysref_in ]
set syzygy_std0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 syzygy_std0 ]
set vin0_01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin0_01 ]
set vin2_01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin2_01 ]
set vout00 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout00 ]
set vout10 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout10 ]

set pl_sysref [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pl_sysref ]
set fpga_refclk_in [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 fpga_refclk_in ]
set_property -dict [ list \
    CONFIG.FREQ_HZ {122880000} \
] $fpga_refclk_in



# Create ports
# set dip_switch_4bits [ create_bd_port -dir I -from 3 -to 0 dip_switch_4bits ]
set dp_aux_data_in [ create_bd_port -dir I dp_aux_data_in ]
set dp_aux_data_oe [ create_bd_port -dir O -from 0 -to 0 dp_aux_data_oe ]
set dp_aux_data_out [ create_bd_port -dir O dp_aux_data_out ]
set dp_hot_plug_detect [ create_bd_port -dir I dp_hot_plug_detect ]
# set leds_4bits [ create_bd_port -dir O -from 3 -to 0 leds_4bits ]
set lmk_reset [ create_bd_port -dir O -from 0 -to 0 lmk_reset ]
# set pmod0 [ create_bd_port -dir IO -from 7 -to 0 pmod0 ]
# set pmod1 [ create_bd_port -dir IO -from 7 -to 0 pmod1 ]
# set push_button_4bits [ create_bd_port -dir I -from 3 -to 0 push_button_4bits ]
# set rgbleds_6bits [ create_bd_port -dir O -from 5 -to 0 rgbleds_6bits ]
# set syzygy_vio_en [ create_bd_port -dir O -from 0 -to 0 syzygy_vio_en ]


## RF data converter

set rfdc [ create_bd_cell -type ip -vlnv [latest_ip usp_rf_data_converter] rfdc ]
set_property -dict [ list \
    CONFIG.ADC0_Fabric_Freq {256.000} \
    CONFIG.ADC0_Outclk_Freq {256.000} \
    CONFIG.ADC0_PLL_Enable {true} \
    CONFIG.ADC0_Refclk_Freq {409.600} \
    CONFIG.ADC0_Sampling_Rate {4.096} \
    CONFIG.ADC2_Enable {1} \
    CONFIG.ADC2_Fabric_Freq {256.000} \
    CONFIG.ADC2_Outclk_Freq {256.000} \
    CONFIG.ADC2_PLL_Enable {true} \
    CONFIG.ADC2_Refclk_Freq {409.600} \
    CONFIG.ADC2_Sampling_Rate {4.096} \
    CONFIG.ADC_Data_Type00 {0} \
    CONFIG.ADC_Data_Type01 {0} \
    CONFIG.ADC_Data_Type20 {0} \
    CONFIG.ADC_Data_Type21 {0} \
    CONFIG.ADC_Decimation_Mode00 {2} \
    CONFIG.ADC_Decimation_Mode01 {2} \
    CONFIG.ADC_Decimation_Mode20 {2} \
    CONFIG.ADC_Decimation_Mode21 {2} \
    CONFIG.ADC_Mixer_Mode00 {2} \
    CONFIG.ADC_Mixer_Mode01 {2} \
    CONFIG.ADC_Mixer_Mode20 {2} \
    CONFIG.ADC_Mixer_Mode21 {2} \
    CONFIG.ADC_Mixer_Type00 {0} \
    CONFIG.ADC_Mixer_Type01 {0} \
    CONFIG.ADC_Mixer_Type20 {0} \
    CONFIG.ADC_Mixer_Type21 {0} \
    CONFIG.ADC_OBS02 {0} \
    CONFIG.ADC_OBS22 {0} \
    CONFIG.ADC_RESERVED_1_00 {false} \
    CONFIG.ADC_RESERVED_1_02 {false} \
    CONFIG.ADC_RESERVED_1_20 {false} \
    CONFIG.ADC_RESERVED_1_22 {false} \
    CONFIG.ADC_Slice20_Enable {true} \
    CONFIG.ADC_Slice21_Enable {true} \
    CONFIG.DAC0_Enable {1} \
    CONFIG.DAC0_Fabric_Freq {256.000} \
    CONFIG.DAC0_Outclk_Freq {256.000} \
    CONFIG.DAC0_PLL_Enable {true} \
    CONFIG.DAC0_Refclk_Freq {409.600} \
    CONFIG.DAC0_Sampling_Rate {4.096} \
    CONFIG.DAC_Data_Width00 {8} \
    CONFIG.DAC1_Enable {1} \
    CONFIG.DAC1_Fabric_Freq {256.000} \
    CONFIG.DAC1_Outclk_Freq {256.000} \
    CONFIG.DAC1_PLL_Enable {true} \
    CONFIG.DAC1_Refclk_Freq {409.600} \
    CONFIG.DAC1_Sampling_Rate {4.096} \
    CONFIG.DAC_Data_Width10 {8} \
    CONFIG.DAC_Interpolation_Mode00 {2} \
    CONFIG.DAC_Interpolation_Mode02 {0} \
    CONFIG.DAC_Interpolation_Mode10 {2} \
    CONFIG.DAC_Mixer_Mode00 {2} \
    CONFIG.DAC_Mixer_Mode02 {2} \
    CONFIG.DAC_Mixer_Mode10 {2} \
    CONFIG.DAC_Mixer_Type00 {0} \
    CONFIG.DAC_Mixer_Type02 {3} \
    CONFIG.DAC_Mixer_Type10 {0} \
    CONFIG.DAC_RESERVED_1_00 {false} \
    CONFIG.DAC_RESERVED_1_01 {false} \
    CONFIG.DAC_RESERVED_1_02 {false} \
    CONFIG.DAC_RESERVED_1_03 {false} \
    CONFIG.DAC_RESERVED_1_10 {false} \
    CONFIG.DAC_RESERVED_1_11 {false} \
    CONFIG.DAC_RESERVED_1_12 {false} \
    CONFIG.DAC_RESERVED_1_13 {false} \
    CONFIG.DAC_RTS {false} \
    CONFIG.DAC_Slice00_Enable {true} \
    CONFIG.DAC_Slice02_Enable {false} \
    CONFIG.DAC_Slice10_Enable {true} \
    CONFIG.DAC0_Multi_Tile_Sync {true} \
    CONFIG.DAC1_Multi_Tile_Sync {true} \
    CONFIG.ADC0_Multi_Tile_Sync {true} \
    CONFIG.ADC2_Multi_Tile_Sync {true} \
] $rfdc

## DDC 
set ddc_oct [ create_bd_cell -type ip -vlnv [latest_ip axi_ddc_oct] ddc_oct ]
set_property -dict [list CONFIG.N_CH {16}] $ddc_oct

## Reset generator
set stream_rstgen [create_bd_cell -type ip -vlnv [latest_ip proc_sys_reset] stream_rstgen]

## DDR4
set ddr4_0 [ create_bd_cell -type ip -vlnv [latest_ip ip:ddr4] ddr4_0 ]
set_property -dict [ list \
    CONFIG.C0.BANK_GROUP_WIDTH {1} \
    CONFIG.C0.DDR4_AxiAddressWidth {33} \
    CONFIG.C0.DDR4_AxiDataWidth {512} \
    CONFIG.C0.DDR4_CLKFBOUT_MULT {15} \
    CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5} \
    CONFIG.C0.DDR4_CasLatency {17} \
    CONFIG.C0.DDR4_CasWriteLatency {12} \
    CONFIG.C0.DDR4_DIVCLK_DIVIDE {2} \
    CONFIG.C0.DDR4_DataWidth {64} \
    CONFIG.C0.DDR4_InputClockPeriod {4998} \
    CONFIG.C0.DDR4_MemoryPart {MT40A1G16RC-062E} \
    CONFIG.C0.DDR4_MemoryType {Components} \
    CONFIG.C0.DDR4_TimePeriod {833} \
    CONFIG.System_Clock {No_Buffer} \
] $ddr4_0

set ddr4_0_sys_reset [create_bd_cell -type ip -vlnv [latest_ip proc_sys_reset] ddr4_0_sys_reset]
set ddr4_cpu_rstgen [create_bd_cell -type ip -vlnv [latest_ip proc_sys_reset] ddr4_cpu_rstgen]
set ddr4_ui_rstgen [create_bd_cell -type ip -vlnv [latest_ip proc_sys_reset] ddr4_ui_rstgen]

set interconnect_ddr4 [ create_bd_cell -type ip -vlnv [latest_ip axi_interconnect] interconnect_ddr4 ]
set_property -dict [ list \
    CONFIG.NUM_SI {2} \
    CONFIG.NUM_MI {1} \
    CONFIG.S00_HAS_DATA_FIFO {2} \
    CONFIG.S01_HAS_DATA_FIFO {2} \
] $interconnect_ddr4

### FPGA REFCLK preparation
set util_ds_buf_refclk [create_bd_cell -type ip -vlnv [latest_ip util_ds_buf] util_ds_buf_refclk ]
set_property -dict [ list \
    CONFIG.C_BUF_TYPE {IBUFDS} \
] $util_ds_buf_refclk

set c_clk_mmcm_256 [create_bd_cell -type ip -vlnv [latest_ip clk_wiz] c_clk_mmcm_256]
set_property -dict [list CONFIG.PRIM_IN_FREQ.VALUE_SRC USER] $c_clk_mmcm_256
set_property -dict [list \
    CONFIG.OPTIMIZE_CLOCKING_STRUCTURE_EN {true} \
    CONFIG.PRIM_IN_FREQ {122.88} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {256} \
    CONFIG.CLKIN1_JITTER_PS {81.38} \
    CONFIG.MMCM_DIVCLK_DIVIDE {12} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {115.625} \
    CONFIG.MMCM_CLKIN1_PERIOD {8.138} \
    CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {4.625} \
    CONFIG.CLKOUT1_JITTER {191.296} \
    CONFIG.CLKOUT1_PHASE_ERROR {360.233} \
] $c_clk_mmcm_256


### DDR4 clock preparation
set util_ds_buf_0 [create_bd_cell -type ip -vlnv [latest_ip util_ds_buf] util_ds_buf_0 ]
set_property -dict [ list \
    CONFIG.C_BUF_TYPE {IBUFDS} \
] $util_ds_buf_0

set util_ds_buf_1 [create_bd_cell -type ip -vlnv [latest_ip util_ds_buf] util_ds_buf_1 ]
set_property -dict [ list \
    CONFIG.C_BUF_TYPE {BUFG} \
] $util_ds_buf_1

### DDR4 sys_rst generation
set c_clk_mmcm_200 [ create_bd_cell -type ip -vlnv [latest_ip clk_wiz] c_clk_mmcm_200 ]
set_property -dict [ list \
    CONFIG.CLKIN1_JITTER_PS {50.0} \
    CONFIG.CLKOUT1_JITTER {92.799} \
    CONFIG.CLKOUT1_PHASE_ERROR {82.655} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {6.000} \
    CONFIG.MMCM_CLKIN1_PERIOD {5.000} \
    CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {6.000} \
    CONFIG.PRIM_IN_FREQ {200.000} \
    CONFIG.PRIM_SOURCE {No_buffer} \
] $c_clk_mmcm_200

set c_clk_mmcm_200_locked [create_bd_cell -type ip -vlnv [latest_ip util_vector_logic] c_clk_mmcm_200_locked]
set_property -dict [ list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
] $c_clk_mmcm_200_locked

set clk_mmcm_reset [create_bd_cell -type ip -vlnv [latest_ip util_vector_logic] clk_mmcm_reset ]
set_property -dict [ list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
] $clk_mmcm_reset

set binary_latch_counter_0 [ create_bd_cell -type ip -vlnv [latest_ip user:binary_latch_counter] binary_latch_counter_0]


## Zynq
source ./zynq_inst.tcl
set sys_rstgen [create_bd_cell -type ip -vlnv [latest_ip proc_sys_reset] sys_rstgen]

set interconnect_cpu [ create_bd_cell -type ip -vlnv [latest_ip axi_interconnect] interconnect_cpu ]
set_property -dict [ list \
    CONFIG.NUM_MI {14} \
    CONFIG.S00_HAS_DATA_FIFO {2} \
] $interconnect_cpu

## GPIO
set pin_control [ create_bd_cell -type ip -vlnv [latest_ip axi_gpio] pin_control]
set_property -dict [ list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0x00000004} \
    CONFIG.C_GPIO_WIDTH {32} \
] $pin_control

set pin0_lmk_reset [create_bd_cell -type ip -vlnv [latest_ip xlslice] pin0_lmk_reset]

## DMA
set axi_dma [create_bd_cell -type ip -vlnv [latest_ip axi_dma] axi_dma]
set_property -dict [list \
    CONFIG.c_include_sg {0} \
    CONFIG.c_sg_length_width {20} \
    CONFIG.c_sg_include_stscntrl_strm {0} \
    CONFIG.c_include_mm2s {0} \
    CONFIG.c_addr_width {40} \
] $axi_dma

## DDC fifo
set axis_data_fifo [create_bd_cell -type ip -vlnv [latest_ip axis_data_fifo] axis_data_fifo]
set_property -dict [list CONFIG.IS_ACLK_ASYNC {1}] $axis_data_fifo

set datafifo_rstgen [create_bd_cell -type ip -vlnv [latest_ip proc_sys_reset] datafifo_rstgen]
set_property -dict [list CONFIG.C_AUX_RESET_HIGH.VALUE_SRC USER] $datafifo_rstgen

## bit width expander
create_bd_cell -type module -reference bw_expander bw_expander_0
set_property CONFIG.FREQ_HZ 300000000 [get_bd_intf_pins /bw_expander_0/s_axis]
set_property CONFIG.FREQ_HZ 300000000 [get_bd_intf_pins /bw_expander_0/m_axis]

## packet gate
create_bd_cell -type module -reference packet_gate packet_gate_0
set_property CONFIG.FREQ_HZ 256000000 [get_bd_intf_pins /packet_gate_0/s_axis]
set_property CONFIG.FREQ_HZ 256000000 [get_bd_intf_pins /packet_gate_0/m_axis]

## TLAST generator
create_bd_cell -type module -reference tlast_gen tlast_gen_0
set_property CONFIG.FREQ_HZ 300000000 [get_bd_intf_pins /tlast_gen_0/s_axis]
set_property CONFIG.FREQ_HZ 300000000 [get_bd_intf_pins /tlast_gen_0/m_axis]

## Packetsize GPIO
set packet_size [ create_bd_cell -type ip -vlnv [latest_ip axi_gpio] packet_size]
set_property -dict [ list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0x00000004} \
    CONFIG.C_GPIO_WIDTH {32} \
] $packet_size

## FIFO reset GPIO
set fifo_reset [ create_bd_cell -type ip -vlnv [latest_ip axi_gpio] fifo_reset]
set_property -dict [ list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0x00000000} \
    CONFIG.C_GPIO_WIDTH {32} \
] $fifo_reset

set hls_reset [ create_bd_cell -type ip -vlnv [latest_ip axi_gpio] hls_reset]
set_property -dict [ list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0x00000000} \
    CONFIG.C_GPIO_WIDTH {32} \
] $hls_reset

## FIFO reset slice
create_bd_cell -type ip -vlnv [latest_ip xlslice] fs_slice
create_bd_cell -type ip -vlnv [latest_ip xlslice] hls_slice

## PL SYSREF
set sysref_buf [create_bd_cell -type ip -vlnv [latest_ip util_ds_buf] sysref_buf]
set sysref_sync [create_bd_cell -type module -reference sync_cdc sysref_sync]


## Rewind & trigger
set axi_rewind [ create_bd_cell -type ip -vlnv [latest_ip axi_rewind] axi_rewind]
set axi_trigger [ create_bd_cell -type ip -vlnv [latest_ip axi_trigger] axi_trigger]

set hls_rstgen [create_bd_cell -type ip -vlnv [latest_ip proc_sys_reset] hls_rstgen]
set_property -dict [list CONFIG.C_AUX_RESET_HIGH.VALUE_SRC USER] $hls_rstgen

## connection
################### interface
# RFDC connection
connect_bd_intf_net [get_bd_intf_ports vout00] [get_bd_intf_pins rfdc/vout00]
connect_bd_intf_net [get_bd_intf_ports vout10] [get_bd_intf_pins rfdc/vout10]
connect_bd_intf_net [get_bd_intf_ports vin0_01] [get_bd_intf_pins rfdc/vin0_01]
connect_bd_intf_net [get_bd_intf_ports vin2_01] [get_bd_intf_pins rfdc/vin2_01]
connect_bd_intf_net [get_bd_intf_ports sysref_in] [get_bd_intf_pins rfdc/sysref_in]
connect_bd_intf_net [get_bd_intf_pins adc0_clk] [get_bd_intf_pins rfdc/adc0_clk]
connect_bd_intf_net [get_bd_intf_pins adc2_clk] [get_bd_intf_pins rfdc/adc2_clk]
connect_bd_intf_net [get_bd_intf_pins dac0_clk] [get_bd_intf_pins rfdc/dac0_clk]
connect_bd_intf_net [get_bd_intf_pins dac1_clk] [get_bd_intf_pins rfdc/dac1_clk]

# Zynq
connect_bd_net [get_bd_ports dp_aux_data_in] [get_bd_pins zynq_ultra_ps_e_0/dp_aux_data_in]
connect_bd_net [get_bd_ports dp_hot_plug_detect] [get_bd_pins zynq_ultra_ps_e_0/dp_hot_plug_detect]
connect_bd_net [get_bd_ports dp_aux_data_out] [get_bd_pins zynq_ultra_ps_e_0/dp_aux_data_out]
connect_bd_net [get_bd_ports dp_aux_data_oe] [get_bd_pins dp_aux_data_oe_inv/Res]

# Zynq reset
set pl_resetn [create_bd_net pl_resetn]
connect_bd_net -net $pl_resetn [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

###### 256 MHz clock
set stream_clk [create_bd_net stream_clk]
connect_bd_net -net $stream_clk [get_bd_pins c_clk_mmcm_256/clk_out1]

set stream_resetn [create_bd_net stream_resetn]
connect_bd_net -net $stream_resetn [get_bd_pins stream_rstgen/peripheral_aresetn]
connect_bd_net -net $stream_clk [get_bd_pins stream_rstgen/slowest_sync_clk]
connect_bd_net -net $pl_resetn [get_bd_pins stream_rstgen/ext_reset_in]

connect_bd_net -net $stream_clk [get_bd_pins rfdc/m0_axis_aclk]
connect_bd_net -net $stream_clk [get_bd_pins rfdc/m2_axis_aclk]
connect_bd_net -net $stream_clk [get_bd_pins rfdc/s0_axis_aclk]
connect_bd_net -net $stream_clk [get_bd_pins rfdc/s1_axis_aclk]

connect_bd_net -net $stream_resetn [get_bd_pins rfdc/m0_axis_aresetn]
connect_bd_net -net $stream_resetn [get_bd_pins rfdc/m2_axis_aresetn]
connect_bd_net -net $stream_resetn [get_bd_pins rfdc/s0_axis_aresetn]
connect_bd_net -net $stream_resetn [get_bd_pins rfdc/s1_axis_aresetn]

# Peripheral clocking
set sys_cpu_clk [create_bd_net sys_cpu_clk]
connect_bd_net -net $sys_cpu_clk [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]

# Peripheral reset
set sys_cpu_reset [create_bd_net sys_cpu_reset]
connect_bd_net -net $sys_cpu_reset [get_bd_pins sys_rstgen/peripheral_reset]
set sys_cpu_resetn [create_bd_net sys_cpu_resetn]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins sys_rstgen/peripheral_aresetn]

connect_bd_net -net $sys_cpu_clk [get_bd_pins sys_rstgen/slowest_sync_clk]
connect_bd_net -net $pl_resetn [get_bd_pins sys_rstgen/ext_reset_in]

# 100 MHz AXI
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/S00_ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/M00_ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/M01_ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/M02_ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/M03_ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/M04_ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/M05_ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/M06_ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/M07_ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/M08_ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/M09_ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/M10_ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/M11_ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/M12_ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/M13_ACLK]

connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/S00_ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/M00_ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/M01_ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/M02_ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/M03_ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/M04_ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/M05_ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/M06_ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/M07_ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/M08_ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/M09_ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/M10_ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/M11_ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/M12_ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/M13_ARESETN]

connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_LPD] [get_bd_intf_pins interconnect_cpu/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins interconnect_cpu/M00_AXI] [get_bd_intf_pins ddc_oct/s00_axi]

connect_bd_net -net $sys_cpu_clk [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_lpd_aclk]

# Device clock
connect_bd_intf_net [get_bd_intf_ports fpga_refclk_in] [get_bd_intf_pins util_ds_buf_refclk/CLK_IN_D]
connect_bd_net [get_bd_pins util_ds_buf_refclk/IBUF_OUT] [get_bd_pins c_clk_mmcm_256/clk_in1]


# DDR4
connect_bd_intf_net [get_bd_intf_ports ddr4_pl] [get_bd_intf_pins ddr4_0/C0_DDR4]
connect_bd_intf_net [get_bd_intf_pins interconnect_ddr4/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]
connect_bd_intf_net [get_bd_intf_pins interconnect_ddr4/M00_AXI] [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI]

connect_bd_intf_net [get_bd_intf_ports sys_clk_ddr4] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
connect_bd_net [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins util_ds_buf_1/BUFG_I]


set ddr4_clk [create_bd_net ddr4_clk]
connect_bd_net -net $ddr4_clk [get_bd_pins util_ds_buf_1/BUFG_O]
connect_bd_net -net $ddr4_clk [get_bd_pins ddr4_0/c0_sys_clk_i]
connect_bd_net -net $ddr4_clk [get_bd_pins c_clk_mmcm_200/clk_in1]

set ddr4_cpu_clk [create_bd_net ddr4_cpu_clk]
connect_bd_net -net $ddr4_cpu_clk [get_bd_pins zynq_ultra_ps_e_0/pl_clk1]
connect_bd_net -net $ddr4_cpu_clk [get_bd_pins interconnect_ddr4/S00_ACLK]
connect_bd_net -net $ddr4_cpu_clk [get_bd_pins interconnect_ddr4/ACLK]
connect_bd_net -net $ddr4_cpu_clk [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]

set ddr4_ui_clk [create_bd_net ddr4_ui_clk]
connect_bd_net -net $ddr4_ui_clk [get_bd_pins ddr4_0/c0_ddr4_ui_clk]
connect_bd_net -net $ddr4_ui_clk [get_bd_pins interconnect_ddr4/M00_ACLK]
connect_bd_net -net $ddr4_ui_clk [get_bd_pins ddr4_0_sys_reset/slowest_sync_clk]

set ddr4_rst [create_bd_net ddr4_rst]
connect_bd_net -net $ddr4_rst [get_bd_pins ddr4_0/c0_ddr4_ui_clk_sync_rst]
connect_bd_net -net $ddr4_rst [get_bd_pins ddr4_0_sys_reset/ext_reset_in]

set ddr4_peripheral_aresetn [create_bd_net ddr4_peripheral_aresetn]
connect_bd_net -net $ddr4_peripheral_aresetn [get_bd_pins ddr4_0_sys_reset/peripheral_aresetn]
connect_bd_net -net $ddr4_peripheral_aresetn [get_bd_pins interconnect_ddr4/M00_ARESETN]
connect_bd_net -net $ddr4_peripheral_aresetn [get_bd_pins ddr4_0/c0_ddr4_aresetn]

set ddr4_cpu_resetn [create_bd_net ddr4_cpu_resetn]
connect_bd_net -net $ddr4_cpu_resetn [get_bd_pins ddr4_cpu_rstgen/peripheral_aresetn]
connect_bd_net -net $ddr4_cpu_clk [get_bd_pins ddr4_cpu_rstgen/slowest_sync_clk]
connect_bd_net -net $pl_resetn [get_bd_pins ddr4_cpu_rstgen/ext_reset_in]

connect_bd_net -net $ddr4_cpu_resetn [get_bd_pins interconnect_ddr4/ARESETN]
connect_bd_net -net $ddr4_cpu_resetn [get_bd_pins interconnect_ddr4/S00_ARESETN]

set ddr4_ui_resetn [create_bd_net ddr4_ui_resetn]
connect_bd_net -net $ddr4_ui_resetn [get_bd_pins ddr4_ui_rstgen/peripheral_aresetn]
connect_bd_net -net $ddr4_ui_clk [get_bd_pins ddr4_ui_rstgen/slowest_sync_clk]
connect_bd_net -net $ddr4_rst [get_bd_pins ddr4_ui_rstgen/ext_reset_in]


#### DDR4 sys_rst preparation
connect_bd_net [get_bd_pins c_clk_mmcm_200/locked] [get_bd_pins c_clk_mmcm_200_locked/Op1]
connect_bd_net [get_bd_pins c_clk_mmcm_200_locked/Res] [get_bd_pins ddr4_0/sys_rst]

######## mmcm reset preparation
connect_bd_net [get_bd_pins c_clk_mmcm_200/reset] [get_bd_pins clk_mmcm_reset/Res]
connect_bd_net [get_bd_pins c_clk_mmcm_256/reset] [get_bd_pins clk_mmcm_reset/Res]
connect_bd_net [get_bd_pins binary_latch_counter_0/latched] [get_bd_pins clk_mmcm_reset/Op1]

connect_bd_net -net $sys_cpu_resetn [get_bd_pins binary_latch_counter_0/resetn]
connect_bd_net -net $sys_cpu_clk [get_bd_pins binary_latch_counter_0/clk]




# DDC
connect_bd_net -net $stream_clk [get_bd_pins ddc_oct/s_axis_aclk]
connect_bd_net -net $stream_resetn [get_bd_pins ddc_oct/s_axis_aresetn]
connect_bd_net -net $sys_cpu_clk [get_bd_pins ddc_oct/s00_axi_aclk]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins ddc_oct/s00_axi_aresetn]

# RFDC
connect_bd_intf_net [get_bd_intf_pins ddc_oct/m_axis_ddsi] [get_bd_intf_pins rfdc/s00_axis]
connect_bd_intf_net [get_bd_intf_pins ddc_oct/m_axis_ddsq] [get_bd_intf_pins rfdc/s10_axis]
connect_bd_intf_net [get_bd_intf_pins rfdc/m00_axis] [get_bd_intf_pins ddc_oct/s_axis_i]
connect_bd_intf_net [get_bd_intf_pins rfdc/m20_axis] [get_bd_intf_pins ddc_oct/s_axis_q]

connect_bd_net -net $sys_cpu_clk [get_bd_pins rfdc/s_axi_aclk]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins rfdc/s_axi_aresetn]
connect_bd_intf_net [get_bd_intf_pins interconnect_cpu/M02_AXI] [get_bd_intf_pins rfdc/s_axi]

# GPIO
connect_bd_intf_net [get_bd_intf_pins interconnect_cpu/M01_AXI] [get_bd_intf_pins pin_control/S_AXI]
connect_bd_net -net $sys_cpu_clk [get_bd_pins pin_control/s_axi_aclk]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins pin_control/s_axi_aresetn]
connect_bd_net [get_bd_pins pin0_lmk_reset/Din] [get_bd_pins pin_control/gpio_io_o]
connect_bd_net [get_bd_ports lmk_reset] [get_bd_pins pin0_lmk_reset/Dout]

# HLS reset
set hls_resetn [create_bd_net hls_resetn]
connect_bd_net -net $hls_resetn [get_bd_pins hls_rstgen/peripheral_aresetn]
connect_bd_net -net $stream_clk     [get_bd_pins hls_rstgen/slowest_sync_clk]
connect_bd_net -net $stream_resetn       [get_bd_pins hls_rstgen/ext_reset_in]
connect_bd_net [get_bd_pins hls_reset/gpio_io_o] [get_bd_pins hls_slice/Din]
connect_bd_net [get_bd_pins hls_slice/Dout] [get_bd_pins hls_rstgen/aux_reset_in]

# packet gate
connect_bd_net -net $stream_clk [get_bd_pins packet_gate_0/s_axis_aclk]
connect_bd_net -net $hls_resetn [get_bd_pins packet_gate_0/s_axis_aresetn]
connect_bd_intf_net [get_bd_intf_pins ddc_oct/m_axis_ddc] [get_bd_intf_pins packet_gate_0/s_axis]

# axi_rewind
connect_bd_net -net $stream_clk [get_bd_pins axi_rewind/dev_clk]
connect_bd_net -net $hls_resetn [get_bd_pins axi_rewind/dev_rstn]
connect_bd_intf_net [get_bd_intf_pins packet_gate_0/m_axis] [get_bd_intf_pins axi_rewind/axis_data_in]
connect_bd_intf_net [get_bd_intf_pins interconnect_cpu/M06_AXI] [get_bd_intf_pins axi_rewind/axi_phase_rew]
connect_bd_intf_net [get_bd_intf_pins interconnect_cpu/M07_AXI] [get_bd_intf_pins axi_rewind/axi_offset_real]
connect_bd_intf_net [get_bd_intf_pins interconnect_cpu/M08_AXI] [get_bd_intf_pins axi_rewind/axi_offset_imag]
connect_bd_intf_net [get_bd_intf_pins interconnect_cpu/M09_AXI] [get_bd_intf_pins axi_rewind/axi_phi_0]
connect_bd_net -net $sys_cpu_clk [get_bd_pins axi_rewind/axi_clk]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins axi_rewind/axi_aresetn]

# axi_trigger
connect_bd_net -net $stream_clk [get_bd_pins axi_trigger/dev_clk]
connect_bd_net -net $hls_resetn [get_bd_pins axi_trigger/dev_rstn]
connect_bd_intf_net [get_bd_intf_pins axi_rewind/axis_data_out] [get_bd_intf_pins axi_trigger/axis_data_in]
connect_bd_intf_net [get_bd_intf_pins axi_rewind/axis_phase_out] [get_bd_intf_pins axi_trigger/axis_phase_in]

connect_bd_intf_net [get_bd_intf_pins interconnect_cpu/M10_AXI] [get_bd_intf_pins axi_trigger/s_axi_trig_low]
connect_bd_intf_net [get_bd_intf_pins interconnect_cpu/M11_AXI] [get_bd_intf_pins axi_trigger/s_axi_trig_high]
connect_bd_intf_net [get_bd_intf_pins interconnect_cpu/M12_AXI] [get_bd_intf_pins axi_trigger/s_axi_control]

connect_bd_net -net $sys_cpu_clk [get_bd_pins axi_trigger/s_axi_aclk]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins axi_trigger/axi_aresetn]


# FIFO
connect_bd_intf_net [get_bd_intf_pins axi_trigger/axis_data_out] [get_bd_intf_pins axis_data_fifo/S_AXIS]
connect_bd_net -net $stream_clk [get_bd_pins axis_data_fifo/s_axis_aclk]
connect_bd_net -net $ddr4_ui_clk [get_bd_pins axis_data_fifo/m_axis_aclk]
## Data fifo reset 
## This is a dedicated reset generator for AXIS data fifo to enable reset without interfering other components.
set datafifo_resetn [create_bd_net datafifo_resetn]
connect_bd_net -net $datafifo_resetn [get_bd_pins datafifo_rstgen/peripheral_aresetn]
connect_bd_net -net $ddr4_ui_clk     [get_bd_pins datafifo_rstgen/slowest_sync_clk]
connect_bd_net -net $pl_resetn       [get_bd_pins datafifo_rstgen/ext_reset_in]
connect_bd_net [get_bd_pins fifo_reset/gpio_io_o] [get_bd_pins fs_slice/Din]
connect_bd_net [get_bd_pins fs_slice/Dout] [get_bd_pins datafifo_rstgen/aux_reset_in]

connect_bd_net -net $datafifo_resetn [get_bd_pins axis_data_fifo/s_axis_aresetn]

# DMA
connect_bd_intf_net [get_bd_intf_pins axi_dma/M_AXI_S2MM] [get_bd_intf_pins interconnect_ddr4/S01_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_dma/S_AXI_LITE] [get_bd_intf_pins interconnect_cpu/M03_AXI]

connect_bd_net -net $sys_cpu_clk [get_bd_pins axi_dma/s_axi_lite_aclk]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins axi_dma/axi_resetn]

connect_bd_net -net $ddr4_ui_clk [get_bd_pins interconnect_ddr4/S01_ACLK]
connect_bd_net -net $ddr4_ui_clk [get_bd_pins axi_dma/m_axi_s2mm_aclk]

connect_bd_net -net $ddr4_ui_resetn [get_bd_pins interconnect_ddr4/S01_ARESETN]

# bitwidth converter
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo/M_AXIS] [get_bd_intf_pins bw_expander_0/s_axis]
connect_bd_intf_net [get_bd_intf_pins bw_expander_0/m_axis] [get_bd_intf_pins tlast_gen_0/s_axis]
connect_bd_intf_net [get_bd_intf_pins tlast_gen_0/m_axis] [get_bd_intf_pins axi_dma/S_AXIS_S2MM]

# tlast generator
connect_bd_net -net $ddr4_ui_clk [get_bd_pins tlast_gen_0/s_axis_aclk]
connect_bd_net -net $datafifo_resetn [get_bd_pins tlast_gen_0/s_axis_aresetn]


# Packet size GPIO
connect_bd_intf_net [get_bd_intf_pins interconnect_cpu/M04_AXI] [get_bd_intf_pins packet_size/S_AXI]
connect_bd_net -net $sys_cpu_clk [get_bd_pins packet_size/s_axi_aclk]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins packet_size/s_axi_aresetn]

connect_bd_net [get_bd_pins packet_size/gpio_io_o] [get_bd_pins tlast_gen_0/packet_length]

# FIFO reset GPIO
connect_bd_intf_net [get_bd_intf_pins interconnect_cpu/M05_AXI] [get_bd_intf_pins fifo_reset/S_AXI]
connect_bd_net -net $sys_cpu_clk [get_bd_pins fifo_reset/s_axi_aclk]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins fifo_reset/s_axi_aresetn]

# HLS reset GPIO
connect_bd_intf_net [get_bd_intf_pins interconnect_cpu/M13_AXI] [get_bd_intf_pins hls_reset/S_AXI]
connect_bd_net -net $sys_cpu_clk [get_bd_pins hls_reset/s_axi_aclk]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins hls_reset/s_axi_aresetn]


# pl sysref
connect_bd_net -net $stream_clk [get_bd_pins sysref_sync/dest_clk]
connect_bd_intf_net [get_bd_intf_ports pl_sysref] [get_bd_intf_pins sysref_buf/CLK_IN_D]
connect_bd_net [get_bd_pins sysref_buf/IBUF_OUT] [get_bd_pins sysref_sync/src_in]
connect_bd_net [get_bd_pins sysref_sync/dest_out] [get_bd_pins rfdc/user_sysref_adc]
connect_bd_net [get_bd_pins sysref_sync/dest_out] [get_bd_pins rfdc/user_sysref_dac]

# Addresses
assign_bd_address -offset 0x001000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
assign_bd_address -offset 0x001000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces axi_dma/Data_S2MM] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force

assign_bd_address -offset 0x80050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs pin_control/S_AXI/Reg] -force
assign_bd_address -offset 0x80000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs ddc_oct/s00_axi/reg0] -force
assign_bd_address -offset 0x80010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma/S_AXI_LITE/Reg] -force
assign_bd_address -offset 0x80020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs packet_size/S_AXI/Reg] -force
assign_bd_address -offset 0x80030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs fifo_reset/S_AXI/Reg] -force
assign_bd_address -offset 0x80080000 -range 0x00040000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs rfdc/s_axi/Reg] -force

assign_bd_address -offset 0x800C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_rewind/axi_phase_rew/Reg] -force
assign_bd_address -offset 0x800D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_rewind/axi_offset_real/Reg] -force
assign_bd_address -offset 0x800E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_rewind/axi_offset_imag/Reg] -force
assign_bd_address -offset 0x800F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_rewind/axi_phi_0/Reg] -force
assign_bd_address -offset 0x80100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_trigger/s_axi_control/Reg] -force
assign_bd_address -offset 0x80110000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_trigger/s_axi_trig_high/Reg] -force
assign_bd_address -offset 0x80120000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_trigger/s_axi_trig_low/Reg] -force
assign_bd_address -offset 0x80130000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs hls_reset/S_AXI/Reg] -force

### Project
save_bd_design
validate_bd_design

set project_system_dir "./${project_name}/${project_name}.srcs/sources_1/bd/system"

set_property synth_checkpoint_mode None [get_files  $project_system_dir/system.bd]
generate_target {synthesis implementation} [get_files  $project_system_dir/system.bd]
make_wrapper -files [get_files $project_system_dir/system.bd] -top

import_files -force -norecurse -fileset sources_1 $project_system_dir/hdl/system_wrapper.v
set_property top system_wrapper [current_fileset]
