--! \file design.vhdl
--! \brief Definice top-level entity Led7seg_alu2 a jeji architektury popsane strukturalnim popisem

--! Zavedena standardni knihovna \c IEEE
LIBRARY ieee;
--! Zpristupnen balik \c std_logic_1164 z knihovny \c IEEE pro podporu 9-ti stavove logiky
USE ieee.std_logic_1164.ALL;

--! \brief Definice top-level entity Led7seg_alu2
--! \todo Doplnte chybejici casti definice portu entity Led7seg_alu2
ENTITY Led7seg_alu2 IS
	PORT(
		a:    in std_logic_vector(1 downto 0);	--! Deklarace vstupniho vektoru: \a a[1:0]
		b:    in std_logic_vector(1 downto 0);	--! Deklarace vstupniho vektoru: \a b[1:0]
		oper: in std_logic_vector(1 downto 0);	--! Deklarace vstupu definujici typ operace
		an:   out std_logic_vector(3 downto 0);	--! Deklarace vystupu na display: \a an[3:0]
		seg:  out std_logic_vector(7 downto 0);	--! Deklarace vystupu na display: \a seg[7:0]
		zero: out std_logic;			--! Deklarace vystupu (flag) signalizujiciho nulovy vysledek
      alu_result_out: out std_logic_vector(3 DOWNTO 0)
		);
END ENTITY Led7seg_alu2;

--! \brief Definice strukturalniho popisu architektury entity Led7seg_alu2

ARCHITECTURE Structural OF Led7seg_alu2 IS

	--! \brief Deklarace komponenty Alu2
	COMPONENT Alu2 IS
		PORT(
			a:      in std_logic_vector(1 downto 0);	--! Deklarace vstupniho vektoru: \a a[1:0]
			b:      in std_logic_vector(1 downto 0);	--! Deklarace vstupniho vektoru: \a b[1:0]
			oper:   in std_logic_vector(1 downto 0);	--! Deklarace vstupu definujici typ operace: \a oper[1:0]
			result: out std_logic_vector(3 downto 0);	--! Deklarace vystupniho vektoru s vysledkem operace: \a result[3:0]
			zero:   out std_logic			--! Deklarace vystupu (flag) signalizujiciho nulovy vysledek na \a result[3:0]
			);
	END COMPONENT Alu2;

	--! \brief Deklarace komponenty Led7seg_decoder_signed
	COMPONENT Led7seg_decoder_signed IS
		PORT(
			x:   in std_logic_vector(3 downto 0);	-- Deklarace vstupu: x[3:0]
			an:  out std_logic_vector(3 downto 0);	-- Deklarace vystupu: an[3:0]
			seg: out std_logic_vector(7 downto 0)	-- Deklarace vystupu: seg[7:0]
			);
	END COMPONENT Led7seg_decoder_signed;

	SIGNAL alu_result_i: std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');	--! Vnitrni signal pro ulozeni mezivysledku
BEGIN

	--! Instanciace komponenty Alu2 a jeji propojeni pomoci jmenne asociace
	alu: Alu2
		PORT MAP(
			a      => a,
			b      => b,
			oper   => oper,
			result => alu_result_i,
			zero   => zero
			);
	alu_result_out <= alu_result_i;
	--! Instanciace komponenty Led7seg_decoder a jeji propojeni pomoci jmenne asociace
	decoder: Led7seg_decoder_signed
		PORT MAP(
			x   => alu_result_i,
			an  => an,
			seg => seg
			);

END ARCHITECTURE Structural;
