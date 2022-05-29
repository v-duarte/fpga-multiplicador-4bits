
use work.Utils.all;
entity Multiplicador is
	port(
		 A: in Bit_Vector(3 downto 0);
		 B: in Bit_Vector(3 downto 0);
		 STB: in Bit;
		 Done: out Bit;
		 Result: out Bit_Vector(7 downto 0);
		 Clk: in Bit
		 );
	end Multiplicador;


architecture Multiplicador of Multiplicador is 

	component Adder8
	port (A: in Bit_Vector(7 downto 0); 
		  B: in Bit_Vector(7 downto 0); 
		  Cin: in Bit; 
		  Cout: out Bit; 
		  Sum: out  Bit_Vector(7 downto 0));
	end component;	  
	
	component Latch8
	port(D: in Bit_Vector(7 downto 0);
		 CLK: in Bit; 
		 Pre: in Bit; 
		 Clr: in Bit; 
		 Q: out Bit_Vector(7 downto 0)); 
	end component;	
	
	component Controller 
		port(STB: in  Bit;
			 CLK: in  Bit;
			 LSB: in  Bit; 
			 Stop: in  Bit;
             Init: out  Bit;
			 Shift: out  Bit;
			 Add: out  Bit;
			Done: out  Bit);
	end component;	 
	
	component ShiftN 
		port (CLK: in Bit; 
			  CLR: in Bit; 
			  LD: in Bit; 
			  SH: in Bit; 	  
			  DIR: in Bit; 
		   	  D: in Bit_Vector; 
			  Q: out Bit_Vector);
	end component;	  

signal init: Bit;
signal shift:Bit;
signal salida_SRAA: Bit_Vector(7 downto 0); 
signal salida_SRBB: Bit_Vector(7 downto 0);	
signal latch: Bit_Vector(7 downto 0); --Salida del latch ACC  
signal resultado: Bit_vector(7 downto 0); --Salida del sumador
signal salida_lsb: Bit;	-- Bit menos significativo de la entrada A
signal stop: Bit; -- Indica que la multiplicacion ya termino.  
signal add: Bit; -- Salida add de la FMS
signal Cout: Bit;-- Bit de accareo de la suma
signal init_bar: Bit;	--Usado para no limpiar el registro de almacenamiento mientras que no este en el estado Init.
signal done_mul: Bit; --Para que el multiplicador solo salga el resultado final de la maquina de estado.
signal Clk_bar: Bit; --Clock usado por la maquina de estado, para acelerar su funcionamiento (comienza a funcionar aprox. 10 ns mas rapido que usando Clk.)

begin		 
	init_bar <= not init;
	salida_lsb <= salida_SRAA(0);
	Clk_bar <= not Clk;
	Done<=done_mul;
	--Rotar derecha SRA
	SRAA: ShiftN port map(CLK=>Clk,CLR =>'0',LD=>init,SH=>shift,DIR=>'0',D=>A,Q=>salida_SRAA);
	--Rotar Izquierda
	SRBB: ShiftN port map(CLK=>Clk,CLR =>'0',LD=>init,SH=>shift,DIR=>'1',D=>B,Q=>salida_SRBB);
	--Sumador
	Adder: Adder8 port map(A=>salida_SRBB,B=>latch,Cin=>'0',Cout=>Cout,Sum=>resultado); 
	--Registro acumulador
	ACC: Latch8 port map(D=>resultado,Clk=>add,Pre=>'1',Clr=>init_bar,Q=>latch);
	--Registro que copia el resultado final de la multiplicacion
	RES: Latch8 port map(D=>latch,Clk=>done_mul,Pre=>'1',Clr=>init_bar,Q=>Result);
	--Controlador
	FMS: Controller port map(STB=>STB,CLK=>Clk_bar,LSB=>salida_lsb,Stop=>stop,Init=>init,Shift=>shift, Add=>add, Done=>done_mul);
	--NOR
	stop <= not (salida_SRAA(0) or salida_SRAA(1) or salida_SRAA(2) or salida_SRAA(3) or salida_SRAA(4) or salida_SRAA(5) or salida_SRAA(6) or salida_SRAA(7));
end;

 

