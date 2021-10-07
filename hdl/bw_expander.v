`timescale 1ns/100ps

module bw_expander (
    input  wire [ 95:0] s_axis_tdata,
    input  wire         s_axis_tvalid,
    output wire         s_axis_tready,

    output wire [127:0] m_axis_tdata,
    output wire         m_axis_tvalid,
    input  wire         m_axis_tready
);

    assign m_axis_tdata = {{16{s_axis_tdata[95]}}, s_axis_tdata[95:48], {16{s_axis_tdata[47]}}, s_axis_tdata[47:0]};
    assign s_axis_tready = m_axis_tready;
    assign m_axis_tvalid = s_axis_tvalid;

endmodule