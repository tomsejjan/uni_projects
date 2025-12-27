--! \file design_alu2.vhdl
--! \brief Definice entity Alu2 a jeji architektury popsane strukturalnim popisem

--! Zavedena standardni knihovna \c IEEE
LIBRARY ieee;
--! Zpristupnen balik \c std_logic_1164 z knihovny \c IEEE pro podporu 9-ti stavove logiky
USE ieee.std_logic_1164.ALL;

--! \brief Definice entity Alu2
--! \details Vyznam bitu vstupniho portu \a oper[1:0]
--!  - `"00"` => \a A `and` \a B
--!  - `"01"` => \a A `+` \a B
--!  - `"10"` => \a A `-` \a B
--!  - `"11"` => \a B `-` \a A
--!
ENTITY Alu2 IS
	
    PORT(
		a:      in std_logic_vector(1 downto 0);	--! Deklarace vstupniho vektoru: \a a[1:0]
		b:      in std_logic_vector(1 downto 0);	--! Deklarace vstupniho vektoru: \a b[1:0]
		oper:   in std_logic_vector(1 downto 0);	--! Deklarace vstupu definujici typ operace: \a oper[1:0]
		result: inout std_logic_vector(3 downto 0);	--! Deklarace vystupniho vektoru s vysledkem operace: \a result[3:0]
		zero:   out std_logic			--! Deklarace vystupu signalizujiciho nulovy vysledek na \a result[3:0]
		);
END ENTITY Alu2;

--! \brief Definice strukturalniho popisu architektury entity Alu2
--! \details Vyznam bitu vstupniho portu \a oper[1:0]
--!  - `"00"` => \a A `and` \a B
--!  - `"01"` => \a A `+` \a B
--!  - `"10"` => \a A `-` \a B
--!  - `"11"` => \a B `-` \a A
--!

ARCHITECTURE Structural OF Alu2 IS

	--! \brief Deklarace komponenty Full_adder
	COMPONENT Full_adder IS
		PORT(
			a:    in std_logic;				-- Deklarace vstupu: a
			b:    in std_logic;				-- Deklarace vstupu: b
			cin:  in std_logic;				-- Deklarace vstupu: carry in
			sum:  out std_logic;				-- Deklarace vystupu: sum
			cout: out std_logic					-- Deklarace vystupu: carry out
			);
	END COMPONENT Full_adder;

	SIGNAL sa_i, sb_i: std_logic_vector(2 DOWNTO 0) := "000"; --! Vnitrni signaly pro ulozeni rozsirenych signalu a,b
	SIGNAL c_i: std_logic_vector(3 DOWNTO 0) := "0000";		--! Vnitrni signal pro ulozeni prenosu
	SIGNAL res_i: std_logic_vector(3 DOWNTO 0) := "0000";	--! Vnitrni signal pro ulozeni vysledku aritmetickeho vypoctu
BEGIN
    sa_i <= ('1' & NOT a) WHEN oper = "11" ELSE
    		('0' & a);
    
    sb_i <= ('1' & NOT b) WHEN oper = "10" ELSE
    		('0' & b);
    c_i(0) <= oper(1);
    fa_generate: FOR n IN 0 TO 2 GENERATE
    	fa_n: Full_adder PORT MAP(
        	a => sa_i(n),
            b => sb_i(n),
            cin => c_i(n),
            sum => res_i(n),
            cout => c_i(n+1)
        );
    END GENERATE fa_generate;

    zero <= '1' when result = "0000"
    else '0';
    res_i(3) <= res_i(2) WHEN oper(1) = '1' ELSE
    			'0'; --scitani
    result <= "00" & (a AND b) WHEN oper = "00" ELSE 
              res_i; 
END ARCHITECTURE Structural;
