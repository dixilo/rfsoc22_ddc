`timescale 1ns/100ps

module packet_gate #(
    parameter N_CH = 16
)(
    input  wire         s_axis_aclk,
    input  wire         s_axis_aresetn,

    input  wire [95:0] s_axis_tdata,
    input  wire        s_axis_tvalid,
    output wire        s_axis_tready,

    output wire [95:0] m_axis_tdata,
    output wire        m_axis_tvalid,
    input  wire        m_axis_tready
);

    reg [8:0] valid_counter;
    reg [8:0] void_counter;
    reg gate_open;
    
    assign m_axis_tdata = s_axis_tdata;
    assign s_axis_tready = m_axis_tready;

    assign m_axis_tvalid = s_axis_tvalid & gate_open;

    wire valid_condition = (valid_counter == (N_CH - 1));
    wire void_condition = (void_counter == (256 - N_CH));

    always @(posedge s_axis_aclk) begin
        if( s_axis_aresetn == 1'b0) begin
            valid_counter <= 8'b0;
            void_counter <= 8'b0;
            gate_open <= 1'b0;
        end else begin
            if (s_axis_tvalid) begin
                void_counter <= 1'b0;
                if (valid_condition) begin
                    gate_open <= 1'b1;
                end else begin
                    valid_counter <= valid_counter + 1;
                end
            end else begin
                valid_counter <= 1'b0;
                if (void_condition) begin
                    gate_open <= 1'b0;
                end else begin
                    void_counter <= void_counter + 1;
                end
            end
        end
    end

endmodule
