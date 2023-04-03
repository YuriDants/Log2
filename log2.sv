// Aluno: Ítalo Vladimir Diniz Vilarim
// Matrícula: 121110385

// Desafios de Microeletônica
// Log2

module LOG (
	parameter M = 2,
    parameter N = 5                              //fração de bits
)(	input logic [M + N : 0] number,              //entrada para calcular o log
    input logic clk_i, rstn_i, ready_o, valid_i,
    output logic [M + N : 0] logNumber,          //saida com valor do log
    output logic ready_i, valid_o
);
    
    logic signed [M + N : 0] index; 			 //log2(x) = index + log2(m)
    logic [2*M + 2*N :0] x, a, b; 
    logic [5:0] count;							 //contagem de bits
    logic [2:0] {INIT = 0, STATE1 = 1, STATE2 = 2, STATE3 = 3, STATE4 = 4, STATE5 = 5, STATE6 = 6} state;
    
    always_ff @(posedge clk_i)
        if(rstn_i) 
        begin
            ready_i <= 0;
            logNumber <= 'x;
            valid_o <= 0;
            state <= INIT;
        end
        else case (state)
                INIT: 
            	begin
                    logNumber <= '0;			 //zera saída
                    ready_i <= 1;
                    valid_o <= 0;
                    count <= N - 1;              //decresce o contador de bits
                    index <= 0; 				 //zera index
                    state <= STATE1;
                end
                
                STATE1: 
                begin
                    if(valid_i) 
                    begin
                        ready_i <= 0;
                        x <= number;             //x recebe o valor de entrada
                        state <= STATE2;
                    end
                    else 
                    begin
                        state <= STATE1;
                    end
                end
                
                STATE2: 
                begin
                    if((x >> N) > 1)             //avaliando toda a entrada
                    begin
                        x <= x >> 1;			 //caso maior que 1, valor é dividido por 2
                        index <= index + 1;		 //index acrescentado de 1
                    end
                    else if(!(x >> N)) 			
                    begin
                        x <= x << 1;			 //caso menor que 1, valor multipilicado por 2
                        index <= index - 1;		 //index decrescido de 1
                    end
                    else 
                    begin
                        index <= index <<< N;   
                        state <= STATE3;                     
                    end
                end
                
                STATE3: 
                begin
                    a <= x;                      //a e b igualados a x para fazer multiplicação de
                    b <= x;						 //potências com mesma base
                    x <= 0;						 //x zerado para receber novos valores no próximo estado
                    state <= STATE4;
                end
                
                STATE4:
                begin
                    if(a >= 1) 
                    begin						 //caso a seja ímpar, x = x + b, caso par, continua x
                        x <= (a[0]) ? (x + b) : x; 
                        a <= a >> 1;			 //divide valor por 2
                        b <= b << 1;			 //multiplica valor por 2
                    end
                    else 
                    begin
                        x <= x >> N; 			 //quando a for 0, x é deslocado em N para manter 
                        state <= STATE5;		 //bits fracionários 
                    end
                end
                
                STATE5: 
                begin
                  if(count <= N - 1) 
                  begin
                        if((x >> N) >= 2)        //caso a parte inteira de x seja >= 2
                        begin					 //bit fracionário será 1 e x dividido por 2
                            logNumber[count] <= 1;
                            x <= x >> 1;
                        end
                        else logNumber[count] <= 0;
                        
                        count <= count - 1;      //count decrescido
                        state <= STATE3;		 //realiza a potencia novamente
                    end
                    else 
                    begin 
                        state <= STATE6;
                        logNumber <= index + logNumber;
                        						 //index será o log2 da entrada (inteiro)
                        						 //somado aos bits fracionários calculados
                        valid_o <= 1;
                    end
                end
                
                STATE6: 
                begin
                    if(ready_o) 
                    begin
                        valid_o <= 0;
                        state <= INIT;
                    end
                    else state <= STATE6;
                end
        endcase
endmodule


