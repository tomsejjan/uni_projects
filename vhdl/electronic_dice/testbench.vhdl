--! \file testbench.vhdl
--! \brief Definice entity a architektury Testbench urcene pro testovani DUT (Device Under Test) komponenty: Kostka

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE std.env.finish;			-- Zpristupneni procedury finish z baliku env, ktera zajistuje ukonceni simulace
--! Zpristupnen cely balik \c pkg_bpc_los z pracovni knihovny \c work pro podporu zobrazeni stavu 7-seg displeje
USE work.pkg_bpc_los.ALL;
--! Zpristupneni prevodnich funkci pro 7-segmentovy displej
USE work.pkg_led7seg_decoders.ALL;

--! \brief Testbench pro entitu: Kostka
ENTITY Testbench IS
END ENTITY Testbench;

--! \brief Behavioralni popis architektury entity Testbench pro testovani obvodu Kostka.
ARCHITECTURE Behavioral OF Testbench IS

	CONSTANT clock_period_c: delay_length := 1 ms;		--! Perioda hodinoveho signalu clk (tj. 1 kHz)

	--! \brief DUT (Device Under Test) komponenta Kostka
	COMPONENT Kostka
		PORT(
			clk : in std_logic;							--! Deklarace vstupu: clk
			ce  : in std_logic;							--! Deklarace vstupu: ce
			arst: in std_logic;							--! Deklarace vstupu: arst
			seg : out std_logic_vector(7 downto 0);		--! Deklarace vystupu: seg[7:0]
			an  : out std_logic_vector(3 downto 0)		--! Deklarace vystupu: an[3:0]
			);
	END COMPONENT Kostka;

	-- Inputs
	SIGNAL clk_in, arst_in: std_logic := '0';			--! Signaly pripojene na vstupy testovane komponenty
	SIGNAL ce_in: std_logic := '1';						--! Signal pripojeny na vstup testovane komponenty

	-- Outputs
	SIGNAL seg_out: std_logic_vector(7 DOWNTO 0);		--! Signaly pripojene na vystupy testovane komponenty pro segmenty displeje
	SIGNAL an_out: std_logic_vector(3 DOWNTO 0);		--! Signaly pripojene na vystupy testovane komponenty pro anody displeje

BEGIN
	--! Instanciace komponenty Kostka jako DUT a pripojeni jejich portu na jednotlive stimuly
	dut: Kostka
		PORT MAP(
			clk  => clk_in,
			ce   => ce_in,
			arst => arst_in,
			seg  => seg_out,
			an   => an_out
			);

	-- Clock process definition
	--! Proces entity Testbench vytvarejici hodinove impulsy
	--! \vhdlflow Tento diagram zobrazuje jednotlive kroky procesu vytvarejiciho 150 period na signalu \p clk_in.
	clock_proc: PROCESS
	BEGIN
		WAIT FOR 5 ms;		-- Wait for 5 ms before start of simulation
		FOR i IN 1 TO 150 LOOP --udělám si 150 period
			clk_in <= '1';
			WAIT FOR clock_period_c / 2; --nastavuji si střídu na 50%
			clk_in <= '0';
			WAIT FOR clock_period_c / 2;
		END LOOP;
		WAIT FOR 10 ms;		-- Hold for 10 ms before end of simulation
		WAIT;
	END PROCESS clock_proc;

	-- Stimulus process definition
	--! Testovaci process entity Testbench vytvarejici jednotlive stimuly.
	--! \vhdlflow Tento diagram zobrazuje jednotlive kroky testovaciho procesu vcetne popisu jednotlivych stimulu a testovacich podminek.
	--! \test **Test #0-6**\n
	--!   Zobrazuje hodnotu na displeji po dobu 70 period hodinoveho signalu \b clk_in.\n
	--! \test **Test #7-18**\n
	--!   Nastavime signal \b arst_in na aktivni hodnotu a kontrolujeme 11 period hodinoveho signalu \b clk_in,
	--!   ze nedojde ke zmene hodnoty na segmentech.\n
	--! \test **Test #19-26**\n
	--!   Stridave povolujeme a zakazujeme citani johnsonova citace pomoci signalu \b ce_in po dobu 70 period hodinoveho 
	--!   signalu \b clk_in kontrolujeme hodnoty na segmentech.
	testbench_proc: PROCESS
		VARIABLE symbol_on_segments_v: std_logic_vector(7 DOWNTO 0) := X"00";
	BEGIN
		REPORT "Test start." SEVERITY note;

		WAIT FOR 5 ms;		-- Wait for 5 ms before start of simulation
		FOR i IN 1 TO 7 LOOP --7 stavů. 6 našich známých a 1 s chybovou indikací
			led7seg_show(an_out, seg_out(6 DOWNTO 0), seg_out(7));
			symbol_on_segments_v := seg_out;
			FOR j IN 1 TO 10 LOOP --čekám na stabilizaci signálu a kontrolu výsledku
				WAIT ON clk_in UNTIL clk_in = '1'; --until – dokud není!!
                --čekej, jestli se změní. Pokud ano, zkontroluj, jestli clk_in='1'. POUZE WAIT UNTIL NEMONITURUJE VŠECHNY ZMĚNY!!
			END LOOP;
		END LOOP;

		REPORT "Resetujeme...";
		arst_in <= '1';
		FOR j IN 1 TO 11 LOOP --proč 11 period???
			WAIT ON clk_in UNTIL clk_in = '1';
			ASSERT seg_out(6 DOWNTO 0) = led7seg_johnson_to_segments("000") REPORT "Nefunguje ARst" SEVERITY error;
		END LOOP;

		arst_in <= '0';
		REPORT "Konec resetovani...";
		FOR i IN 1 TO 7 LOOP
			led7seg_show(an_out, seg_out(6 DOWNTO 0), ce_in);	-- Doxygen vhdlflow parser crash
			FOR j IN 1 TO 10 LOOP
				WAIT ON clk_in UNTIL clk_in = '1';
			END LOOP;

			IF(i MOD 2 = 0) THEN --přepínám signál každé 2 iterace (kruhovost zajišťuje modulo
				ce_in <= NOT ce_in;
			END IF;

			IF ce_in = '1' THEN
				symbol_on_segments_v := seg_out;
			ELSIF ce_in = '0' THEN
				ASSERT seg_out = symbol_on_segments_v REPORT "Nefunguje CE" SEVERITY error;
			END IF;
		END LOOP;

		REPORT "Test done." SEVERITY note;
		finish;					-- Procedura z baliku env zajistujici ukonceni simulace
	END PROCESS testbench_proc;
END ARCHITECTURE Behavioral;
