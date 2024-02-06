`timescale 1ns / 1ps

module tb_packet_gate(
    );
    
    parameter STEP_SYS = 40;

    // input
    logic        s_axis_aclk;
    logic        s_axis_aresetn;

    logic [95:0] s_axis_tdata;
    logic        s_axis_tvalid;
    logic        s_axis_tready;

    logic [95:0] m_axis_tdata;
    logic        m_axis_tvalid;
    logic        m_axis_tready;

    
    packet_gate dut(.*);

    task clk_gen();
        s_axis_aclk = 0;
        forever #(STEP_SYS/2) s_axis_aclk = ~s_axis_aclk;
    endtask
    
    task rst_gen();
        m_axis_tready = 1;
        s_axis_tdata = 0;
        s_axis_tvalid = 0;

        s_axis_aresetn = 0;
        #(STEP_SYS*20);
        s_axis_aresetn = 1;
    endtask
    
    initial begin
        fork
            clk_gen();
            rst_gen();
        join_none

        #(STEP_SYS*20);


        for(int i = 0; i < 15; i++) begin
            @(posedge s_axis_aclk);
            s_axis_tvalid <= 1;
            s_axis_tdata <= i;
        end
        @(posedge s_axis_aclk);
        s_axis_tvalid <= 0;

        repeat(256-16-1) @(posedge s_axis_aclk);
        for(int i = 0; i < 16; i++) begin
            @(posedge s_axis_aclk);
            s_axis_tvalid <= 1;
            s_axis_tdata <= i;
        end
        @(posedge s_axis_aclk);
        s_axis_tvalid <= 0;

        repeat(300) @(posedge s_axis_aclk);
        
        for(int i = 0; i < 16; i++) begin
            @(posedge s_axis_aclk);
            s_axis_tvalid <= 1;
            s_axis_tdata <= i;
        end
        @(posedge s_axis_aclk);
        s_axis_tvalid <= 0;
        repeat(256-16-1) @(posedge s_axis_aclk);
        for(int i = 0; i < 16; i++) begin
            @(posedge s_axis_aclk);
            s_axis_tvalid <= 1;
            s_axis_tdata <= i;
        end
        @(posedge s_axis_aclk);
        s_axis_tvalid <= 0;
        
        repeat(300) @(posedge s_axis_aclk);
        $finish;
    end
    
endmodule