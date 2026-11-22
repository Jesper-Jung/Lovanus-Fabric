//=================================================================* * * * *---*
//
//     +                       +                                 +
//    .         .         .        +          .          .         .         + .
// .    *       * *.  *      * **    **    * *    *   . * .   . *  .       .
//      .      .    \  .    / .  \   . \   . .     \ *       .      *        .
//  .   *     *      * *   *  * + *  *  *  * *      *  *           *    .           .
//       .     \    .   . /  .     \  .   \ . \     .     *      *        .      .
// .     * -- *  * *     *   *      * *    **   *  *   *      .      *       .      .
//   .         .         .          .          .          .  + Lovanus-Fabric +   .
//             +                   +                      +                   +
//
//  * Module Name   : u_cache
//  * Author        : Jesper
//  * Purpose       :
//
//  * Note
//      |   See '2.3 Immediate encoding variant' of the RISC-V unpriviliged document.
//
//  * Reference
//
//=================================================================* * * * *---*

module cache import amba_pkg::*; #(
    ,parameter              ADDR_W      = 32
    ,parameter              DATA_W      = 32
) (
     input                  hclk_i
    ,input                  hrst_ni

    ,input  ahb_req_t       src_i       [0:PORT_NUM-1]
    ,output ahb_resp_t      src_o       [0:PORT_NUM-1]

    ,input  ahb_resp_t      dst_i       [0:PORT_NUM-1]
    ,output ahb_req_t       dst_o       [0:PORT_NUM-1]
);

endmodule



module sram_array #(
     parameter DATA_W = 32
    ,parameter DEPTH_W = 6
) (
     input  wire                    clk_i
    ,input  wire                    rst_ni

    ,input  wire                    wen_i
    ,input  wire      [DEPTH_W-1:0] addr_i

    ,input  wire       [DATA_W-1:0] wdata_i
    ,output reg        [DATA_W-1:0] rdata_o
);

    reg [DATA_W-1:0] mem_r [DEPTH_W-1:0];
    initial for (integer i = 0; i < DEPTH; i++) mem_r[i] = 0;

    /**
     * 1w/r port, Sync Write, Sync Read
     *
     * Write: Sync, store if wen_i is high
     * Read : Sync, always output
     */
    
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (wen_i)
            mem_r[addr_i] <= wdata_i;
        rdata_o <= mem_r[addr_i];
    end


endmodule