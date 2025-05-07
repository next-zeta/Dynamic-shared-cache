`timescale 1ns / 1ps

module tb_SimpleModule;

    parameter CLK_PERIOD = 10; // 时钟周期
    parameter NUM_FILES = 16;  // 对应 16 位 test_input

    // 信号声明
    logic clk;
    logic rst_n;
    logic [NUM_FILES-1:0] test_input; // 16 位宽
    logic all_eof;

    // 变量声明
    integer file [NUM_FILES];
    integer status [NUM_FILES];
    integer test_case_count = 0;

    // 实例化被测试模块（假设为 test_i，需替换为实际模块名）
    test_i uut (
        .clk(clk),
        .rst_n(rst_n),
        .test_input(test_input)
        // 添加其他端口连接
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // 复位生成
    initial begin
        rst_n = 0;
        #(CLK_PERIOD * 5); // 复位 5 个时钟周期
        rst_n = 1;
    end

    // 测试序列
    initial begin
        // 初始化输入
        test_input = 0;

        // 打开 16 个文件
        for (int i = 0; i < NUM_FILES; i++) begin
            string filename;
            $sformat(filename, "D:/rate/ic/DC/Dynamic-shared-cache/test/test_sequence_%0d.txt", i);
            file[i] = $fopen(filename, "r");
            if (file[i] == 0) begin
                $display("Error opening %s", filename);
                $stop; // 暂停仿真但不终止
            end
        end

        // 等待复位释放
        @(posedge rst_n);
        $display("Reset released, starting test sequence at Time=%0t", $time);

        // 读取文件并应用到 test_input
        while (1) begin
            all_eof = 1;
            for (int i = 0; i < NUM_FILES; i++) begin
                if (!$feof(file[i])) begin
                    all_eof = 0;
                    status[i] = $fscanf(file[i], "%b\n", test_input[i]);
                    if (status[i] != 1) begin
                        $display("Warning: Invalid data in file %0d at test case %0d, setting bit %0d to 0", i, test_case_count, i);
                        test_input[i] = 0;
                    end
                end else begin
                    test_input[i] = 0; // 文件结束，填 0
                end
            end

            if (all_eof) break; // 所有文件都读完，退出循环

            $display("Test Case %0d, Time=%0t: test_input=%b", 
                     test_case_count, $time, test_input);
            test_case_count++;
            repeat(1) @(posedge clk); // 等待三个时钟周期
        end

        // 关闭所有文件
        for (int i = 0; i < NUM_FILES; i++) begin
            $fclose(file[i]);
        end
        $display("Reached end of all test sequence files at Time=%0t, Total test cases: %0d", 
                 $time, test_case_count);
        // 不结束仿真，继续运行
        forever @(posedge clk);
    end

    // 断言：验证每位 1 连续至少 5 次
    generate
        for (genvar i = 0; i < NUM_FILES; i++) begin : assert_blocks
            property min_ones_check;
                @(posedge clk) disable iff (!rst_n)
                test_input[i] == 1 |-> test_input[i] == 1 [*4];
            endproperty
            assert property(min_ones_check) else
                $display("Assertion failed for bit %0d at Time=%0t: test_input[%0d]=1 not sustained for 5 cycles", 
                         i, $time, i);
        end
    endgenerate

endmodule