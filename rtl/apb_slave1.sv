module apb_slave(apb_if vif);

  typedef enum logic [1:0] {IDLE, SETUP, ACCESS} state_t;
  state_t state, next_state;

  logic [7:0] mem [0:255];
  logic [7:0] addr_reg, wdata_reg;
  logic [7:0] rdata_reg = 0;  
  logic [2:0] wait_cnt;
  logic [2:0] dynamic_wait;

  integer i;
  initial begin
    for (i = 0; i < 256; i++)
      mem[i] = 0;
  end

  // STATE
  always @(posedge vif.PCLK or negedge vif.PRESETn)
    if (!vif.PRESETn) state <= IDLE;
    else state <= next_state;

  // NEXT STATE
  always @(*) begin
    next_state = state;

    case(state)
      IDLE:  if (vif.PSEL) next_state = SETUP;
      SETUP: if (vif.PENABLE) next_state = ACCESS;
      ACCESS: if (vif.PREADY)
                next_state = (vif.PSEL ? SETUP : IDLE);
    endcase
  end

  // RANDOM WAIT
  always @(posedge vif.PCLK)
    if (state == SETUP)
      dynamic_wait <= $urandom_range(0,5);

  // WAIT COUNTER
  always @(posedge vif.PCLK or negedge vif.PRESETn)
    if (!vif.PRESETn) wait_cnt <= 0;
    else if (state == ACCESS && wait_cnt < dynamic_wait)
      wait_cnt <= wait_cnt + 1;
    else wait_cnt <= 0;

  assign vif.PREADY = (state == ACCESS) && (wait_cnt == dynamic_wait);

  // CAPTURE
  always @(posedge vif.PCLK)
    if (state == SETUP) begin
      addr_reg  <= vif.PADDR;
      wdata_reg <= vif.PWDATA;
    end

  // READ/WRITE
  always @(posedge vif.PCLK)
    if (state == ACCESS && vif.PREADY) begin
      if (vif.PWRITE)
        mem[addr_reg] <= wdata_reg;
      else
        rdata_reg <= mem[addr_reg];
    end

  assign vif.PRDATA = rdata_reg;

endmodule
