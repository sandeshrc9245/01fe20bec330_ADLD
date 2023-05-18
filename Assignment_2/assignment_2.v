module tb;
  reg clk;
  reg reset;
  reg [1:0]selection;
  reg [4:0]coin_in;
  wire [3:0]product_out;
  wire [4:0]coin_out;
  
  vending_machine ab(clk,reset,selection,coin_in,product_out,coin_out);
  
  initial clk=0;
  always #5 clk=~clk;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
    $monitor($time," reset=%b selection=%d coin_in=%d product_out=%d coin_out=%d coins_inserted=%d ",reset,selection,coin_in,product_out,coin_out,ab.coins_inserted);
   
    
    #5 reset=1;
    #10 reset=0;
    #10 selection=2'b00;    // product A 10rs
        coin_in=5'd10;
    
    #30 selection=2'b00;    // product A 5rs
        coin_in=5'd5;
    
     #50 selection=2'b01;    // product B 10rs 1 coins
        coin_in = 5'd10;
    
    #40 selection=2'b01;    // product B 5rs 2 coins
         coin_in=5'd5;
    #40  coin_in=5'd5;
    
   
    
    #20 selection=2'b10;    // product C 5rs 3 coins
        coin_in=5'd5;
    #20 coin_in=5'd5;
    #20 coin_in=5'd5;
    
    #20 selection=2'b10;     // product C 10rs 1 coin 5 rs 1 coin
        coin_in=5'd5;
    #20 coin_in=5'd10;
    
    #20 selection=2'b10;     // product C 10rs 2 coins
        coin_in=5'd10;
    #20 coin_in=5'd10;
    
    #20 selection=2'b11;     // product D 5rs 4 coins
        coin_in=5'd5;
    #20 coin_in=5'd5;
    #20 coin_in=5'd5;
    #20 coin_in=5'd5;
    
    #20 selection=2'b11;     // product D 10rs 1 coin  5 rs 2 coins
        coin_in=5'd10;
    #20 coin_in=5'd5;
    #20 coin_in=5'd5;
    
    #20 selection=2'b11;     // product D 5rs 3 coins and 1 10 rs coin
        coin_in=5'd5;
    #20 coin_in=5'd5;
    #20 coin_in=5'd5;
    #20 coin_in=5'd10;
    
    
    #20 selection=2'b11;     // product D 10rs 2 coins
        coin_in=5'd10;
    #20 coin_in=5'd10;
    
    
    #100 $finish;
  end
  
endmodule


// Code your testbench here
// or browse Examples
module vending_machine(
  input clk,
  input reset,
  input [1:0]selection,
  input [4:0]coin_in,
  output reg [3:0]product_out,
  output reg [4:0]coin_out
);

// Define product prices
parameter PRICE_A = 5'd5;
parameter PRICE_B = 5'd10;
parameter PRICE_C = 5'd15;
parameter PRICE_D = 5'd20;

// Define product codes
parameter PRODUCT_A = 2'b00;
parameter PRODUCT_B = 2'b01;
parameter PRODUCT_C = 2'b10;
parameter PRODUCT_D = 2'b11;

// Define state variables
reg [1:0] state;
reg [3:0] product_selected;
reg [4:0] coins_inserted; 
reg [4:0] change_given;

// Define initial values
initial state = 2'b00;
initial product_selected = 4'b0000;
initial coins_inserted = 5'b00000;
initial change_given = 5'b00000;
  
//define state machine
always@(posedge clk) 
begin
  if(reset) 
  begin
    state <= 2'b00;
    product_selected <= 4'b0000;
    coins_inserted <= 5'b00000;
    change_given <= 5'b00000;
  end
  else
  begin
    case(state)
      2'b00:begin
             product_out<=4'b0000;
           	 coin_out<=5'b00000;
           	 product_selected<=4'b0000;
			 coins_inserted<=5'b00000;
			 change_given<=5'b00000;
             state<=2'b01;
            end
      
     /* 2'b01:begin          				// Waiting for product selection
            if(selection == 2'b00) 
               product_selected <= 4'b0000;
            else if(selection == 2'b01) 
               product_selected <= 4'b0001;
            else if(selection == 2'b10) 
               product_selected <= 4'b0010;  
            else if(selection == 2'b11) 
     		   product_selected <= 4'b0011;
            else  
     		   product_selected <= 4'bxxxx;
              
             product_selected <= 4'b0000;
             coins_inserted <= 5'b00000;
             change_given <= 5'b00000;
             state <= 2'b10;
            end   */
      
      2'b01:begin                       // Waiting for coin insertion
        	if(coin_in == 5'b0101) 
             begin // 5rs coin inserted
              coins_inserted <= coins_inserted + 5'b00101;
             end
             else if (coin_in == 5'b01010) 
             begin // 10rs coin inserted
              coins_inserted <= coins_inserted + 5'b01010;
             end
            
             if(coin_in==5'd00000)
              state<=2'b01;
             else if(selection==PRODUCT_A && coins_inserted >= 5'd5)
              state<=2'b10;
       	  	 else if(selection==PRODUCT_B && coins_inserted >= 5'd10)
               state<=2'b10;
        	 else if(selection==PRODUCT_C && coins_inserted >= 5'd15)
               state<=2'b10;
        	 else if(selection==PRODUCT_D && coins_inserted >= 5'd20)
               state<=2'b10;
             else
              state<=2'b01;
        
             end
        
      2'b10:begin
           if(selection == PRODUCT_A && coins_inserted >= PRICE_A)
           begin
           product_selected <= 4'b0000;
            if(coins_inserted==5'd5)
             coin_out <= 5'd0;
           else if(coins_inserted==5'd10)
            coin_out <= 5'd5;
           else 
             coin_out<=5'bxxxxx;
         end
        
        else if(selection == PRODUCT_B && coins_inserted >= PRICE_B)
        begin
          product_selected <= 4'b0001;
          if(coins_inserted==5'd10)
          coin_out <= 5'd0;
          else if(coins_inserted==5'd15)
          coin_out <= 5'd5;
          else if(coins_inserted==5'd20)
          coin_out <= 5'd10;
          else
            coin_out<=5'bxxxxx;
        end
        
        else if(selection == PRODUCT_C && coins_inserted >= PRICE_C)
        begin
          product_selected <= 4'b0010;
          if(coins_inserted==5'd15)
          coin_out <= 5'd0;
          else if(coins_inserted==5'd20)
          coin_out <= 5'd5;
          else
            coin_out<=5'bxxxxx;
        end
        
        else if(selection == PRODUCT_D && coins_inserted >= PRICE_D)
        begin
          product_selected <= 4'b0011;
          if(coins_inserted==5'd20)
          coin_out <= 5'd0;
          else
            coin_out<=5'bxxxxx;
        end
         
       else
         begin
           state<=2'b10;
         end
        
        state <= 2'b11;
       end
      
      2'b11:begin        // Dispensing product and change
             product_out <= product_selected;
             coin_out <= change_given;
             state <= 2'b00;
            end
    endcase
  end
end

endmodule