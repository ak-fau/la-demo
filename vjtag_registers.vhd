library IEEE;
use IEEE.std_logic_1164.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

entity vjtag_registers is
  generic (
    DATA_WIDTH : integer := 8;
    ADDR_WIDTH : integer := 10);
  port (
    clk    : in  std_logic;
    reset  : in  std_logic;
    cmd    : out std_logic_vector(7 downto 0);
    status : in  std_logic_vector(7 downto 0);
    addr_o : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    addr_i : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    addr_u : out std_logic;
    data_i : in  std_logic_vector(DATA_WIDTH   downto 0); -- plus one bit!!
    t_mask : out std_logic_vector(DATA_WIDTH-1 downto 0);
    t_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
    --t_re   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    --t_fe   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    t_post : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    t_addr : in  std_logic_vector(ADDR_WIDTH-1 downto 0));
end entity vjtag_registers;

architecture rtl of vjtag_registers is
  constant VJTAG_IR_LEN : integer := 4;

  signal jtag_tck, jtag_tms, jtag_tdi, jtag_tdo : std_logic;
  signal jtag_ir_in  : std_logic_vector(VJTAG_IR_LEN-1 downto 0);
  signal jtag_ir_out : std_logic_vector(VJTAG_IR_LEN-1 downto 0);

  signal jtag_tlr : std_logic;
  signal v_cdr, v_sdr, v_udr : std_logic;
  signal dr_s : std_logic_vector(7 downto 0);
  signal dr : std_logic_vector(7 downto 0);

begin

  u0 : component sld_virtual_jtag
   generic map (
      sld_auto_instance_index => "NO",
      sld_instance_index => 1,
      sld_ir_width => VJTAG_IR_LEN)
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

  jtag_ir_out <= (others => '0');

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

end architecture rtl;
