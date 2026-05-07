module apb_assertions(apb_if vif);

  //========================
  // SETUP → ACCESS transition
  //========================
  // When in SETUP (PSEL=1, PENABLE=0),
  // next cycle must go to ACCESS (PENABLE=1)
  property setup_to_access;
    @(posedge vif.PCLK)
    (vif.PSEL && !vif.PENABLE)
    |-> ##1 vif.PENABLE;
  endproperty

  assert property (setup_to_access)
    else $error("[%0t] ASSERT FAIL: SETUP not followed by ACCESS",
                $time);


  //========================
  // PENABLE valid only when PSEL is high
  //========================
  property penable_valid;
    @(posedge vif.PCLK)
    vif.PENABLE |-> vif.PSEL;
  endproperty

  assert property (penable_valid)
    else $error("[%0t] ASSERT FAIL: PENABLE high when PSEL low",
                $time);


  //========================
  // Address stability during wait state
  //========================
  property addr_stable_during_wait;
    @(posedge vif.PCLK)
    (vif.PSEL && vif.PENABLE && !vif.PREADY)
    |-> $stable(vif.PADDR);
  endproperty

  assert property (addr_stable_during_wait)
    else $error("[%0t] ASSERT FAIL: PADDR changed during wait",
                $time);

endmodule
