# Copyright (c) 2017 Daichi Teruya
# Released under the MIT license
# http://opensource.org/licenses/mit-license.php
source "builder/settings.tcl"

########################################
### Create Base System for ZedBoaard ###
########################################
# Prepare Block Design Struction
create_bd_design $design_name
set_property  ip_repo_paths  C:/Xilinx/sysdev/zed/ip [current_project]
update_ip_catalog

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup

apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]

# Add BRAM and GPIO
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
endgroup

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_0
endgroup
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1}] [get_bd_cells axi_bram_ctrl_0]

startgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_gpio_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:board -config {Board_Interface "btns_5bits ( Push buttons ) " }  [get_bd_intf_pins axi_gpio_0/GPIO]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "New Blk_Mem_Gen" }  [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA]
endgroup

##########################
### Install PyCoRAM IP ###
##########################
# Add HP0 Interface into ZYNQ
startgroup
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP0 {1} CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {32}] [get_bd_cells processing_system7_0]
endgroup

# Add PyCoRAM IP
lappend ip_repo_path_list [file join $project_directory "ips/"]
puts "INFO: Set IP repositories paths"
set_property ip_repo_paths $ip_repo_path_list [current_fileset]
update_ip_catalog -rebuild

startgroup
create_bd_cell -type ip -vlnv PyCoRAM:user:pycoram_userlogic:1.0 pycoram_userlogic_0
endgroup

# Connect PyCoRAM IP to ZYNQ
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/pycoram_userlogic_0/ctrl_thread_corammemory_0_AXI" Clk "Auto" }  [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins pycoram_userlogic_0/ctrl_thread_coramiochannel_0_AXI]
endgroup

# PyCoRAM IP Connection
connect_bd_net [get_bd_pins pycoram_userlogic_0/UCLK] [get_bd_pins processing_system7_0/FCLK_CLK0]
connect_bd_net [get_bd_pins pycoram_userlogic_0/ctrl_thread_CCLK] [get_bd_pins processing_system7_0/FCLK_CLK0]
connect_bd_net [get_bd_pins pycoram_userlogic_0/URESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]
connect_bd_net [get_bd_pins pycoram_userlogic_0/ctrl_thread_CRESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]

regenerate_bd_layout
assign_bd_address

####################
### Make Wrapper ###
####################
save_bd_design
set design_bd_name  [get_bd_designs]
make_wrapper -files [get_files $design_bd_name.bd] -top -import
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

