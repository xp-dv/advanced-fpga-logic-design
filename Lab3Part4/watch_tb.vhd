---- Watch Block Test Bench ----
-- Required Libraries --
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Entity Declaration --
entity watch_tb is
end entity watch_tb;

-- Architecture Body --
architecture beh of watch_tb is -- beh signifies that the architecture type is behavioral
  -- Declaration and Initialization of Constants --
  constant CLK_PERIOD: time := 1 sec; -- f = 1 Hz
  constant TEST_DURATION: time := 1000 sec;

  -- Declaration and Initialization of Signals --
  signal reset, clk: std_logic := '0'; -- Reset and Clock Signal
  signal en_i: std_logic := '0'; -- Watch Enable Input Signal
  signal y2, y1, y0: std_logic_vector(3 downto 0) := "0000"; -- 3 BCD Digit Count Output

  signal simulate: std_logic := '1'; -- Variable used to stop the simulation. Must be the "signal" type to be used between processes
begin
  -- Instantiate Unit Under Test --
  uut: entity work.watch
    port map (
      reset => reset,
      clk => clk,
      en_i => en_i,
      y2 => y2,
      y1 => y1,
      y0 => y0
    );

  -- Clock Signal --
  process begin
    -- To ensure that the rising edge of the clock signal occurs as close to the middle of the input signal as possible:
    -- All desired inputs should last for one full clock period
    -- The input signal should only ever rise or fall with the falling edge of the clock signal
    while simulate = '1' loop -- Stop clock by setting simulate = '0' in the test bench
      wait for CLK_PERIOD / 2;
      clk <= not clk;
    end loop;
    wait; -- Suspend the test bench for analysis. Equivalent to $stop. Must be inside a process
  end process;

  -- State Transition Testing --
  process is
  begin
    en_i <= '0'; wait for CLK_PERIOD; en_i <= '1'; -- Enable
    wait for TEST_DURATION; -- Watch Counter
    simulate <= '0'; reset <= '1'; wait for CLK_PERIOD; reset <= '0'; -- Reset and Stop Clock Simulation

    wait; -- Suspend the test bench for analysis. Equivalent to $stop. Must be inside a process
  end process;
end beh;
