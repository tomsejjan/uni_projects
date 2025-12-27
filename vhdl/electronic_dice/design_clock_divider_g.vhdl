--! \file design_clock_divider_g.vhdl
--! \brief Definice entity Clock_divider_g a jeji behavioralni architektury
--! \authors Martin Stava 2013, Petr Petyovsky.

-- BPC-LOS Clock Divider entity
-- Authors: Martin Stava 2013, Petr Petyovsky.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--! \brief Genericka entita delicka frekvence
--! \details Delicka frekvence obsahuje vnitrni citac reagujici na nastupou hranu vstupu \a clk_in a ktery cita od hodnoty 0 do hodnoty \a MAX vcetne.
--!   S dalsi nastupnou hranou dojde opetovnemu vynulovani hodnoty vnitrniho citace a cely cyklus se opakuje.
--!   Delicka navic obsahuje vystupni port \a clk_out, na kterem generuje prubeh vydeleneho hodinoveho signalu a take vystup \a tc s vyznamem
--!   \c TerminalCount, tj. byla dosazena maximalni hodnota na vnitrnim citaci a s dalsi nastupnou hranou dojde k jeho resetu.
ENTITY Clock_divider_g IS
	GENERIC(
		MAX: positive			--! Genericky parametr urcujici maximalni hodnotu vnitrniho citace, po ktere dojde k jeho opetovnemu vynulovani
		);
	PORT(
		clk_in : IN  std_logic;	--! Port pro vstup hodinoveho signalu \a clk_in
		clk_out: OUT std_logic;	--! Port pro vystup vydeleneho hodinoveho signalu \a clk_out
		tc     : OUT std_logic	--! (Terminal Count) – poseldní počet, pak se čítač vynuluje
		);
END ENTITY Clock_divider_g;

--! \brief Behavioralni architektura genericke entity delicky frekvence
ARCHITECTURE Behavioral OF Clock_divider_g IS

	SIGNAL cnt_i    : natural RANGE 0 TO MAX := 0;	--! Vnitrni hodnota citace
	SIGNAL clk_out_i: std_logic := '0';				--! Vnitrni signal pro clk_out

BEGIN
	--! Process zajistujici inkrementaci citace, urceni podminky pro jeho vynulovani po prichodu dalsi nastupne hrany.
	--! \vhdlflow Tento diagram zobrazuje jednotlive kroky procesu inkrementace citace a urceni podminky pro jeho nulovani.
	--! \param[in] clk_in Vstupni hodinovy signal
	counter_proc: PROCESS(clk_in)
	BEGIN
		IF rising_edge(clk_in) THEN
			IF cnt_i < MAX THEN
				cnt_i <= cnt_i + 1;
			ELSE
				cnt_i <= 0;
			END IF;
		END IF;
	END PROCESS counter_proc;

	--! Process zajistujici hodnotu vystupniho hodinoveho signalu \p clk_out_i
	--! \vhdlflow Tento diagram zobrazuje jednotlive kroky procesu urceni hodnoty vydeleneho hodinoveho signalu \p clk_out_i.
	--! \param[in] clk_in Vstupni hodinovy signal
	clock_out_proc: PROCESS(clk_in)
	BEGIN
		IF rising_edge(clk_in) THEN
			IF cnt_i = MAX / 2 THEN
				clk_out_i <= '1';
			ELSIF cnt_i = MAX THEN
				clk_out_i <= '0';
			END IF;
		END IF;
	END PROCESS clock_out_proc;

	clk_out <= TRANSPORT clk_out_i AFTER 0.1 ms; -- NEMAZAT: zamerne zpozdeni simulujici casove zpozdeni na vystupu clk_out
	tc      <= '1' WHEN cnt_i = MAX ELSE
	           '0';

END ARCHITECTURE Behavioral;
