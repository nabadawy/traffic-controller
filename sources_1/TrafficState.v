

`timescale 1ns / 1ps
module TrafficState (clk ,reset , trafficSensor , pendingWalk , expired ,startTimer , timeParameter , resetWalk , mainLight , sideLight , walkLight , state );
input clk ;
input reset , trafficSensor , pendingWalk , expired ;

output startTimer ;
output [1:0] timeParameter ;

output resetWalk ;

output [1:0] mainLight , sideLight ;
output walkLight ;

output [2:0] state ;

reg startTimer ;
reg [1:0] timeParameter ;
reg resetWalk ;
reg [1:0] mainLight , sideLight ;
reg walkLight ;

parameter ON = 1'b1;
parameter OFF = 1'b0;

 reg [2:0] state ;

parameter START_MG = 0;
parameter CONT_MG_NO_TRAFFIC = 1;
parameter CONT_MG_TRAFFIC = 2;
parameter MYEL = 3;
parameter PEDESTRIAN_WALK = 4;
parameter START_SG = 5;
parameter CONT_SG_TRAFFIC = 6;
parameter SYEL = 7;
parameter INVALID_STATE = 8;

parameter RED = 2'b00 ;
parameter YELLOW = 2'b01 ;
parameter GREEN = 2'b10 ;

parameter BASE_SELECT = 2'b00 ;
parameter EXT_SELECT = 2'b01 ;
 parameter YEL_SELECT = 2'b10 ;
parameter ZERO_SELECT = 2'b11 ;

always @ ( posedge clk )
begin
startTimer <= 0;
resetWalk <= 0;

if ( reset )
begin
startTimer <= 1;
timeParameter <= BASE_SELECT*2 ;
state <= START_MG ;
end
else if (~ expired )
begin
case ( state )
START_MG, CONT_MG_NO_TRAFFIC , CONT_MG_TRAFFIC:
{ mainLight , sideLight , walkLight } <= {GREEN , RED , OFF };

MYEL:
{ mainLight , sideLight , walkLight } <= { YELLOW , RED , OFF };

PEDESTRIAN_WALK:
{ mainLight , sideLight , walkLight } <= {RED , RED , ON };

START_SG, CONT_SG_TRAFFIC:
{ mainLight , sideLight , walkLight } <= {RED , GREEN , OFF };

SYEL: 
{ mainLight , sideLight , walkLight } <= {RED , YELLOW , OFF };

default:
{ mainLight , sideLight , walkLight } <= { YELLOW , YELLOW , ON };
endcase
end
else
begin
startTimer <= 1;
case ( state )
START_MG:
 begin
if ( trafficSensor )
begin
timeParameter <= EXT_SELECT ;
state <= CONT_MG_TRAFFIC ;
 end
 else
 begin
timeParameter <= BASE_SELECT ;
state <= CONT_MG_NO_TRAFFIC ;
end
end

CONT_MG_NO_TRAFFIC, CONT_MG_TRAFFIC:
begin
timeParameter <= YEL_SELECT ;
state <= MYEL ;
end

MYEL:
begin
if ( pendingWalk )
begin
timeParameter <= EXT_SELECT ;
state <= PEDESTRIAN_WALK ;
 end
 else
 begin
timeParameter <= BASE_SELECT ;
state <= START_SG ;
 end
 end

PEDESTRIAN_WALK:
begin
timeParameter <= BASE_SELECT ;
state <= START_SG ;

resetWalk <= 1;
end

START_SG:
begin
if ( trafficSensor )
begin
timeParameter <= EXT_SELECT ;
state <= CONT_SG_TRAFFIC ;
 end
 else
begin
timeParameter <= YEL_SELECT;
state <= SYEL ;

end
end

CONT_SG_TRAFFIC:
begin
timeParameter <= YEL_SELECT ;
state <= SYEL ;
end

SYEL:
begin
timeParameter <= BASE_SELECT ;
state <= START_MG ;
 end

default:
begin
state <= INVALID_STATE ;
end
endcase
end
end

endmodule
