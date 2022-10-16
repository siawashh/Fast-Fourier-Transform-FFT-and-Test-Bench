----------------------------------------------------------------------------------
-- Engineer: siawash 
-- Create Date:    19:28:15 09/12/2022  
-- Module Name:    FFT_fourpoint_all_in_one - Behavioral 
-- Project Name: 	FFT 4point all in one code
-- Description: 
--
-- posedge osilator = 24MHz
--
-------------------------------- 4-piont-FFT all in one calculation ------------------------------------------
--
-- I/O :
-- in 4-piont-FFT we have reverse bit input reverse bit means when we have (in0 , in1 , in2 , in3) we dont have
-- (out0 ,out1, out2 , out3) but we can compute how to give input to have (out0 ,out1, out2 , out3) the way is:
-- 0 1 2 3 >> to binary >> 00 01 10 11 >> reverse bit >> 00 10 01 11 >> to decomal >> 0 2 1 3
-- so if we give (in0 , in2 , in1 , in3) to 4-piont-FFT will have (out0 ,out1, out2 , out3)
--
-- circuit connection draw to formula : 
--													A_r					A_i
-- A = [ X(0) + W(2)^0 * X(2) ] = (X0_r + X2_r) + j (X0_i + X2_i)
--
--													B_r					B_i
-- B = [ X(0) - W(2)^0 * X(2) ] = (X0_r - X2_r) + j (X0_i - X2_i)
--
--													C_r					C_i
-- C = [ X(1) + W(2)^0 * X(3) ] = (X1_r + X3_r) + j (X1_i + X3_i)
--
--													D_r					D_i
-- D = [ X(1) - W(2)^0 * X(3) ] = (X1_r - X3_r) + j (X1_i - X3_i)
--
--												F(0)_r				F(0)_i
--	F(0) = A + W(4)^0 * C		  = (A_r + C_r) 	+ j (A_i + C_i)
--
--																																	F(1)_r			F(1)_i
-- F(1) = B + W(4)^1 * D >>  W(4)^1 = -j >>  B + ( -j * D) = (B_r + D_i) + j (B_i + (- D_r))	= (B_r + D_i) + j (B_i - D_r)
--
--												F(2)_r				F(2)_i
-- F(2) = A	- W(4)^0 * C		  = (A_r - C_r) 	+ j (A_i - C_i)
--
--																																		F(3)_r			F(3)_i
-- F(3) = B - W(4)^1 * D >>  W(4)^1 = -j >> B - ( -j * D)  = (B_r -  D_i) + j (B_i - (- D_r)) = (B_r - D_i) + j (B_i + D_r)	 
--
-- math formuls:
--
-- complex number * -j:
-- (D_r+j D_i)* -j = D_i + j(-D_r)
-- (D_r-j D_i)* -j = D_i - j(-D_r)
-- 
-- complex number + complex number:
-- [ X(0) + X(2) ] = (X0_r + X2_r) + j (X0_i + X2_i)
-- [ X(0) - X(2) ] = (X0_r - X2_r) + j (X0_i - X2_i)
--
-- coeffients: 
-- W(N)^n = e^(-j*2*pi*n / N) >> consider x = -2*pi*n / N >> e^jx = cos(x)+j sin(x) 
-- W(4)^0 = 1  bcz >> anything^0 = 1 >>  e^(-j*2*pi*0 / 4) = e^0 = 1
-- W(4)^1 = -j bcz >> e^(-j*2*pi*1 / 4) >> e^(-j*pi / 2) = cos(-pi / 2) + j sin(-pi / 2) = 0 + j*(-1) = -j 

--------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FFT_fourpoint_all_in_one is
generic(
	word_lenght : integer := 8
);
port(
-- input
i_X0_r,	i_X0_i :in signed(word_lenght-1 downto 0) ;
i_X1_r,	i_X1_i :in signed(word_lenght-1 downto 0) ;
i_X2_r,	i_X2_i :in signed(word_lenght-1 downto 0) ;
i_X3_r,	i_X3_i :in signed(word_lenght-1 downto 0) ;

-- output
o_F0_r,	o_F0_i :out signed(word_lenght-1 downto 0) ;
o_F1_r,	o_F1_i :out signed(word_lenght-1 downto 0) ;
o_F2_r,	o_F2_i :out signed(word_lenght-1 downto 0) ;
o_F3_r,	o_F3_i :out signed(word_lenght-1 downto 0) ;

-- control
clk,CE 	:in std_logic;
done 		:out std_logic
);
end FFT_fourpoint_all_in_one;

architecture Behavioral of FFT_fourpoint_all_in_one is

-- input register
signal X0_r_int,	X0_i_int : signed(word_lenght-1 downto 0) ;
signal X1_r_int,	X1_i_int : signed(word_lenght-1 downto 0) ;
signal X2_r_int,	X2_i_int : signed(word_lenght-1 downto 0) ;
signal X3_r_int,	X3_i_int : signed(word_lenght-1 downto 0) ;

-- output register
signal F0_r_int,	F0_i_int : signed(word_lenght-1 downto 0) ;
signal F1_r_int,	F1_i_int : signed(word_lenght-1 downto 0) ;
signal F2_r_int,	F2_i_int : signed(word_lenght-1 downto 0) ;
signal F3_r_int,	F3_i_int : signed(word_lenght-1 downto 0) ;

-- pipeline register
signal A_r_int,	A_i_int : signed(word_lenght-1 downto 0) ;
signal B_r_int,	B_i_int : signed(word_lenght-1 downto 0) ;
signal C_r_int,	C_i_int : signed(word_lenght-1 downto 0) ;
signal D_r_int,	D_i_int : signed(word_lenght-1 downto 0) ;

-- control signal and register
signal CE_int  	: std_logic;
signal CE2  		: std_logic;
signal done_int  	: std_logic;
type state1 is range 0 to 3;
type state2 is range 0 to 3;
signal FSM1 : state1;
signal FSM2 : state2;

BEGIN
-- output register to output via wire
o_F0_r	<= F0_r_int;
o_F0_i	<= F0_i_int;

o_F1_r	<= F1_r_int;
o_F1_i	<= F1_i_int;

o_F2_r	<= F2_r_int;
o_F2_i	<= F2_i_int;

o_F3_r	<= F3_r_int;
o_F3_i	<= F3_i_int;

-- output register to output via wire
done <= done_int;
FFT:process(clk)
begin
	if rising_edge(clk) then
		-- done overread preventer
		done_int <= '0';
		
		-- input data register
		X0_r_int <= i_X0_r;
		X0_i_int <= i_X0_i;
		
		X1_r_int <= i_X1_r;
		X1_i_int <= i_X1_i;
		
		X2_r_int <= i_X2_r;
		X2_i_int <= i_X2_i;
		
		X3_r_int <= i_X3_r;
		X3_i_int <= i_X3_i;
		
		-- input control register
		CE_int	<= CE ;
		
		-- pipe 1
		if CE_int = '1' then
		case FSM1 is
		when 0 =>
		-- A =  (X0_r + X2_r) + j (X0_i + X2_i)
		A_r_int <= X0_r_int + X2_r_int;
		A_i_int <= X0_i_int + X2_i_int;
		FSM1 <= 1;
		when 1 =>
		--B = (X0_r - X2_r) + j (X0_i - X2_i)
		B_r_int <= X0_r_int - X2_r_int;
		B_i_int <= X0_i_int - X2_i_int;
		FSM1 <= 2;
		when 2 =>
		--C = (X1_r + X3_r) + j (X1_i + X3_i)
		C_r_int <= X1_r_int + X3_r_int;
		C_i_int <= X1_i_int + X3_i_int;
		FSM1 <= 3;
		when 3 =>
		--D = (X1_r - X3_r) + j (X1_i - X3_i)
		D_r_int <= X1_r_int - X3_r_int;
		D_i_int <= X1_i_int - X3_i_int;
		FSM1 <= 0;
		-- control
		CE2 <= '1';
		end case;
		end if;
		
		-- pipe 2
		if CE2 = '1' then		
		case FSM2 is
		when 0 =>
		-- F(0) = (A_r + C_r) + j (A_i + C_i)
		F0_r_int <= A_r_int + C_r_int;
		F0_i_int <= A_i_int + C_i_int;
		FSM2 <= 1;
		when 1 =>
		--F(1) = (B_r + D_i) + j (B_i - D_r)
		F1_r_int <= B_r_int + D_i_int;
		F1_i_int <= B_i_int - D_r_int;
		FSM2 <= 2;
		when 2 =>
		--F(2) = (A_r - C_r) + j (A_i - C_i)
		F2_r_int <= A_r_int - C_r_int;
		F2_i_int <= A_i_int - C_i_int;
		FSM2 <= 3;
		when 3 =>
		--F(3) = (B_r - D_i) + j (B_i + D_r)
		F3_r_int <= B_r_int - D_i_int;
		F3_i_int <= B_i_int + D_r_int;
		FSM2 <= 0;
		-- control
		done_int <= '1';
		CE2 <= '0';
		end case;
		end if;
		
	end if;
end process;
end Behavioral;

