module apb_coverage(apb_if vif);

  //========================
  // COVERGROUP
  //========================
  covergroup cg @(posedge vif.PCLK);

    // Read / Write
    cp_rw: coverpoint vif.PWRITE {
      bins READ  = {0};
      bins WRITE = {1};
    }

    // Ready / Wait
    cp_ready: coverpoint vif.PREADY {
      bins WAIT  = {0};
      bins READY = {1};
    }

    // Address distribution
    cp_addr: coverpoint vif.PADDR {
      bins low  = {[0:85]};
      bins mid  = {[86:170]};
      bins high = {[171:255]};
    }

  endgroup

  //========================
  // INSTANCE
  //========================
  cg c;

  initial begin
    c = new();
  end

endmodule
