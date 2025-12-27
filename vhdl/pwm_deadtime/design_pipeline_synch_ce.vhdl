--! \file design_pipeline_synch_ce.vhdl
--! \brief Entity Pipeline_synch_ce and its behavioral architecture definition

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--! \brief Entity Pipeline_synch_ce (synchronous pipeline with one level)
ENTITY Pipeline_synch_ce IS
	PORT(
		clk: in std_logic;			--! Port for clock signal input\a clk
		ce : in std_logic;			--! Port for clock enable input \a ce
		d  : in std_logic;			--! Port for data input \a d
		q  : out std_logic			--! Port for output \a q with value \a d delayed one clock cycle
		);
END ENTITY Pipeline_synch_ce;

--! \brief Behavioral architecture of the entity Pipeline_synch_ce (synchronous pipeline with one level)
ARCHITECTURE Behavioral OF Pipeline_synch_ce IS
	SIGNAL q_i: std_logic := '0';	--! Internal value stored in pipeline
BEGIN
	--! \brief Process implementing the pipeline register stage for output \p q_i and the load conditions for new values.
    --! \vhdlflow This diagram illustrates the individual steps of inserting a new value into the pipeline.
	pipeline_proc: PROCESS(clk)
	BEGIN
    	IF rising_edge(clk) THEN
        	IF ce = '1' THEN
            	q_i <= d;
            END IF;
       	END IF;
   	END PROCESS pipeline_proc;

	q <= q_i;
END ARCHITECTURE Behavioral;
