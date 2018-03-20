# Clock period = 5ns and Duty cycle = 50%
create_clock -period 5 -waveform "0 2.5" [get_ports clk] -name clk

set in_ports [remove_from_collection [all_inputs] [get_ports clk]]

set_input_delay  4 -clock [get_clocks clk] $in_ports
set_output_delay 4 -clock [get_clocks clk] [all_outputs]

