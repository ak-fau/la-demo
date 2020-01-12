library IEEE;
use IEEE.std_logic_1164.all;

entity mx10 is
  port(
    clk25        : in    std_logic;
    clko1        : in    std_logic;
    rstn         : in    std_logic;

    dbg_txd      : out   std_logic;
    dbg_rxd      : in    std_logic;

    led_amber    : out   std_logic;
    led_green    : out   std_logic;

    led          : out   std_logic_vector(1 downto 0);
    button       : in    std_logic_vector(1 downto 0);

    scl          : inout std_logic;
    sda          : inout std_logic;

    pmod_J2      : inout std_logic_vector(7 downto 0);
    pmod_J3      : inout std_logic_vector(7 downto 0);
    pmod_J4      : inout std_logic_vector(7 downto 0);
    pmod_J5      : inout std_logic_vector(7 downto 0);

    sd_vsel      : out   std_logic;
    ddr3_reset_n : out   std_logic);
end mx10;

architecture top of mx10 is

  signal clk, reset : std_logic;
  signal rst_n : std_logic_vector(4 downto 0) := (others => '0');

  signal pmod_led8 : std_logic_vector(7 downto 0);

begin

  clk <= clk25;

  process (clk, rstn)
  begin
    if rstn = '0' then
      rst_n <= (others => '0');
      reset <= '1';
    elsif rising_edge(clk) then
      rst_n(0) <= '1';
      rst_n(rst_n'left downto 1) <= rst_n(rst_n'left-1 downto 0);
      reset <= not rst_n(rst_n'left);
    end if;
  end process;

  ddr3_reset_n <= '0';

  dbg_txd <= dbg_rxd;

  led_amber <= reset;
  -- led_green <= '0';

  scl <= 'Z';
  sda <= 'Z';

  pmod_J2 <= pmod_led8;
  pmod_J3 <= (others => 'Z');
  pmod_J4 <= (others => 'Z');
  pmod_J5 <= (others => 'Z');

  -- sd_vsel <= '1'; -- 1.8V
  sd_vsel <= '0'; -- 3.3V

  led(0) <= not button(0);
  led(1) <= not button(1);

  u0: entity work.vjtag
    port map (
      reset => reset,
      ir0   => led_green,
      data  => pmod_led8);

end top;
