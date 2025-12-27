--! \file design_comparator_g.vhdl
--! \brief Definition of the entity Comparator_g and its RTL architecture which simulates real impact of the transport delay on the output signal


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--! \brief Generic entity of comparator with result of comparation of vectors \a a < \a b
ENTITY Comparator_g IS
	GENERIC(
		BITS: positive			--! Generic parameter declaring width of the compared input vectors \a a, \a b
		);
	PORT(
		a  : IN  std_logic_vector(BITS-1 DOWNTO 0);	--! Port for input vector \a a[BITS-1:0]
		b  : IN  std_logic_vector(BITS-1 DOWNTO 0);	--! Port for input vector \a b[BITS-1:0]
		cmp: OUT std_logic							--! Port for the comparation result \a a < \a b
		);
END ENTITY Comparator_g;

--! \brief RTL architecture of generic entity of comparator with result of comparation of vectors \a a < \a b
--! \details RTL architektura genericke entity of comparator with result of comparation of vectors \a a < \a b, which simulates real impact of the transport delay on the output signal \p cmp.
ARCHITECTURE RTL OF Comparator_g IS
	SIGNAL cmp_i: std_logic_vector(BITS DOWNTO 0) := (OTHERS => '0');	--! Internal vector for storing temporary terms while calculation
	CONSTANT cmp_delay_c: delay_length := 10 ns;	--! Value defined for simulation of the transport delay while calculation
BEGIN
	cmp_i(0) <= '0';	-- '0' means: (a < b), '1' means (a <= b).
	comp: FOR i IN 0 TO BITS-1 GENERATE
		cmp_i(i + 1) <= TRANSPORT ( ( a(i) XNOR b(i) ) AND cmp_i(i) ) OR ( NOT a(i) AND b(i) )
		                AFTER cmp_delay_c;	-- DO NOT ERASE: intentional transport delay (due to the comparation computing)
	END GENERATE comp;

	cmp <= cmp_i(BITS);
END ARCHITECTURE RTL;
