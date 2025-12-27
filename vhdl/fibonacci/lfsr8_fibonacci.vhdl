LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! \brief Entita posuvneho registru s linearni zpetnou vazbou - LFSR
--! \todo Doplnte chybejici casti definice portu entity Lfsr8_fibonacci
ENTITY Lfsr8_fibonacci IS
	PORT(
		clk : in std_logic;					--! Port pro vstup hodinoveho signalu \a clk
		ce  : in std_logic;					--! Port pro vstup signalu povolujiciho citani \a ce
		arst: in std_logic;					--! Port pro vstup signalu asynchronni reset \a arst
		q   : out std_logic_vector(7 downto 0)				--! Port pro vystup hodnoty LFSR \a q[7:0]
		);
END ENTITY Lfsr8_fibonacci;

--! \brief Behavioralni architektura entity posuvneho registru s linearni zpetnou vazbou - LFSR
--! \details Posuvny registr s linearni zpetnou vazbou typu fibonacci vyuzivajici polynom: x^8 + x^6 + x^5 + x^4 + 1
ARCHITECTURE Behavioral OF Lfsr8_fibonacci IS
	SIGNAL q_i: std_logic_vector(7 DOWNTO 0) := (OTHERS => '1');		--! Vnitrni hodnota LFSR
BEGIN
	--! Process zajistujici vypocet nove hodnoty LFSR \p q_i a jeji nulovani po prichodu aktivni urovne na portu \a arst.
	--! \vhdlflow Tento diagram zobrazuje jednotlive kroky procesu vypoctu nove hodnoty  a jeji nulovani pri aktivnim portu \a arst.
	--! \todo Promyslete si predem, ktery signal (nebo signaly) musi byt soucasti citlivostniho seznamu procesu: `lfsr_proc`.
	lfsr_proc: PROCESS(clk,arst)
	BEGIN
	--! \todo Doplnte telo procesu: `lfsr_proc`
    	if arst = '1' THEN
    		q_i <= (OTHERS => '1');
    	ELSIF rising_edge(clk) then
    		if ce = '1' then
        		q_i <= q_i(6 downto 0) & (q_i(7) XOR q_i(5) XOR q_i(4) XOR q_i(3));
            END IF;
        END IF;    
	END PROCESS;
	q <= q_i;

END ARCHITECTURE Behavioral;