--! \file design.vhdl
--! \brief Definice top-level entity Led7seg_adder3 a jeji architektury popsane strukturalnim popisem

--! Zavedena standardni knihovna \c IEEE
LIBRARY ieee;
--! Zpristupnen balik \c std_logic_1164 z knihovny \c IEEE pro podporu 9-ti stavove logiky
USE ieee.std_logic_1164.ALL;

--! \brief Definice top-level entity Led7seg_adder3
ENTITY Led7seg_adder3 IS
	PORT(
		a:   in std_logic_vector(2 downto 0);	--! Deklarace vstupniho vektoru: \a a[2:0]
		b:   in std_logic_vector(2 downto 0);	--! Deklarace vstupniho vektoru: \a b[2:0]
		cin: in std_logic;			--! Deklarace vstupu carry_in: \a cin
		an:  out std_logic_vector(3 downto 0);	--! Deklarace vystupu na display: \a an[3:0]
		seg: out std_logic_vector(6 downto 0);	--! Deklarace vystupu na display: \a seg[6:0]
        led_out: out std_logic_vector(3 downto 0)
		);
END ENTITY Led7seg_adder3;

--! \brief Definice strukturalniho popisu architektury entity Led7seg_adder3
--! \todo Zde budou vlozeny instance komponent Adder3 a Led7seg_decoder_hex, ktere bude treba vhodne propojit tak,
--!       aby vznikl obvod 3-bitove scitacky a dekoderu pro display.
ARCHITECTURE Structural OF Led7seg_adder3 IS

	--! \brief Deklarace komponenty Adder3
	COMPONENT Adder3 IS
		PORT(
			a:   in std_logic_vector(2 downto 0);	-- Deklarace vstupu: a[2:0]
			b:   in std_logic_vector(2 downto 0);	-- Deklarace vstupu: b[2:0]
			cin: in std_logic;			-- Deklarace vstupu: carry in
			sum: out std_logic_vector	-- Deklarace vystupu: souctu			
            );
	END COMPONENT Adder3;

	--! \brief Deklarace komponenty Led7seg_decoder
	COMPONENT Led7seg_decoder_hex IS
		PORT(
			x:   in std_logic_vector(3 downto 0);	-- Deklarace vstupu: x[3:0]
			an:  out std_logic_vector(3 downto 0);	-- Deklarace vystupu: an[3:0]
			seg: out std_logic_vector(6 downto 0)	-- Deklarace vystupu: seg[6:0]
			);
	END COMPONENT Led7seg_decoder_hex;

	SIGNAL sum_result_i: std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');	--! Vnitrni signal pro ulozeni mezivysledku
BEGIN

	--! Instanciace komponenty Adder3 a jeji propojeni pomoci jmenne asociace
	adder: Adder3
		PORT MAP(
			a   => a,
			b   => b,
			cin => cin,
			sum => sum_result_i
			);
	led_out <= sum_result_i;
	--! Instanciace komponenty Led7seg_decoder a jeji propojeni pomoci jmenne asociace
	decoder: Led7seg_decoder_hex
		PORT MAP(
			x   => sum_result_i,
			an  => an,
			seg => seg
			);

END ARCHITECTURE Structural;
