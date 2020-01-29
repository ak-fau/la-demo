library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_gen_tb is begin
end entity data_gen_tb;

architecture sim of data_gen_tb is

  constant DATA_WIDTH : integer := 8;
  constant CLOCK_HALF_TIME: time := 20 ns;

  signal clk : std_logic := '0';
  signal reset : std_logic := '1';
  signal cnt : integer := 0;

  signal enable : std_logic := '0';
  signal mode : std_logic := '0';
  signal data : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

  -- Test clock generator
  process
  begin
    clk <= '0';
    wait for CLOCK_HALF_TIME;
    clk <= '1';
    wait for CLOCK_HALF_TIME;
  end process;

  -- Step counter to generate test stimuls
  process (clk)
  begin
    if rising_edge(clk) then
      cnt <= cnt + 1;
    end if;
  end process;

  -- Test stimuls
  process (clk, cnt)
  begin
    if rising_edge(clk) then
      case cnt is
        when 0 =>
          reset <= '1';
          enable <= '0';
          mode <= '0';
        when 3 =>
          reset <= '0';
        when 5 =>
          enable <= '1';
        when 261 =>
          mode <= '1';
        when 270 =>
          mode <= '0';
        when 271 =>
          mode <= '1';
        when others => null;
      end case;
    end if;
  end process;

  -- Design Under Test
  dut: entity work.data_gen
    generic map (
      DATA_WIDTH => DATA_WIDTH)
    port map (
      clk   => clk,
      reset => reset,
      en    => enable,
      mode  => mode,
      data  => data);

end architecture sim;
