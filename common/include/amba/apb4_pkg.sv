package apb4_pkg;
/* verilator lint_off UNUSEDPARAM */

//==============================================================================
//  Widths

localparam int PADDR_WIDTH      = 32;
localparam int PDATA_WIDTH      = 32;
localparam int PSTRB_WIDTH      = PDATA_WIDTH / 8;
localparam int PPROT_WIDTH      = 3;

//==============================================================================
//  Encodings (PPROT bit fields, OR them together)

localparam logic [PPROT_WIDTH-1:0]
    PPROT_NORMAL            = 3'b000,
    PPROT_PRIVILEGED        = 3'b001,
    PPROT_SECURE            = 3'b000,
    PPROT_NONSECURE         = 3'b010,
    PPROT_DATA              = 3'b000,
    PPROT_INSTRUCTION       = 3'b100;

localparam int
    PPROT_PRIVILEGED_BIT    = 0,
    PPROT_NONSECURE_BIT     = 1,
    PPROT_INSTRUCTION_BIT   = 2;

//==============================================================================
//  Port structures

typedef struct packed {
    logic [PADDR_WIDTH-1:0]     paddr;
    logic [PPROT_WIDTH-1:0]     pprot;
    logic                       psel;
    logic                       penable;
    logic                       pwrite;
    logic [PDATA_WIDTH-1:0]     pwdata;
    logic [PSTRB_WIDTH-1:0]     pstrb;      // 0 on reads
} apb_req_t;

typedef struct packed {
    logic [PDATA_WIDTH-1:0]     prdata;
    logic                       pready;
    logic                       pslverr;    // valid only in the last ACCESS cycle
} apb_resp_t;

//==============================================================================
//  Defaults

function automatic apb_req_t apb_req_idle();
    apb_req_t r;
    r = '0;
    return r;
endfunction

function automatic apb_resp_t apb_resp_okay();
    apb_resp_t r;
    r        = '0;
    r.pready = 1'b1;
    return r;
endfunction

//==============================================================================
//  Helpers
//  (take whole structs and read only some fields: unused bits are expected)

/* verilator lint_off UNUSEDSIGNAL */

// SETUP phase
function automatic logic apb_is_setup(input apb_req_t q);
    return q.psel & ~q.penable;
endfunction

// ACCESS phase (may still be waiting on PREADY)
function automatic logic apb_is_access(input apb_req_t q);
    return q.psel & q.penable;
endfunction

// last cycle of a transfer: PSEL && PENABLE && PREADY
function automatic logic apb_xfer_done(input apb_req_t q, input apb_resp_t p);
    return q.psel & q.penable & p.pready;
endfunction

// merge PWDATA into the old register value byte by byte using PSTRB
function automatic logic [PDATA_WIDTH-1:0] apb_wdata_merge(
    input logic [PDATA_WIDTH-1:0]   orig,
    input apb_req_t                 q
);
    logic [PDATA_WIDTH-1:0] r;
    logic [PDATA_WIDTH-1:0] wd;     // locals: Icarus cannot part-select struct members in a loop
    logic [PSTRB_WIDTH-1:0] st;
    wd = q.pwdata;
    st = q.pstrb;
    for (int n = 0; n < PSTRB_WIDTH; n++)
        r[n*8 +: 8] = st[n] ? wd[n*8 +: 8] : orig[n*8 +: 8];
    return r;
endfunction

/* verilator lint_on UNUSEDSIGNAL */
/* verilator lint_on UNUSEDPARAM */

endpackage
