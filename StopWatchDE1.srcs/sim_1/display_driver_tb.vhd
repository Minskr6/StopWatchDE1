-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 15 Apr 2026 13:30:36 GMT
-- Request id : cfwk-fed377c2-69df92fc18737

library ieee;
use ieee.std_logic_1164.all;

entity tb_display_driver is
end tb_display_driver;

architecture tb of tb_display_driver is

    component display_driver
        port (clk      : in std_logic;
              rst      : in std_logic;
              ce_1khz  : in std_logic;
              h_set_in : in std_logic_vector (3 downto 0);
              t_set_in : in std_logic_vector (3 downto 0);
              u_sec_in : in std_logic_vector (3 downto 0);
              t_sec_in : in std_logic_vector (3 downto 0);
              u_min_in : in std_logic_vector (3 downto 0);
              t_min_in : in std_logic_vector (3 downto 0);
              seg      : out std_logic_vector (6 downto 0);
              dp       : out std_logic;
              anode    : out std_logic_vector (7 downto 0));
    end component;

    signal clk      : std_logic;
    signal rst      : std_logic;
    signal ce_1khz  : std_logic;
    signal h_set_in : std_logic_vector (3 downto 0);
    signal t_set_in : std_logic_vector (3 downto 0);
    signal u_sec_in : std_logic_vector (3 downto 0);
    signal t_sec_in : std_logic_vector (3 downto 0);
    signal u_min_in : std_logic_vector (3 downto 0);
    signal t_min_in : std_logic_vector (3 downto 0);
    signal seg      : std_logic_vector (6 downto 0);
    signal dp       : std_logic;
    signal anode    : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : display_driver
    port map (clk      => clk,
              rst      => rst,
              ce_1khz  => ce_1khz,
              h_set_in => h_set_in,
              t_set_in => t_set_in,
              u_sec_in => u_sec_in,
              t_sec_in => t_sec_in,
              u_min_in => u_min_in,
              t_min_in => t_min_in,
              seg      => seg,
              dp       => dp,
              anode    => anode);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
       
        ce_1khz  <= '0';
        t_min_in <= "0001"; -- 1 
        u_min_in <= "0010"; -- 2 
        t_sec_in <= "0011"; -- 3 
        u_sec_in <= "0100"; -- 4 
        t_set_in <= "0101"; -- 5 
        h_set_in <= "0110"; -- 6 

        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 50 ns;

        ce_1khz <= '1';
        wait for 10 * TbPeriod;
        

        ce_1khz <= '0';
        wait for 10 * TbPeriod;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_display_driver of tb_display_driver is
    for tb
    end for;
end cfg_tb_display_driver;