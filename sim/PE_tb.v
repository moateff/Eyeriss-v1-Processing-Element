`timescale 1ns / 1ps

module PE_tb();
    parameter CLK_PERIOD = 5;
    parameter DATA_WIDTH = 16;
	
    parameter DATA_WIDTH_IFMAP  = 16;
    parameter DATA_WIDTH_FILTER = 64;
    parameter DATA_WIDTH_PSUM   = 64;
    
    parameter IFMAP_FIFO_DEPTH  = 4;
    parameter FILTER_FIFO_DEPTH = 8;
    parameter PSUM_FIFO_DEPTH   = 8;
    
    parameter X_WIDTH = 1;
    parameter S_WIDTH = 6;    
    parameter F_WIDTH = 6;
    parameter U_WIDTH = 3;
    parameter n_WIDTH = 3;
    parameter p_WIDTH = 5;
    parameter q_WIDTH = 3;
    
    parameter IFMAP_SPAD_DEPTH  = 12;
    parameter FILTER_SPAD_DEPTH = 224;
    parameter PSUM_SPAD_DEPTH   = 24;
    
    parameter W_MAX = 227;
    parameter S_MAX = 11;
    parameter F_MAX = 55; 
    parameter U_MAX = 4;
	parameter n_MAX = 4;
    parameter p_MAX = 16;
    parameter q_MAX = 4;
    
    localparam IFMAP_MEM_SIZE  = n_MAX * W_MAX * q_MAX;
    localparam FILTER_MEM_SIZE = (p_MAX * q_MAX * S_MAX) / 4;
    localparam PSUM_MEM_SIZE   = (p_MAX * n_MAX * F_MAX) / 4;
    
    parameter LAYER_W = 227;
    parameter LAYER_S = 11;
    parameter LAYER_F = 55; 
    parameter LAYER_U = 4;
	parameter LAYER_n = 1;
    parameter LAYER_p = 16;
    parameter LAYER_q = 1;
  
    reg  clk;
    reg  reset;
    reg  enable;
    reg  configure;
    wire busy;
	
    reg [S_WIDTH - 1:0] S;    
    reg [F_WIDTH - 1:0] F;
    reg [U_WIDTH - 1:0] U;
    reg [n_WIDTH - 1:0] n;    
    reg [p_WIDTH - 1:0] p;      
    reg [q_WIDTH - 1:0] q;  
 
    reg  [DATA_WIDTH_IFMAP-1:0] ifmap_mem [0:IFMAP_MEM_SIZE - 1];  
	reg  [DATA_WIDTH_IFMAP-1:0] ifmap;
    reg                         push_ifmap;
	wire                        ifmap_fifo_full;
    
    reg  [DATA_WIDTH_FILTER-1:0] filter_mem [0:FILTER_MEM_SIZE - 1];  
	reg  [DATA_WIDTH_FILTER-1:0] filter;
    reg                          push_filter;
	wire                         filter_fifo_full;
	
	reg	 [DATA_WIDTH_PSUM-1:0] ipsum_mem [0:PSUM_MEM_SIZE - 1];
	reg  [DATA_WIDTH_PSUM-1:0] ipsum;
    reg                        push_ipsum;
	wire                       ipsum_fifo_full;

    reg  [DATA_WIDTH_PSUM-1:0] expected_output [0:PSUM_MEM_SIZE - 1];
    wire [DATA_WIDTH_PSUM-1:0] opsum; 
    reg                        pop_opsum;
    wire                       opsum_fifo_empty;
    
    always #(CLK_PERIOD/2.0) clk = ~clk;

    PE_wrapper #(
        .DATA_WIDTH(DATA_WIDTH),
        
        .DATA_WIDTH_IFMAP(DATA_WIDTH_IFMAP),
        .DATA_WIDTH_FILTER(DATA_WIDTH_FILTER),
        .DATA_WIDTH_PSUM(DATA_WIDTH_PSUM),
        
        .IFMAP_FIFO_DEPTH(IFMAP_FIFO_DEPTH),
        .FILTER_FIFO_DEPTH(FILTER_FIFO_DEPTH),
        .PSUM_FIFO_DEPTH(PSUM_FIFO_DEPTH),
        
        .U_WIDTH(U_WIDTH),
        .S_WIDTH(S_WIDTH),
        .F_WIDTH(F_WIDTH),
        .n_WIDTH(n_WIDTH),
        .p_WIDTH(p_WIDTH),
        .q_WIDTH(q_WIDTH),
        
        .IFMAP_SPAD_DEPTH(IFMAP_SPAD_DEPTH),
        .FILTER_SPAD_DEPTH(FILTER_SPAD_DEPTH),
        .PSUM_SPAD_DEPTH(PSUM_SPAD_DEPTH)
    ) DUT (
        .clk(clk),
        .reset(reset),
        
        .enable(enable),
        .configure(configure),
        .busy(busy),
           
        .S(S),
        .F(F),
        .U(U),
        .n(n),
        .p(p),
        .q(q), 
		
        .push_ifmap(push_ifmap),
        .ifmap(ifmap),
        .ifmap_fifo_full(ifmap_fifo_full),
        
        .push_filter(push_filter),
        .filter(filter), 
        .filter_fifo_full(filter_fifo_full), 
               
        .push_ipsum(push_ipsum),
        .ipsum(ipsum),
        .ipsum_fifo_full(ipsum_fifo_full),
        
        .pop_opsum(pop_opsum),
        .opsum(opsum),
        .opsum_fifo_empty(opsum_fifo_empty)
    );
	
    // Load input data
    initial begin
        $readmemb("ifmap_data.mem", ifmap_mem);
        $readmemb("filter_data.mem", filter_mem);
		$readmemb("ipsum_data.mem", ipsum_mem);
        $readmemb("expected_output.mem", expected_output);
    end
    
	//testing
    initial begin
		intialize_tb;
        wait_cycles(1);
		enable_pe;
        assert_reset;
        wait_cycles(1);
        cfg(LAYER_S, LAYER_F, LAYER_U, LAYER_n, LAYER_p, LAYER_q);
	end
	
    integer i;
	initial begin
		@(negedge configure)
		for (i = 0; i < LAYER_n * LAYER_W * LAYER_q; i = i + 1) begin
			while (ifmap_fifo_full) begin wait_cycles(1); end
			ifmap = ifmap_mem[i];
			push_ifmap = 1;
			wait_cycles(1);
			push_ifmap = 0;
			ifmap = 0;
			wait_cycles(1); 
		end
	end
    
    
	integer j;
    initial begin
        @(negedge configure);
        for (j = 0; j < (LAYER_p * LAYER_q * LAYER_S) / 4;j = j + 1) begin
            while (filter_fifo_full) begin wait_cycles(1); end 
            filter = filter_mem[j];
            push_filter = 1;
            wait_cycles(1);
            push_filter = 0;
            filter = 0;
            wait_cycles(1);
        end
    end
    
	
	integer k;
	initial begin
        @(negedge configure)
        for (k = 0; k < (LAYER_p * LAYER_n * LAYER_F) / 4; k = k + 1) begin
            while (ipsum_fifo_full) begin wait_cycles(1); end
            ipsum = ipsum_mem[k];
            push_ipsum  = 1'b1;
            wait_cycles(1);
            push_ipsum = 1'b0;
            ipsum = 0;
            while (DUT.ipsum_fifo_empty) begin wait_cycles(1); end
            wait_cycles(100); 
        end
    end

	integer	m;
	initial begin
		@(negedge configure)
		for (m = 0; m < (LAYER_p * LAYER_n * LAYER_F) / 4; m = m + 1) begin
            wait(!opsum_fifo_empty);
            wait_cycles(1);
            pop_opsum = 1'b1;
            if (opsum == expected_output[m]) begin
                $display("Correct reading at index %0d: Expected %h, Got %h at time = %0t", m, expected_output[m], opsum, $time);
            end else begin
                $display("Mismatch at index %0d: Expected %h, Got %h at time = %0t", m, expected_output[m], opsum, $time);
            end
            wait_cycles(1);
            pop_opsum = 1'b0;
            wait_cycles(100);
        end
        $stop;
	end
	
	task intialize_tb;
		begin
            clk       = 1'b0;
            reset     = 1'b0;
            enable    = 1'b0;
            configure = 1'b0;
               
            push_ifmap  = 1'b0;
            push_filter = 1'b0;
            push_ipsum  = 1'b0;
            pop_opsum   = 1'b0; 
		end
	endtask
	
	task wait_cycles;
        input integer num_cycles;
        begin
            repeat(num_cycles) @(posedge clk);
        end
    endtask
	
	task enable_pe;
        begin
            enable = 1'b1; 
        end
    endtask
	
	task assert_reset;
        begin
            reset = 1'b1;
            wait_cycles(1);      
            reset = 1'b0; 
        end
    endtask
	
    task cfg;
        input [S_WIDTH - 1:0] cfg_S;
        input [F_WIDTH - 1:0] cfg_F;
        input [U_WIDTH - 1:0] cfg_U;
        input [n_WIDTH - 1:0] cfg_n;
        input [p_WIDTH - 1:0] cfg_p;
        input [q_WIDTH - 1:0] cfg_q;        
        begin
            S = cfg_S;
            F = cfg_F;
            U = cfg_U;
            n = cfg_n;  
            p = cfg_p; 
            q = cfg_q;
              
            configure = 1'b1; 
            wait_cycles(1);      
            configure = 1'b0;
            
            S = 0;
            F = 0;
            U = 0;
            n = 0;  
            p = 0; 
            q = 0; 
        end
    endtask
	
endmodule