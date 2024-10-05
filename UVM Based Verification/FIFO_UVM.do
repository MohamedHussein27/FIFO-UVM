vlib work
vlog -f fifo_files_list.txt +cover -covercells
vsim -voptargs=+acc work.fifo_top -cover
add wave /fifo_top/fifoif/*
coverage save top.ucdb -onexit
run -all