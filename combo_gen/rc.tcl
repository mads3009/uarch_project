set_attribute hdl_search_path {./} 
set_attribute lib_search_path {./}

set_attribute library [list microarch.lib]

set current_design test
set myFiles [list test.v]

read_hdl ${myFiles}
elaborate ${current_design}

check_design -unresolved
report timing -lint

# Synthesize the design to the target library
synthesize -to_mapped

write_hdl -mapped >  ${current_design}_netlist.v
report_timing


