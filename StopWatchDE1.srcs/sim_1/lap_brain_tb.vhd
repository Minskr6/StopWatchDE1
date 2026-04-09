-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 09 Apr 2026 12:32:28 GMT
-- Request id : cfwk-fed377c2-69d79c5c41ff2

library ieee;
use ieee.std_logic_1164.all;

entity tb_LAP_BRAIN is
end tb_LAP_BRAIN;

architecture tb of tb_LAP_BRAIN is

    component LAP_BRAIN
        port (CLK      : in std_logic;
              RST      : in std_logic;
              CNT      : in std_logic_vector (6 downto 0);
              LAP_TIME : in std_logic;
              LAP_MEM  : in std_logic;
              DATA_OUT : out std_logic_vector (6 downto 0));
    end component;

    signal CLK      : std_logic;
    signal RST      : std_logic;
    signal CNT      : std_logic_vector (6 downto 0);
    signal LAP_TIME : std_logic;
    signal LAP_MEM  : std_logic;
    signal DATA_OUT : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 1000 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : LAP_BRAIN
    port map (CLK      => CLK,
              RST      => RST,
              CNT      => CNT,
              LAP_TIME => LAP_TIME,
              LAP_MEM  => LAP_MEM,
              DATA_OUT => DATA_OUT);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        CNT <= (others => '0');
        LAP_TIME <= '0';
        LAP_MEM <= '0';

        -- Reset generation
        -- ***EDIT*** Check that RST is really your reset signal
        RST <= '1';
        wait for 100 ns;
        RST <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_LAP_BRAIN of tb_LAP_BRAIN is
    for tb
    end for;
end cfg_tb_LAP_BRAIN;