class apb_master;

  mailbox #(apb_txn1) mbx;
  virtual apb_if vif;

  function new(mailbox #(apb_txn1) mbx, virtual apb_if vif);
    this.mbx = mbx;
    this.vif = vif;
  endfunction

  task run();
    apb_txn1 tx;

    forever begin
      mbx.get(tx);

      // SETUP
      @(posedge vif.PCLK);
      vif.PSEL    <= 1;
      vif.PENABLE <= 0;
      vif.PADDR   <= tx.PADDR;
      vif.PWRITE  <= tx.PWRITE;
      vif.PWDATA  <= tx.PWDATA;

      // ACCESS
      @(posedge vif.PCLK);
      vif.PENABLE <= 1;

      // WAIT
      wait(vif.PREADY);

      // Decide back-to-back or not
      if ($urandom_range(0,1)) begin
        // BACK-TO-BACK (no IDLE)
        @(posedge vif.PCLK);
        vif.PENABLE <= 0;
      end
      else begin
        // GO IDLE
        @(posedge vif.PCLK);
        vif.PSEL    <= 0;
        vif.PENABLE <= 0;

        // random gap
        repeat($urandom_range(1,3)) @(posedge vif.PCLK);
      end

    end
  endtask

endclass
