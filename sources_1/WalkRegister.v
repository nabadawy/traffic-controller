`timescale 1ns / 1ps

module WalkRegister (clk ,walkPush , reset ,pendingWalk );
input clk ;
input walkPush , reset ;
output pendingWalk ;
reg pendingWalk ;

always @ ( posedge clk )
begin
pendingWalk <= reset ? 0 :
pendingWalk ? pendingWalk : walkPush ;
end
endmodule
