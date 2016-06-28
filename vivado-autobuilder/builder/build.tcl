# Copyright (c) 2017 Daichi Teruya
# Released under the MIT license
# http://opensource.org/licenses/mit-license.php
source builder/settings.tcl

### Create New Project ###
create_project -force $project_name $project_directory

source builder/project_generator.tcl

close_project


