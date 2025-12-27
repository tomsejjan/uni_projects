--! \file testbench.vhdl
--! \brief Definice entity a architektury Testbench urcene pro testovani DUT (Device Under Test) komponent: Led7seg_comparator4, Comparator_cmp3way_g a Led7seg_decoder_cmp3way


LIBRARY ieee; --! Zavedena standardni knihovna IEEE

USE ieee.std_logic_1164.ALL;--! Zpristupnen balik std_logic_1164 z knihovny  IEEE pro podporu 9-ti stavove logiky

USE ieee.numeric_std.ALL;--! Zpristupnen balik numeric_std z knihovny IEEE pro podporu konverze cisel dle IEEE 1076.3

--LIBRARY work;
--! Zpristupnen cely balik \c pkg_bpc_los z pracovni knihovny \c work pro podporu zobrazeni stavu 7-seg displeje
USE work.pkg_bpc_los.ALL;
--! Zpristupnen balik \c pkg_cmp3way z pracovni knihovny \c work obsahujici definici typu \c Cmp3Way_t a dalsi deklarace.
USE work.pkg_cmp3way.ALL;


--! \details Entita Testbench overuje spravnost TŘÍ komponent: Led7seg_comparator4, Comparator_cmp3way_g a Led7seg_decoder_cmp3way.
ENTITY Testbench IS
	-- Entita Testbench nebude mit zadne vstupy ani vystupy
END Testbench;

--! \brief Definice architektury entity Testbench
--! \details Architektura entity Testbench overuje spravnost komponent: Led7seg_comparator4, Comparator_cmp3way_g a Led7seg_decoder_cmp3way.
ARCHITECTURE Behavioral of Testbench IS

	CONSTANT stimulus_step_c: delay_length := 10 ns;	--! Definice a inicializace konstanty simulace

	--! \brief DUT (Device Under Test) komponenta Led7seg_comparator4
	COMPONENT Led7seg_comparator4 IS
		PORT(
			a:    in std_logic_vector(3 downto 0);	-- Deklarace vstupu:  a[3:0]
			b:    in std_logic_vector(3 downto 0);	-- Deklarace vstupu:  b[3:0]
			an:   out std_logic_vector(3 downto 0);	-- Deklarace vystupu: an[3:0]
			seg:  out std_logic_vector(6 downto 0)	-- Deklarace vystupu: seg[6:0]
			);
	END COMPONENT Led7seg_comparator4;

	SIGNAL a_in, b_in: std_logic_vector(3 DOWNTO 0) := (OTHERS => '0'); --! Definice signalu pripojenych na vstupy testovane komponenty
	SIGNAL an_out:  std_logic_vector(3 DOWNTO 0) := (OTHERS => '1');	--! Definice signalu pripojenych na vystupy testovane komponenty (anody)
	SIGNAL seg_out: std_logic_vector(6 DOWNTO 0) := (OTHERS => '1');	--! Definice signalu pripojenych na vystupy testovane komponenty (katody)

	-- Mapping alias to the internal signal and port with VHDL-2008 External name feature
	ALIAS dut_cmp_result IS						--! Pripojeni na vnitrni signal \p cmp_result_i testovane komponenty Led7seg_comparator4
		<< SIGNAL .Testbench.dut.cmp_result_i: Cmp3Way_t >>;
	ALIAS dut_led7seg_decoder_en IS			--! Pripojeni na vnitrni port \a en testovane komponenty Led7seg_decoder_cmp3way
		<< SIGNAL .Testbench.dut.led7seg_decoder.en: std_logic >>;

BEGIN

	dut: Led7seg_comparator4 --hází výsledek porovnání na sedmisegmentový displej
		PORT MAP(
			a   => a_in,
			b   => b_in,
			an  => an_out,
			seg => seg_out
			);

	--! \vhdlflow testbench_proc
	--! \test **Test #0 - #5**\n
	--!   Testujeme spravnou funkci dut_led7seg_decoder\n
	--! \test **Test #6 - #262**\n
	--!   Testujeme spravnou funkci dut_comparator4
	testbench_proc: PROCESS
	BEGIN
		REPORT "Test start." SEVERITY note;

		-- Testujeme decoder
		REPORT "Testing dut_led7seg_decoder..." SEVERITY note;
		FOR i IN Cmp3Way_t'left TO Cmp3Way_t'right LOOP --iteruji přes všechny stavy tohoto výčtového typu

			dut_cmp_result <= FORCE i;				-- VHDL-2008 forcing value to the internal signal
			dut_led7seg_decoder_en <= FORCE '1';	-- VHDL-2008 forcing value to the internal port
			WAIT FOR stimulus_step_c;

			CASE i IS
				WHEN A_lt_B_c => REPORT "A < B" SEVERITY note;
				WHEN A_eq_B_c => REPORT "A = B" SEVERITY note;
				WHEN A_gt_B_c => REPORT "A > B" SEVERITY note;
				WHEN OTHERS   => REPORT "Neznamy stav" SEVERITY error;
			END CASE;

			led7seg_show_big(an_out, seg_out); --zobrazení na sedmisegmentovce
			dut_led7seg_decoder_en <= FORCE '0'; --TESTUJI SIGNÁL NA DEKODÉRU, KDYŽ JE VYPLÝ
			WAIT FOR stimulus_step_c;

			ASSERT (seg_out = 7X"7F") OR (an_out = X"F")
				REPORT "Komponenta Led7seg_decoder generuje chybne vystupy pri EN=0" SEVERITY error;

		END LOOP;
		dut_cmp_result <= RELEASE;				-- VHDL-2008 releasing internal signal to the normal
		dut_led7seg_decoder_en <= RELEASE;		-- VHDL-2008 releasing internal port to the normal

		-- Testujeme comparator
		REPORT "Testing dut_comparator4..." SEVERITY note;
		FOR a IN 0 TO 15 LOOP --16 kombinací, protože áčko je 4bitové číslo
			FOR b IN 0 TO 15 LOOP --kombinace, abychom pro každé áčko zkusili béčko
				a_in <= std_logic_vector(to_unsigned(a, 4));
				b_in <= std_logic_vector(to_unsigned(b, 4));
				WAIT FOR stimulus_step_c;

				IF a < b THEN
					ASSERT(dut_cmp_result = A_lt_B_c)
						REPORT "A >= B, A=" & to_string(a) & ", B=" & to_string(b) SEVERITY error; --Zde je A i B typu integer KVŮLI FOR CYKLU, proto je konverze možná!
				END IF;

				IF a = b THEN
					ASSERT(dut_cmp_result = A_eq_B_c)
						REPORT "A /= B, A=" & to_string(a) & ", B=" & to_string(b) SEVERITY error;
				END IF;

				IF a > b THEN
					ASSERT(dut_cmp_result = A_gt_B_c)
						REPORT "A <= B, A=" & to_string(a) & ", B=" & to_string(b) SEVERITY error;
				END IF;

			END LOOP;
		END LOOP;

		
		a_in <= (OTHERS => '0');
		b_in <= (OTHERS => '0');
		WAIT FOR stimulus_step_c;

		REPORT "Test done." SEVERITY note;
		WAIT;
	END PROCESS;
END Behavioral;
