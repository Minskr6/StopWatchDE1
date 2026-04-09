----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2026 01:28:19 PM
-- Design Name: 
-- Module Name: counter_core - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter_core is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ce : in STD_LOGIC;
           h_set : out STD_LOGIC_VECTOR (3 downto 0);
           t_set : out STD_LOGIC_VECTOR (3 downto 0);
           u_sec : out STD_LOGIC_VECTOR (3 downto 0);
           t_sec : out STD_LOGIC_VECTOR (3 downto 0);
           u_min : out STD_LOGIC_VECTOR (3 downto 0);
           t_min : out STD_LOGIC_VECTOR (3 downto 0));
end counter_core;

architecture Behavioral of counter_core is

    component counter is
        generic (
        G_BITS : positive;  --! Default number of bits
        G_MAX : integer
    );
    port (
        clk : in  std_logic;                             --! Main clock
        rst : in  std_logic;                             --! High-active synchronous reset
        en  : in  std_logic;                             --! Clock enable input
        cnt : out std_logic_vector(G_BITS - 1 downto 0);  --! Counter value
        ceo : out std_logic
    );
end component counter;

signal sig_ceo0, sig_ceo1, sig_ceo2, sig_ceo3, sig_ceo4 : std_logic;

begin

   cnt_h_set : component counter
        generic map(G_MAX => 9, G_BITS => 4)
        port map(
            clk => clk,
            rst => rst,
            en => ce,
            cnt => h_set,
            ceo => sig_ceo0
            );
           

    cnt_t_set : component counter
        generic map(G_MAX => 9, G_BITS => 4)
        port map(
            clk => clk, 
            rst => rst, 
            en => sig_ceo0,
            cnt => t_set, 
            ceo => sig_ceo1
            );

    cnt_u_sec : component counter
        generic map(G_MAX => 9, G_BITS => 4)
        port map(
            clk => clk, 
            rst => rst, 
            en => sig_ceo1,
            cnt => u_sec, 
            ceo => sig_ceo2
            );

    cnt_t_sec : component counter
        generic map(G_MAX => 5, G_BITS => 4)
        port map(clk => clk, 
            rst => rst, 
            en => sig_ceo2, 
            cnt => t_sec, 
            ceo => sig_ceo3
            );

    cnt_u_min : component counter
        generic map(G_MAX => 9, G_BITS => 4)
        port map(
            clk => clk, 
            rst => rst, 
            en => sig_ceo3, 
            cnt => u_min, 
            ceo => sig_ceo4
            );

    cnt_t_min : component counter
        generic map(G_MAX => 5, G_BITS => 4)
        port map(
            clk => clk, 
            rst => rst, 
            en => sig_ceo4, 
            cnt => t_min, 
            ceo => open
            );


end Behavioral;
