--! \file pkg_cmp3way.vhdl
--! \brief Zdrojovy soubor baliku pro podporu trojcestneho porovnani

--! Zavedena standardni knihovna \c IEEE
LIBRARY ieee;
--! Zpristupnen balik \c std_logic_1164 z knihovny \c IEEE pro podporu 9-ti stavove logiky
USE ieee.std_logic_1164.ALL;

--! \brief Definice baliku pro podporu trojcestneho porovnani
--! \details Balik obsahuje definici typu \c Cmp3Way_t a deklaraci komponent: Comparator_cmp3way_g a Led7seg_decoder_cmp3way.
PACKAGE pkg_cmp3way IS

	--! \brief Definice vyctoveho typu reprezentujiciho vysledek trojcestneho porovnani: `(A < B)`, `(A = B)`, `(A > B)`
	--! \details \li `(A < B)` - **A_lt_B_c** - `A` less than `B`,
	--! \details \li `(A = B)` - **A_eq_B_c** - `A` equal to `B`,
	--! \details \li `(A > B)` - **A_gt_B_c** - `A` greater than `B`.
	
    TYPE Cmp3Way_t IS (
		A_lt_B_c,		-- (A < B): A less than B
		A_eq_B_c,		-- (A = B): A equal to B
		A_gt_B_c		-- (A > B): A greater than B
		);

	-- Dalsi varianta, jak by bylo mozne tento typ nadefinovat
	--SUBTYPE Cmp3Way_t IS integer RANGE -1 TO 1;
	--CONSTANT A_lt_B_c: Cmp3Way_t := -1;		-- (A < B): A less than B
	--CONSTANT A_eq_B_c: Cmp3Way_t :=  0;		-- (A = B): A equal to B
	--CONSTANT A_gt_B_c: Cmp3Way_t := +1;		-- (A > B): A greater than B

	--! \brief Deklarace genericke komponenty Comparator_cmp3way_g
	COMPONENT Comparator_cmp3way_g IS
		GENERIC(
			BITS: positive := 4								--! Genericky parametr definujici sirku porovnavanych vstupnich vektoru: a, b
			);
		PORT(
			a:   in std_logic_vector(bits-1 downto 0);		--! Deklarace vstupniho vektoru: a[BITS-1:0]
			b:   in std_logic_vector(bits-1 downto 0);		--! Deklarace vstupniho vektoru: b[BITS-1:0]
			cmp: out Cmp3Way_t;								--! Deklarace vystupu s vysledkem trojcestneho porovnani vektoru: a, b
            compare: out std_logic_vector(1 downto 0);
			);
	END COMPONENT Comparator_cmp3way_g;

	--! \brief Deklarace komponenty Led7seg_decoder_cmp3way
	COMPONENT Led7seg_decoder_cmp3way IS
		PORT(
			cmp:  in Cmp3Way_t;							--! Deklarace vstupu s vysledkem trojcestneho porovnani
			en:  in std_logic;							--! Deklarace vstupu povolujiciho zobrazeni na display: en
			an:  out std_logic_vector(3 downto 0);		--! Deklarace vystupu na display: an[3:0]
			seg: out std_logic_vector(6 downto 0)		--! Deklarace vystupu na display: seg[6:0]
			);
	END COMPONENT Led7seg_decoder_cmp3way;

END PACKAGE pkg_cmp3way;
