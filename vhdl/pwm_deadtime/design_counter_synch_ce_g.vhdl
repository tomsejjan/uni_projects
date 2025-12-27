--! \file design_counter_synch_ce_g.vhdl
--! \brief Definition of the generic entity synchronous binary counter with output \a q[BITS-1:0] with limitation of counting to \a MAX and its behavioral architecture

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

--! \brief Entity synchronous binary counter with output \a q[BITS-1:0] with limitation of counting to \a MAX and its behavioral architecture
ENTITY Counter_synch_ce_g IS
	GENERIC(
		BITS: positive;			--! Generic parameter declaring width of the input vector \a q[BITS-1:0]
		MAX : positive			--! Generic parameter declaring maximal value of the counter. After the maximal value it goes to zero
		);
	PORT(
		clk: IN std_logic;							--! Port for clock input \a clk
		ce : IN std_logic;							--! Port for clock enable input \a ce
		q  : OUT std_logic_vector(BITS-1 downto 0)					--! Synchronous counter output \a q[BITS-1:0]
		);
END ENTITY Counter_synch_ce_g;

--! \brief Behavioral architecture of the generic entity synchronous binary counter with output \a q[BITS-1:0] with limitation of counting to \a MAX
ARCHITECTURE Behavioral OF Counter_synch_ce_g IS
	SIGNAL cnt_i: natural RANGE 0 TO MAX := 0;		--! Internal value of the binary counter
BEGIN
	--! \brief Process handling the counter increment logic. 
    --! \details When `ce = 0`, the current value of \p cnt_i is maintained. 
    --! When `ce = 1` and the current state is less than \a MAX, the counter increments. 
    --! If the maximum value \p MAX is reached, the counter resets to 0.
    --! \vhdlflow This diagram illustrates the individual steps of the counter value update process.
	cnt_proc: PROCESS(clk)
	BEGIN
    	IF rising_edge(clk) THEN
        	IF ce = '1' THEN
            	IF cnt_i < MAX THEN
                	cnt_i <= cnt_i + 1;
                ELSE
                	cnt_i <= 0;
                END IF;
            END IF;
        END IF;
	END PROCESS cnt_proc;

	q <= std_logic_vector(to_unsigned(cnt_i, BITS));
END ARCHITECTURE Behavioral;
