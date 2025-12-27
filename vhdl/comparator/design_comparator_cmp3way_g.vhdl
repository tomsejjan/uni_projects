--! \file design_comparator_cmp3way_g.vhdl
--! \brief Definice genericke entity Comparator_cmp3way_g a jeji architektury

--! Zavedena standardni knihovna \c IEEE
LIBRARY ieee;
--! Zpristupnen balik \c std_logic_1164 z knihovny \c IEEE pro podporu 9-ti stavove logiky
USE ieee.std_logic_1164.ALL;
--! Zpristupnen balik \c pkg_cmp3way z pracovni knihovny \c work
--! \details Balik obsahuje definici typu \c Cmp3Way_t a dalsi deklarace.
USE work.pkg_cmp3way.ALL;

--! \brief Definice genericke entity Comparator_cmp3way_g
ENTITY Comparator_cmp3way_g IS
	GENERIC(
		BITS: positive := 4								--! Genericky parametr definujici sirku porovnavanych vstupnich vektoru \a a, \a b
		);
	PORT(
		a:   in std_logic_vector(bits-1 downto 0);	--! Deklarace vstupniho vektoru: \a a[BITS-1:0]
		b:   in std_logic_vector(bits-1 downto 0);	--! Deklarace vstupniho vektoru: \a b[BITS-1:0]
		cmp: out Cmp3Way_t;		--! Deklarace vystupu s vysledkem trojcestneho porovnani vektoru \a a, \a b	
        compare: out std_logic_vector(1 downto 0);
		);
END ENTITY Comparator_cmp3way_g;

--! \brief Definice architektury genericke entity Comparator_cmp3way_g
--! \details Zde budou realizovany pozadovane kombinacni funkce pro vystup \a cmp.
ARCHITECTURE Behavioral OF Comparator_cmp3way_g IS
BEGIN
	--SIGNAL compare_i: std_logic_vector(1 downto 0) := (OTHERS => '0');
   cmp <= 	A_eq_B_c when(a = b) else
   			A_lt_B_c when(a < b) else
   			A_gt_B_c ;
   

   -- compare <= 	"00" when cmp = A_eq_B_c else
   -- 	 		"01" when cmp = A_lt_B_c else
   --     		"10";
   
   compare <= 	"00" when (a = b) else
    	 		"01" when (a < b) else
        		"10";
                
    
END ARCHITECTURE Behavioral;
