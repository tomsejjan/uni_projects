--! \file design_led7seg_decoder_johnson.vhdl
--! \brief Definice entity Led7seg_decoder_johnson a jeji behavioralni architektury



LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--! Zpristupnen balik \c pkg_led7seg_def z pracovni knihovny \c work
--! \details Balik obsahuje definici subtypu a konstant pro 7-segmentovy displej.
USE work.pkg_led7seg_def.ALL;

--! Zpristupnen balik \c pkg_led7seg_decoders z pracovni knihovny \c work
--! \details Balik obsahuje definici prevodnich funkci pro 7-segmentovy displej.
USE work.pkg_led7seg_decoders.ALL;

--! \brief Entita dekoderu hodnoty v johnsonove kodu na 7-segmentovy displej
ENTITY Led7seg_decoder_johnson IS
	PORT(
		johnson_val: IN  std_logic_vector(2 DOWNTO 0);	--! Port pro vstup hodnoty v johnsonove kodu \a johnson_val[2:0]
		seg        : OUT std_logic_vector(7 DOWNTO 0);	--! Port pro vystup signalu pro segmenty disleje \a seg[7:0]
		an         : OUT std_logic_vector(3 DOWNTO 0)	--! Port pro vystup signalu pro anody disleje \a an[3:0]
		);
END ENTITY Led7seg_decoder_johnson;

--! \brief Architektura dekoderu pro 7-segmentovy displej
--! \details Behavioralni popis architektury dekoderu hodnoty v johnsonove kodu na 7-segmentovy displej vyuzivajici
--!   prevodnich funkci z baliku pkg_led7seg_decoders.
ARCHITECTURE Behavioral OF Led7seg_decoder_johnson IS
BEGIN
	seg <= led7seg_dp_to_segments('0', led7seg_johnson_to_segments(johnson_val)); --fazetová funkce
	an  <= led7seg_pos_to_anodes(pos_1_c, '1');

END ARCHITECTURE Behavioral;
