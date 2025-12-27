--! \file design_led7seg_decoder_cmp3way.vhdl
--! \brief Definice entity Led7seg_decoder_cmp3way a jeji architektury


--! Zavedena standardni knihovna \c IEEE
LIBRARY ieee;
--! Zpristupnen balik \c std_logic_1164 z knihovny \c IEEE pro podporu 9-ti stavove logiky
USE ieee.std_logic_1164.ALL;
--! Zpristupnen balik \c pkg_cmp3way z pracovni knihovny \c work
--! \details Balik obsahuje definici typu \c Cmp3Way_t a dalsi deklarace.
USE work.pkg_cmp3way.ALL;
--! Zpristupnen balik \c pkg_led7seg_def z pracovni knihovny \c work
--! \details Balik obsahuje definici subtypu a konstant pro 7-segmentovy displej.
USE work.pkg_led7seg_def.ALL;

--! \brief Definice entity Led7seg_decoder_cmp3way
ENTITY Led7seg_decoder_cmp3way IS
	PORT(
		cmp:  in Cmp3Way_t;		--! Deklarace vstupu \a cmp s vysledkem trojcestneho porovnani
		en:   in std_logic;		--! Deklarace vstupu povolujiciho zobrazeni na display \a en
		an:   out std_logic_vector(3 downto 0);	--! Deklarace vystupu na display: \a an[3:0]
		seg:  out std_logic_vector(6 downto 0)	--! Deklarace vystupu na display: \a seg[6:0]
		);
END ENTITY Led7seg_decoder_cmp3way;

--! \brief Definice architektury entity Led7seg_decoder_cmp3way
--! \details Zde budou realizovany pozadovane kombinacni funkce pro vystupy na display \a seg a \a an.
ARCHITECTURE Behavioral OF Led7seg_decoder_cmp3way IS
BEGIN
	WITH cmp SELECT
		seg <= segments_less_c    WHEN A_lt_B_c,	-- symbol < pro vysledek (A < B)
		       segments_equal_c   WHEN A_eq_B_c,	-- symbol = pro vysledek (A = B)
		       segments_greater_c WHEN others;	-- symbol > pro vysledek (A > B)

	an <= anodes_1_c when en = '1' else
    anodes_none_c;

END ARCHITECTURE Behavioral;
