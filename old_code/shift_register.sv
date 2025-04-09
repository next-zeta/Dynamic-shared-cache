module shift_register(
    system_if.slave     sys_if,
    input        [15:0] port_req,
    input        [10:0] space_port_0,
    input        [10:0] space_port_1,
    input        [10:0] space_port_2,
    input        [10:0] space_port_3,
    output logic [15:0] port_align,
    output logic [4:0]  port_sram [15:0],
    output       [4:0]  port_0_find,
    output       [4:0]  port_1_find,
    output       [4:0]  port_2_find,
    output       [4:0]  port_3_find
);

    integer i;
    logic [4:0] port_0_reg;
    logic [4:0] port_4_reg;
    logic [4:0] port_8_reg;
    logic [4:0] port_12_reg;
    logic [4:0] port_1_reg;
    logic [4:0] port_5_reg;
    logic [4:0] port_9_reg;
    logic [4:0] port_13_reg;
    logic [4:0] port_2_reg;
    logic [4:0] port_6_reg;
    logic [4:0] port_10_reg;
    logic [4:0] port_14_reg;
    logic [4:0] port_3_reg;
    logic [4:0] port_7_reg;
    logic [4:0] port_11_reg;
    logic [4:0] port_15_reg;
    logic [4:0] port_0_reg_tmp;
    logic [4:0] port_4_reg_tmp;
    logic [4:0] port_8_reg_tmp;
    logic [4:0] port_12_reg_tmp;
    logic [4:0] port_1_reg_tmp;
    logic [4:0] port_5_reg_tmp;
    logic [4:0] port_9_reg_tmp;
    logic [4:0] port_13_reg_tmp;
    logic [4:0] port_2_reg_tmp;
    logic [4:0] port_6_reg_tmp;
    logic [4:0] port_10_reg_tmp;
    logic [4:0] port_14_reg_tmp;
    logic [4:0] port_3_reg_tmp;
    logic [4:0] port_7_reg_tmp;
    logic [4:0] port_11_reg_tmp;
    logic [4:0] port_15_reg_tmp;
    logic [4:0] port_4_reg_max;
    logic [4:0] port_12_reg_max;
    logic [4:0] port_5_reg_max;
    logic [4:0] port_13_reg_max;
    logic [4:0] port_6_reg_max;
    logic [4:0] port_14_reg_max;
    logic [4:0] port_7_reg_max;
    logic [4:0] port_15_reg_max;
    logic [10:0] space_sram [31:0];

    assign port_0_find = port_0_reg;
    assign port_1_find = port_1_reg;
    assign port_2_find = port_2_reg;
    assign port_3_find = port_3_reg;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 比较器实例化
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    comparator_port port_4(
        .port(port_4_reg),
        .a(space_sram[port_4_reg - 5'd7]),
        .b(space_sram[port_4_reg]),
        .c(space_sram[port_4_reg + 5'd7]),
        .port_max(port_4_reg_max)
    );
    comparator_port port_12(
        .port(port_12_reg),
        .a(space_sram[port_12_reg - 5'd7]),
        .b(space_sram[port_12_reg]),
        .c(space_sram[port_12_reg + 5'd7]),
        .port_max(port_12_reg_max)
    );
    comparator_port port_5(
        .port(port_5_reg),
        .a(space_sram[port_5_reg - 5'd7]),
        .b(space_sram[port_5_reg]),
        .c(space_sram[port_5_reg + 5'd7]),
        .port_max(port_5_reg_max)
    );
    comparator_port port_13(
        .port(port_13_reg),
        .a(space_sram[port_13_reg - 5'd7]),
        .b(space_sram[port_13_reg]),
        .c(space_sram[port_13_reg + 5'd7]),
        .port_max(port_13_reg_max)
    );
    comparator_port port_6(
        .port(port_6_reg),
        .a(space_sram[port_6_reg - 5'd7]),
        .b(space_sram[port_6_reg]),
        .c(space_sram[port_6_reg + 5'd7]),
        .port_max(port_6_reg_max)
    );
    comparator_port port_14(
        .port(port_14_reg),
        .a(space_sram[port_14_reg - 5'd7]),
        .b(space_sram[port_14_reg]),
        .c(space_sram[port_14_reg + 5'd7]),
        .port_max(port_14_reg_max)
    );
    comparator_port port_7(
        .port(port_7_reg),
        .a(space_sram[port_7_reg - 5'd7]),
        .b(space_sram[port_7_reg]),
        .c(space_sram[port_7_reg + 5'd7]),
        .port_max(port_7_reg_max)
    );
    comparator_port port_15(
        .port(port_15_reg),
        .a(space_sram[port_15_reg - 5'd7]),
        .b(space_sram[port_15_reg]),
        .c(space_sram[port_15_reg + 5'd7]),
        .port_max(port_15_reg_max)
    );

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 状态机定义
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    typedef enum logic [1:0] {
        COMPARE,  // 比较SRAM空间数量
        UPDATE,   // 更新SRAM空间数量，并给出对齐信号
        SHIFT     // 移位
    } state_t;

    state_t state, next_state;

    always_ff @(posedge sys_if.clk) begin
        if (!sys_if.rst) begin
            state <= COMPARE;
        end else begin
            state <= next_state;
        end
    end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 寄存器逻辑
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    always_ff @(posedge sys_if.clk) begin
        if (!sys_if.rst) begin
            port_0_reg_tmp <= 5'd0;
            port_4_reg_tmp <= 5'd14;
            port_8_reg_tmp <= 5'd28;
            port_12_reg_tmp <= 5'd10;
            port_1_reg_tmp <= 5'd24;
            port_5_reg_tmp <= 5'd6;
            port_9_reg_tmp <= 5'd20;
            port_13_reg_tmp <= 5'd2;
            port_2_reg_tmp <= 5'd16;
            port_6_reg_tmp <= 5'd30;
            port_10_reg_tmp <= 5'd12;
            port_14_reg_tmp <= 5'd26;
            port_3_reg_tmp <= 5'd8;
            port_7_reg_tmp <= 5'd22;
            port_11_reg_tmp <= 5'd4;
            port_15_reg_tmp <= 5'd18;
        end else begin
            port_0_reg_tmp <= port_0_reg;
            port_4_reg_tmp <= port_4_reg;
            port_8_reg_tmp <= port_8_reg;
            port_12_reg_tmp <= port_12_reg;
            port_1_reg_tmp <= port_1_reg;
            port_5_reg_tmp <= port_5_reg;
            port_9_reg_tmp <= port_9_reg;
            port_13_reg_tmp <= port_13_reg;
            port_2_reg_tmp <= port_2_reg;
            port_6_reg_tmp <= port_6_reg;
            port_10_reg_tmp <= port_10_reg;
            port_14_reg_tmp <= port_14_reg;
            port_3_reg_tmp <= port_3_reg;
            port_7_reg_tmp <= port_7_reg;
            port_11_reg_tmp <= port_11_reg;
            port_15_reg_tmp <= port_15_reg;
        end
    end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 组合逻辑
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    always_comb begin
        if (!sys_if.rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                space_sram[i] = 11'd2047;
            end
            port_0_reg = 5'd0;
            port_4_reg = 5'd14;
            port_8_reg = 5'd28;
            port_12_reg = 5'd10;
            port_1_reg = 5'd24;
            port_5_reg = 5'd6;
            port_9_reg = 5'd20;
            port_13_reg = 5'd2;
            port_2_reg = 5'd16;
            port_6_reg = 5'd30;
            port_10_reg = 5'd12;
            port_14_reg = 5'd26;
            port_3_reg = 5'd8;
            port_7_reg = 5'd22;
            port_11_reg = 5'd4;
            port_15_reg = 5'd18;
            for (i = 0; i < 16; i = i + 1) begin
                port_align[i] = 1'b0;
            end
        end else begin
            case (state)
                COMPARE: begin
                    next_state = UPDATE;
                    port_sram[0] = port_0_reg;
                    port_sram[4] = port_4_reg_max;
                    port_sram[8] = port_8_reg;
                    port_sram[12] = port_12_reg_max;
                    port_sram[1] = port_1_reg;
                    port_sram[5] = port_5_reg_max;
                    port_sram[9] = port_9_reg;
                    port_sram[13] = port_13_reg_max;
                    port_sram[2] = port_2_reg;
                    port_sram[6] = port_6_reg_max;
                    port_sram[10] = port_10_reg;
                    port_sram[14] = port_14_reg_max;
                    port_sram[3] = port_3_reg;
                    port_sram[7] = port_7_reg_max;
                    port_sram[11] = port_11_reg;
                    port_sram[15] = port_15_reg_max;
                    for (i = 0; i < 16; i = i + 1) begin
                        port_align[i] = 1'b0;
                    end
                end
                UPDATE: begin
                    next_state = SHIFT;
                    for (i = 0; i < 16; i = i + 1) begin
                        if (port_req[i]) begin
                            port_align[i] = 1'b1;
                        end else begin
                            port_align[i] = 1'b0;
                        end
                    end
                    space_sram[port_0_reg] = space_port_0;
                end
                SHIFT: begin
                    next_state <= COMPARE;
                    for (i = 0; i < 16; i = i + 1) begin
                        port_align[i] = 1'b0;
                    end
                    port_0_reg = port_0_reg_tmp + 5'd11;
                    port_4_reg = port_4_reg_tmp + 5'd11;
                    port_8_reg = port_8_reg_tmp + 5'd11;
                    port_12_reg = port_12_reg_tmp + 5'd11;
                    port_1_reg = port_1_reg_tmp + 5'd11;
                    port_5_reg = port_5_reg_tmp + 5'd11;
                    port_9_reg = port_9_reg_tmp + 5'd11;
                    port_13_reg = port_13_reg_tmp + 5'd11;
                    port_2_reg = port_2_reg_tmp + 5'd11;
                    port_6_reg = port_6_reg_tmp + 5'd11;
                    port_10_reg = port_10_reg_tmp + 5'd11;
                    port_14_reg = port_14_reg_tmp + 5'd11;
                    port_3_reg = port_3_reg_tmp + 5'd11;
                    port_7_reg = port_7_reg_tmp + 5'd11;
                    port_11_reg = port_11_reg_tmp + 5'd11;
                    port_15_reg = port_15_reg_tmp + 5'd11;
                end
                default: begin
                    next_state = COMPARE;
                end
            endcase
        end
    end

endmodule
