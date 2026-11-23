`default_nettype none
module ahb5_reg_if #(
     parameter REG_ADDR_W   = 5
    ,parameter HMASTER_W    = 8
) (
     input  wire                        i_hclk
    ,input  wire                        i_hrst_b

    // AHB5 subordinate
    /* verilator lint_off UNUSEDSIGNAL */
    ,input  wire                        i_hsel
    ,input  wire                 [31:0] i_haddr
    ,input  wire                  [1:0] i_htrans
    ,input  wire                        i_hwrite
    ,input  wire                  [2:0] i_hsize
    ,input  wire                  [2:0] i_hburst
    ,input  wire                  [3:0] i_hprot
    ,input  wire                        i_hmastlock
    ,input  wire        [HMASTER_W-1:0] i_hmaster
    ,input  wire                        i_hexcl
    /* verilator lint_on UNUSEDSIGNAL */
    ,input  wire                 [31:0] i_hwdata
    ,input  wire                  [3:0] i_hwstrb
    ,input  wire                        i_hready
    ,output wire                        o_hreadyout
    ,output wire                        o_hresp
    ,output wire                        o_hexokay
    ,output wire                 [31:0] o_hrdata

    // register bus
    ,output wire                        o_reg_wr
    ,output wire       [REG_ADDR_W-1:0] o_reg_addr
    ,output wire                 [31:0] o_reg_wdata
    ,output wire                  [3:0] o_reg_wstrb
    ,input  wire                 [31:0] i_reg_rdata
);

function [3:0] fn_lane_mask;
    input [1:0] lane;
    input [2:0] size;
    begin
        fn_lane_mask = ~(4'b1111 << (1 << size)) << lane;
    end
endfunction

//--------------------------------------
// Wiring & Reg Declaration

wire                    htrans_active;
wire                    aph_accept;

// data phase
reg                     dph_valid_r;
reg                     dph_write_r;
reg    [REG_ADDR_W-1:0] dph_addr_r;
reg               [3:0] dph_lane_mask_r;

//==============================================================================
// Address phase -> data phase

assign htrans_active    = i_htrans[1];
assign aph_accept       = i_hsel & i_hready & htrans_active;

always @(posedge i_hclk or negedge i_hrst_b) begin
    if      (~i_hrst_b  ) dph_valid_r <=     1'b0;
    else if ( i_hready  ) dph_valid_r <= #1  aph_accept;
end

always @(posedge i_hclk or negedge i_hrst_b) begin
    if (~i_hrst_b) begin
        dph_write_r     <=     1'b0;
        dph_addr_r      <=     {REG_ADDR_W{1'b0}};
        dph_lane_mask_r <=     4'b0000;
    end
    else if (aph_accept) begin
        dph_write_r     <= #1  i_hwrite;
        dph_addr_r      <= #1  i_haddr[REG_ADDR_W-1:0];
        dph_lane_mask_r <= #1  fn_lane_mask(i_haddr[1:0], i_hsize);
    end
end

//==============================================================================
// Outputs

assign o_hreadyout  = 1'b1;
assign o_hresp      = 1'b0;
assign o_hexokay    = 1'b0;
assign o_hrdata     = i_reg_rdata;

assign o_reg_wr     = dph_valid_r & dph_write_r;
assign o_reg_addr   = dph_addr_r;
assign o_reg_wdata  = i_hwdata;
assign o_reg_wstrb  = dph_lane_mask_r & i_hwstrb;

endmodule
`default_nettype wire
