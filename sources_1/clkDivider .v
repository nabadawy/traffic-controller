
`timescale 1ns / 1ps

module TimeParameters (input clk , reset ,output reg [3:0] tBASE ,output reg [3:0]tEXT ,output reg [3:0] tYEL ); 
parameter BASE_SELECT = 2'b00;
parameter EXT_SELECT = 2'b01;
parameter YEL_SELECT = 2'b10 ;

parameter DEFAULT_BASE = 4'b0110 ;
parameter DEFAULT_EXT = 4'b0011 ;
parameter DEFAULT_YEL = 4'b0010 ;

parameter MAX_TIME = 4'b1111 ;
parameter ZERO_TIME = 4'b0000 ;

always @ ( posedge clk )
begin
if ( reset )
begin
tBASE <= DEFAULT_BASE ;
tEXT <= DEFAULT_EXT ;
tYEL <= DEFAULT_YEL ;
end
end 
endmodule

module clkDivider (clk , reset , timeParameters , selector , startTimer , expired );
input clk ;
input reset ;
input [11:0] timeParameters ;
input [1:0] selector ;
input startTimer ;

output expired ;
reg expired ;
reg [3:0] count ;
reg [32:0] clkCount ;
parameter ZERO_COUNT = 4'b0000 ;
parameter BASE_SELECT = 2'b00 ;
parameter EXT_SELECT = 2'b01 ;
parameter YEL_SELECT = 2'b10 ;
parameter n = 32'd49999999 ;


always @ ( posedge clk )
begin

expired <= 0;

if ( clkCount == n ||
reset == 1)
clkCount <= 32'b0 ;
else
clkCount <= clkCount + 1;

if ( reset )
begin
expired <= 0;
count <= 4'b1111 ; 
end
else if ( startTimer )
begin
 expired <= 0;
 clkCount <= 32'b0 ;

case ( selector )
BASE_SELECT:
begin
if ( timeParameters [11:8] == 4'b0000 )
begin
expired <= 1;
count <= 4'b1111 ; 
end
else
count <= timeParameters [11:8];
end

EXT_SELECT:
begin
if ( timeParameters [7:4] == 4'b0000 )
begin
expired <= 1;
count <= 4'b1111 ;
end
else
count <= timeParameters [7:4];
end

 YEL_SELECT:
begin
if ( timeParameters [3:0] == 4'b0000 )
begin
expired <= 1;
count <= 4'b1111 ; 
end
else

count <= timeParameters [3:0];
end

default:
count <= 4'b1111 ; 
endcase
end
else if ( clkCount == n )
begin
expired <= ( count == 4'b0001 );
count <= count - 1;
end
end
endmodule

