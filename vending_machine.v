`timescale 1ns / 1ps

module vending_machine (
    input clk,
    input reset,
    input [2:0] coin,            // 3'b001 = ?1, 010 = ?2, 100 = ?5
    output reg product,
    output reg [3:0] change,
    output reg [4:0] total_debug // for observation
);

    reg [4:0] total;          // registered state
    reg [4:0] next_total;     // combinational next total
    reg [4:0] coin_value;

    // Coin decoding
    always @(*) begin
        case (coin)
            3'b001: coin_value = 1;
            3'b010: coin_value = 2;
            3'b100: coin_value = 5;
            default: coin_value = 0;
        endcase
    end

    // Combinational logic for next_total and outputs
    always @(*) begin
        next_total = total + coin_value;

        if (next_total >= 10) begin
            product = 1;
            change = next_total - 10;
            total_debug = 0;  // reset total_debug after dispensing
        end else begin
            product = 0;
            change = 0;
            total_debug = next_total; // immediate updated total
        end
    end

    // Sequential logic to update total on clock edge
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            total <= 0;
        end else begin
            if (next_total >= 10)
                total <= 0;   // reset after dispensing
            else
                total <= next_total;
        end
    end

endmodule

