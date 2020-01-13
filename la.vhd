library ieee;
use ieee.std_logic_1164.all;

entity la is
  generic (
    DATA_WIDTH : integer := 8);
  port (
    clk   : in std_logic;
    reset : in std_logic;
    data  : in std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity la;

architecture struct of la is

  constant ADDR_WIDTH : integer := 10;

  signal cmd : std_logic_vector(7 downto 0);
  signal status : std_logic_vector(7 downto 0);
  signal t_mask, t_data : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal t_post, t_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);

  signal d_data : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal wr_data : std_logic_vector(DATA_WIDTH downto 0);
  signal trigger : std_logic;
  signal wr_addr : std_logic_vector(ADDR_WIDTH downto 0); -- plus 1 bit!!
  signal wr_en   : std_logic;

  signal restart, arm : std_logic;
  signal done : std_logic;
  signal fsm_state : std_logic_vector(3 downto 0);

  -- TCK clock domain (DPRAM read port)
  signal mclk : std_logic;
  signal maddr : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal mdata : std_logic_vector(DATA_WIDTH downto 0); -- plus 1 bit!!

begin

  u0: entity work.vjtag_registers
    port map (
      clk    => clk,
      reset  => reset,

      -- System clock domain
      cmd    => cmd,
      status => status,
      t_mask => t_mask,
      t_data => t_data,
      --t_re   => t_re,
      --t_fe   => t_fe,
      t_post => t_post,
      t_addr => t_addr,

      -- TCK clock domain
      mclk  => mclk,
      maddr => maddr,
      mdata => mdata
      );

  restart <= cmd(7);
  arm <= cmd(0);

  status <= done & "000" & fsm_state;

  wr_data <= wr_addr(10) & d_data;

  u1: entity work.dpram
    port map (
      -- Write port
      wrclock	 => clk,
      wraddress	 => wr_addr(9 downto 0),
      data	 => wr_data,
      wren	 => wr_en,

      -- Read port
      rdclock	 => mclk,
      rdaddress	 => maddr,
      q	 => mdata);

  u2: entity work.la_trigger
    generic map (
      DATA_WIDTH => DATA_WIDTH)
    port map (
      clk     => clk,
      reset   => reset,
      inp     => data,
      pattern => t_data,
      mask    => t_mask,
      d_out   => d_data,
      t_out   => trigger);

  u3: entity work.la_control
    port map (
      clk => clk,
      reset => reset,
      post_st => t_post,
      arm     => arm,
      restart => restart,
      trigger => trigger,
      state   => fsm_state,
      done    => done,
      t_addr  => t_addr,
      dp_wadr => wr_addr,
      dp_we   => wr_en);

end architecture struct;
