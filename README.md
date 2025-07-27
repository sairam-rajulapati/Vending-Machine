# Vending-Machine using Verilog HDL
The vending machine accepts coins (₹1, ₹2, ₹5), accumulates the total value, and dispenses a product once the total reaches or exceeds ₹10. If the user overpays, the machine returns change.

## Table of Contents

1. [Introduction](#1-introduction)
2. [Methodology](#2-methodology)  
   - [Directions Considered](#directions-considered)  
   - [Problem Statement](#problem-statement)
   - [System Design Approach](#system-design-approach)
   - [State Diagram](#state-diagram)  
   - [State Table](#state-table)
3. [RTL Code](#RTL-Code)
   - [RTL Schematic View](#RTL-Schematic-View)
4. [TESTBENCH](#TESTBENCH)    
5. [Output Waveforms](#Output-Waveforms)    

# 1. Introduction

This project presents a Verilog-based simulation of a vending machine, designed to accept coins of ₹1, ₹2, and ₹5 denominations. The vending machine keeps track of the total inserted amount and dispenses a product when the total reaches or exceeds ₹10. If the inserted amount exceeds ₹10, the machine returns the appropriate change.

The system is modeled using combinational and sequential logic in Verilog and includes a testbench to simulate real-world coin input sequences. This design serves as a practical example of implementing digital systems using hardware description languages and demonstrates key concepts such as:

Coin decoding logic

Accumulator-based total tracking

Threshold-based product dispensing

Change return logic

Clock-driven state updates

This project is especially useful for students and learners exploring digital design, Verilog HDL, and embedded system simulation. It can also be extended for FPGA implementation or used as a foundational block for more complex vending logic.
     

# 2. Methodology
The vending machine was designed using a combination of combinational and sequential logic, structured in a way that mimics the behavior of a real-world vending machine. The following methodology was followed during the development of this project

## Directions Considered

We considered two major approaches for designing the vending machine:

Finite State Machine (FSM) based logic — where each coin input transitions the system through defined states.

Accumulator-based logic — which adds coin values directly and checks the total against the threshold.

We chose the accumulator-based approach for its simplicity, clarity, and ease of simulation, especially in educational contexts.

## Problem Statement


Design and simulate a vending machine that:

Accepts coins of ₹1, ₹2, and ₹5.

Tracks the total amount inserted.

Dispenses a product when the total is ₹10 or more.

Returns change if the total exceeds ₹10.

Resets internal state after each product dispense.


## System Design Approach

Coin Input Handling
The coin input is a 3-bit signal representing the coin denomination:

3'b001 → ₹1

3'b010 → ₹2

3'b100 → ₹5
A combinational block decodes this input into a usable value.

Total Tracking
A 5-bit register total keeps track of the accumulated amount.
The next value (next_total) is calculated by adding the current total with the decoded coin value.

Product Dispensing Logic
When the accumulated total is greater than or equal to ₹10:

product output is set to 1

change is calculated as next_total - 10

The internal total is reset to 0

Sequential Update on Clock Edge

On each positive edge of the clock (or reset), the machine updates the total.

If a product is dispensed, total is reset to 0; otherwise, it’s updated with next_total.

Simulation with Testbench
A testbench (vending_machine_tb.v) simulates realistic coin sequences to verify:

Correct accumulation

Product dispensing at the right time

Correct change output

System reset behavior

## State Diagram

<img width="1024" height="1024" alt="image" src="https://github.com/user-attachments/assets/dade215b-ba6e-4c84-acdc-b670c255dc07" />


## State Table
| Current Total (`total`) | Coin Input (`coin`) | Coin Value | New Total (`next_total`) | Product | Change | Next State (`total`) |
| ----------------------- | ------------------- | ---------- | ------------------------ | ------- | ------ | -------------------- |
| 0                       | 001 (₹1)            | 1          | 1                        | 0       | 0      | 1                    |
| 1                       | 010 (₹2)            | 2          | 3                        | 0       | 0      | 3                    |
| 3                       | 100 (₹5)            | 5          | 8                        | 0       | 0      | 8                    |
| 8                       | 010 (₹2)            | 2          | 10                       | 1       | 0      | 0                    |
| 5                       | 100 (₹5)            | 5          | 10                       | 1       | 0      | 0                    |
| 7                       | 100 (₹5)            | 5          | 12                       | 1       | 2      | 0                    |
| 9                       | 001 (₹1)            | 1          | 10                       | 1       | 0      | 0                    |
| 2                       | 100 (₹5)            | 5          | 7                        | 0       | 0      | 7                    |
| 7                       | 001 (₹1)            | 1          | 8                        | 0       | 0      | 8                    |
| 0                       | 000 (No Coin)       | 0          | 0                        | 0       | 0      | 0                    |



   
# 3.RTL Code

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

# RTL Schematic View

<img width="1610" height="491" alt="image" src="https://github.com/user-attachments/assets/bef72257-fc2e-4587-b713-3156b56c3502" />


# TESTBENCH

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

# Output Waveforms

<img width="604" height="263" alt="Screenshot 2025-07-14 223306" src="https://github.com/user-attachments/assets/a1a66f7e-0e54-405a-84dd-a2be21d28c22" />


<img width="1764" height="741" alt="Screenshot 2025-07-14 223839" src="https://github.com/user-attachments/assets/ee6cdc5f-42dc-4355-973d-9454b4688c10" />

<img width="1699" height="699" alt="Screenshot 2025-07-14 223234" src="https://github.com/user-attachments/assets/5dea6d17-1e45-43d5-9305-f0e76ef97200" />

