`timescale 1ns / 1ps

module TrafficLight ( signal , red , yellow , green );
input [1:0] signal ;
output red , yellow , green ;

reg red , yellow , green ;

parameter RED_LIGHT = 2'b00;
parameter YELLOW_LIGHT = 2'b01;
parameter GREEN_LIGHT = 2'b10 ;

 
parameter ON = 1;
parameter OFF = 0;

always @ ( signal )
begin
case ( signal )
RED_LIGHT:
begin
red <= ON;
yellow <= OFF ;
green <= OFF ;
end
YELLOW_LIGHT:
begin
red <= OFF ;
yellow <= ON;
green <= OFF ;
end
GREEN_LIGHT:
begin
red <= OFF ;
yellow <= OFF ;
green <= ON;
end

endcase
end
endmodule

