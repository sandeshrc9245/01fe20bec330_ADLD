`timescale 1ns/100ps
module assignment1_tb();
  reg clk;
  reg reset;
  reg sen_1;
  reg sen_2;
  reg [3:0] password;

  wire gate_open;
 


car_park dut(clk,reset,sen_1,sen_2,password,gate_open);

initial begin
sen_1 = 1'b0;
sen_2  = 1'b0;
reset = 1'b1;
clk   = 1'b0;
password = 4'b0000;
$display("%t clk: %b sen_1: %b sen_2: %b gate_open: %b",$time,clk,sen_1,sen_2,gate_open);

#12
reset = 1'b0;
sen_2 = 1'b0;
sen_1 = 1'b1;
#10 password = 4'b0101;
#10 sen_2 = 1'b1;
sen_1 = 1'b0;
$display("%t clk: %b sen_1: %b sen_2: %b gate_open: %b",$time,clk,sen_1,sen_2,gate_open);

#10
sen_2 = 1'b0;
sen_1 = 1'b1;
#10 password = 4'b0000;
#10 password = 4'b0101;
#10 sen_2 = 1'b1;
sen_1 = 1'b0;
#10 sen_2 = 1'b0;

$display("%t clk: %b sen_1: %b sen_2: %b gate_open: %b",$time,clk,sen_1,sen_2,gate_open);

#100 $finish;

end
always #5 clk = ~clk;

endmodule
 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module car_park(input clk,reset,
 input sen_1, sen_2, 
 input [3:0] password,
 output reg gate_open);
parameter idle = 2'b00, enter_password = 2'b01,right_password = 2'b10;
reg[2:0] current_state, next_state;


always @(posedge clk)
 begin
 if(reset)
begin
 current_state = idle;
end 
else
 current_state = next_state;
 end



always @(*)
 begin
 case(current_state)
 
idle: begin
 if(sen_1 == 1)
 next_state = enter_password;
 else
 next_state = idle;
 end
 
enter_password: begin
 if(password==4'b0101)
 begin 
 gate_open = 1;
 next_state = right_password;
 end
 else
 begin
 gate_open=0;
 next_state = enter_password;
 end
 end
 
 
right_password: begin
 if(sen_1==1 && sen_2 == 1) 
 begin 
 next_state = idle;
 end 
 else
 next_state = right_password;
 end
 
 default: begin
          next_state = idle;
          gate_open = 0;
          end
 endcase

 end


endmodule
