--! \file pkg_bpc_los.vhdl
--! \brief BPC-LOS vizualizacni knihovna
--! \details BPC-LOS vizualizacni knihovna HW pro laboratorni ulohy
--! \version 1.9
--! \author Petyovsky (petyovsky@vut.cz)
--! \note Due to Mike/ZT now compatible with GHDL. Kudos to you bro. :-)

--! Zavedena standardni knihovna \c IEEE
LIBRARY ieee;
--! Zpristupnen balik \c std_logic_1164 z knihovny \c IEEE pro podporu 9-ti stavove logiky
USE ieee.std_logic_1164.ALL;
--! Zpristupnen balik \c numeric_std z knihovny \c IEEE pro podporu konverze cisel dle IEEE 1076.3
USE ieee.numeric_std.ALL;
--! Zpristupnen balik \c textio z knihovny \c std pro podporu prace s konzolou a soubory
USE std.textio.ALL;

--! \brief Definice rozhrani baliku BPC-LOS vizualizacni knihovny
PACKAGE pkg_bpc_los IS

	--! \brief Vizualizace stavu LED 7-0
	--! \details Procedura pro vizualizaci stavu LED 7-0 na konzolu simulacniho prostredi.
	--! \param[in] led Vektor[7:0] se vstupy pro jednotlive LED.
	PROCEDURE ledbar8_show(						-- Vizualizace LED 7-0
		led: IN std_logic_vector(7 DOWNTO 0)	-- Deklarace vstupu: led[7:0]
		);

	--! \brief Vizualizace stavu LED 15-0
	--! \details Procedura pro vizualizaci stavu LED 15-0 na konzolu simulacniho prostredi.
	--! \param[in] led Vektor[15:0] se vstupy pro jednotlive LED.
	PROCEDURE ledbar16_show(					-- Vizualizace LED 15-0
		led: IN std_logic_vector(15 DOWNTO 0)	-- Deklarace vstupu: led[15:0]
		);

	--! \brief Vizualizace stavu vsech segmentu displeje (mala)
	--! \details Procedura pro malou vizualizaci stavu vsech LED segmentu displeje na konzolu simulacniho prostredi.
	--! \param[in] an Vektor[3:0] se vstupy pro jednotlive anody.
	--! \param[in] seg Vektor[6:0] se vstupy pro jednotlive katody segmentu.
	--! \param[in] dp Vstup pro katodu segmentu desetinna tecka.
	PROCEDURE led7seg_show(						-- Vizualizace 4x led7segment
		an:  IN std_logic_vector(3 DOWNTO 0);	-- Deklarace vstupu: an[3:0]
		seg: IN std_logic_vector(6 DOWNTO 0);	-- Deklarace vstupu: seg[6:0]
		dp:  IN std_logic := '1'				-- Deklarace vstupu: dp
		);

	--! \brief Vizualizace stavu vsech segmentu displeje (velka)
	--! \details Procedura pro velkou vizualizaci stavu vsech LED segmentu displeje na konzolu simulacniho prostredi.
	--! \param[in] an Vektor[3:0] se vstupy pro jednotlive anody.
	--! \param[in] seg Vektor[6:0] se vstupy pro jednotlive katody segmentu.
	--! \param[in] dp Vstup pro katodu segmentu desetinna tecka.
	PROCEDURE led7seg_show_big(					-- Velka vizualizace 4x led7segment
		an:  IN std_logic_vector(3 DOWNTO 0);	-- Deklarace vstupu: an[3:0]
		seg: IN std_logic_vector(6 DOWNTO 0);	-- Deklarace vstupu: seg[6:0]
		dp:  IN std_logic := '1'				-- Deklarace vstupu: dp
		);

END PACKAGE pkg_bpc_los;

--! \brief Definice implementace baliku BPC-LOS vizualizacni knihovny
PACKAGE BODY pkg_bpc_los IS

	PROCEDURE ledbar8_show(						-- Vizualizace LED 7-0
		led: IN std_logic_vector(7 DOWNTO 0)	-- Deklarace vstupu: led[7:0]
		)
	IS

		TYPE LedSegments_t IS ARRAY (natural RANGE <>) OF string(1 TO 1);
		CONSTANT ls: LedSegments_t(0 TO 1) := (" ", string'(1 => character'val(16#A4#)));

		VARIABLE ll: line;

	BEGIN
		FOR i IN led'range LOOP
			write(ll, "[" & ls(to_integer(unsigned(std_logic_vector'("0") & led(i) ))) & "]");
		END LOOP;
		writeline(OUTPUT, ll);
	END PROCEDURE ledbar8_show;

	PROCEDURE ledbar16_show(					-- Vizualizace LED 15-0
		led: IN std_logic_vector(15 DOWNTO 0)	-- Deklarace vstupu: led[15:0]
		)
	IS

		TYPE LedSegments_t IS ARRAY (natural RANGE <>) OF string(1 TO 1);
		CONSTANT ls: LedSegments_t(0 TO 1) := (" ", string'(1 => character'val(16#A4#)));

		VARIABLE ll: line;

	BEGIN
		FOR i IN led'range LOOP
			write(ll, "[" & ls(to_integer(unsigned(std_logic_vector'("0") & led(i) ))) & "]");
		END LOOP;
		writeline(OUTPUT, ll);
	END PROCEDURE ledbar16_show;

	--! \details Datovy typ reprezentujici vektor integer cisel.
	TYPE integer_vector IS ARRAY (natural RANGE <>) OF integer;		-- VHDL-2008 jiz ma tento typ preddefinovan

	--! \brief Konverze vektoru \c std_logic_vector na vektor hodnot typu \c integer
	--! \details Interni funkce pro konverzi vektoru \c std_logic_vector na vektor hodnot typu \c integer o stejnem poctu prvku. Vyuzito v: led7seg_show() a led7seg_show_big()
	--! \param[in] a Vstupni hodnota typu \c std_logic_vector
	--! \return Vraci vektor hodnot typu integer o stejnem poctu prvku jako ma vstupni vektor \p a.
	FUNCTION to_integer_vector(						-- Konverze vektoru std_logic_vector na vektor hodnot typu integer
		a: std_logic_vector							-- Vstupni hodnota typu std_logic_vector
		)
	RETURN integer_vector IS

		VARIABLE result: integer_vector(a'range);
	BEGIN
		FOR i IN a'range LOOP
			result(i) := to_integer(unsigned(std_logic_vector'("0") & a(i)));
		END LOOP;
		RETURN result;
	END FUNCTION to_integer_vector;

	PROCEDURE led7seg_show(							-- Vizualizace 4x led7segment
			an:  IN std_logic_vector(3 DOWNTO 0);	-- Deklarace vstupu: an[3:0]
			seg: IN std_logic_vector(6 DOWNTO 0);	-- Deklarace vstupu: seg[6:0]
			dp:  IN std_logic := '1'				-- Deklarace vstupu: dp
			)
	IS

		TYPE HorizontalSegments_t IS ARRAY (natural RANGE <>) OF string(1 TO 1);
		CONSTANT hs: HorizontalSegments_t(0 TO 1) := ("_", " ");

		TYPE VerticalSegments_t IS ARRAY (natural RANGE <>) OF string(1 TO 1);
		CONSTANT vs: VerticalSegments_t(0 TO 1) := ("|", " ");

		TYPE PointSegments_t IS ARRAY (natural RANGE <>) OF string(1 TO 1);
		CONSTANT ps: PointSegments_t(0 TO 1) := (",", " ");

		TYPE DisplayLanes_t IS ARRAY (natural RANGE <>) OF line;
		VARIABLE dl: DisplayLanes_t(0 TO 2);

		VARIABLE p, g, f, e, d, c, b, a: integer;

	BEGIN
		(p, g, f, e, d, c, b, a) := to_integer_vector(dp & seg);

		FOR i IN an'range LOOP
			IF(an(i) = '0') THEN
				write(dl(0), " "   & hs(a) & " "   & " "   & " ");
				write(dl(1), vs(f) & hs(g) & vs(b) & " "   & " ");
				write(dl(2), vs(e) & hs(d) & vs(c) & ps(p) & " ");
			ELSE
				FOR j IN dl'range LOOP
					write(dl(j), string'("     "));
				END LOOP;
			END IF;
		END LOOP;

		FOR i IN dl'range LOOP
			writeline(OUTPUT, dl(i));
		END LOOP;

	END PROCEDURE led7seg_show;

	PROCEDURE led7seg_show_big(					-- Velka vizualizace 4x led7segment
		an:  IN std_logic_vector(3 DOWNTO 0);	-- Deklarace vstupu: an[3:0]
		seg: IN std_logic_vector(6 DOWNTO 0);	-- Deklarace vstupu: seg[6:0]
		dp:  IN std_logic := '1'				-- Deklarace vstupu: dp
		)
	IS

		TYPE HorizontalSegments_t IS ARRAY (natural RANGE <>) OF string(1 TO 5);
		CONSTANT hs: HorizontalSegments_t(0 TO 1) := (" ~~~ ", "     ");

		TYPE VerticalSegments_t IS ARRAY (natural RANGE <>) OF string(1 TO 1);
		CONSTANT vs: VerticalSegments_t(0 TO 1) := ("|", " ");

		TYPE PointSegments_t IS ARRAY (natural RANGE <>) OF string(1 TO 1);
		CONSTANT ps: PointSegments_t(0 TO 1) := ("o", " ");

		TYPE DisplayLanes_t IS ARRAY (natural RANGE <>) OF line;
		VARIABLE dl: DisplayLanes_t(0 TO 6);

		VARIABLE p, g, f, e, d, c, b, a: integer;

	BEGIN
		(p, g, f, e, d, c, b, a) := to_integer_vector(dp & seg);

		FOR i IN an'range LOOP
			IF(an(i) = '0') THEN
				write(dl(0),         hs(a)         & " "   & " ");
				write(dl(1), vs(f) & "   " & vs(b) & " "   & " ");
				write(dl(2), vs(f) & "   " & vs(b) & " "   & " ");
				write(dl(3),         hs(g)         & " "   & " ");
				write(dl(4), vs(e) & "   " & vs(c) & " "   & " ");
				write(dl(5), vs(e) & "   " & vs(c) & " "   & " ");
				write(dl(6),         hs(d)         & ps(p) & " ");
			ELSE
				FOR j IN dl'range LOOP
					write(dl(j), string'("      "));
				END LOOP;
			END IF;
		END LOOP;

		FOR i IN dl'range LOOP
			writeline(OUTPUT, dl(i));
		END LOOP;

		writeline(OUTPUT, dl(0));	-- Tisk nyni jiz prazdneho retezce dl(0) vytiskne novy radek (viz. 5.3.2.2 IEEE Std 1076-2008 16.4 Package TEXTIO)
	END PROCEDURE led7seg_show_big;

END PACKAGE BODY pkg_bpc_los;
