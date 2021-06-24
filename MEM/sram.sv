`timescale 1ns/1ns

module sram (
    input clk, rst,
    input WE_N_SRAM,
    input [15:0] address_SRAM,
    inout [31:0] data_SRAM
);

    reg signed [31:0] memory [0:511];
    integer i;
    integer fd;

    assign #30 data_SRAM = WE_N_SRAM ? memory[address_SRAM] : {32{1'bz}};

    initial begin
        fd = $fopen("./build/memory.txt", "w");
        $fdisplay(fd, "MEMORY--------------------------------------------------------------------");
        for (i = 0; i<512; i=i+1) begin
            memory[i] = 0;
            $fdisplay(fd, "%d: %d", 4*i+1024, memory[i]);
        end
        $fclose(fd);
    end

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            fd = $fopen("./build/memory.txt", "w");
            $fdisplay(fd, "MEMORY--------------------------------------------------------------------");
            for (i = 0; i<512; i=i+1) begin
                memory[i] = 0;
                $fdisplay(fd, "%d: %d", 4*i+1024, memory[i]);
            end
            $fclose(fd);            
        end
        else if (~WE_N_SRAM) begin
            memory[address_SRAM] = data_SRAM;
            fd = $fopen("./build/memory.txt", "w");
            $fdisplay(fd, "MEMORY--------------------------------------------------------------------");
            for (i = 0; i<512; i=i+1)
                $fdisplay(fd, "%d: %d", 4*i+1024, memory[i]);
            $fclose(fd);
        end
    end
endmodule