// Autor: Yuri Siqueira Dantas 
// criado no EDA playground 
module Log2_2_tb();
logic clk,reset,flag_u,h_u;
  logic [7:0] in_u, resultadoTeorico,calculodoerroobtido;
logic [7:0] out_u;
  int erro;
  


Log2 dut(
  .clk(clk),
  .reset(reset),
  .h(h_u),
  .flag(flag_u),
  .in(in_u),
  .out(out_u)
);


initial
	begin
	$dumpfile("log2_dump.vcd");
	$dumpvars;
		#1 clk = 0;
        #1 reset = 0;
        #1 reset = 1;
        #1 reset = 0;
      
	//certo = 1;
	//erro = 0;
      erro =0;
	in_u = 0;
	resultadoTeorico = 0;
      h_u = 0;
      for (int i=0; i < 256; i++)
		begin
          in_u = $urandom_range(0,255); //random
           	h_u = 1;
         do  begin
          #1 clk = 1;
          #1 clk = 0;
         end while(!flag_u);
         // $display("%b",out_u);
        
     
      resultadoTeorico = Log2Teorico(in_u);

          if (resultadoTeorico != out_u)begin
            calculodoerroobtido = out_u - resultadoTeorico;
            $display("ERRO - entrada = %b, saida = %b, esperado = %b", in_u, out_u, resultadoTeorico);
            erro++;
          end
          
	end
      if(!erro)  $display("OK");
    end

	function byte Log2Teorico(input bit[7:0] entr_u); // mesma função desenvolvida em alto nivel para que possa ser usada como comparador do resultado
	byte resultadoTeorico;
	real aux_u;
	int parteI_u, z_u;
	aux_u = entr_u;
	z_u = 0;
	resultadoTeorico = 0;
   
    for (parteI_u = 0; aux_u >= 2; parteI_u++)
		begin
		aux_u /= 2;
		end
	
    for (int i = 0; i < 5; i++)
		begin
		z_u *=2;
		aux_u *= aux_u;
          if (aux_u >= 2)
			begin
			z_u++;
			aux_u /= 2;
			end
		end
    while (parteI_u)
	begin
		resultadoTeorico += 8'b0010_0000;
		parteI_u--;
		end
    while (z_u)
		begin
		resultadoTeorico += 8'b0000_0001;
		z_u--;
		end
	return resultadoTeorico;
endfunction

endmodule
