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
  constant VJTAG_IR_LEN : integer := 1;

  signal clk, reset : std_logic;
  signal rst_n : std_logic_vector(4 downto 0) := (others => '0');

  signal jtag_tck, jtag_tms, jtag_tdi, jtag_tdo : std_logic;
  signal jtag_ir_in  : std_logic_vector(VJTAG_IR_LEN-1 downto 0);
  signal jtag_ir_out : std_logic_vector(VJTAG_IR_LEN-1 downto 0);

  component v_jtag is
    port (
      tck                : out std_logic;
      tms                : out std_logic;
      tdi                : out std_logic;
      tdo                : in  std_logic := 'X';
      ir_in              : out std_logic_vector(VJTAG_IR_LEN-1 downto 0);
      ir_out             : in  std_logic_vector(VJTAG_IR_LEN-1 downto 0) := (others => 'X');
      virtual_state_cdr  : out std_logic;
      virtual_state_sdr  : out std_logic;
      virtual_state_e1dr : out std_logic;
      virtual_state_pdr  : out std_logic;
      virtual_state_e2dr : out std_logic;
      virtual_state_udr  : out std_logic;
      virtual_state_cir  : out std_logic;
      virtual_state_uir  : out std_logic;
      jtag_state_tlr     : out std_logic;
      jtag_state_rti     : out std_logic;
      jtag_state_sdrs    : out std_logic;
      jtag_state_cdr     : out std_logic;
      jtag_state_sdr     : out std_logic;
      jtag_state_e1dr    : out std_logic;
      jtag_state_pdr     : out std_logic;
      jtag_state_e2dr    : out std_logic;
      jtag_state_udr     : out std_logic;
      jtag_state_sirs    : out std_logic;
      jtag_state_cir     : out std_logic;
      jtag_state_sir     : out std_logic;
      jtag_state_e1ir    : out std_logic;
      jtag_state_pir     : out std_logic;
      jtag_state_e2ir    : out std_logic;
      jtag_state_uir     : out std_logic);
  end component v_jtag;

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

  pmod_J2 <= (others => 'Z');
  pmod_J3 <= (others => 'Z');
  pmod_J4 <= (others => 'Z');
  pmod_J5 <= (others => 'Z');

  -- sd_vsel <= '1'; -- 1.8V
  sd_vsel <= '0'; -- 3.3V

  led(0) <= not button(0);
  led(1) <= not button(1);

  u0 : component v_jtag
    port map (
      tck                => jtag_tck,
      tms                => jtag_tms,
      tdi                => jtag_tdi,
      tdo                => jtag_tdo,
      ir_in              => jtag_ir_in,
      ir_out             => jtag_ir_out,
      virtual_state_cdr  => open,
      virtual_state_sdr  => open,
      virtual_state_e1dr => open,
      virtual_state_pdr  => open,
      virtual_state_e2dr => open,
      virtual_state_udr  => open,
      virtual_state_cir  => open,
      virtual_state_uir  => open,
      jtag_state_tlr     => open,
      jtag_state_rti     => open,
      jtag_state_sdrs    => open,
      jtag_state_cdr     => open,
      jtag_state_sdr     => open,
      jtag_state_e1dr    => open,
      jtag_state_pdr     => open,
      jtag_state_e2dr    => open,
      jtag_state_udr     => open,
      jtag_state_sirs    => open,
      jtag_state_cir     => open,
      jtag_state_sir     => open,
      jtag_state_e1ir    => open,
      jtag_state_pir     => open,
      jtag_state_e2ir    => open,
      jtag_state_uir     => open);

  jtag_tdo <= jtag_tdi;
  jtag_ir_out <= (others => '0');

  led_green <= jtag_ir_in(0);

end top;
