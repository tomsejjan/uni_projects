--! \file design_register_synch_load_ce_g.vhdl
--! \brief Definice genericke entity Register_synch_load_ce_g a jeji behavioralni architektury

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! \brief Genericka entita synchronniho registru se vstupy \a ce a \a load. Sirka vstupnich dat je \a BITS
ENTITY Register_synch_load_ce_g IS
	GENERIC(
		BITS: positive			--! Genericky parametr definujici sirku vystupniho vektoru \a q[BITS-1:0]
		);
	PORT(
		clk : in std_logic;							--! Port pro vstup hodinoveho signalu \a clk
		ce  : in std_logic;							--! Port pro vstup signalu povolujiciho hodinovy signal \a ce
		load: in std_logic;							--! Port pro vstup signalu synchronni load \a load
		d   : in std_logic_vector(BITS-1 downto 0);						--! Port pro vstup vektoru dat \a d[BITS-1:0] pro synchronni load
		q   : out std_logic_vector(BITS-1 downto 0)						--! Port pro vystup hodnoty vektoru \a q[BITS-1:0]
		);
END ENTITY Register_synch_load_ce_g;

--! \brief Behavioralni architektura entity synchronniho registru se vstupem load a sirkou vstupnich dat BITS
ARCHITECTURE Behavioral OF Register_synch_load_ce_g IS
	SIGNAL q_i: std_logic_vector(d'range) := (OTHERS => '0'); 	--! Vnitrni hodnota v registru
BEGIN
	--! Proces zajistujici archivaci hodnoty `d`, pokud plati, ze `load = 1`, `ce = 1` a detekujeme nastupnou hranu na hodinovem signalu `clk`.
	--! \vhdlflow Tento diagram zobrazuje jednotlive podminky a postupne kroky procesu archivace nove hodnoty v registru
	reg_proc: PROCESS(clk)
	BEGIN
		IF rising_edge(clk) THEN
       		IF load = '1' THEN
            	IF ce = '1' THEN
                	q_i <= d;
                END IF;
            END IF;
        END IF;
    END PROCESS reg_proc;
	q <= q_i;
END ARCHITECTURE Behavioral;
