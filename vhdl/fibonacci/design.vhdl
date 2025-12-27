LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Led_lfsr8_10hz IS
	PORT(
		  ce	 : in std_logic;
        arst : in std_logic;
        clk	 : in std_logic;
        led	 : out std_logic_vector(7 downto 0)
		);
END ENTITY Led_lfsr8_10hz;


ARCHITECTURE Structural OF Led_lfsr8_10hz IS
	
    COMPONENT Lfsr8_fibonacci IS
		PORT(
			clk : in std_logic;
			ce  : in std_logic;					
			arst: in std_logic;					
			q   : out std_logic_vector(7 downto 0)				
			);
	END COMPONENT Lfsr8_fibonacci;
	
    COMPONENT Clock_divider_g IS
		GENERIC(
			MAX: positive := 10-1
			);
		PORT(
			clk_in : in std_logic;		
			clk_out: out std_logic;	
			tc     : out std_logic			
			);
	END COMPONENT Clock_divider_g;
    
	SIGNAL clk_10hz_i : std_logic := '0';
    SIGNAL internal_clk: std_logic := '0';
BEGIN

	lfsr8: Lfsr8_fibonacci
    	PORT MAP(
        		clk 	=> clk_10hz_i,
				ce  	=> ce,
				arst	=> arst,
				q  	=> led
        		);
    clock: Clock_divider_g
    	GENERIC MAP(
            MAX => 10_000_000-1
        )
    	PORT MAP(
				clk_in 	=> clk,
				clk_out	=> clk_10hz_i,
				tc    	=> OPEN
        		);
END ARCHITECTURE Structural;