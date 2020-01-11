library IEEE;
use IEEE.std_logic_1164.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

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

  signal jtag_tlr : std_logic;
  signal v_cdr, v_sdr, v_udr : std_logic;
  signal dr_s : std_logic_vector(7 downto 0);
  signal dr : std_logic_vector(7 downto 0);

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

  pmod_J2 <= dr;
  pmod_J3 <= (others => 'Z');
  pmod_J4 <= (others => 'Z');
  pmod_J5 <= (others => 'Z');

  -- sd_vsel <= '1'; -- 1.8V
  sd_vsel <= '0'; -- 3.3V

  led(0) <= not button(0);
  led(1) <= not button(1);

  u0 : component sld_virtual_jtag
   generic map (
      sld_auto_instance_index => "NO",
      sld_instance_index => 1,
      sld_ir_width => 1)
    port map (
      tck                => jtag_tck,
      tms                => jtag_tms,
      tdi                => jtag_tdi,
      tdo                => jtag_tdo,
      ir_in              => jtag_ir_in,
      ir_out             => jtag_ir_out,
      virtual_state_cdr  => v_cdr,
      virtual_state_sdr  => v_sdr,
      virtual_state_e1dr => open,
      virtual_state_pdr  => open,
      virtual_state_e2dr => open,
      virtual_state_udr  => v_udr,
      virtual_state_cir  => open,
      virtual_state_uir  => open,
      jtag_state_tlr     => jtag_tlr,
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

  -- jtag_tdo <= jtag_tdi;
  jtag_ir_out <= (others => '0');

  led_green <= jtag_ir_in(0);

  process (jtag_tck, reset)
  begin
    if reset = '1' then
      dr <= (others => '0');
    elsif falling_edge(jtag_tck) then
      if v_udr = '1' then
        dr <= dr_s;
      end if;
    end if;
  end process;

  process (jtag_tck, reset)
  begin
    if reset = '1' then
      dr_s <= (others => '0');
    elsif rising_edge(jtag_tck) then
      if jtag_tlr = '1' then
        dr_s <= (others => '0');
      elsif v_cdr = '1' then
        dr_s <= x"C" & "000" & jtag_ir_in(0);
      elsif v_sdr = '1' then
        dr_s(dr_s'left-1 downto 0) <= dr_s(dr_s'left downto 1);
        dr_s(dr_s'left) <= jtag_tdi;
      end if;
    end if;
  end process;

  jtag_tdo <= dr_s(0);

end top;
