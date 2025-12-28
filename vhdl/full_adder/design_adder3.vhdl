--! \file design_adder3.vhdl
--! \brief Definice entity Adder3 a jeji architektury popsane strukturalnim popisem

--! Zavedena standardni knihovna \c IEEE
LIBRARY ieee;
--! Zpristupnen balik \c std_logic_1164 z knihovny \c IEEE pro podporu 9-ti stavove logiky
USE ieee.std_logic_1164.ALL;

--! \brief Definice entity 3-bitove scitacky Adder3
ENTITY Adder3 IS
	--GENERIC(BITS: positive := 3);
    PORT(
		a:   in std_logic_vector(2 downto 0);	--! Deklarace vstupniho vektoru: \a a[2:0]
		b:   in std_logic_vector(2 downto 0);	--! Deklarace vstupniho vektoru: \a b[2:0]
		cin: in std_logic;						--! Deklarace vstupu carry_in: \a cin
		sum: out std_logic_vector(3 downto 0)	--! Deklarace vystupu souctu: \a sum[3:0]
		);
END ENTITY Adder3;

--! \brief Definice strukturalniho popisu architektury entity 3-bitove scitacky: Adder3

ARCHITECTURE Structural OF Adder3 IS

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

	SIGNAL c_i: std_logic_vector(3 DOWNTO 0) := (OTHERS => '0'); --! Vnitrni signal pro ulozeni prenosu
BEGIN

	--! Instanciace komponent Full_adder a jejich propojeni pomoci jmenne asociace

	sum(3) <= c_i(3);
	c_i(0) <= cin;
	fa_generate: FOR n IN 0 TO 2 GENERATE
		fa_n: Full_adder
			PORT MAP(
				a 	 => a(n),
				b    => b(n),
				cin  => c_i(n),
				sum  => sum(n),
				cout => c_i(n+1)
			);
	END GENERATE fa_generate;
END ARCHITECTURE Structural;
