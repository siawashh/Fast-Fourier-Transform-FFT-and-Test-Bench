-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY FFT_fourpoint_all_in_one_TB IS
  generic(
	word_lenght : integer := 8
);
  END FFT_fourpoint_all_in_one_TB;

  ARCHITECTURE behavior OF FFT_fourpoint_all_in_one_TB IS 

  -- Component Declaration
          COMPONENT farad_FFT_fourpoint_all_in_one
          PORT(
						--input
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
          END COMPONENT;

signal	i_X0_r,	i_X0_i : signed(word_lenght-1 downto 0) ;
signal	i_X1_r,	i_X1_i : signed(word_lenght-1 downto 0) ;
signal	i_X2_r,	i_X2_i : signed(word_lenght-1 downto 0) ;
signal	i_X3_r,	i_X3_i : signed(word_lenght-1 downto 0) ;

	-- output
signal	o_F0_r,	o_F0_i : signed(word_lenght-1 downto 0) ;
signal	o_F1_r,	o_F1_i : signed(word_lenght-1 downto 0) ;
signal	o_F2_r,	o_F2_i : signed(word_lenght-1 downto 0) ;
signal	o_F3_r,	o_F3_i : signed(word_lenght-1 downto 0) ;

	-- control
signal	clk,CE 	: std_logic;
signal	done 		: std_logic;
constant clk_period : time := 10 ns;          

  BEGIN

  -- Component Instantiation
          uut: farad_FFT_fourpoint_all_in_one PORT MAP(
                  i_X0_r => i_X0_r,
						i_X0_i => i_X0_i,
						
						i_X1_r => i_X1_r,
						i_X1_i => i_X1_i,
						
						i_X2_r => i_X2_r,
						i_X2_i => i_X2_i,
						
						i_X3_r => i_X3_r,
						i_X3_i => i_X3_i,
						
						o_F0_r => o_F0_r,
						o_F0_i => o_F0_i,
						
						o_F1_r => o_F1_r,
						o_F1_i => o_F1_i,
						
						o_F2_r => o_F2_r,
						o_F2_i => o_F2_i,
						
						o_F3_r => o_F3_r,
						o_F3_i => o_F3_i,
						
						clk	=>	clk,
						CE		=> CE,
						done	=>	done
          );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
  --  Test Bench Statements
     stim_proc : PROCESS
     BEGIN

        wait for 100 ns; -- wait until global set/reset completes
			
        -- Add user defined stimulus here
						
						CE <= '1';
						
						-- x = [7+i 5-4i 3+23i 9-2i]
						-- FFT(x) =  24 +18i   2 -18i  -4 +30i   6 -26i
						i_X0_r 	<= to_signed(7,word_lenght);
						i_X0_i 	<= to_signed(1,word_lenght);
						
						i_X1_r 	<= to_signed(5,word_lenght);
						i_X1_i 	<= to_signed(-4,word_lenght);
						
						i_X2_r 	<= to_signed(3,word_lenght);
						i_X2_i 	<= to_signed(23,word_lenght);
						
						i_X3_r 	<= to_signed(9,word_lenght);
						i_X3_i 	<= to_signed(-2,word_lenght);
						--wait for 20 ns;
						--CE <= '0';
			
        wait; -- will wait forever
     END PROCESS ;
  --  End Test Bench 

  END;
