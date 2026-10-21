`timescale 1ns / 1ps

module tb_counter_2_1();

    // 输入信号使用 reg 定义，用于在 testbench 中驱动激励
    reg sys_clk;
    reg sys_rst_n;
    
    // 输出信号使用 wire 定义，用于观察模块输出
    wire led_out;

    // 实例化设计模块
    counter_2_1 u_counter (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .led_out(led_out)
    );

    // 生成 50MHz 时钟：周期为 20ns (每 10ns 翻转一次)[cite: 4, 5]
    always #10 sys_clk = ~sys_clk;

    initial begin
        // 生成供 GTKWave 和 vcd2csv 提取数据的 vcd 波形文件
        $dumpfile("tb_counter_2_1.vcd");
        $dumpvars(0, tb_counter_2_1);

        // 1. 初始化信号
        sys_clk = 0;
        sys_rst_n = 0; // 初始按下复位键

        // 延迟一段时间后释放复位键，开始正常计数
        #100;
        sys_rst_n = 1;

        // 2. 等待超过 0.5s 观察 toggle 翻转时刻
        // 0.5s = 500,000,000 ns。这里等待 600,000,000 ns 确保能看到LED翻转。
        #600_000_000;

        // 3. 在计数中途进行复位 (Reset pressed in the middle of a count)
        sys_rst_n = 0; // 模拟在任意时刻按下复位键
        #50;           // 保持复位状态一小段时间
        sys_rst_n = 1; // 释放复位键，预期LED立即恢复长亮并重新计时

        // 再等待一段时间观察恢复后的计时是否正常
        #600_000_000;

        // 结束仿真
        $finish;
    end

endmodule