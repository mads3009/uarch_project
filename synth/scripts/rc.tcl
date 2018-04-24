# Synthesis script

set_attribute hdl_search_path $HDL_PATH
set_attribute lib_search_path $LIB_PATH

set_attribute library [list microarch.lib]
set_attribute auto_ungroup none

read_hdl ${myFiles}
elaborate ${current_design}

read_sdc ${SDC_FILE}

check_design -unresolved
report timing -lint

synthesize -to_generic
synthesize -to_mapped
report_timing

write_hdl -mapped >  ../${current_design}_netlist.v


