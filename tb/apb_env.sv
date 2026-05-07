class apb_env;

  apb_master mst;
  apb_monitor mon;
  apb_scoreboard1 sb;

  mailbox #(apb_txn1) mst_mbx;
  mailbox #(apb_txn1) mon_mbx;

  virtual apb_if vif;

  function new(virtual apb_if vif);
    this.vif = vif;

    mst_mbx = new();
    mon_mbx = new();

    mst = new(mst_mbx, vif);
    mon = new(mon_mbx, vif);
    sb  = new(mon_mbx);
  endfunction

  task run();
    fork
      mst.run();
      mon.run();
      sb.run();
    join_none

    // stimulus
    repeat (30) begin
      apb_txn1 tx = new();
      assert(tx.randomize());
      mst_mbx.put(tx);
    end
  endtask

endclass
