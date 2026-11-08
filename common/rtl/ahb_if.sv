interface ahb_if import amba_pkg::*; (
     input logic    hclk_i
    ,input logic    hrst_ni
)

    ahb_req_t   ahb_req;
    ahb_resp_t  ahb_resp;
    logic       hready;
    logic       hsel;

    modport manager (
         input      hclk_i
        ,input      hrst_ni

        ,output     ahb_req
        ,input      ahb_resp
        ,input      hready
    );

    modport subordinate (
         input      hclk_i
        ,input      hrst_ni

        ,input      ahb_req
        ,output     ahb_resp
        ,input      hready
        ,input      hsel
    );

endinterface
