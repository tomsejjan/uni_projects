--! \file design.vhdl
--! \brief Definice top-level entity Kostka a jeji sktrukturalni architektury

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--! \brief Top-level entita Kostka
ENTITY Kostka IS
	PORT(
		clk : in std_logic;						--! Port pro vstup hodinoveho signalu \a clk
		ce  : in std_logic;						--! Port pro vstup signalu povolujiciho citani \a ce
		arst: in std_logic;						--! Port pro vstup signalu asynchronni reset \a arst
		seg : out std_logic_vector(7 downto 0);	--! Port pro vystup signalu pro segmenty disleje \a seg[7:0]
		an  : out std_logic_vector(3 downto 0);		--! Port pro vystup signalu pro anody disleje \a an[3:0]
		led : out std_logic_vector(2 downto 0)
		);
END ENTITY Kostka;

--! \brief Strukturalni popis architektury top-level entity Kostka
ARCHITECTURE Structural OF Kostka IS
	SIGNAL clk_100hz_i: std_logic := '0';		--! Vnitrni hodinovy signal z portu \a clk, vydeleny delickou na frekvenci 100 Hz
	SIGNAL johnson_val_i: std_logic_vector(2 DOWNTO 0) := (OTHERS => '0');	--! Vnitrni signal s hodnotou johnsonova citace

BEGIN
	divider1: ENTITY work.Clock_divider_g
		GENERIC MAP(
			MAX => 1000000-1
			)
		PORT MAP(
			clk_in  => clk,
			clk_out => clk_100hz_i,
			tc      => OPEN
			);

	cnt_john1: ENTITY work.Counter_johnson	-- Asynchronni zapojeni vyuzivajici hod. signal clk_100hz_i ziskany z delicky
		PORT MAP(
			clk  => clk_100hz_i,
			ce   => ce,
			arst => arst,
			q    => johnson_val_i
			);
	led <= johnson_val_i;
	decoder1: ENTITY work.Led7seg_decoder_johnson
		PORT MAP(
			johnson_val => johnson_val_i,
			seg         => seg,
			an          => an
			);

END ARCHITECTURE Structural;
