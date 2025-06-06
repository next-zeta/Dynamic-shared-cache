module bitmap #(
    parameter SRAM_ID = 0
)(
    input logic clk,
    input logic rst_n,
    
    input logic alloc_valid,
    output logic [4:0] sram_id,
    output logic bitmap_add
);
    
    // logic       bitmap_add;
    // logic [4:0] sram_id;
    logic [11:0] sram_memory;
    logic [31:0] random_val;

    // 假设使用 LFSR 或其他随机数生成方式
    // 这里简化为 $urandom，实际硬件实现可能需要 LFSR
    always_ff @(posedge clk) begin
        random_val <= $urandom;
    end

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            sram_id <= SRAM_ID;
        end
        else begin
            sram_id <= sram_id + 3;
        end
    end

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            sram_memory <= 12'd2048;
        end
        else if(alloc_valid && bitmap_add) begin
            sram_memory <= sram_memory;
        end
        else if(!alloc_valid && bitmap_add) begin
            sram_memory <= sram_memory + 1;
        end
        else if(alloc_valid && !bitmap_add) begin
            sram_memory <= sram_memory - 1;
        end
        else begin
            sram_memory <= sram_memory;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bitmap_add <= 0;
        end
        else if(sram_memory < 12'd2048 && random_val[1:0] == 2'b00) begin
            bitmap_add <= 1;
        end
        else begin
            bitmap_add <= 0;
        end
    end
endmodule