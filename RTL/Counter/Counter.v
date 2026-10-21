`timescale 1ns / 1ps

module counter_2_1 (
    input  wire sys_clk,    // 50MHz 系统时钟
    input  wire sys_rst_n,  // 异步复位按钮（低电平有效）
    output reg  led_out     // LED 输出（低电平有效，0亮1灭）
);

    // 定义25位计数器和最大计数值 (25,000,000 - 1)
    reg [24:0] cnt;
    localparam MAX_VAL = 25'd9;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            // 异步复位：任何时刻按下，立即返回初始状态
            cnt     <= 25'd0;
            led_out <= 1'b0;      // 初始状态LED亮起 (低电平有效)
        end else begin
            if (cnt == MAX_VAL) begin
                // 达到0.5秒，翻转LED状态并清零计数器
                cnt     <= 25'd0;
                led_out <= ~led_out; 
            end else begin
                // 未达到0.5秒，计数器加1
                cnt     <= cnt + 1'b1;
            end
        end
    end

endmodule
