// file: Driver.v
// author: @mahmoudelsayed

`timescale 1ns/1ns

module Driver(input clk, input reset, walk, sensor, output[2:0] Main_road, output [2:0] Side_road);
    wire clok;
    clockDivider #(50000000) clock(clk,reset,clok);
    TrafficLight Light(clok,reset, walk, sensor, Main_road,Side_road);

endmodule
