--! \file design.vhdl
--! \brief Definice top-level entity Led7seg_counter_synch_bcd a jeji sktrukturalni architektury

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--! \brief Top-level entita Led7seg_counter_synch_bcd
ENTITY Led7seg_counter_synch_bcd IS
	PORT(
		clk : in std_logic;						--! Port pro vstup hodinoveho signalu \a clk
		rst : in std_logic;						--! Port pro vstup signalu synchronni reset \a rst
		load: in std_logic;						--! Port pro vstup signalu povolujiciho synchronni \a load
		ce  : in std_logic;						--! Port pro vstup signalu povolujiciho citani \a ce
		d   : in std_logic_vector(3 downto 0);					--! Port pro vstup vektoru dat \a d[3:0] pro synchronni load
		seg : out std_logic_vector(7 downto 0);					--! Port pro vystup signalu pro segmenty disleje \a seg[7:0]
		an  : out std_logic_vector(3 downto 0)					--! Port pro vystup signalu pro anody disleje \a an[3:0]
		);
END ENTITY Led7seg_counter_synch_bcd;

--! \brief Strukturalni popis architektury top-level entity Led7seg_counter_synch_bcd

ARCHITECTURE Structural OF Led7seg_counter_synch_bcd IS
	SIGNAL ce_100hz_i: std_logic := '0';	--! Vnitrni signal ce povolujici citani BCD citace, vydeleny delickou na frekvenci 100 Hz
	SIGNAL val_bcd_i: std_logic_vector(3 DOWNTO 0) := X"0";	--! Vnitrni signal s hodnotou BCD citace

BEGIN
	divider1: ENTITY work.Clock_divider_synch_g
		GENERIC MAP(
			MAX => 10-1
			)
		PORT MAP(
			clk_in  => clk,					-- Na clk_in je priveden zakladni hodinovy signal: clk
			rst     => rst,
			ce      => ce,
			ceo     => ce_100hz_i,
			clk_out => OPEN,
			tc      => OPEN
			);

	cnt_bcd1: ENTITY work.Counter_bcd_rst_load_ce_g	-- Synchronni zapojeni - vse bezi na zakladnim hodinovem signalu: clk
		PORT MAP(
			clk  => clk,					-- Na clk je priveden zakladni hodinovy signal: clk
			rst  => rst,
			load => load,
			ce   => ce_100hz_i,					-- Na ce je priveden signal ce_100hz_i generovany delickou: divider1
			d    => d,
			q    => val_bcd_i
			);

	decoder1: ENTITY work.Led7seg_decoder_bcd
		PORT MAP(
			val_bcd => val_bcd_i,
			seg     => seg,
			an      => an
			);

END ARCHITECTURE Structural;
