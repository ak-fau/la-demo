library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_gen is
  generic (
    DATA_WIDTH : integer := 8);
  port (
    clk   : in std_logic;
    reset : in std_logic;
    en    : in std_logic;
    mode  : in std_logic;
    data  : out std_logic_vector(DATA_WIDTH-1 downto 0));
end entity data_gen;

architecture rtl of data_gen is
  signal d : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
begin

  data <= d;

  process (clk, reset)
  begin
    if reset = '1' then
      d <= (others => '0');
    elsif rising_edge(clk) then
      if en = '1' then
        d <= std_logic_vector(unsigned(d) + 1);
      end if;
    end if;
  end process;

end rtl;
