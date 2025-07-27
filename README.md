# Vending-Machine using Verilog HDL
The vending machine accepts coins (₹1, ₹2, ₹5), accumulates the total value, and dispenses a product once the total reaches or exceeds ₹10. If the user overpays, the machine returns change.



## Table of Contents

1. [Introduction](#1-introduction) 

# 1. Introduction

This project presents a Verilog-based simulation of a vending machine, designed to accept coins of ₹1, ₹2, and ₹5 denominations. The vending machine keeps track of the total inserted amount and dispenses a product when the total reaches or exceeds ₹10. If the inserted amount exceeds ₹10, the machine returns the appropriate change.

The system is modeled using combinational and sequential logic in Verilog and includes a testbench to simulate real-world coin input sequences. This design serves as a practical example of implementing digital systems using hardware description languages and demonstrates key concepts such as:

Coin decoding logic

Accumulator-based total tracking

Threshold-based product dispensing

Change return logic

Clock-driven state updates

This project is especially useful for students and learners exploring digital design, Verilog HDL, and embedded system simulation. It can also be extended for FPGA implementation or used as a foundational block for more complex vending logic.

2. [Methodology](#2-methodology)  
   - [Directions Considered](#directions-considered)  
   - [Problem Statement](#problem-statement)
   - [System Design Approach](#system-design-approach)
   - [State Diagram](#state-diagram)  
   - [State Table](#state-table)
     

# 2. Methodology

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



