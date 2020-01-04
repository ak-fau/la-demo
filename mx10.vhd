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

  constant DATA_WIDTH : integer := 8;

  signal clk, reset : std_logic;
  signal rst_n : std_logic_vector(4 downto 0) := (others => '0');

  signal enable : std_logic;
  signal data : std_logic_vector(DATA_WIDTH-1 downto 0);

  signal pulse_1ms : std_logic;

  signal btn0, btn1 : std_logic;
  signal btn0d, btn1d : std_logic := '0';
  signal btn0_down, btn1_down : std_logic;

  signal mode : std_logic := '0';

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
  led_green <= '0';

  scl <= 'Z';
  sda <= 'Z';

  pmod_J2 <= data;
  pmod_J3 <= (others => 'Z');
  pmod_J4 <= (others => 'Z');
  pmod_J5 <= (others => 'Z');

  -- sd_vsel <= '1'; -- 1.8V
  sd_vsel <= '0'; -- 3.3V

  led(0) <= btn0;
  led(1) <= mode;

  u0: entity work.clk_div
    generic map (
      DIV => 12500000)
    port map (
      clk => clk,
      reset => reset,
      pulse => enable);

  u1: entity work.data_gen
    generic map (
      DATA_WIDTH => DATA_WIDTH)
    port map (
      clk => clk,
      reset => reset,
      mode => mode,
      en => btn0_down, -- enable,
      data => data);

  u2_0: entity work.clk_div
    generic map (
      DIV => 25000)
    port map (
      clk => clk,
      reset => reset,
      pulse => pulse_1ms);

  u2_1: entity work.debounce
    port map (
      clk => clk,
      reset => reset,
      p1ms => pulse_1ms,
      d => button(0),
      q => btn0);

  u2_2: entity work.debounce
    port map (
      clk => clk,
      reset => reset,
      p1ms => pulse_1ms,
      d => button(1),
      q => btn1);

  process (clk, reset)
  begin
    if reset = '1' then
      btn0d <= '0';
      btn1d <= '0';
    elsif rising_edge(clk) then
      btn0d <= btn0;
      btn1d <= btn1;
    end if;
  end process;

  btn0_down <= '1' when btn0 = '1' and btn0d = '0' else '0';
  btn1_down <= '1' when btn1 = '1' and btn1d = '0' else '0';

  process (clk, reset)
  begin
    if reset = '1' then
      mode <= '0';
    elsif rising_edge(clk) then
      if btn1_down = '1' then
        mode <= not mode;
      end if;
    end if;
  end process;

end top;
