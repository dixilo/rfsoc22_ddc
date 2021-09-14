`timescale 1ns/100ps

module tlast_gen #(
    parameter C_WIDTH = 32
)(
    input  wire         s_axis_aclk,
    input  wire         s_axis_aresetn,
    input  wire [C_WIDTH-1:0] packet_length,

    input  wire [127:0] s_axis_tdata,
    input  wire         s_axis_tvalid,
    output wire         s_axis_tready,

    output wire [127:0] m_axis_tdata,
    output wire         m_axis_tvalid,
    input  wire         m_axis_tready,
    output wire         m_axis_tlast
);

    reg [C_WIDTH-1:0] counter;
    
    assign m_axis_tdata = s_axis_tdata;
    assign s_axis_tready = m_axis_tready;
    assign m_axis_tvalid = m_axis_tvalid;

    wire last = (counter == (packet_length - 1));

    always @(posedge s_axis_aclk) begin
        if( s_axis_aresetn == 1'b0) begin
            counter <= {(C_WIDTH){1'b0}};
        end else begin
            if (m_axis_tready & s_axis_tvalid) begin
                if (last) begin
                    counter <= {(C_WIDTH){1'b0}};
                end else begin
                    counter <= counter + 1;
                end
            end
        end
    end

    assign m_axis_tlast = last & s_axis_tvalid;

endmodule