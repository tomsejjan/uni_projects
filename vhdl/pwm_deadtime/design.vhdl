--! \file design.vhdl
--! \brief Definition of top-level entity Generator_pwm_deadtime and its structural architecture

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! \brief Top-level entity Generator_pwm_deadtime
ENTITY Generator_pwm_deadtime IS
	PORT(
		clk       : in std_logic;							--! Port for clock signal input \a clk
		ce        : in std_logic;							--! Port for clock enable input \a ce
		pwm_val   : in std_logic_vector(2 DOWNTO 0);					--! Port for pwm value input \a pwm_val[2:0]
		drv_top   : out std_logic;							--! Port for signal output \a drv_top
		drv_bottom: out std_logic							--! Port for signal output \a drv_bottom
		);
END ENTITY Generator_pwm_deadtime;

--! \brief Structural description of the architecture top-level entity Generator_pwm_deadtime

--!   The circuit realizes Generator_pwm_deadtime with outputs \p drv_top a \p drv_bottom

ARCHITECTURE Structural OF Generator_pwm_deadtime IS
	SIGNAL q_i: std_logic_vector(pwm_val'range) := (OTHERS => '0');			--! Internal signal with the value of the counter
	SIGNAL pwm_val_i: std_logic_vector(pwm_val'range) := (OTHERS => '0');	--! Internal signal with the PWM value valid for THIS PWM cycle
	SIGNAL load_i: std_logic := '0';		--! Internal signal defining the time for getting a new PWM value
	SIGNAL cmp_i: std_logic := '0';			--! Internal signal with the result of the comparation (hazards included, pipelining needed)
	CONSTANT pwm_max_c: positive := 6;		--! Maximal value of the PWM counter
BEGIN
	pwm_counter1: ENTITY work.Counter_synch_ce_g
		GENERIC MAP(
			BITS => 3,			
			MAX  => pwm_max_c
			)
		PORT MAP(
			clk => clk,
			ce  => ce,
			q   => q_i
			);

	load_i <= '1' WHEN q_i = std_logic_vector(to_unsigned(pwm_max_c, q_i'length)) ELSE
	          '0';

	pwm_value_register1: ENTITY work.Register_synch_load_ce_g
		GENERIC MAP(
			BITS => 3			
			)
		PORT MAP(
			clk  => clk,
			ce   => ce,
			load => load_i,
			d    => pwm_val,
			q    => pwm_val_i
			);

	pwm_comparator1: ENTITY work.Comparator_g
		GENERIC MAP(
			BITS => 3			
			)
		PORT MAP(
			a   => q_i,
			b   => pwm_val_i,
			cmp => cmp_i
			);

	deadtime_generator1: ENTITY work.Generator_deadtime_synch_ce
		PORT MAP(
			clk        => clk,
			ce         => ce,
			cmp        => cmp_i,
			drv_top    => drv_top,
			drv_bottom => drv_bottom
			);

END ARCHITECTURE Structural;
