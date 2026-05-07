class apb_monitor;

  mailbox #(apb_txn1) mbx;
  virtual apb_if vif;

  function new(mailbox #(apb_txn1) mbx, virtual apb_if vif);
    this.mbx = mbx;
    this.vif = vif;
  endfunction

  task run();
    apb_txn1 tx;

    forever begin
      @(posedge vif.PCLK);

      if (vif.PSEL && vif.PENABLE && vif.PREADY) begin
        tx = new();

        tx.PADDR  = vif.PADDR;
        tx.PWRITE = vif.PWRITE;
        tx.PWDATA = vif.PWDATA;
        tx.PRDATA = vif.PRDATA;

        mbx.put(tx);
      end
    end
  endtask

endclass
