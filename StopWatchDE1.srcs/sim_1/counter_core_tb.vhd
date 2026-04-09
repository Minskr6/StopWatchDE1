-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 09 Apr 2026 12:19:29 GMT
-- Request id : cfwk-fed377c2-69d79951a9d21

library ieee;
use ieee.std_logic_1164.all;

entity tb_counter_core is
end tb_counter_core;

architecture tb of tb_counter_core is

    component counter_core
        port (clk   : in std_logic;
              rst   : in std_logic;
              ce    : in std_logic;
              h_set : out std_logic_vector (3 downto 0);
              t_set : out std_logic_vector (3 downto 0);
              u_sec : out std_logic_vector (3 downto 0);
              t_sec : out std_logic_vector (3 downto 0);
              u_min : out std_logic_vector (3 downto 0);
              t_min : out std_logic_vector (3 downto 0));
    end component;

    signal clk   : std_logic;
    signal rst   : std_logic;
    signal ce    : std_logic;
    signal h_set : std_logic_vector (3 downto 0);
    signal t_set : std_logic_vector (3 downto 0);
    signal u_sec : std_logic_vector (3 downto 0);
    signal t_sec : std_logic_vector (3 downto 0);
    signal u_min : std_logic_vector (3 downto 0);
    signal t_min : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : counter_core
    port map (clk   => clk,
              rst   => rst,
              ce    => ce,
              h_set => h_set,
              t_set => t_set,
              u_sec => u_sec,
              t_sec => t_sec,
              u_min => u_min,
              t_min => t_min);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process is
    begin

        ce <= '0';

        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 100 ns;

        ce <= '1';
        wait for 105 * tbperiod;
        
        ce <= '0';
        wait for 6 * tbperiod;
        
        ce <= '1';
        wait for 6000 * tbperiod;
        
        ce <= '0';
        wait for 6 * tbperiod;

        tbsimended <= '1';
        wait;

    end process stimuli;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_counter_core of tb_counter_core is
    for tb
    end for;
end cfg_tb_counter_core;