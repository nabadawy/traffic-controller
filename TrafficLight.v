// file: Traffic_Light.v
// author: @mahmoudelsayed

`timescale 1ns/1ns

module TrafficLight(input clk,reset,walk, sensor,output reg [2:0] Main_road,output reg [2:0] Side_road);

    reg[4:0] state;
    localparam  s0=5'b00001,
                s1=5'b00010,
                s2=5'b00100,
                s3=5'b01000,
		s4=5'b10000;
    reg [3:0] counter;
    localparam  T_base_main=4'd11,
                T_base = 4'd5,
                T_yel = 4'd1,
		T_ext = 4'd2;
    
    
    reg walkReq;
    reg shorterMainroadTime;
    reg longerSideroadTime;

    always @(posedge clk or posedge reset) begin
    
        if(reset)begin
            counter<=4'd0;
            state<=s0;
            
        end else 
        begin
            case(state)
            
            s0: begin
		if(walk == 1) walkReq <= 1;
		if(counter<5) begin
                    state <= s0;
                    counter <= counter+1;
		end
		else if(counter == 5)
			begin 
				state <= s0;
                		counter <= counter+1;
				if(sensor == 1) shorterMainroadTime = 1; else shorterMainroadTime = 0;
			end
		else 
			begin
				if(shorterMainroadTime == 1)
				begin
			      		if(counter < T_ext + T_base + 1)
					begin state<= s0; counter <= counter + 1;end
					else begin
                			    state <= s1;
                 			    counter<=4'd0;
            			    	end
				end
				else
				begin
					if(counter < T_base_main)
					begin state<= s0; counter <= counter + 1;end
					else begin
                			    state <= s1;
                 			    counter<=4'd0;
            			    	end
				end
			end
		end
            s1: begin
		if(walk == 1) walkReq <= 1;
		if(counter<T_yel) begin
                    state <= s1;
                    counter <= counter+1;
                end
                else begin
		    if(walkReq == 1)
		    begin
			state <= s4;
			counter <= 4'd0;
			walkReq <= 0;
		    end 
	 	    else begin
                        state <=s2;
                        counter<=4'd0;
                    end
		end
		end
            s2: begin
		if(walk == 1) walkReq <= 1;
		if(counter<5) begin
                    state <= s2;
                    counter <= counter+1;
		end
		else if(counter == 5)
			begin 
				if(sensor == 0) 
				begin longerSideroadTime = 0; state <= s3; counter<=4'd0; end 
				else begin longerSideroadTime = 1; state <= s2; counter <= counter+1; end
			end
		else  //counter reached 6 i.e. longerSideroadTime is high
			begin
			      if(counter < T_ext + T_base + 1) //thus extent time to 9
			      begin state<= s2; counter <= counter + 1;end
			      else begin
                		 state <= s3;
                 		 counter<=4'd0;
            		       end
			end
		end
            s3: begin
		if(walk == 1) walkReq <= 1;
		if(counter<T_yel) begin
                    state <= s3;
                    counter <= counter+1;
                end
                else begin
                    state <=s0;
                    counter<=4'd0;
                end
		end
	    s4:if(counter<T_ext) begin
                    state <= s4;
                    counter <= counter+1;
                end
                else begin
                    state <=s2;
                    counter<=4'd0;
                end
            default: state<=s0;
            
            endcase
        end  
    
    end
    always @(*)
    begin
        case (state)
            s0: begin Main_road <= 3'b001;
                Side_road <= 3'b100;
                end
            s1: begin Main_road <= 3'b010;
                Side_road <= 3'b100;
                end
            s2: begin 
                Main_road <= 3'b100;
                Side_road <= 3'b001; 
                end
            s3:begin Main_road <= 3'b100;
                Side_road <= 3'b010;
                end
	    s4:begin Main_road <= 3'b100;
		Side_road <= 3'b100;
		end
        endcase
    end
    

endmodule
