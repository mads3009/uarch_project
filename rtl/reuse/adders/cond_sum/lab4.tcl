#Tcl script which can be used with JasperGold
#Use "source lab4.tcl" in the console to source this script

#Reading the files 
analyze -v2k { wallace_abc_adder.v wallace_abc_adder_top.v cond_sum16.v  cond_sum32.v  cond_sum8.v  microarch.v };
analyze -sv  { bind_wrapper_wallace_abc_adder.sv };

#Elaborating the design
elaborate -top {wallace_abc_adder_top};

#You will need to add commands below

#Set the clock
clock -clear; clock clk

#Set Reset
reset -expression {rst};

#Prove all
prove -bg -all

