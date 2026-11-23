/* verilator lint_off UNUSEDPARAM */

// widths
localparam  HADDR_WIDTH             = 32;
localparam  HDATA_WIDTH             = 32;
localparam  HWSTRB_WIDTH            = HDATA_WIDTH / 8;
localparam  HTRANS_WIDTH            = 2;
localparam  HSIZE_WIDTH             = 3;
localparam  HBURST_WIDTH            = 3;
localparam  HPROT_WIDTH             = 4;
localparam  HRESP_WIDTH             = 1;

// HTRANS
localparam  [1:0]
            HTRANS_IDLE             = 2'b00,
            HTRANS_BUSY             = 2'b01,
            HTRANS_NONSEQ           = 2'b10,
            HTRANS_SEQ              = 2'b11;

// HSIZE
localparam  [2:0]
            HSIZE_BYTE              = 3'b000,
            HSIZE_HWORD             = 3'b001,
            HSIZE_WORD              = 3'b010,
            HSIZE_DWORD             = 3'b011;

// HBURST
localparam  [2:0]
            HBURST_SINGLE           = 3'b000,
            HBURST_INCR             = 3'b001,
            HBURST_WRAP4            = 3'b010,
            HBURST_INCR4            = 3'b011,
            HBURST_WRAP8            = 3'b100,
            HBURST_INCR8            = 3'b101,
            HBURST_WRAP16           = 3'b110,
            HBURST_INCR16           = 3'b111;

// HPROT
localparam  HPROT_DATA_BIT          = 0,
            HPROT_PRIVILEGED_BIT    = 1,
            HPROT_BUFFERABLE_BIT    = 2,
            HPROT_MODIFIABLE_BIT    = 3;

localparam  [3:0]
            HPROT_DEFAULT           = 4'b0011;

// HRESP
localparam  HRESP_OKAY              = 1'b0,
            HRESP_ERROR             = 1'b1;

/* verilator lint_on UNUSEDPARAM */
