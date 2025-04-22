vlog ../../../sideband_env/test/pack1.sv
vsim -voptargs=+acc work.top
run 0
do wave_uvm.do
# add wave -position insertpoint  \
# sim:/uvm_root/uvm_test_top/env/agent/driver/count \
# sim:/uvm_root/uvm_test_top/env/agent/driver/sb_pattern_detected \
# sim:/uvm_root/uvm_test_top/env/agent/driver/new_resp \
# sim:/uvm_root/uvm_test_top/env/agent/driver/new_req \
# sim:/uvm_root/uvm_test_top/env/agent/driver/rsp \
# sim:/uvm_root/uvm_test_top/env/agent/driver/req \
# sim:/uvm_root/uvm_test_top/env/agent/driver/trans
run -all