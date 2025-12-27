--! \file design.vhdl
--! \brief Definice entity Circuit16 a jeji architektury

--! Zavedena standardni knihovna \c IEEE
LIBRARY ieee;
--! Zpristupnen balik \c std_logic_1164 z knihovny \c IEEE pro podporu 9-ti stavove logiky
USE ieee.std_logic_1164.ALL;

--! \brief Definice entity Circuit16
ENTITY Circuit16 IS
	PORT(
		e: IN  std_logic;						--! Deklarace vstupu: \a e
		x: IN  std_logic_vector(3 DOWNTO 0);	--! Deklarace vstupu: \a x[3:0]
		y: OUT std_logic 						--! Deklarace vystupu: \a y
		);
END Circuit16;

--! \brief Definice architektury entity Circuit16
--! \details Zde bude realizovana kombinacni funkce dle tabulky zadani, pomoci prikazu: `WHEN`-`ELSE`.
ARCHITECTURE Behavioral OF Circuit16 IS
	SIGNAL s_i: std_logic_vector(2 DOWNTO 0);	--! \c Mux8_1E select - rizeni vnitrniho prepinace: \c Mux8_1E
	SIGNAL x0_L_i: std_logic;					--! Pomocny vnitrni signal negace signalu \p x(0)
BEGIN
	s_i <= x(3 DOWNTO 1);						-- Mux8_1E select - prirazeni z casti vstupniho vektoru
	x0_L_i <= NOT x(0);							-- Prirazeni do pomocneho vnitrniho signalu negace x(0)

	y <='0' WHEN e ='0' ELSE
    	'0' WHEN s_i = "000" ELSE
    	'1' when s_i = "001" ELSE
        x(0) when s_i ="010" ELSE
        '1' when s_i = "011" ELSE
        '0' when s_i = "100" ELSE
        x0_L_i when s_i = "101" ELSE
        '1' when s_i = "110" ELSE
        x0_L_i ;
END Behavioral;
