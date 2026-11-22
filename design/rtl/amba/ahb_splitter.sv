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
//  * Module Name   : u_ahb_splitter
//  * Author        : Jesper
//  * Purpose       :
//
//  * Note
//      |   See '2.3 Immediate encoding variant' of the RISC-V unpriviliged document.
//
//  * Reference
//
//=================================================================* * * * *---*

module ahb_splitter import amba_pkg::*; #(
     parameter              PORT_NUM    = 2
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



