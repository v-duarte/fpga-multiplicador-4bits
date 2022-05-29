entity Test_Multiplicador_2 is end;

use work.Utils.all;
use STD.textio.all;

architecture Driver of Test_Multiplicador_2 is 
	component Multiplicador port(
		 A: in Bit_Vector(3 downto 0);
		 B: in Bit_Vector(3 downto 0);
		 STB: in Bit;
		 Done: out Bit;
		 Result: out Bit_Vector(7 downto 0);
		 Clk: in Bit
		 );
	end component;
	constant texto_inicio:string:="Esto es un multiplicador.Solo es posible multiplicar dos numeros enteros entre 0 y 15";
	constant texto_ingreso_a:string:="Por favor ingrese el primer numero entre 0 y 15";
	constant texto_ingreso_b:string:="Por favor ingrese el segundo numero entre 0 y 15";
	constant texto_error:string:="Error. Debe ingresar un numero entero en el rango de entre 0 y 15";
	constant texto_resultado:string:="El resultado de la multiplicacion es:";
	
	signal Clk: Bit; 
	signal A,B:Bit_Vector(3 downto 0);
	signal Result: Bit_Vector(7 downto 0); 
	signal STB,Done: Bit;	  
	use work.Utils.all;
begin 
	UTT:Multiplicador port map(A,B,STB,Done,Result,Clk);
	Clock(Clk, 10ns , 10ns );
	Stimulus:process 
	
	variable buff: line;
	variable numA: Natural;
	variable numB: Natural;
	variable resultado: Natural;
	
	
	begin
		write(buff,texto_inicio);
		writeline(output,buff);
		write(buff,texto_ingreso_a);
		writeline(output,buff);
		readline(input,buff);
		read(buff,numA);
		while numA>15 loop	-- Comprueba que el primer numero cumple los requisitos
			write(buff,texto_error);
			writeline(output,buff);
			write(buff,texto_ingreso_a);
			writeline(output,buff);
			readline(input,buff);
			read(buff,numA);
		end loop;
		A <= Convert(numA,A'Length);
		wait for 20 ns;
		write(buff,texto_ingreso_b);
		writeline(output,buff);
		readline(input,buff);
		read(buff,numB);
		while numB>15 loop	-- Comprueba que el segundo numero cumple los requisitos
			write(buff,texto_error);
			writeline(output,buff);
			write(buff,texto_ingreso_b);
			writeline(output,buff);
			readline(input,buff);
			read(buff,numB);
		end loop;
		B <= Convert(numB,B'Length);
		STB<='1';
		wait for 25 ns; 
		STB<='0';
		wait for 240 ns;
		resultado := Convert(Result);
		write(buff,texto_resultado);
		writeline(output,buff);
		write(buff,resultado);
		writeline(output,buff);
		wait;
	end process;
end Driver;