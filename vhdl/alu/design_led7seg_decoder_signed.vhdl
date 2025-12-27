--! \file design_led7seg_decoder_signed.vhdl
--! \brief Definice entity Led7seg_decoder_signed a jeji architektury modifikaci lab ulohy c.3 - ukol c. 5

--! Zavedena standardni knihovna \c IEEE
LIBRARY ieee;
--! Zpristupnen balik \c std_logic_1164 z knihovny \c IEEE pro podporu 9-ti stavove logiky
USE ieee.std_logic_1164.ALL;
--! Zpristupnen balik \c pkg_led7seg_def z pracovni knihovny \c work
--! \details Balik obsahuje definici subtypu a konstant pro 7-segmentovy displej.
USE work.pkg_led7seg_def.ALL;

--! \brief Definice entity Led7seg_decoder_signed
ENTITY Led7seg_decoder_signed IS
	PORT(
		x:   in std_logic_vector(3 downto 0);	--! Deklarace datovych vstupu: \a x[3:0]
		an:  out std_logic_vector(3 downto 0);	--! Deklarace vystupu na display: \a an[3:0]
		seg: out std_logic_vector(7 downto 0)	--! Deklarace vystupu na display: \a seg[7:0]
		);
END Led7seg_decoder_signed;

--! \brief Definice architektury entity Led7seg_decoder_signed
--!   Entita bude zobrazovat znamenkova cisla s vyuzitim radove carky jako symbolu pro zaporna cisla.
ARCHITECTURE Behavioral OF Led7seg_decoder_signed IS
BEGIN
	an <= anodes_1_c;
	with x select
    	seg <= (dp_off_c & segments_0_c ) when X"0",
    	(dp_off_c & segments_1_c ) when X"1",
    	(dp_off_c & segments_2_c ) when X"2",
        (dp_off_c & segments_3_c ) when X"3",
        (dp_off_c & segments_4_c ) when X"4",
        (dp_off_c & segments_5_c ) when X"5",
        (dp_off_c & segments_6_c ) when X"6",
        (dp_off_c & segments_7_c ) when X"7",
        (dp_off_c & segments_8_c ) when X"8",
        (dp_on_c & segments_7_c ) when X"9",
        (dp_on_c & segments_6_c) when X"A",
        (dp_on_c & segments_5_c) when X"B",
        (dp_on_c & segments_4_c) when X"C",
        (dp_on_c & segments_3_c) when X"D",
        (dp_on_c & segments_2_c) when X"E",
        (dp_on_c & segments_1_c) when X"F",
        (dp_off_c & segments_none_c ) when others;
END Behavioral;
