library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

entity vjtag_registers is
  generic (
    DATA_WIDTH : integer := 8;
    ADDR_WIDTH : integer := 10;
    CSR_WIDTH  : integer := 8);
  port (
    clk    : in  std_logic;
    reset  : in  std_logic;

    -- System clock domain
    cmd    : out std_logic_vector(CSR_WIDTH-1 downto 0);
    status : in  std_logic_vector(CSR_WIDTH-1 downto 0);
    t_mask : out std_logic_vector(DATA_WIDTH-1 downto 0);
    t_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
    --t_re   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    --t_fe   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    t_post : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    t_addr : in  std_logic_vector(ADDR_WIDTH-1 downto 0);

    -- TCK clock domain
    mclk   : out std_logic;
    maddr  : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    mdata  : in  std_logic_vector(DATA_WIDTH   downto 0) -- plus one bit!!
    );
end entity vjtag_registers;

architecture rtl of vjtag_registers is
  constant VJTAG_IR_LEN : integer := 4;

  constant IR_STATUS : std_logic_vector(VJTAG_IR_LEN-1 downto 0) := x"0";
  constant IR_CMD    : std_logic_vector(VJTAG_IR_LEN-1 downto 0) := x"1";
  constant IR_DATA   : std_logic_vector(VJTAG_IR_LEN-1 downto 0) := x"2";
  constant IR_T_MASK : std_logic_vector(VJTAG_IR_LEN-1 downto 0) := x"4";
  constant IR_T_DATA : std_logic_vector(VJTAG_IR_LEN-1 downto 0) := x"5";
  constant IR_ADDR   : std_logic_vector(VJTAG_IR_LEN-1 downto 0) := x"8";
  constant IR_POST   : std_logic_vector(VJTAG_IR_LEN-1 downto 0) := x"9";
  constant IR_T_ADDR : std_logic_vector(VJTAG_IR_LEN-1 downto 0) := x"a";

  signal jtag_tck, jtag_tms, jtag_tdi, jtag_tdo : std_logic;
  signal jtag_ir_in  : std_logic_vector(VJTAG_IR_LEN-1 downto 0);
  signal jtag_ir_out : std_logic_vector(VJTAG_IR_LEN-1 downto 0);

  signal jtag_tlr : std_logic;
  signal v_cdr, v_sdr, v_udr : std_logic;

  signal shift_reg : std_logic_vector(ADDR_WIDTH-1 downto 0); -- max length

  signal j_addr_r : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal j_cmd_r : std_logic_vector(CSR_WIDTH-1 downto 0);
  signal j_tm_r : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal j_td_r : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal j_t_post_r : std_logic_vector(ADDR_WIDTH-1 downto 0);

  signal j_status : std_logic_vector(CSR_WIDTH-1 downto 0);
  signal j_t_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal j_data : std_logic_vector(DATA_WIDTH downto 0);

  signal cmd_r : std_logic_vector(CSR_WIDTH-1 downto 0);
  signal tm_r : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal td_r : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal t_post_r : std_logic_vector(ADDR_WIDTH-1 downto 0);

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

  process (jtag_tck, jtag_tlr)
  begin
    if jtag_tlr = '1' then
      j_addr_r <= (others => '0');
      j_cmd_r <= (others => '0');
      j_tm_r <= (others => '0');
      j_td_r <= (others => '0');
      j_t_post_r <= (others => '0');
    elsif falling_edge(jtag_tck) then
      if v_udr = '1' then
        case jtag_ir_in is
          when IR_CMD =>
            j_cmd_r <= shift_reg(CSR_WIDTH-1 downto 0);
          when IR_T_MASK =>
            j_tm_r <= shift_reg(DATA_WIDTH-1 downto 0);
          when IR_T_DATA =>
            j_td_r <= shift_reg(DATA_WIDTH-1 downto 0);
          when IR_ADDR =>
            j_addr_r <= shift_reg(ADDR_WIDTH-1 downto 0);
          when IR_POST =>
            j_t_post_r <= shift_reg(ADDR_WIDTH-1 downto 0);
          when others => null;
        end case;
      elsif v_cdr = '1' and jtag_ir_in = IR_DATA then
        j_addr_r <= std_logic_vector(unsigned(j_addr_r)+1);
      end if;
    end if;
  end process;

  process (jtag_tck, jtag_tlr)
  begin
    if jtag_tlr = '1' then
      shift_reg <= (others => '0');
    elsif rising_edge(jtag_tck) then
      if jtag_tlr = '1' then
        shift_reg <= (others => '0');
      elsif v_cdr = '1' then
        case jtag_ir_in is
          when IR_STATUS =>
            shift_reg <= "00" & j_status;
          when IR_CMD =>
            shift_reg <= "00" & j_cmd_r;
          when IR_DATA =>
            shift_reg <= "0" & j_data;
          when IR_T_MASK =>
            shift_reg <= "00" & j_tm_r;
          when IR_T_DATA =>
            shift_reg <= "00" & j_td_r;
          when IR_ADDR =>
            shift_reg <= j_addr_r;
          when IR_POST =>
            shift_reg <= j_t_post_r;
          when IR_T_ADDR =>
            shift_reg <= j_t_addr;
          when others =>
            shift_reg <= (others => '0');
        end case;
      elsif v_sdr = '1' then
        case jtag_ir_in is
          when IR_STATUS | IR_CMD => -- 8-bit registers
            shift_reg(6 downto 0) <= shift_reg(7 downto 1);
            shift_reg(7) <= jtag_tdi;
          when IR_DATA => -- DATA_WIDTH+1 register
            shift_reg(DATA_WIDTH-1 downto 0) <= shift_reg(DATA_WIDTH downto 1);
            shift_reg(DATA_WIDTH) <= jtag_tdi;
          when IR_T_MASK | IR_T_DATA => -- DATA_WIDTH registers
            shift_reg(DATA_WIDTH-2 downto 0) <= shift_reg(DATA_WIDTH-1 downto 1);
            shift_reg(DATA_WIDTH-1) <= jtag_tdi;
          when IR_ADDR | IR_POST | IR_T_ADDR => -- ADDR_WIDTH registers
            shift_reg(ADDR_WIDTH-2 downto 0) <= shift_reg(ADDR_WIDTH-1 downto 1);
            shift_reg(ADDR_WIDTH-1) <= jtag_tdi;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  jtag_tdo <= shift_reg(0);

  -- DPRAM (read port) signals
  -- TCK clock domain
  mclk <= jtag_tck;
  maddr <= j_addr_r;
  j_data <= mdata;

end architecture rtl;
