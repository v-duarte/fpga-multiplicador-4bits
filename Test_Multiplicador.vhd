entity Test_Multiplicador is end;

use work.Utils.all;


architecture Driver of Test_Multiplicador is 
	component Multiplicador port(
		 A: in Bit_Vector(3 downto 0);
		 B: in Bit_Vector(3 downto 0);
		 STB: in Bit;
		 Done: out Bit;
		 Result: out Bit_Vector(7 downto 0);
		 Clk: in Bit
		 );
	end component;
	signal Clk: Bit; 
	signal A,B:Bit_Vector(3 downto 0);
	signal Result: Bit_Vector(7 downto 0); 
	signal STB,Done: Bit;	  
	use work.Utils.all;
begin 
	UTT:Multiplicador port map(A,B,STB,Done,Result,Clk);
	Clock(Clk, 10ns , 10ns );							   
	Stimulus:process
	begin
		for i in 15 downto 0 loop
			A <= Convert(i,A'Length) after 10 ns;
			for j in 15 downto 0 loop
				B <= Convert(j,B'Length)after 10 ns;
				wait for 60ns;
				STB <= '1', '0' after 20 ns;
				wait for 240 ns;
			end loop;
		end loop;
	wait;
	end process;
end Driver;

