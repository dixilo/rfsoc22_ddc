# DAQ2 alpha version

## Utility
source ./util.tcl

## Device setting (RFSoC 2x2)
set p_device "xczu28dr-ffvg1517-2-e"
set p_board "xilinx.com:kcu105:part0:1.5"


set project_name "rfsoc22_ddc"

create_project -force $project_name ./${project_name} -part $p_device
set_property board_part $p_board [current_project]

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


# Create ports
set dip_switch_4bits [ create_bd_port -dir I -from 3 -to 0 dip_switch_4bits ]
set dp_aux_data_in [ create_bd_port -dir I dp_aux_data_in ]
set dp_aux_data_oe [ create_bd_port -dir O -from 0 -to 0 dp_aux_data_oe ]
set dp_aux_data_out [ create_bd_port -dir O dp_aux_data_out ]
set dp_hot_plug_detect [ create_bd_port -dir I dp_hot_plug_detect ]
set leds_4bits [ create_bd_port -dir O -from 3 -to 0 leds_4bits ]
set lmk_reset [ create_bd_port -dir O -from 0 -to 0 lmk_reset ]
set pmod0 [ create_bd_port -dir IO -from 7 -to 0 pmod0 ]
set pmod1 [ create_bd_port -dir IO -from 7 -to 0 pmod1 ]
set push_button_4bits [ create_bd_port -dir I -from 3 -to 0 push_button_4bits ]
set rgbleds_6bits [ create_bd_port -dir O -from 5 -to 0 rgbleds_6bits ]
set syzygy_vio_en [ create_bd_port -dir O -from 0 -to 0 syzygy_vio_en ]


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
    CONFIG.ADC_Data_Type00 {1} \
    CONFIG.ADC_Data_Type01 {1} \
    CONFIG.ADC_Data_Type20 {1} \
    CONFIG.ADC_Data_Type21 {1} \
    CONFIG.ADC_Decimation_Mode00 {2} \
    CONFIG.ADC_Decimation_Mode01 {2} \
    CONFIG.ADC_Decimation_Mode20 {2} \
    CONFIG.ADC_Decimation_Mode21 {2} \
    CONFIG.ADC_Mixer_Mode00 {0} \
    CONFIG.ADC_Mixer_Mode01 {0} \
    CONFIG.ADC_Mixer_Mode20 {0} \
    CONFIG.ADC_Mixer_Mode21 {0} \
    CONFIG.ADC_Mixer_Type00 {2} \
    CONFIG.ADC_Mixer_Type01 {2} \
    CONFIG.ADC_Mixer_Type20 {2} \
    CONFIG.ADC_Mixer_Type21 {2} \
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
    CONFIG.DAC1_Enable {1} \
    CONFIG.DAC1_Fabric_Freq {256.000} \
    CONFIG.DAC1_Outclk_Freq {256.000} \
    CONFIG.DAC1_PLL_Enable {true} \
    CONFIG.DAC1_Refclk_Freq {409.600} \
    CONFIG.DAC1_Sampling_Rate {4.096} \
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
] $rfdc

## DDC 
set ddc_oct [ create_bd_cell -type ip -vlnv [latest_ip axi_ddc_oct] ddc_oct ]

save_bd_design
