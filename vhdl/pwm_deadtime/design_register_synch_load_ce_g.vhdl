--! \file design_register_synch_load_ce_g.vhdl
--! \brief Generic entity Register_synch_load_ce_g and its behavioral architecture


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! \brief Generic entity synchronous register with inputs \a ce a \a load. Input data width is \a BITS
ENTITY Register_synch_load_ce_g IS
	GENERIC(
		BITS: positive			--! Generic parameter declaring width of the output vector \a q[BITS-1:0]
		);
	PORT(
		clk : in std_logic;							--! Port for clock signal input\a clk
		ce  : in std_logic;							--! Port for clock enable input \a ce
		load: in std_logic;							--! Port for synchronous data load \a load
		d   : in std_logic_vector(BITS-1 downto 0);						--! Port for input data vector \a d[BITS-1:0] for synchronous load
		q   : out std_logic_vector(BITS-1 downto 0)						--! Port for output values \a q[BITS-1:0]
		);
END ENTITY Register_synch_load_ce_g;

--! \brief Behavioral architecture entity of the synchronous register with input load and input data width BITS
ARCHITECTURE Behavioral OF Register_synch_load_ce_g IS
	SIGNAL q_i: std_logic_vector(d'range) := (OTHERS => '0'); 	--! Iternal value in register
BEGIN
	--! \brief Process ensuring the storage of value \p d when \p load = '1' and \p ce = '1' on the rising edge of the \p clk signal.
    --! \vhdlflow This diagram illustrates the specific conditions and sequential steps for archiving a new value into the register.
	reg_proc: PROCESS(clk)
	BEGIN
		IF rising_edge(clk) THEN
       		IF load = '1' THEN
            	IF ce = '1' THEN
                	q_i <= d;
                END IF;
            END IF;
        END IF;
    END PROCESS reg_proc;
	q <= q_i;
END ARCHITECTURE Behavioral;
