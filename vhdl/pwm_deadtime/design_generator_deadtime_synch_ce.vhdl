--! \file design_generator_deadtime_synch_ce.vhdl
--! \brief Entity Generator_deadtime_synch_ce and its structural architecture definition

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! \brief Entity Generator_deadtime_synch_ce
ENTITY Generator_deadtime_synch_ce IS
	PORT(
		clk       : IN  std_logic;			--! Port for clock signal input\a clk
		ce        : IN  std_logic;			--! Port for clock enable input \a ce
		cmp       : IN  std_logic;			--! Port for comparation result input \a cmp
		drv_top   : OUT std_logic;			--! Port for signal output \a drv_top
		drv_bottom: OUT std_logic			--! Port for signal output \a drv_bottom
		);
END ENTITY Generator_deadtime_synch_ce;

--! \brief Structural description of the architecture for entity Generator_deadtime_synch_ce.
ARCHITECTURE Structural OF Generator_deadtime_synch_ce IS
	SIGNAL cmp_p0_i: std_logic := '0';		--! Internal signal with the comparation result after pipelining
	SIGNAL drv_top_q0_i: std_logic := '0';	--! Internal signal for the top transistor control (hazards included, further pipelining needed)
	SIGNAL drv_bottom_q0_i: std_logic := '0';	--! Internal signal for the bottom transistor control (hazards included, further pipelining needed)

BEGIN
	cmp_pipeline0: ENTITY work.Pipeline_synch_ce
		PORT MAP(
			clk => clk,
			ce  => ce,
			d   => cmp,
			q   => cmp_p0_i
			);

	drv_top_q0_i    <= cmp_p0_i AND cmp;
	drv_bottom_q0_i <= cmp_p0_i NOR cmp;

	top_pipeline1: ENTITY work.Pipeline_synch_ce
		PORT MAP(
			clk => clk,
			ce  => ce,
			d   => drv_top_q0_i,
			q   => drv_top
			);

	bottom_pipeline1: ENTITY work.Pipeline_synch_ce
		PORT MAP(
			clk => clk,
			ce  => ce,
			d   => drv_bottom_q0_i,
			q   => drv_bottom
			);

END ARCHITECTURE Structural;
