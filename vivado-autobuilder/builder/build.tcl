# Copyright (c) 2017 Daichi Teruya
# Released under the MIT license
# http://opensource.org/licenses/mit-license.php
source builder/settings.tcl

### Create New Project ###
create_project -force $project_name $project_directory

source builder/project_generator.tcl

launch_runs synth_1 -job 8
wait_on_run synth_1

launch_runs impl_1 -job 8
wait_on_run impl_1

launch_runs impl_1 -to_step write_bitstream -job 8
wait_on_run impl_1

close_project


