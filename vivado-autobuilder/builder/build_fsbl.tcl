# Copyright (c) 2017 Daichi Teruya
# Released under the MIT license
# http://opensource.org/licenses/mit-license.php
source "builder/settings.tcl"

set app_name            "fsbl"
set app_type            {Zynq FSBL}
set bsp_name            "fsbl_bsp"
set proc_name           "ps7_cortexa9_0"
set workspace           [file join $project_directory $project_name.sdk]

sdk set_workspace $workspace
sdk create_hw_project -name $hw_name -hwspec [file join $workspace $hwspec_file]
sdk create_app_project -name fsbl -app {Zynq FSBL} -proc $proc_name -hwproject $hw_name -os standalone

sdk build_project -type all

