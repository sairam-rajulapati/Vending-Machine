`timescale 1ns / 1ps

module vending_machine_tb;

    reg clk;
    reg reset;
    reg [2:0] coin;
    wire product;
    wire [3:0] change;
    wire [4:0] total_debug;

    // Instantiate DUT
    vending_machine uut (
        .clk(clk),
        .reset(reset),
        .coin(coin),
        .product(product),
        .change(change),
        .total_debug(total_debug)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    // Coin sequences to simulate
    reg [2:0] coin_sequence [0:10];
    integer i;

    initial begin
        $display("=== Vending Machine Simulation ===");

        clk = 0;
        reset = 1;
        coin = 3'b000;
        #10;
        reset = 0;

        // Sequence: ?5 + ?2 + ?2 + ?1 = ?10 (dispense product)
        coin_sequence[0] = 3'b100;
        coin_sequence[1] = 3'b010;
        coin_sequence[2] = 3'b010;
        coin_sequence[3] = 3'b001;

        // ?5 + ?5 = ?10 (dispense product)
        coin_sequence[4] = 3'b100;
        coin_sequence[5] = 3'b100;

        // ?2 + ?5 + ?5 = ?12 (dispense product, change = 2)
        coin_sequence[6] = 3'b010;
        coin_sequence[7] = 3'b100;
        coin_sequence[8] = 3'b100;

        // No coin input at end
        coin_sequence[9] = 3'b000;

        // Run the test sequence
        for (i = 0; i < 10; i = i + 1) begin
            coin = coin_sequence[i];
            @(posedge clk);
        end

        coin = 3'b000;
        @(posedge clk);

        $display("=== Simulation Complete ===");
        $finish;
    end

    // Monitor outputs every clock cycle
    always @(posedge clk) begin
        $display("Time=%0t | Coin=%b | Product=%b | Change=%d | Total=%d",
                 $time, coin, product, change, total_debug);
    end

endmodule

