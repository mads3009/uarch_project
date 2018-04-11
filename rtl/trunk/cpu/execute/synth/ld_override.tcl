set LIB_PATH ../../../../../synth/lib/
set SCRIPTS_PATH ../../../../../synth/scripts/
set HDL_PATH ./

set current_design ld_override
set myFiles [list ld_override.v]

set SDC_FILE ./constraints_${current_design}.sdc

source ${SCRIPTS_PATH}/rc.tcl

