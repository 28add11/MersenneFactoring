module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/rtl/tb.fst");
    $dumpvars(0, tb);
end
endmodule
