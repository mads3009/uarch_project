set LIB_PATH ../../../../../synth/lib/
set SCRIPTS_PATH ../../../../../synth/scripts/
set HDL_PATH ./

set current_design st_eq_checker
set myFiles [list st_eq_checker.v]

set SDC_FILE ./constraints_${current_design}.sdc

source ${SCRIPTS_PATH}/rc.tcl

