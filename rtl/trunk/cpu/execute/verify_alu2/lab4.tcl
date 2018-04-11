#Tcl script which can be used with JasperGold
#Use "source lab4.tcl" in the console to source this script

#Reading the files 
analyze -v2k { alu2.v alu2_top.v or.v and.v not.v bit_shift_left_flgs.v bit_shift_right_flgs.v compare_netlist.v cond_sum32_c.v cond_sum16_c.v cond_sum8_c.v parity_netlist.v zero_sizes.v microarch.v ../../../reuse/sub_designs/mux3bit_2x1.v ../../../reuse/sub_designs/mux4bit_2x1.v ../../../reuse/sub_designs/mux4bit_3x1.v ../../../reuse/sub_designs/mux2bit_2x1.v ../../../reuse/sub_designs/eq_checker8_netlist.v ../../../reuse/adders/cond_sum/cond_sum32.v ../../../reuse/adders/cond_sum/cond_sum16.v ../../../reuse/adders/cond_sum/cond_sum8.v ../../../reuse/adders/cond_sum/cond_sum_abc.v ../../../reuse/adders/cond_sum/wallace_abc_adder.v ../../../reuse/sub_designs/demux_1x16.v ../../../reuse/sub_designs/eq_checker.v ../../../reuse/sub_designs/mux4_32.v  ../../../reuse/sub_designs/eq_checker16_netlist.v ../../../reuse/sub_designs/mux16bit_8x1.v         ../../../reuse/sub_designs/mux32bit_2x1.v ../../../reuse/sub_designs/eq_checker32_netlist.v  ../../../reuse/sub_designs/mux32bit_4x1.v      ../../../reuse/sub_designs/mux8bit_8x1.v      ../../../reuse/sub_designs/eq_checker3_netlist.v   ../../../reuse/sub_designs/mux32bit_16x1.v ../../../reuse/sub_designs/mux32bit_8x1.v   ../../../reuse/sub_designs/mux_nbit_2x1.v  ../../../reuse/sub_designs/mux_nbit_4x1.v /home/projects/courses/spring_18/ee382n-16120/lib/lib1 /home/projects/courses/spring_18/ee382n-16120/lib/lib2 /home/projects/courses/spring_18/ee382n-16120/lib/lib3 /home/projects/courses/spring_18/ee382n-16120/lib/lib4 /home/projects/courses/spring_18/ee382n-16120/lib/lib5 /home/projects/courses/spring_18/ee382n-16120/lib/lib6 ld_override_netlist.v};



analyze -sv  { bind_wrapper_alu2.sv };

#Elaborating the design
elaborate -top {alu2_top};

#You will need to add commands below

#Set the clock
clock -clear; clock clk

#Set Reset
reset -expression {rst};

#Prove all
prove -bg -all

