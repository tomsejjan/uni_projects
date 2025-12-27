--! \file design_counter_johnson.vhdl
--! \brief Definice entity Counter_johnson a jeji behavioralni architektury


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--! \brief Entita johnsonova citace
ENTITY Counter_johnson IS
	PORT(
		clk : in std_logic;						--! Port pro vstup hodinoveho signalu \a clk
		ce  : in std_logic;						--  ce – pro ukončení počítání
		arst: in std_logic;						--! Port pro vstup signalu asynchronni reset \a arst
		q   : out std_logic_vector(2 downto 0)		--! Port pro vystup hodnoty johnsonova citace \a q[2:0]
		);
END ENTITY Counter_johnson;

--! \brief Behavioralni architektura entity johnsonova citace
ARCHITECTURE Behavioral OF Counter_johnson IS
	SIGNAL q_i: std_logic_vector(2 DOWNTO 0) := (OTHERS => '0');	--! Vnitrni hodnota johnsonova citace
BEGIN
	--! Process zajistujici inkrementaci hodnoty johnsonova citace \p q_i a jeji nulovani po prichodu aktivni urovne na portu \a arst.
	--! \vhdlflow Tento diagram zobrazuje jednotlive kroky procesu inkrementace hodnoty johnsonova citace a jeji nulovani pri aktivnim portu \a arst.
	johnson_proc: PROCESS(clk, arst)--, ce) citlivostní seznam určuje, kdy se má spustit proces! Nepatří tam ce, protože nejdříve zkontroluji ten arst a clk, a pak měním nebo nemění ce
	BEGIN
	--! \todo Doplnte telo procesu: `johnson_proc`.
    IF arst = '1' THEN
    	q_i <= (OTHERS => '0');
    	ELSIF rising_edge(clk) THEN
    	
    		IF ce = '1' THEN
    	    	q_i <= q_i(1 DOWNTO 0) & NOT(q_i(2));
    	    END IF;
    	END IF;
	END PROCESS;

	q <= q_i;

END ARCHITECTURE Behavioral;
