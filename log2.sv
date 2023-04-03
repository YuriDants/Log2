// Autor: Yuri Siqueira Dantas 
// criado no EDA playground 

module Log2(
  input clk,
  input reset,
  input h,
  output reg flag,
  input [7:0] in,
  output reg [7:0] out //out = xxx(parte inteira).xxxxx(parte decimal);
);
	
  reg [2:0] parteI;
  reg [3:0] estado;
  reg [4:0] z;
  reg [15:0] mantissa, aux;
  parameter idle = 0;
  parameter estado1 = 1;
  parameter estado2 = 2;
  parameter estado3 = 3;
  parameter estado4 = 4;
  parameter estado5 = 5;
  parameter estado6 = 6;
  parameter estado7 = 7;
  parameter estado8 = 8;
  parameter estado9 = 9;
  parameter estado10 = 10;
  parameter estado11 = 11;
  
  
  
  
  
	always_comb begin //combinatorio para que a parte inteira seja identificada 
if (in[7])
  parteI <= 3'd7;
else if (in[6])
  parteI <= 3'd6;
else if (in[5])
  parteI <= 3'd5;
else if (in[4])
  parteI <= 3'd4;
else if (in[3])
  parteI <= 3'd3;
else if (in[2])
  parteI <= 3'd2;
else if (in[1])
  parteI <= 3'd1;
else if (in[0])
  parteI <= 3'd0;
      else parteI <= 3'd0;
               
    end
  always@(posedge clk or posedge reset) begin //logica tirada da referencia para que o log da mantissa possa ser descoberto
    if(reset)
      begin
        z <= 0;
        estado <= idle;
        flag <=0;
        out <= 0;
        mantissa <=0;
      end
    else begin
      if(estado == idle) begin  
        mantissa <= in;
        z <= 0;
        if (h) begin
          flag <=0;
          estado = estado1;
        end
      end
      else if (estado == estado1) begin
        {mantissa,aux} <= {mantissa << (3'd7 - parteI), 8'd0}*{mantissa << (3'd7 - parteI), 8'd0};//mantissa = xx.xx_xxxx_xxxx_xxxx
         estado <= estado2;
       end
      else if (estado == estado2) begin
        if(mantissa[15]) begin
          z++;
        end else  mantissa <= mantissa << 1;
         estado <= estado3;
      end
        else if(estado == estado3) begin
          {mantissa,aux} <= mantissa *mantissa;
          z = z << 1;
          estado <= estado4;
        end
      else if(estado == estado4) begin
  			if(mantissa[15]) begin
          z++;
        end else mantissa <= mantissa << 1; //
          estado <= estado5;
        end
      else if(estado == estado5) begin
  			{mantissa,aux} <= mantissa *mantissa;
          z = z << 1; //00xx0
          estado <= estado6;
        end
      else if(estado == estado6) begin
  			if(mantissa[15]) begin
          z++; //00xxx
        end else mantissa <= mantissa << 1; //
          estado <= estado7;
        end
      else if(estado == estado7) begin
  			{mantissa,aux} <= mantissa *mantissa;
          z = z << 1; //0xxx0
          estado <= estado8;
        end
      else if(estado == estado8) begin
  			if(mantissa[15]) begin
          z++; //0xxxx
        end else mantissa <= mantissa << 1; //
          estado <= estado9;
        end
      else if(estado == estado9) begin
  			{mantissa,aux} <= mantissa *mantissa;
          z = z << 1; //xxxx0
          estado <= estado10;
        end
      else if(estado == estado10) begin
  			if(mantissa[15]) begin
          z++; //xxxxx
        end else mantissa <= mantissa << 1; //
          estado <= estado11;
        end
      else if(estado == estado11) begin
        out <= {parteI,z};
        flag <= 1; //ao final da maquina de estados a flag dispara
        estado = idle;
        end
      end
    end

endmodule
