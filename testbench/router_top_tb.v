////////////////////////////////////////////////////////////////////////////////// 
// Engineer:        NIDHIN CHANDRAN
// 
// Create Date:     03/Aug/2024
// Module Name:     router_top_tb
// Project Name:    1X3 Router
//  
// Description:     testbench to verify the module - router_top 
// 
// 
//////////////////////////////////////////////////////////////////////////////////

module router_top_tb ();
    reg           clock;
    reg           resetn;
    reg           read_enb_0;
    reg           read_enb_1;
    reg           read_enb_2;
    reg           pkt_valid;
    reg[7:0]      data_in;
    wire          valid_out_0;
    wire          valid_out_1;
    wire          valid_out_2;
    wire          error;
    wire          busy;
    wire[7:0]     data_out_0;
    wire[7:0]     data_out_1;
    wire[7:0]     data_out_2;
    integer       i;
    router_top DUT(
        .clock(clock),
        .resetn(resetn),
        .read_enb_0(read_enb_0),
        .read_enb_1(read_enb_1),
        .read_enb_2(read_enb_2),
        .pkt_valid(pkt_valid),
        .data_in(data_in),
        .valid_out_0(valid_out_0),
        .valid_out_1(valid_out_1),
        .valid_out_2(valid_out_2),
        .error(error),
        .busy(busy),
        .data_out_0(data_out_0),
        .data_out_1(data_out_1),
        .data_out_2(data_out_2)
    );

    always  begin
        #5
        clock  = 0;
        #5
        clock  = 1;
    end

    task reset(); begin
        @ (negedge clock);
        resetn          =   0;
        read_enb_0      =   0;
        read_enb_1      =   0;
        read_enb_2      =   0;
        pkt_valid       =   0;
        data_in         =   0;
        @ (negedge clock);
        resetn = 1;
    end
    endtask

    task gen_packet(input[5:0]k,input[1:0]l); begin: t1     //  gen_packet(payload length, Destination Address)
        reg[7:0] header, payload, parity;
        reg[5:0] payld_len;
        reg[1:0] dest_addr;

        wait(!busy)
        @(negedge clock);
        payld_len       =   k;
        dest_addr       =   l;
        parity          =   8'b0;
        pkt_valid       =   1'b1;
        header          =   {payld_len, dest_addr};
        data_in         =   header;
        parity          =   parity  ^   data_in;
        
        @(negedge clock);
        for (i = 0; i < payld_len; i = i + 1) begin
            wait(!busy)
            @(negedge clock);

            payload     =   {$random}%256;
            data_in     =   payload;
            parity      =   parity  ^   data_in;
            
        end
        wait(!busy)
        @(negedge clock);
        pkt_valid       =   1'b0;
        data_in         =   parity;
    end  
    endtask

    task gen_error(input[5:0]k,input[1:0]l); begin: t2     //  gen_error(payload length, Destination Address)
        reg[7:0] header, payload, parity;
        reg[5:0] payld_len;
        reg[1:0] dest_addr;

        wait(!busy)
        @(negedge clock);
        payld_len       =   k;
        dest_addr       =   l;
        parity          =   8'b0;
        pkt_valid       =   1'b1;
        header          =   {payld_len, dest_addr};
        data_in         =   header;
        parity          =   parity  ^   data_in;
        
        @(negedge clock);
        for (i = 0; i < payld_len; i = i + 1) begin
            wait(!busy)
            @(negedge clock);

            payload     =   {$random}%256;
            data_in     =   payload;
            parity      =   parity  ^   data_in;
            
        end
        wait(!busy)
        @(negedge clock);
        pkt_valid       =   1'b0;
        data_in         =   parity + 1;
    end  
    endtask
    
    initial begin
        reset();
        gen_packet(6'h23, 2'h0);
        read_enb_1      =   1;
        gen_packet(6'h4, 2'h1);
        @(negedge clock);
        gen_packet(6'h8, 2'h2);
        repeat(32)
            @(negedge clock);
        read_enb_2      =   1;
        $finish;
    end
    
    initial begin
        repeat(20)
            @(negedge clock);
        read_enb_0      =   1;
    end

endmodule