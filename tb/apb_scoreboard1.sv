class apb_scoreboard1;

  mailbox #(apb_txn1) mbx;

  // Associative memory (professional model)
  bit [7:0] ref_mem [bit [7:0]];

  function new(mailbox #(apb_txn1) mbx);
    this.mbx = mbx;
  endfunction


  task run();
    apb_txn1 tx;

    forever begin
      mbx.get(tx);

      //------------------------
      // WRITE operation
      //------------------------
      if (tx.PWRITE) begin
        ref_mem[tx.PADDR] = tx.PWDATA;

        $display("[%0t] [MASTER] WRITE addr=%0h data=%0h",
                  $time, tx.PADDR, tx.PWDATA);
      end

      //------------------------
      // READ operation
      //------------------------
      else begin

        // If address never written before
        if (!ref_mem.exists(tx.PADDR)) begin
          $display("[%0t] [INFO] First READ addr=%0h default=0",
                    $time, tx.PADDR);

          if (tx.PRDATA !== 8'h00) begin
            $error("[%0t]  MISMATCH addr=%0h exp=00 got=%0h",
                    $time, tx.PADDR, tx.PRDATA);
          end
          else begin
            $display("[%0t]  MATCH addr=%0h data=%0h",
                      $time, tx.PADDR, tx.PRDATA);
          end
        end

        // If address already written
        else begin
          if (tx.PRDATA !== ref_mem[tx.PADDR]) begin
            $error("[%0t]  MISMATCH addr=%0h exp=%0h got=%0h",
                    $time, tx.PADDR,
                    ref_mem[tx.PADDR], tx.PRDATA);
          end
          else begin
            $display("[%0t] [SLAVE] READ addr=%0h data=%0h",
                      $time, tx.PADDR, tx.PRDATA);
          end
        end

      end

    end
  endtask

endclass
