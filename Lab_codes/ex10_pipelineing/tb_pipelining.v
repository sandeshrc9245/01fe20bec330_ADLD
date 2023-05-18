
module tb_pipelining();
parameter N=10;
reg [N-1:0]A,B,C,D;
reg clk;
wire [N-1:0]F;

pipe_ex PIPELINE(F,A,B,C,D,clk);

initial 
clk=0;
always #10 clk=~clk;

initial 
   begin
    #5 A=10; B=12; C=6; D=3; //F=75  (4Bh)
    #20 A=10; B=10; C=5; D=3; //F=66  (42h)
    #20 A=20; B=11; C=1; D=4; //F=112  (70h)
  end

initial
  begin
  $monitor("Time :%d, F=%d",$time,F);
  #100 $finish;
  end
endmodule
    



module pipe_ex(F,A,B,C,D,clk);
parameter N=10;
input [N-1:0]A,B,C,D;
input clk;
output [N-1:0]F;
reg [N-1:0] L12_x1,L12_x2,L12_D,L23_x3,L23_D,L34_F;
assign F=L34_F;

always@(posedge clk)
  begin
     L12_x1<=#4 A+B;
     L12_x2<=#4 C-D;
     L12_D<=D;            //stage-1
 
     L23_x3<=#4 L12_x1 + L12_x2;
     L23_D<=L12_D;          //stage-2

     L34_F<=#6 L23_x3 * L23_D;
  end
endmodule
