`timescale 1ns/1ns

module sramCTRL (
    input clk, rst,

    input MEM_R_EN, MEM_W_EN,
    input [31:0] address, write_data,
    
    output [31:0] read_data,
    output ready,

    inout [31:0] data_SRAM,
    output [15:0] address_SRAM,
    output WE_N_SRAM
);

    integer cycle = 0;
    wire [31:0] temp_address = (address - 1023) / 4;

    assign read_data = data_SRAM;
    assign ready = (cycle == 6) ? 1 : (MEM_W_EN || MEM_R_EN) ? 0 : 1;
    assign data_SRAM = WE_N_SRAM ? {32{1'bz}} : write_data;
    assign address_SRAM = temp_address[15:0];
    assign WE_N_SRAM = ~MEM_W_EN;

    always@(posedge clk, posedge rst) begin
        if (rst) cycle = 0;
        else if (MEM_W_EN || MEM_R_EN) begin
            if(cycle == 6) begin
                cycle = 0;
            end
            else cycle = cycle + 1;
        end
    end

endmodule