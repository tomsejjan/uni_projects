--! \file design_pipeline_synch_ce.vhdl
--! \brief Definice entity Pipeline_synch_ce a jeji behavioralni architektury


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--! \brief Entita Pipeline_synch_ce (jednourovnova synchronni pipeline)
ENTITY Pipeline_synch_ce IS
	PORT(
		clk: in std_logic;			--! Port pro vstup hodinoveho signalu \a clk
		ce : in std_logic;			--! Port pro vstup signalu povolujiciho hodinovy signal \a ce
		d  : in std_logic;			--! Port pro vstup dat \a d
		q  : out std_logic			--! Port pro vystup \a q obsahujici hodnotu \a d zpozdenou o jednu periodu hodin
		);
END ENTITY Pipeline_synch_ce;

--! \brief Behavioralni architektura entity Pipeline_synch_ce (jednourovnova synchronni pipeline)
ARCHITECTURE Behavioral OF Pipeline_synch_ce IS
	SIGNAL q_i: std_logic := '0';	--! Vnitrni hodnota uchovana v pipeline
BEGIN
	--! Process zajistujici registrovou cast pipeline pro vystup \p q_i a podminky pro nacteni nove hodnoty.
	--! \vhdlflow Tento diagram zobrazuje jednotlive kroky procesu vlozeni nove hodnoty do pipeline.
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
