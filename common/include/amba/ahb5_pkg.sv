package ahb5_pkg;
/* verilator lint_off UNUSEDPARAM */

//==============================================================================
//  Widths

localparam int HADDR_WIDTH      = 32;
localparam int HDATA_WIDTH      = 32;
localparam int HWSTRB_WIDTH     = HDATA_WIDTH / 8;
localparam int HTRANS_WIDTH     = 2;
localparam int HSIZE_WIDTH      = 3;
localparam int HBURST_WIDTH     = 3;
localparam int HPROT_WIDTH      = 4;
localparam int HRESP_WIDTH      = 1;
localparam int HMASTER_WIDTH    = 8;

//==============================================================================
//  Encodings

typedef enum logic [HTRANS_WIDTH-1:0] {
    HTRANS_IDLE             = 2'b00,
    HTRANS_BUSY             = 2'b01,
    HTRANS_NONSEQ           = 2'b10,
    HTRANS_SEQ              = 2'b11
} htrans_e;

typedef enum logic [HSIZE_WIDTH-1:0] {
    HSIZE_B8                = 3'b000,
    HSIZE_B16               = 3'b001,
    HSIZE_B32               = 3'b010,
    HSIZE_B64               = 3'b011,
    HSIZE_B128              = 3'b100,
    HSIZE_B256              = 3'b101,
    HSIZE_B512              = 3'b110,
    HSIZE_B1024             = 3'b111
} hsize_e;

// aliases (an enum cannot hold two names with the same value)
localparam hsize_e
    HSIZE_BYTE              = HSIZE_B8,
    HSIZE_HWORD             = HSIZE_B16,
    HSIZE_WORD              = HSIZE_B32,
    HSIZE_DWORD             = HSIZE_B64;

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

localparam logic [HPROT_WIDTH-1:0]
    HPROT_OPCODE            = 4'b0000,
    HPROT_DATA              = 4'b0001,
    HPROT_USER              = 4'b0000,
    HPROT_PRIVILEGED        = 4'b0010,
    HPROT_NON_BUFFERABLE    = 4'b0000,
    HPROT_BUFFERABLE        = 4'b0100,
    HPROT_NON_MODIFIABLE    = 4'b0000,
    HPROT_MODIFIABLE        = 4'b1000;  // "Cacheable" in AHB-Lite

localparam int
    HPROT_DATA_BIT          = 0,
    HPROT_PRIVILEGED_BIT    = 1,
    HPROT_BUFFERABLE_BIT    = 2,
    HPROT_MODIFIABLE_BIT    = 3;

localparam logic [HPROT_WIDTH-1:0]
    HPROT_DEFAULT           = HPROT_DATA | HPROT_PRIVILEGED;

typedef enum logic [HRESP_WIDTH-1:0] {
    HRESP_OKAY              = 1'b0,
    HRESP_ERROR             = 1'b1
} hresp_e;

//==============================================================================
//  Port structures

typedef struct packed {
    logic [HADDR_WIDTH-1:0]     haddr;
    logic [HTRANS_WIDTH-1:0]    htrans;
    logic                       hwrite;
    logic [HSIZE_WIDTH-1:0]     hsize;
    logic [HBURST_WIDTH-1:0]    hburst;
    logic [HPROT_WIDTH-1:0]     hprot;
    logic                       hmastlock;
    logic [HMASTER_WIDTH-1:0]   hmaster;
    logic                       hexcl;
} ahb_aph_t;

// data phase, manager-driven
typedef struct packed {
    logic [HDATA_WIDTH-1:0]     hwdata;
    logic [HWSTRB_WIDTH-1:0]    hwstrb;     // write data phase only
} ahb_dph_t;

// manager port
typedef struct packed {
    ahb_aph_t                   aph;
    ahb_dph_t                   dph;
} ahb_req_t;

typedef struct packed {
    logic                       hready;     // bus HREADY
    logic [HRESP_WIDTH-1:0]     hresp;
    logic                       hexokay;
    logic [HDATA_WIDTH-1:0]     hrdata;
} ahb_resp_t;

// subordinate port
typedef struct packed {
    logic                       hsel;       // from decoder
    ahb_aph_t                   aph;
    ahb_dph_t                   dph;
    logic                       hready;     // bus HREADY, not own HREADYOUT
} ahb_sreq_t;

typedef struct packed {
    logic                       hreadyout;
    logic [HRESP_WIDTH-1:0]     hresp;
    logic                       hexokay;
    logic [HDATA_WIDTH-1:0]     hrdata;
} ahb_sresp_t;

//==============================================================================
//  Defaults
//  (functions instead of '{field: ..} constants: Icarus cannot parse those)

function automatic ahb_req_t ahb_req_idle();
    ahb_req_t r;
    r            = '0;
    r.aph.htrans = HTRANS_IDLE;
    r.aph.hprot  = HPROT_DEFAULT;
    return r;
endfunction

function automatic ahb_sresp_t ahb_sresp_okay();
    ahb_sresp_t r;
    r           = '0;
    r.hreadyout = 1'b1;
    r.hresp     = HRESP_OKAY;
    return r;
endfunction

//==============================================================================
//  Helpers
//  (take whole structs/addresses and read only some bits: unused bits are expected)

// NONSEQ or SEQ
function automatic logic ahb_is_active(input logic [HTRANS_WIDTH-1:0] htrans);
    return htrans[1];
endfunction

// subordinate accepts an address phase: HSEL && HREADY && HTRANS[1]
function automatic logic ahb_aph_accept(input ahb_sreq_t s);
    return s.hsel & s.hready & s.aph.htrans[1];
endfunction

function automatic logic ahb_is_wrap(input logic [HBURST_WIDTH-1:0] hburst);
    return (hburst != HBURST_SINGLE) & ~hburst[0];
endfunction

// beats in a fixed-length burst (SINGLE/INCR return 1: INCR is undefined length)
function automatic int ahb_hburst2beats(input logic [HBURST_WIDTH-1:0] hburst);
    case (hburst)
        HBURST_WRAP4,  HBURST_INCR4  : return 4;
        HBURST_WRAP8,  HBURST_INCR8  : return 8;
        HBURST_WRAP16, HBURST_INCR16 : return 16;
        default                      : return 1;
    endcase
endfunction

function automatic int ahb_hsize2bytes(input logic [HSIZE_WIDTH-1:0] hsize);
    return 1 << hsize;
endfunction

// IHI 0033 3.4: HSIZE no wider than the data bus, and HADDR aligned to HSIZE
function automatic logic ahb_hsize_legal(
    input logic [HADDR_WIDTH-1:0]   haddr,
    input logic [HSIZE_WIDTH-1:0]   hsize
);
    logic [HADDR_WIDTH-1:0] amask;
    amask = HADDR_WIDTH'(ahb_hsize2bytes(hsize) - 1);
    return (ahb_hsize2bytes(hsize) <= HWSTRB_WIDTH) && ((haddr & amask) == '0);
endfunction

// byte lanes selected by HADDR/HSIZE (little-endian). Use to check HWSTRB
// against the transfer, or to build a full-strobe HWSTRB.
// Valid only when ahb_hsize_legal(haddr, hsize): an oversized HSIZE returns
// all lanes and an unaligned HADDR drops the upper lanes, without any error.
function automatic logic [HWSTRB_WIDTH-1:0] ahb_lane_mask(
    input logic [HADDR_WIDTH-1:0]   haddr,
    input logic [HSIZE_WIDTH-1:0]   hsize
);
    logic [HWSTRB_WIDTH-1:0] base;
    base = HWSTRB_WIDTH'((1 << (1 << hsize)) - 1);
    return base << haddr[$clog2(HWSTRB_WIDTH)-1:0];
endfunction

// would nbytes starting at haddr cross a 1KB boundary?
function automatic logic ahb_cross_1kb(
    input logic [HADDR_WIDTH-1:0]   haddr,
    input logic [10:0]              nbytes
);
    return (11'({1'b0, haddr[9:0]}) + nbytes) > 11'd1024;
endfunction

endpackage

/* verilator lint_on UNUSEDPARAM */
