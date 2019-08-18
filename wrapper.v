`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/08 14:38:48
// Design Name: 
// Module Name: wrapper1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/08 14:26:51
// Design Name: 
// Module Name: wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module wrappper #( parameter READ_LATENCY = 3, parameter ADDR_WIDTH = 15, parameter DATA_WIDTH = 31)
( input wire clk, input wire rst, input wire [ADDR_WIDTH-1:0] addr, input wire en, input wire we, input wire [DATA_WIDTH-1:0] din, output wire [DATA_WIDTH-1:0] dout, output reg vaild
    );
    blk_mem_gen_0 your_instance_name (
  .clka(clk),    // input wire clka
  .ena(en),      // input wire ena
  .wea(we),      // input wire [3 : 0] wea
  .addra(addr),  // input wire [5 : 0] addra
  .dina(din),    // input wire [31 : 0] dina
  .douta(dout)  // output wire [31 : 0] douta
);
reg [1:0] wait_counter;
reg [1:0] wait_counter_next;
reg en_to_bram;

enum { IDLE, WAIT, READ } state_aq, state_next;
// FSM


always @(posedge clk, negedge rst)
begin
    if(rst==1'b0) state_aq <= IDLE;
    else state_aq <= state_next;
end



always @(*)
begin
state_next = state_aq;
case(state_aq)
    IDLE : begin
    if(en == 1'b1 && we ==1'b0) begin
    if(READ_LATENCY == 1)
    state_next <= READ;
    else 
   state_next <= WAIT; end
    end

    WAIT : begin
    if(wait_counter == READ_LATENCY-1) state_next <= READ;
    end

    READ : begin
    state_next <= IDLE; 
    end
    endcase
 end
 


always @(*)
begin
state_next = state_aq;
case(state_aq)
    IDLE : begin
    en_to_bram = en;
    vaild = 0; end

    WAIT : begin
    en_to_bram = 1;
    vaild = 0; end

    READ : begin
    en_to_bram = 0;
    vaild = 1; end
    endcase
end



always@ (posedge clk, negedge rst)
begin
    if(rst ==1'b0) wait_counter <= 0;
    else  wait_counter <=wait_counter_next;
end


always@ (*)
begin
    wait_counter_next = wait_counter;
    case(state_aq) 
    IDLE : wait_counter_next = 2'b1;
    WAIT : wait_counter_next = wait_counter + 1'b1;
    default : wait_counter_next = 0; 
    endcase

 end
endmodule

