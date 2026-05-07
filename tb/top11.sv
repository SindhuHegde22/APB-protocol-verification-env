`timescale 1ns/1ps

`include "apb_txn1.sv"
`include "apb_master.sv"
`include "apb_monitor1.sv"
`include "apb_scoreboard1.sv"
`include "apb_env.sv"
`include "apb_assertions.sv"
`include "apb_coverage.sv"
`include "apb_if1.sv"
`include "apb_slave1.sv"

module top11;

  logic clk;
  apb_if vif(clk);

  apb_slave dut(vif);

  apb_env env;
  apb_assertions asr(vif);
  apb_coverage cov(vif);

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    vif.PRESETn = 0;
    #20 vif.PRESETn = 1;
  end

  initial begin
    env = new(vif);
    env.run();

    #2000 $finish;
  end

endmodule
