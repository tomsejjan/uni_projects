--! \file design.vhdl
--! \brief Definice top-level entity Led7seg_comparator4 a jeji architektury popsane strukturalnim popisem

--! Zavedena standardni knihovna \c IEEE
LIBRARY ieee;
--! Zpristupnen balik \c std_logic_1164 z knihovny \c IEEE pro podporu 9-ti stavove logiky
USE ieee.std_logic_1164.ALL;
--! Zpristupnen balik \c pkg_cmp3way z pracovni knihovny \c work
--! \details Balik obsahuje definici typu \c Cmp3Way_t a deklaraci komponent: Comparator_cmp3way_g a Led7seg_decoder_cmp3way.
USE work.pkg_cmp3way.ALL;

--! \brief Definice top-level entity Led7seg_comparator4
ENTITY Led7seg_comparator4 IS
	PORT(
		a:   in std_logic_vector(3 downto 0);	--! Deklarace vstupniho vektoru: \a a[3:0]
		b:   in std_logic_vector(3 downto 0);	--! Deklarace vstupniho vektoru: \a b[3:0]
		an:  out std_logic_vector(3 downto 0);	--! Deklarace vystupu na display: \a an[3:0]
		seg: out std_logic_vector(6 downto 0)	--! Deklarace vystupu na display: \a seg[6:0]
		);
END ENTITY Led7seg_comparator4;

--! \brief Definice strukturalniho popisu architektury entity Led7seg_comparator4
--! \details Zde budou instanciovany pozadovane komponenty Comparator_cmp3way_g a Led7seg_decoder_cmp3way a budou
--!   vzajemne propojeny s vyuzitim preddefinovaneho signalu \p cmp_result_i a nadefinovanych portu: \a a, \a b, \a an, \a seg.
ARCHITECTURE Structural OF Led7seg_comparator4 IS
	-- Tady bychom meli deklarovat jednotlive komponenty, ale jsou jiz deklarovany v baliku pkg_cmp3way
	SIGNAL cmp_result_i: Cmp3Way_t := A_eq_B_c;	--! Vnitrni signal pro vysledek porovnani vektoru
    --SIGNAL en_result_i: std_logic := '0';
	SIGNAL compare_i: std_logic_vector(1 downto 0) := "00";
BEGIN
	--! Instanciace komponenty Comparator_cmp3way_g a jeji propojeni pomoci jmenne asociace
	comparator4: Comparator_cmp3way_g
		GENERIC MAP(
			BITS => 4
			)
		PORT MAP(
			a   => a,
			b   => b,
			cmp => cmp_result_i,
            compare => OPEN
			);

	--! Instanciace komponenty Led7seg_decoder_cmp3way a jeji propojeni pomoci jmenne asociace
	led7seg_decoder: Led7seg_decoder_cmp3way
		PORT MAP(
			cmp => cmp_result_i,
			en  => '1',--en_result_i,
			an  => an,
			seg => seg
			);

END ARCHITECTURE Structural;
