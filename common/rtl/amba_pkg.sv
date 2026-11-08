package amba_pkg;
/* verilator lint_off UNUSEDPARAM */

localparam  HADDR_WIDTH     = 32;
localparam  HDATA_WIDTH     = 32;

//------------------------------------------------------------------------------
//  AHB signal definition

localparam  HTRANS_WIDTH    = 2;
typedef enum logic [HTRANS_WIDTH-1:0] {
    HTRANS_IDLE             = 2'b00,
    HTRANS_BUSY             = 2'b01,
    HTRANS_NONSEQ           = 2'b10,
    HTRANS_SEQ              = 2'b11
} htrans_e;

localparam  HSIZE_WIDTH     = 3;
typedef enum logic [HSIZE_WIDTH-1:0] {
    HSIZE_B8                = 3'b000,
    HSIZE_B16               = 3'b001,
    HSIZE_B32               = 3'b010,
    HSIZE_B64               = 3'b011,
    HSIZE_B128              = 3'b100,
    HSIZE_B256              = 3'b101,
    HSIZE_B1024             = 3'b111,
    HSIZE_BYTE              = HSIZE_B8,
    HSIZE_HWORD             = HSIZE_B16,
    HSIZE_WORD              = HSIZE_B32,
    HSIZE_DWORD             = HSIZE_B64
} hsize_e;
 
localparam  HBURST_WIDTH    = 3;
typedef enum logic [HBURST_WIDTH-1:0] {
    HBURST_SINGLE           = 3'b000,
    HBURST_INCR             = 3'b001,
    HBURST_WRAP4            = 3'b010,
    HBURST_INCR4            = 3'b011,
    HBURST_WRAP8            = 3'b100,
    HBURST_INCR8            = 3'b101,
    HBURST_WRAP16           = 3'b110,
    HBURST_INCR16           = 3'b111
} hburst_e;

localparam  HPROT_WIDTH     = 4;
typedef enum logic [HPROT_WIDTH-1:0] {
    HPROT_DATA              = 4'b0001,
    HPROT_PRIVILEGED        = 4'b0010,
    HPROT_BUFFERABLE        = 4'b0100,
    HPROT_CACHEABLE         = 4'b1000
} hprot_e;

localparam  HRESP_WIDTH     = 2;
typedef enum logic [HRESP_WIDTH-1:0] {
    HRESP_OKAY              = 2'b00,
    HRESP_ERROR             = 2'b01,
    HRESP_RETRY             = 2'b10,
    HRESP_SPLIT             = 2'b11
} hresp_e;

localparam  HMASTER_WIDTH   = 4;

//------------------------------------------------------------------------------
//  APH port structure Definition
//
//  [Usage]
//      input   ahb_req_t  i_src
//      output  ahb_resp_t o_src
//
//      output  ahb_req_t  o_dst
//      input   ahb_resp_t i_dst

typedef struct packed {
    logic     [HADDR_WIDTH-1:0] haddr;
    logic                       hwrite;
    htrans_e                    htrans;
    hsize_e                     hsize;
    hburst_e                    hburst;
    hprot_e                     hprot;
    logic   [HMASTER_WIDTH-1:0] hmaster;
    logic                       hmastlock;
    logic                       hexcl;
} ahb_req_aph_t;

typedef struct packed {
    logic     [HDATA_WIDTH-1:0] hwdata;
} ahb_req_dph_t;

typedef struct packed {
    ahb_req_aph_t               aph;                   
    ahb_req_dph_t               dph;
} ahb_req_t;

typedef struct packed {
    logic                       hreadyout;
    hresp_e                     hresp;
    logic                       hexokay;
    logic     [HDATA_WIDTH-1:0] hrdata;
} ahb_resp_t;

/* verilator lint_on UNUSEDPARAM */
endpackage
