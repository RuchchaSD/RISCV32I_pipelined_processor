set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_IBUF]


##Clock signal
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { sysclk }]; #IO_L11P_T1_SRCC_35 Sch=sysclk
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { sysclk }];


set_property PACKAGE_PIN D18 [get_ports {out[3]}]
set_property PACKAGE_PIN G14 [get_ports {out[2]}]
set_property PACKAGE_PIN M15 [get_ports {out[1]}]
set_property PACKAGE_PIN M14 [get_ports {out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {out[3]}]
set_property DRIVE 12 [get_ports {out[0]}]
#set_property PACKAGE_PIN R18 [get_ports clk]
#set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN Y16 [get_ports {bitlocation[0]}]
set_property PACKAGE_PIN V16 [get_ports {bitlocation[1]}]
set_property PACKAGE_PIN P16 [get_ports {bitlocation[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bitlocation[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bitlocation[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bitlocation[2]}]
set_property PACKAGE_PIN T16 [get_ports {outSel[0]}]
set_property PACKAGE_PIN W13 [get_ports {outSel[1]}]
set_property PACKAGE_PIN P15 [get_ports {outSel[2]}]
set_property PACKAGE_PIN G15 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports {outSel[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {outSel[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {outSel[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports rst]