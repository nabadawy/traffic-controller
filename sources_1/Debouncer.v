
`timescale 1ns / 1ps
module Debouncer (input clk , reset , noisy ,output reg clean );
reg [18:0] count ;
reg new;

always @( posedge clk )
if ( reset )
begin
count <= 0;
new <= noisy ;
clean <= noisy ;
end
else if ( noisy != new )
begin
new <= noisy ;
count <= 0;
end
else if ( count == 270000 )
clean <= new ;
else
count <= count + 1;

 endmodule
