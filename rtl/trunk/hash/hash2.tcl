set LIB_PATH ../../../synth/lib/
set SCRIPTS_PATH ../../../synth/scripts/
set HDL_PATH ./

set current_design hash2
set myFiles [list hash2.v]

set SDC_FILE ./constraints_${current_design}.sdc

source ${SCRIPTS_PATH}/rc.tcl

