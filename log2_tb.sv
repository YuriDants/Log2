// Aluno: Ítalo Vladimir Diniz Vilarim
// Matrícula: 121110385

// Desafios de Microeletônica
// Log2

module log2_tb;

  parameter M = 2;
  parameter N = 5;

  logic clock;
  logic reset;
  logic iReady, iValid, oReady, oValid;
    
  logic signed [M + N: 0] number, logNumber;
    
  enum logic {S1,S2} state;
    
  initial begin                                                         
      clock = 0;
      reset = 1;
      #20 reset = 0;
  end

  always #5 clock = !clock;

  LOG #(.M(2), .N(5)) log2_tb(                                            //atribuindo os parametros do RTL
        .clk_i(clock),
        .rstn_i(reset),
        .ready_i(iReady),
        .ready_o(oReady),
        .valid_i(iValid),
        .valid_o(oValid)
        .number(number),
        .logNumber(logNumber)
  ); 
    
  always_ff @(posedge clock) 
  begin
      if(reset) 
      begin
          iValid <= 0;
          state <= S1;
          oReady <= 0;
      end
      else case(state)
          S1: 
          begin
              number <= $urandom;                                         //gera número aleatório para entrada
              iValid <= 1;
              if(iReady)
                  state <= S2;
                  oReady <= 1;
          end
          S2: 
              if(oValid) 
              begin
                  if(logNumber[M + N])                                    //caso o primeiro bit seja 1, sinal negativo
                      $display("log base 2 de x: %b", (~logNumber+8'd1)); //complemento de 2 para exibir log
                  else                                                    //caso contrário
                      $display("log base 2 de x: %b", logNumber);         //exibe valor do log
                        
                  $finish();
              end
      endcase
  end
endmodule

