set LIB_PATH ../../../../synth/lib/
set SCRIPTS_PATH ../../../../synth/scripts/
set HDL_PATH ./

set current_design writeback_loads_gen 
set myFiles [list ../writeback_loads_gen.v]

set SDC_FILE ./constraints_${current_design}.sdc

source ${SCRIPTS_PATH}/rc.tcl

