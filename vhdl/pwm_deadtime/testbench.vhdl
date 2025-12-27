--! \file testbench.vhdl
--! \brief Testbench architecture and entity for DUT components (Device Under Test) testing: Generator_pwm_deadtime

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.env.finish;				

--! \brief Testbench for: Generator_pwm_deadtime
--! \details Definition of the Testbench entity for verifying the PWM generator, designed for controlling power transistors in a totem-pole configuration.
ENTITY Testbench IS
END ENTITY Testbench;

--! \brief Behavioral description of the architecture entity Testbench (for testing Generator_pwm_deadtime)
ARCHITECTURE Behavioral OF Testbench IS

	CONSTANT clock_period_c: delay_length := 1 ms;	--! Clock signal period (tj. 1 kHz)

	--! \brief DUT (Device Under Test) component Generator_pwm_deadtime
	COMPONENT Generator_pwm_deadtime IS
		PORT(
			clk       : in std_logic;						
			ce        : in std_logic;						
			pwm_val   : in std_logic_vector(2 DOWNTO 0);				
			drv_top   : out std_logic;						
			drv_bottom: out std_logic						
			);
	END COMPONENT Generator_pwm_deadtime;

	-- Inputs
	SIGNAL clk_in: std_logic := '0';			--! Signal clk connected to inputs of the tested components
	SIGNAL ce_in : std_logic := '1';			--! Signal ce connected to inputs of the tested components
	SIGNAL pwm_val_in: std_logic_vector(2 DOWNTO 0) := (OTHERS => '0'); --! Signal vector [2:0] connected to input \a pwm_val[2:0] of the tested component

	-- Outputs
	SIGNAL drv_top_out: std_logic;				--! Signal connected to the PWM output (top transistor)
	SIGNAL drv_bottom_out: std_logic;			--! Signal connected to the PWM output (top transistor)
	
	-- Mapping alias to the internal signal and port with VHDL-2008 External name feature
	ALIAS dut_cmp_p0 IS							--! Connection to the internal signal \p cmp_p0_i internal tested component Generator_deadtime_synch_ce
		<< SIGNAL .Testbench.dut.deadtime_generator1.cmp_p0_i: std_logic >>;

BEGIN
	--! Connecting instance Generator_pwm_deadtime as DUT
	dut: Generator_pwm_deadtime
		PORT MAP(
			clk        => clk_in,
			ce         => ce_in,
			pwm_val    => pwm_val_in,
			drv_top    => drv_top_out,
			drv_bottom => drv_bottom_out
			);

	--! Clock process definition
	--! \vhdlflow The following diagram shows steps of making 180 periods on \p clk_in. 
	clock_proc: PROCESS
	BEGIN
		WAIT FOR 5 ms;		-- Wait for 5 ms before start of simulation
		FOR i IN 1 TO 180 LOOP
			clk_in <= '1';
			WAIT FOR clock_period_c / 2;
			clk_in <= '0';
			WAIT FOR clock_period_c / 2;
		END LOOP;
		WAIT FOR 10 ms;		-- Hold for 10 ms before end of simulation
		WAIT;
	END PROCESS clock_proc;

	--! Deadtime checking process definition
	--! Proces checking Deadtime conditions for \p drv_top_out and \p drv_bottom_out
	--! \vhdlflow This diagram shows checking Deadtime conditions for \p drv_top_out and \p drv_bottom_out
	--! \param[in] drv_top_out Top transistor output signal
	--! \param[in] drv_bottom_out Bottom transistor output signal
	deadtime_check_proc: PROCESS(drv_top_out, drv_bottom_out)
	BEGIN
		IF drv_top_out = '1' AND drv_bottom_out = '1' THEN
			REPORT "V case: " & to_string(now) &
				", zhorely oba vykonove tranzistory!  :-X"
				SEVERITY error;
		END IF;

		IF drv_top_out'event AND drv_top_out = '1' THEN
			ASSERT drv_bottom_out'stable(clock_period_c)
				REPORT "V case: " & to_string(now) &
					", nebyla splnena Deadtime podminka pro dolni vykonovy tranzistor!  :-("
					SEVERITY error;
		END IF;

		IF drv_bottom_out'event AND drv_bottom_out = '1' THEN
			ASSERT drv_top_out'stable(clock_period_c)
				REPORT "V case: " & to_string(now) &
					", nebyla splnena Deadtime podminka pro horni vykonovy tranzistor!  :-("
					SEVERITY error;
		END IF;
	END PROCESS deadtime_check_proc;

	-- Stimulus process definition
	--! Stimulus process definition
	--! \vhdlflow This diagram shows steps of the testing process including each stimulus descriptions.
	testbench_proc: PROCESS
	BEGIN
		REPORT "Test start." SEVERITY note;

		-- Cekame na prvni nastupnou hranu na signalu clk_in
		WAIT ON clk_in UNTIL clk_in = '1';
		WAIT FOR 12.5 ms;		-- Hold for 12.5 ms

		pwm_val_in <= std_logic_vector(to_unsigned(1, pwm_val_in'length));
		WAIT FOR 0.5 ms;		-- Hold for 0.5 ms

		-- vystup dut_cmp_p0 je v '0' a nezmenil svuj stav uz alespon 7 ms
		ASSERT dut_cmp_p0 = '0' AND dut_cmp_p0'stable(7 ms)
			REPORT "Chybna hodnota cmp_p0_i signalu pri val = 0" SEVERITY error;

		WAIT FOR 13.5 ms;		-- Hold for 13.5 ms
		pwm_val_in <= std_logic_vector(to_unsigned(6, pwm_val_in'length));
		WAIT FOR 0.5 ms;		-- Hold for 0.5 ms

		-- vystup dut_cmp_p0 je v '0' a posledni zmena vystupu probehla pred 5 ms
		ASSERT dut_cmp_p0 = '0' AND dut_cmp_p0'last_event = 5 ms
			REPORT "Chybna hodnota cmp_p0_i signalu pri val = 1" SEVERITY error;

		WAIT FOR 13.5 ms;		-- Hold for 13.5 ms
		pwm_val_in <= std_logic_vector(to_unsigned(7, pwm_val_in'length));
		WAIT FOR 0.5 ms;		-- Hold for 0.5 ms

		-- vystup dut_cmp_p0 je v '1' a posledni zmena vystupu probehla pred 6 ms
		ASSERT dut_cmp_p0 = '1' AND dut_cmp_p0'last_event = 6 ms
			REPORT "Chybna hodnota cmp_p0_i signalu pri val = 6" SEVERITY error;

		WAIT FOR 13.5 ms;		-- Hold for 13.5 ms
		pwm_val_in <= std_logic_vector(to_unsigned(3, pwm_val_in'length));
		WAIT FOR 0.5 ms;		-- Hold for 0.5 ms

		-- vystup dut_cmp_p0 je v '1' a nezmenil svuj stav uz alespon 7 ms
		ASSERT dut_cmp_p0 = '1' AND dut_cmp_p0'stable(7 ms)
			REPORT "Chybna hodnota cmp_p0_i signalu pri val = 7" SEVERITY error;

		REPORT "Testujeme CE = 0";
		--pwm_val_in <= std_logic_vector(to_unsigned(3, pwm_val_in'length));
		ce_in <= '0' AFTER 50 ns;	 -- Prirazeni se zpozdenim 50 ns
		WAIT FOR 7 ms;		-- Hold for 7 ms
		-- vystup dut_cmp_p0 je v '1' a nezmenil svuj stav uz alespon 7 ms
		ASSERT dut_cmp_p0 = '1' AND dut_cmp_p0'stable(7 ms)
			REPORT "Chybna hodnota cmp_p0_i signalu pri val = 3 a ce = 0" SEVERITY error;

		ce_in <= '1' AFTER 50 ns;	 -- Prirazeni se zpozdenim 50 ns
		WAIT FOR 7 ms;		-- Hold for 7 ms
		REPORT "Test of CE and LOAD done...";


		FOR j IN 0 TO 10 LOOP
        	
            WAIT ON clk_in UNTIL clk_in = '1';
			
            FOR i IN 0 TO 7 LOOP
					WAIT ON clk_in UNTIL clk_in = '0';
					pwm_val_in <= std_logic_vector(to_unsigned(i, 3));
                    --WAIT FOR 1 ns;
                    ASSERT drv_top_out /= 'U'
                    	REPORT "Chyba - vznikaji glitche! (0,1,2,3,4,5,6,7)" SEVERITY error;
                    ASSERT drv_bottom_out /= 'U'
                    	REPORT "Chyba - vznikaji glitche! (0,1,2,3,4,5,6,7)" SEVERITY error;
            END LOOP;
            WAIT ON clk_in UNTIL clk_in = '0';
            pwm_val_in <= O"0";
            ASSERT drv_top_out /= 'U'
            	REPORT "Chyba! vznikaji glitche" SEVERITY error;
            ASSERT drv_bottom_out /= 'U'
            	REPORT "Chyba! vznikaji glitche" SEVERITY error;
            
            pwm_val_in <= O"7";
            ASSERT drv_top_out /= 'U'
            	REPORT "Chyba! vznikaji glitche" SEVERITY error;
            ASSERT drv_bottom_out /= 'U'
            	REPORT "Chyba! vznikaji glitche" SEVERITY error;
        END LOOP;		

		REPORT "All tests done." SEVERITY note;
		WAIT;
		finish;			-- Procedura z baliku env zajistujici ukonceni simulace

	END PROCESS testbench_proc;
END ARCHITECTURE Behavioral;
