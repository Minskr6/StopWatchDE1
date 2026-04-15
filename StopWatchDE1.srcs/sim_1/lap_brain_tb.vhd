-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 15 Apr 2026 12:50:47 GMT
-- Request id : cfwk-fed377c2-69df89a7abf2b

library ieee;
use ieee.std_logic_1164.all;

entity tb_lap_brain is
end tb_lap_brain;

architecture tb of tb_lap_brain is

    component lap_brain
        port (clk       : in std_logic;
              rst       : in std_logic;
              lap_time  : in std_logic;
              lap_mem   : in std_logic;
              h_set_in  : in std_logic_vector (3 downto 0);
              t_set_in  : in std_logic_vector (3 downto 0);
              u_sec_in  : in std_logic_vector (3 downto 0);
              t_sec_in  : in std_logic_vector (3 downto 0);
              u_min_in  : in std_logic_vector (3 downto 0);
              t_min_in  : in std_logic_vector (3 downto 0);
              h_set_out : out std_logic_vector (3 downto 0);
              t_set_out : out std_logic_vector (3 downto 0);
              u_sec_out : out std_logic_vector (3 downto 0);
              t_sec_out : out std_logic_vector (3 downto 0);
              u_min_out : out std_logic_vector (3 downto 0);
              t_min_out : out std_logic_vector (3 downto 0));
    end component;

    signal clk       : std_logic;
    signal rst       : std_logic;
    signal lap_time  : std_logic;
    signal lap_mem   : std_logic;
    signal h_set_in  : std_logic_vector (3 downto 0);
    signal t_set_in  : std_logic_vector (3 downto 0);
    signal u_sec_in  : std_logic_vector (3 downto 0);
    signal t_sec_in  : std_logic_vector (3 downto 0);
    signal u_min_in  : std_logic_vector (3 downto 0);
    signal t_min_in  : std_logic_vector (3 downto 0);
    signal h_set_out : std_logic_vector (3 downto 0);
    signal t_set_out : std_logic_vector (3 downto 0);
    signal u_sec_out : std_logic_vector (3 downto 0);
    signal t_sec_out : std_logic_vector (3 downto 0);
    signal u_min_out : std_logic_vector (3 downto 0);
    signal t_min_out : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : lap_brain
    port map (clk       => clk,
              rst       => rst,
              lap_time  => lap_time,
              lap_mem   => lap_mem,
              h_set_in  => h_set_in,
              t_set_in  => t_set_in,
              u_sec_in  => u_sec_in,
              t_sec_in  => t_sec_in,
              u_min_in  => u_min_in,
              t_min_in  => t_min_in,
              h_set_out => h_set_out,
              t_set_out => t_set_out,
              u_sec_out => u_sec_out,
              t_sec_out => t_sec_out,
              u_min_out => u_min_out,
              t_min_out => t_min_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin

        lap_time <= '0';
        lap_mem  <= '0';
        h_set_in <= "0000";
        t_set_in <= "0000";
        u_sec_in <= "0000";
        t_sec_in <= "0000";
        u_min_in <= "0000";
        t_min_in <= "0000";

        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        t_min_in <= "0001"; -- 1
        u_min_in <= "0010"; -- 2
        t_sec_in <= "0011"; -- 3
        u_sec_in <= "0100"; -- 4
        t_set_in <= "0101"; -- 5
        h_set_in <= "0110"; -- 6
        wait for 5 * TbPeriod;


        lap_time <= '1';
        wait for TbPeriod;
        lap_time <= '0';
        wait for 5 * TbPeriod;


        u_sec_in <= "0101"; -- 5
        t_set_in <= "0000"; -- 0
        h_set_in <= "0000"; -- 0
        wait for 5 * TbPeriod;


        lap_mem <= '1';
        wait for 10 * TbPeriod;


        lap_mem <= '0';
        wait for 10 * TbPeriod;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_lap_brain of tb_lap_brain is
    for tb
    end for;
end cfg_tb_lap_brain;