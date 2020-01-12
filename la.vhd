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
  signal maddr_o : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal maddr : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
  signal maddr_update : std_logic;
  signal rd_data : std_logic_vector(DATA_WIDTH downto 0); -- plus 1 bit!!
  signal t_mask, t_data : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal t_post, t_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);

begin

  u0: entity work.vjtag_registers
    port map (
      clk    => clk,
      reset  => reset,
      cmd    => cmd,
      status => status,
      addr_o => maddr_o,
      addr_i => maddr,
      addr_u => maddr_update,
      data_i => rd_data,
      t_mask => t_mask,
      t_data => t_data,
      --t_re   => t_re,
      --t_fe   => t_fe,
      t_post => t_post,
      t_addr => t_addr
      );

end architecture struct;
