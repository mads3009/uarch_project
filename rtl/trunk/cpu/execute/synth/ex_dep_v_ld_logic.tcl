set LIB_PATH ../../../../../synth/lib/
set SCRIPTS_PATH ../../../../../synth/scripts/
set HDL_PATH ./

set current_design ex_dep_v_ld_logic
set myFiles [list ex_dep_v_ld_logic.v]

set SDC_FILE ./constraints_${current_design}.sdc

source ${SCRIPTS_PATH}/rc.tcl

