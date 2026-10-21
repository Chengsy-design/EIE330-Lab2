`timescale 1ns / 1ps


module Running_Light (
    input  wire sys_clk,    // 50MHz 系统时钟
    input  wire sys_rst_n,  // 异步复位按钮（低电平有效）
    output reg  [3:0] led_out // 4个LED输出（低电平有效）
);

    // 定义25位计数器和最大计数值 (25,000,000 - 1)
    reg [24:0] cnt;
    localparam MAX_VAL = 25'd24_99_999;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            // 异步复位：任何时刻按下，立即返回初始状态
            cnt     <= 25'd0;
            led_out <= 4'b1110; // 初始状态：仅LED0亮 (最低位为0)
        end else begin
            if (cnt == MAX_VAL) begin
                // 达到0.5秒，计数器清零
                cnt     <= 25'd0;
                // 执行循环左移，将最高位移到最低位
                led_out <= {led_out[2:0], led_out[3]}; 
            end else begin
                // 未达到0.5秒，计数器加1
                cnt     <= cnt + 1'b1;
            end
        end
    end

endmodule
