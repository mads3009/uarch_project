set LIB_PATH ../../../../../synth/lib/
set SCRIPTS_PATH ../../../../../synth/scripts/
set HDL_PATH ./

set current_design dep_ld_reg
set myFiles [list dep_ld_reg.v]

set SDC_FILE ./constraints_${current_design}.sdc

source ${SCRIPTS_PATH}/rc.tcl

