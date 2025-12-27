--! \file pkg_led7seg_decoders.vhdl
--! \brief Definice prevodnich funkci pro segmenty i anody 7-segmentoveho displeje na kitu NEXYS3/BASYS3

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.numeric_std.ALL;

--! Zpristupnen balik \c pkg_led7seg_def z pracovni knihovny \c work
--! \details Balik obsahuje definici subtypu a konstant pro 7-segmentovy displej na kitu NEXYS3/BASYS3.
USE work.pkg_led7seg_def.ALL;

--! \brief Balik definuje prevodni funkce pro 7-segmentovy displej
--! \details Balik obsahuje definice prevodnich funkci pro 7-segmentovy displej, ktere budeme vyuzivat.
PACKAGE pkg_led7seg_decoders IS

	--! \brief Funkce pro prevod hodnoty pozadovane pozice na vektor anod pro 7-segmentovy displej
	--! \details Funkce prevadi vstupni vektor [1:0] s hodnotou pozadovane pozice na vektor anod pro 7-segmentovy displej.
	--! \param[in] pos_val Vstupni vektor [1:0] s hodnotou pozadovane pozice na displeji: \b pos_1_c ... \b pos_1000_c.
	--! \param[in] enable Vstupni hodnota urcujici, zda ma byt dana pozice zobrazena.
	--! \return Vraci vektor [3:0] hodnot typu \c std_logic_vector pro pripojeni na jednotlive anody 7-segmentovy displeje.
	FUNCTION led7seg_pos_to_anodes(
		pos_val: IN std_logic_vector(1 DOWNTO 0);
		enable:  IN std_logic
		)
	RETURN std_logic_vector;

	--! \brief Funkce pro prevod znamenkove hodnoty v kodu druheho doplnku na symbol pro 7-segmentovy displej
	--! \details Funkce prevadi vstupni vektor [3:0] s hodnotou v kodu druheho doplnku na symboly (-8 ... 7) pro 7-segmentovy displej.
	--! \param[in] signed_val Vstupni vektor [3:0] se znamenkovou hodnotou v kodu druheho doplnku.
	--! \return Vraci vektor [7:0] hodnot typu \c std_logic_vector pro pripojeni na jednotlive segmenty displeje vcetne segmentu radove carky.
	FUNCTION led7seg_signed_to_segments(
		signed_val: IN std_logic_vector(3 DOWNTO 0)
		)
	RETURN std_logic_vector;

	--! \brief Funkce pro prevod hodnoty v johnsonove kodu na symbol pro 7-segmentovy displej
	--! \details Funkce prevadi vstupni vektor [2:0] s hodnotou v johnsonove kodu na symboly (1 ... 6) pro 7-segmentovy displej.
	--! \param[in] johnson_val Vstupni vektor [2:0] s hodnotou v johnsonove kodu.
	--! \return Vraci vektor [6:0] hodnot typu \c std_logic_vector pro pripojeni na jednotlive segmenty displeje.
	FUNCTION led7seg_johnson_to_segments(
		johnson_val: IN std_logic_vector(2 DOWNTO 0)
		)
	RETURN std_logic_vector;

	--! \brief Funkce pro prevod hodnoty v BCD kodu na symbol pro 7-segmentovy displej
	--! \details Funkce prevadi vstupni vektor [3:0] s hodnotou v BCD kodu na symboly (0 ... 9) pro 7-segmentovy displej.
	--! \param[in] bcd_val Vstupni vektor [3:0] s hodnotou v BCD kodu.
	--! \return Vraci vektor [6:0] hodnot typu \c std_logic_vector pro pripojeni na jednotlive segmenty displeje.
	FUNCTION led7seg_bcd_to_segments(
		bcd_val: IN std_logic_vector(3 DOWNTO 0)
		)
	RETURN std_logic_vector;

	--! \brief Funkce pro prevod neznamenkove hodnoty v binarnim kodu na symbol pro 7-segmentovy displej
	--! \details Funkce prevadi vstupni vektor [3:0] s hodnotou v binarnim kodu na symboly (0 ... F) pro 7-segmentovy displej.
	--! \param[in] hex_val Vstupni vektor [3:0] s neznamenkovou hodnotou v binarnim kodu.
	--! \return Vraci vektor [6:0] hodnot typu \c std_logic_vector pro pripojeni na jednotlive segmenty displeje.
	FUNCTION led7seg_hex_to_segments(
		hex_val: IN std_logic_vector(3 DOWNTO 0)
		)
	RETURN std_logic_vector;

	--! \brief Fazetova funkce pro vypocet hodnoty segmentu radove carky
	--! \details Fazetova funkce pro vypocet hodnoty pro segment radove carky a jeji doplneni k hodnote ostatnich segmentu.
	--! \param[in] dp Pokud je '1' segment radove carky ma byt aktivni.
	--! \param[in] digit_segments Vektor [6:0] hodnot typu \c std_logic_vector s hodnotou jednotlivych ciselnych segmentu displeje.
	--! \return Vraci vektor [7:0] hodnot typu \c std_logic_vector pro pripojeni na jednotlive segmenty displeje.
	FUNCTION led7seg_dp_to_segments(
		dp:             IN std_logic;
		digit_segments: IN Segments_t := segments_none_c
		)
	RETURN std_logic_vector;

END pkg_led7seg_decoders;

--! \brief Telo baliku prevodnich funkci pro 7-segmentovy displej
PACKAGE BODY pkg_led7seg_decoders IS

	FUNCTION led7seg_pos_to_anodes(
		pos_val: IN std_logic_vector(1 DOWNTO 0);
		enable:  IN std_logic
		)
	RETURN std_logic_vector IS
		VARIABLE anodes_v: Anodes_t := anodes_none_c;
	BEGIN
		CASE (enable & pos_val) IS
			WHEN '1' & pos_1_c   => anodes_v := anodes_1_c;
			WHEN '1' & pos_10_c   => anodes_v := anodes_10_c;
            WHEN '1' & pos_100_c  => anodes_v := anodes_100_c;
            WHEN '1' & pos_1000_c => anodes_v := anodes_1000_c;
			WHEN OTHERS           => anodes_v := anodes_none_c;
		END CASE;

		RETURN anodes_v;
	END FUNCTION led7seg_pos_to_anodes;


	FUNCTION led7seg_signed_to_segments(
		signed_val: IN std_logic_vector(3 DOWNTO 0)
		)
	RETURN std_logic_vector IS
		VARIABLE segments_v: std_logic_vector(7 DOWNTO 0) := dp_off_c & segments_none_c;
	BEGIN
		CASE signed_val IS
			WHEN X"8"   => segments_v := dp_on_c  & segments_8_c;
			WHEN X"F"	=> segments_v := dp_on_c  & segments_1_c;
            WHEN X"E"	=> segments_v := dp_on_c  & segments_2_c;
            WHEN X"D"	=> segments_v := dp_on_c  & segments_3_c;
            WHEN X"C"	=> segments_v := dp_on_c  & segments_4_c;
            WHEN X"B"	=> segments_v := dp_on_c  & segments_5_c;
            WHEN X"A"	=> segments_v := dp_on_c  & segments_6_c;
            WHEN X"9"	=> segments_v := dp_on_c  & segments_7_c;
            
			WHEN OTHERS => segments_v := dp_off_c & segments_minus_c;
		END CASE;

		RETURN segments_v;
	END FUNCTION led7seg_signed_to_segments;


	FUNCTION led7seg_johnson_to_segments(
		johnson_val: IN std_logic_vector(2 DOWNTO 0)
		)
	RETURN std_logic_vector IS
		VARIABLE segments_v: Segments_t := segments_none_c;
	BEGIN
		CASE johnson_val IS
			WHEN "000"  => segments_v := segments_1_c;
			WHEN "001"  => segments_v := segments_2_c;
            WHEN "011"  => segments_v := segments_3_c;
            WHEN "111"  => segments_v := segments_4_c;
            WHEN "110"  => segments_v := segments_5_c;
            WHEN "100"  => segments_v := segments_6_c;
			WHEN OTHERS => segments_v := segments_minus_c;
		END CASE;

		RETURN segments_v;
	END FUNCTION led7seg_johnson_to_segments;


	FUNCTION led7seg_bcd_to_segments(
		bcd_val: IN std_logic_vector(3 DOWNTO 0)
		)
	RETURN std_logic_vector IS
		VARIABLE segments_v: Segments_t := segments_none_c;
	BEGIN
		CASE bcd_val IS
			WHEN X"0"   => segments_v := segments_0_c;
			WHEN X"1"	=> segments_v := segments_1_c;
            WHEN X"2"	=> segments_v := segments_2_c;
            WHEN X"3"	=> segments_v := segments_3_c;
            WHEN X"4"	=> segments_v := segments_4_c;
            WHEN X"5"	=> segments_v := segments_5_c;
            WHEN X"6"	=> segments_v := segments_6_c;
            WHEN X"7"	=> segments_v := segments_7_c;
            WHEN X"8"	=> segments_v := segments_8_c;
            WHEN X"9"	=> segments_v := segments_9_c;
			WHEN OTHERS => segments_v := segments_minus_c;
		END CASE;

		RETURN segments_v;
	END FUNCTION led7seg_bcd_to_segments;


	FUNCTION led7seg_hex_to_segments(
		hex_val: IN std_logic_vector(3 DOWNTO 0)
		)
	RETURN std_logic_vector IS
		VARIABLE segments_v: Segments_t := segments_none_c;
	BEGIN
		CASE hex_val IS
			WHEN X"0"   => segments_v := segments_0_c;
			WHEN X"1"   => segments_v := segments_1_c;
            WHEN X"2"   => segments_v := segments_2_c;
            WHEN X"3"   => segments_v := segments_3_c;
            WHEN X"4"   => segments_v := segments_4_c;
            WHEN X"5"   => segments_v := segments_5_c;
			WHEN X"6"   => segments_v := segments_6_c;
            WHEN X"7"   => segments_v := segments_7_c;
            WHEN X"8"   => segments_v := segments_8_c;
            WHEN X"9"   => segments_v := segments_9_c;
            WHEN X"A"   => segments_v := segments_A_c;
            WHEN X"B"   => segments_v := segments_B_c;
            WHEN X"C"   => segments_v := segments_C_c;
            WHEN X"D"   => segments_v := segments_D_c;
            WHEN X"E"   => segments_v := segments_E_c;
            WHEN X"F"   => segments_v := segments_F_c;
            WHEN OTHERS => segments_v := segments_minus_c;
		END CASE;

		RETURN segments_v;
	END FUNCTION led7seg_hex_to_segments;


	FUNCTION led7seg_dp_to_segments(
		dp:             IN std_logic;
		digit_segments: IN Segments_t := segments_none_c
		)
	RETURN std_logic_vector IS
		VARIABLE dp_segment_v: std_logic := dp_off_c;
	BEGIN
		IF dp = '1' THEN
			dp_segment_v := dp_on_c;
        ELSE
        	dp_segment_v := dp_off_c;
		END IF;

		RETURN dp_segment_v & digit_segments;
	END FUNCTION led7seg_dp_to_segments;

END pkg_led7seg_decoders;

