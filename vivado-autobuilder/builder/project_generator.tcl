# Copyright (c) 2017 Daichi Teruya
# Released under the MIT license
# http://opensource.org/licenses/mit-license.php
### Project Settings ###
set board_part [get_board_parts -quiet -latest_file_version "*zed*"]
if {[string equal $board_part ""] == 1} {
    puts "ERROR : No target board"
    return 1
}

set_property "board_part"         $board_part      [current_project]
set_property "default_lib"        "xil_defaultlib" [current_project]
set_property "simulator_language" "Mixed"          [current_project]
set_property "target_language"    "Verilog"        [current_project]

### Construct Project ###
# Create filesets
if {[string equal [get_filesets -quiet sources_1] ""]} {
    create_fileset -srcset sources_1
}
if {[string equal [get_filesets -quiet constrs_1] ""]} {
    create_fileset -constrset constrs_1
}
if {[string equal [get_filesets -quiet sim_1] ""]} {
    create_fileset -simset sim_1
}

# Set Design Run
set synth_1_flow     "Vivado Synthesis 2015"
set synth_1_strategy "Vivado Synthesis Defaults"
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -flow $synth_1_flow -strategy $synth_1_strategy -constrset constrs_1
} else {
    set_property flow     $synth_1_flow     [get_runs synth_1]
    set_property strategy $synth_1_strategy [get_runs synth_1]
}
current_run -synthesis [get_runs synth_1]

set impl_1_flow      "Vivado Implementation 2015"
set impl_1_strategy  "Vivado Implementation Defaults"
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -flow $impl_1_flow -strategy $impl_1_strategy -constrset constrs_1 -parent_run synth_1
} else {
    set_property flow     $impl_1_flow      [get_runs impl_1]
    set_property strategy $impl_1_strategy  [get_runs impl_1]
}
current_run -implementation [get_runs impl_1]

proc add_verilog_file {fileset_name library_name file_name} {
    set file    [file normalize $file_name]
    set fileset [get_filesets   $fileset_name] 
    add_files -norecurse -fileset $fileset $file
    set file_obj [get_files -of_objects $fileset $file]
    set_property "file_type" "Verilog"     $file_obj
    set_property "library"   $library_name $file_obj
}

source "builder/block_design_generator.tcl"
source "builder/constraints.tcl"
source "builder/sources.tcl"

