--! \file testbench.vhdl
--! \brief Definice entity a architektury Testbench urcene pro testovani DUT (Device Under Test) komponenty: Lfsr8_fibonacci

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.env.finish;				-- Zpristupneni procedury finish z baliku env, ktera zajistuje ukonceni simulace
--! Zpristupnen cely balik \c pkg_bpc_los z pracovni knihovny \c work pro podporu zobrazeni stavu LED
USE work.pkg_bpc_los.ALL;

--! \brief Testbench pro entitu: Lfsr8_fibonacci
ENTITY Testbench IS
END ENTITY Testbench;

--! \brief Behavioralni popis architektury entity Testbench pro testovani obvodu Lfsr8_fibonacci.
ARCHITECTURE Behavioral OF Testbench IS

	CONSTANT clock_period_c: delay_length := 1 ms;		--! Perioda hodinoveho signalu clk (tj. 1 kHz)

	--! \brief DUT (Device Under Test) komponenta Lfsr8_fibonacci
	COMPONENT Lfsr8_fibonacci IS
		PORT(
			clk : in std_logic;							-- Deklarace vstupu: clk
			ce  : in std_logic;							-- Deklarace vstupu: ce
			arst: in std_logic;							-- Deklarace vstupu: arst
			q   : out std_logic_vector(7 downto 0)		-- Deklarace vystupu: q[7:0]
			);
	END COMPONENT Lfsr8_fibonacci;

	-- Inputs
	SIGNAL clk_in, arst_in : std_logic := '0';			--! Signaly pripojene na vstupy testovane komponenty
	SIGNAL ce_in: std_logic := '1';						--! Signal pripojeny na vstup testovane komponenty

	-- Outputs
	SIGNAL led_out: std_logic_vector(7 DOWNTO 0);		--! Signaly pripojene na vystupy testovane komponenty pro LED

BEGIN
	--! Instanciace komponenty Lfsr8_fibonacci jako DUT a pripojeni jejich portu na jednotlive stimuly
	dut: Lfsr8_fibonacci
		PORT MAP(
			clk  => clk_in,
			ce   => ce_in,
			arst => arst_in,
			q    => led_out
			);

	-- Clock process definition
	--! Proces entity Testbench vytvarejici hodinove impulsy
	--! \vhdlflow Tento diagram zobrazuje jednotlive kroky procesu vytvarejiciho 270 period na signalu \p clk_in.
	clock_proc: PROCESS
	BEGIN
		WAIT FOR 5 ms;		-- Wait after start for 5 ms
		FOR i IN 1 TO 270 LOOP
			clk_in <= '0';
			WAIT FOR clock_period_c / 2;
			clk_in <= '1';
			WAIT FOR clock_period_c / 2;
		END LOOP;
		WAIT FOR 10 ms;		-- Hold for 10 ms before end of simulation
		WAIT;
	END PROCESS clock_proc;

	-- Stimulus process definition
	--! Testovaci process entity Testbench vytvarejici jednotlive stimuly.
	--! \vhdlflow Tento diagram zobrazuje jednotlive kroky testovaciho procesu vcetne popisu jednotlivych stimulu a testovacich podminek.
	--! \test **Test #0-259**\n
	--!   Overuje spravnost vystupni hodnoty dle generovaneho polynomu. A hleda periodu generovane sekvence.\n
	--! \test **Test #260**\n
	--!   Overuje spravnost fungovani obvodu pri `arst = 1`.\n
	--! \test **Test #261-262**\n
	--!   Overuje spravnost fungovani obvodu pri `arst = 0` a `ce = 0`.
	testbench_proc: PROCESS
		VARIABLE val_v: natural := 16#FF#;		-- Valid value of simulated LFSR
	BEGIN
		REPORT "Test start." SEVERITY note;

		WAIT FOR 5 ms;		-- Wait after start for 5 ms
		WAIT ON clk_in UNTIL clk_in = '1';

		FOR i IN 1 TO 260 LOOP
			ledbar8_show(led_out);

			ASSERT led_out = std_logic_vector(to_unsigned(val_v, 8))
				REPORT "Chyba v LFSR na kroku: #" & to_string(i) &
						", led: " & to_string(led_out) &
						", val_v: " & to_string(std_logic_vector(to_unsigned(val_v, 8)))
							SEVERITY failure;

			WAIT ON clk_in UNTIL clk_in = '1';

			val_v := 2 * val_v;
			val_v := val_v + (val_v / 2**8 + val_v / 2**6 + val_v / 2**5 + val_v / 2**4) MOD 2;
			val_v := val_v MOD 256;

			IF led_out = X"FF" THEN
				REPORT "Perioda LFSR nalezena po " & to_string(i) & " krocich.";
			END IF;
		END LOOP;

		arst_in <= '1';
		WAIT ON clk_in UNTIL clk_in = '1';
		ASSERT led_out = X"FF" REPORT "Chyba v LFSR pri: arst = 1 a ce = 1" SEVERITY failure;

		arst_in <= '0';
		ce_in <= '0';
		WAIT ON clk_in UNTIL clk_in = '1';

		FOR i IN 1 TO 2 LOOP
			WAIT ON clk_in UNTIL clk_in = '1';
			ASSERT led_out = X"FF" REPORT "Chyba v LFSR pri: arst = 0 a ce = 0" SEVERITY failure;
		END LOOP;

		REPORT "Test done." SEVERITY note;
		finish;					-- Procedura z baliku env zajistujici ukonceni simulace
	END PROCESS testbench_proc;
END ARCHITECTURE Behavioral;
