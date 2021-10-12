#Read All Files
read_file ../src/top.sv
current_design top
link

#Setting Clock Constraints
source -echo -verbose ../script/DC.sdc

#Synthesis all design
compile -map_effort high -area_effort high

write -format ddc     -hierarchy -output "../syn/top_syn.ddc"
write_sdf ../syn/top_syn.sdf
write_file -format verilog -hierarchy -output ../syn/top_syn.v
report_area > ../syn/area.log
report_timing > ../syn/timing.log
report_qor   >  ../syn/top_syn.qor

