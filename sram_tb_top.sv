// Top-level testbench module
module sram_tb_top;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sram_uvm_pkg::*;
    
    // Clock generation
    logic clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period = 100MHz
    end
    
    // Interface instance
    sram_if vif(clk);
    
    // DUT instance
    top_memory dut (
        .clk(vif.clk),
        .rst(vif.rst),
        .start(vif.start),
        .write_enable(vif.write_enable),
        .bank_select(vif.bank_select),
        .address(vif.address),
        .write_data(vif.write_data),
        .read_data(vif.read_data),
        .done(vif.done)
    );
    
    // Pass interface to UVM config DB
    initial begin
        uvm_config_db#(virtual sram_if)::set(null, "*", "vif", vif);
        
        // Enable waveform dump
        $dumpfile("sram_tb.vcd");
        $dumpvars(0, sram_tb_top);
        
        // Run the test
        run_test();
    end
    
    // Timeout watchdog
    initial begin
        #100000;  // 100us timeout
        `uvm_fatal("TIMEOUT", "Test timed out!")
        $finish;
    end
    
endmodule
