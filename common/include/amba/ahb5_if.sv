interface ahb5_if #(
    parameter int HMASTER_W = 8
) (
    input  logic                    hclk,
    input  logic                    hrst_b
);

    // address phase (manager -> subordinate)
    logic                   hsel;
    logic [31:0]            haddr;
    logic [1:0]             htrans;
    logic                   hwrite;
    logic [2:0]             hsize;
    logic [2:0]             hburst;
    logic [3:0]             hprot;
    logic                   hmastlock;
    logic [HMASTER_W-1:0]   hmaster;
    logic                   hexcl;

    // data phase (manager -> subordinate)
    logic [31:0]            hwdata;
    logic [3:0]             hwstrb;

    // bus HREADY (interconnect -> subordinates and manager)
    logic                   hready;

    // response (subordinate -> manager)
    logic                   hreadyout;
    logic                   hresp;
    logic                   hexokay;
    logic [31:0]            hrdata;

    clocking mgr_cb @(posedge hclk);
        default input #1step output #2;
        output  hsel, haddr, htrans, hwrite, hsize, hburst, hprot, hmastlock, hmaster, hexcl,
                hwdata, hwstrb;
        input   hready, hreadyout, hresp, hexokay, hrdata;
    endclocking

    clocking mon_cb @(posedge hclk);
        default input #1step;
        input   hsel, haddr, htrans, hwrite, hsize, hburst, hprot, hmastlock, hmaster, hexcl,
                hwdata, hwstrb, hready, hreadyout, hresp, hexokay, hrdata;
    endclocking

    modport mgr (clocking mgr_cb, input hclk, hrst_b);
    modport mon (clocking mon_cb, input hclk, hrst_b);

endinterface
