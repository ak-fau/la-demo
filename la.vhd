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

  u1: entity work.dpram
    port map (
      -- Write port
      wrclock	 => clk,
      wraddress	 => (others => '0'),
      data	 => (others => '0'),
      wren	 => '0',
      -- Read port
      rdclock	 => mclk,
      rdaddress	 => maddr,
      q	 => mdata);

end architecture struct;
