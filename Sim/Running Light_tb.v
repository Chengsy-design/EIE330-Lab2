`timescale 1ns / 1ps

module tb_running_light_2_2();

    // 输入信号使用 reg[cite: 5]
    reg sys_clk;
    reg sys_rst_n;
    
    // 输出信号使用 wire[cite: 5]
    wire [3:0] led_out;

    // 实例化流水灯模块
    running_light_2_2 u_running_light (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .led_out(led_out)
    );

    // 生成 50MHz 时钟 (20ns 周期)
    always #10 sys_clk = ~sys_clk;

    initial begin
        // 生成供分析用的 vcd 波形文件[cite: 5]
        $dumpfile("tb_running_light_2_2.vcd");
        $dumpvars(0, tb_running_light_2_2);

        // 1. 初始化
        sys_clk = 0;
        sys_rst_n = 0;

        // 释放复位键
        #100;
        sys_rst_n = 1;

        // 2. 观察完整的循环及 wrap-around 过程[cite: 5]
        // 4个LED每个亮0.5秒，完整一圈需要 2.0秒 (2,000,000,000 ns)
        // 等待 2.2 秒，以确保看到从最后一个LED循环回到第一个LED的现象
        #2_200_000_000;

        // 3. 验证流水灯中途被复位的行为[cite: 5]
        sys_rst_n = 0; // 模拟按下复位键
        #50;
        sys_rst_n = 1; // 释放，预期应立刻回到只有LED0亮的状态(4'b1110)

        // 等待0.6秒，观察复位后是否能够正常切换到下一个状态
        #600_000_000;

        // 结束仿真
        $finish;
    end

endmodule