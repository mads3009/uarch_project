set LIB_PATH ../../../../synth/lib/
set SCRIPTS_PATH ../../../../synth/scripts/
set HDL_PATH ./

set current_design alu1
set myFiles [list alu1.v or.v and.v not.v bit_shift_left_flgs.v bit_shift_right_flgs.v compare_netlist.v cond_sum32_c.v cond_sum16_c.v cond_sum8_c.v parity_netlist.v zero_sizes.v ../../../reuse/sub_designs/mux3bit_2x1.v ../../../reuse/sub_designs/mux4bit_2x1.v ../../../reuse/sub_designs/mux4bit_3x1.v ../../../reuse/sub_designs/mux2bit_2x1.v ../../../reuse/sub_designs/eq_checker8_netlist.v ../../../reuse/adders/cond_sum/cond_sum32.v ../../../reuse/adders/cond_sum/cond_sum16.v ../../../reuse/adders/cond_sum/cond_sum8.v ../../../reuse/adders/cond_sum/cond_sum_abc.v ../../../reuse/adders/cond_sum/wallace_abc_adder.v ../../../reuse/sub_designs/demux_1x16.v ../../../reuse/sub_designs/eq_checker.v ../../../reuse/sub_designs/mux4_32.v  ../../../reuse/sub_designs/eq_checker16_netlist.v ../../../reuse/sub_designs/mux16bit_8x1.v         ../../../reuse/sub_designs/mux32bit_2x1.v ../../../reuse/sub_designs/eq_checker32_netlist.v  ../../../reuse/sub_designs/mux32bit_4x1.v      ../../../reuse/sub_designs/mux8bit_8x1.v      ../../../reuse/sub_designs/eq_checker3_netlist.v   ../../../reuse/sub_designs/mux32bit_16x1.v ../../../reuse/sub_designs/mux32bit_8x1.v   ../../../reuse/sub_designs/mux_nbit_2x1.v  ../../../reuse/sub_designs/mux_nbit_4x1.v ld_override_netlist.v ../../../reuse/sub_designs/greater_than4_netlist.v ../../../reuse/sub_designs/greater_than32_netlist.v ../../../reuse/sub_designs/greater_than_for_af_netlist.v ../../../reuse/sub_designs/greater_than_for_flags_netlist8.v ../../../reuse/sub_designs/greater_than_for_flags_netlist16.v ../../../reuse/sub_designs/greater_than_for_flags_netlist32.v ]


set SDC_FILE ./constraints_${current_design}.sdc

source ${SCRIPTS_PATH}/rc.tcl

