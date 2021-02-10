`timescale 1ns / 1ps

module TrafficController (input clk, reset , trafficSensor , walkRequest ,output  redMain , yellowMain , greenMain , redSide , yellowSide , greenSide , walkLight);
wire resetSync , trafficSensorSync , walkRequestSync;
wire walkReset , pendingWalk ;
wire startTimer , expired ;
wire [3:0] tBASE , tEXT , tYEL ;
wire [1:0] fsmSelector ;
wire [1:0] mainLight , sideLight ;
wire [2:0] state ;

Synchronizer syncTrafficSensor (.clk(clk ), .in(trafficSensor ), .out(trafficSensorSync ));
Debouncer syncReset (.clk(clk), .reset(0) , .noisy(reset), .clean(resetSync));
Debouncer syncWalkRequest (.clk(clk ), .reset(0) , .noisy(walkRequest), .clean(walkRequestSync));
WalkRegister wr (.clk(clk ), .walkPush(walkRequestSync ), .reset(walkReset ), .pendingWalk(pendingWalk ));
TrafficState fsm(.clk(clk), .reset(resetSync), .trafficSensor(trafficSensorSync), .pendingWalk(pendingWalk), .expired(expired ), .startTimer(startTimer ), .timeParameter(fsmSelector), .resetWalk(walkReset ), .mainLight(mainLight), .sideLight( sideLight ), .walkLight(walkLight), .state(state));
TrafficLight main (. signal ( mainLight ), .red(redMain ), .yellow( yellowMain), .green(greenMain ));
TrafficLight side (. signal ( sideLight ), .red(redSide), .yellow(yellowSide), .green(greenSide));
TimeParameters times (.clk(clk), .reset(resetSync), .tBASE(tBASE), .tEXT(tEXT), .tYEL(tYEL));
clkDivider timer (.clk(clk), .reset(resetSync), .timeParameters({ tBASE [3:0] , tEXT [3:0] , tYEL [3:0]}) , .selector(fsmSelector [1:0]) , .startTimer(startTimer), .expired(expired));
 endmodule
