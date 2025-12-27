--! \file testbench.vhdl
--! \brief Definice entity a architektury Testbench urcene pro testovani DUT (Device Under Test) komponenty Circuit16


--! Zavedena standardni knihovna \c IEEE
LIBRARY ieee;
--! Zpristupnen balik \c std_logic_1164 z knihovny \c IEEE pro podporu 9-ti stavove logiky
USE ieee.std_logic_1164.ALL;
--! Zpristupnen balik \c numeric_std z knihovny \c IEEE pro podporu konverze cisel dle IEEE 1076.3
USE ieee.numeric_std.ALL;

--! \brief Definice entity Testbench pro testovani komponenty Circuit16
--! \details Entita Testbench nebude mit zadne vstupy ani vystupy
ENTITY Testbench IS
	-- Entita Testbench nebude mit zadne vstupy ani vystupy
END Testbench;

--! \brief Definice architektury entity Testbench
--! \details Architektura entity Testbench overuje spravnost vystupnich hodnot komponenty Circuit16
ARCHITECTURE Behavioral of Testbench IS

	CONSTANT stimulus_step_c: delay_length := 10 ns;	--! Definice a inicializace konstanty simulace

	--! \brief DUT (Device Under Test) komponenta Circuit16
	COMPONENT Circuit16 IS
		PORT(
			e: IN  std_logic;							-- Deklarace vstupu: e
			x: IN  std_logic_vector(3 DOWNTO 0);		-- Deklarace vstupu: x[3:0]
			y: OUT std_logic 							-- Deklarace vystupu: y
			);
	END COMPONENT Circuit16;

	--! Pozadovane vystupy
	CONSTANT y_valid_c: std_logic_vector(0 TO 15) := B"00_11_01_11_00_10_11_10";

	SIGNAL x_in:  std_logic_vector(3 DOWNTO 0) := "0000"; --! Definice signalu pripojenych na vstupy testovane komponenty
	SIGNAL e_in:  std_logic := '0';						--! Definice signalu pripojeneho na vstup testovane komponenty
	SIGNAL y_out: std_logic;							--! Definice signalu pripojeneho na vystup testovane komponenty

BEGIN
	--! Pripojeni DUT komponenty na jednotlive stimuly pomoci jmenne asociace
	dut: Circuit16
		PORT MAP(
			x => x_in, e => e_in,
			y => y_out
			);

	--! \vhdlflow testbench_proc
	--! \test **Test #0 - #15**\n
	--!       Test vystupu: `y`, pro vsechny kombinace vstupu: `x[3:0]` a `e` dle zadane tabulky.
	testbench_proc: PROCESS
	BEGIN
		REPORT "Test start." SEVERITY note;

		-- Vynulujeme vstupy
		e_in <= '0';
		x_in <= "0000";
		WAIT FOR stimulus_step_c;

		FOR i IN 0 TO 15 LOOP
			x_in <= std_logic_vector(to_unsigned(i, 4));

			e_in <= '0';
			WAIT FOR stimulus_step_c;
			ASSERT(y_out = '0')
				REPORT "Chyba vystupu y pro radek #" & to_string(i) & " tabulky"
					SEVERITY error;

			e_in <= '1';
			WAIT FOR stimulus_step_c;
			ASSERT(y_out = y_valid_c(i))
				REPORT "Chyba vystupu y pro radek #" & to_string(i + 16) & " tabulky"
					SEVERITY error;

		END LOOP;

		-- Vynulujeme vstupy
		e_in <= '0';
		x_in <= "0000";
		WAIT FOR stimulus_step_c;

		REPORT "Test done." SEVERITY note;
		WAIT;
	END PROCESS;
END Behavioral;