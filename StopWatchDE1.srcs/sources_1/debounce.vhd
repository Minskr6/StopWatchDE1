library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce is
    Port ( clk       : in  STD_LOGIC;
           rst       : in  STD_LOGIC;
           btn_in    : in  STD_LOGIC;
           btn_state : out STD_LOGIC;
           btn_press : out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
    ----------------------------------------------------------------
    -- Konstanty
    ----------------------------------------------------------------
    constant C_SHIFT_LEN : positive := 4; 
    
    -- POZOR: Pro simulaci použij 4, pro reálné tlačítko 200_000
    constant C_MAX       : positive := 200_000; 

    ----------------------------------------------------------------
    -- Vnitřní signály
    ----------------------------------------------------------------
    signal ce_sample : std_logic;
    signal sync0     : std_logic := '0';
    signal sync1     : std_logic := '0';
    signal shift_reg : std_logic_vector(C_SHIFT_LEN-1 downto 0) := (others => '0');
    signal debounced : std_logic := '0';
    signal delayed   : std_logic := '0';

    -- Deklarace komponenty (musí odpovídat souboru clk_en.vhd)
    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;

begin
    -- Instance čítače pro vzorkování
    clock_0 : clk_en
        generic map ( G_MAX => C_MAX )
        port map (
            clk => clk,
            rst => rst,
            ce  => ce_sample
        );

    p_debounce : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sync0     <= '0';
                sync1     <= '0';
                shift_reg <= (others => '0');
                debounced <= '0';
                delayed   <= '0';
            else
                -- Synchronizace vstupu (proti metastabilitě)
                sync0 <= btn_in;
                sync1 <= sync0;

                -- Vzorkování tlačítka
                if ce_sample = '1' then
                    -- Posun registru a přidání nového vzorku
                    shift_reg <= shift_reg(C_SHIFT_LEN-2 downto 0) & sync1;

                    -- Logika rozhodování
                    if shift_reg = (shift_reg'range => '1') then
                        debounced <= '1';
                    elsif shift_reg = (shift_reg'range => '0') then
                        debounced <= '0';
                    end if;
                end if;

                -- Zpoždění pro detekci hrany
                delayed <= debounced;
            end if;
        end if;
    end process;

    -- Přiřazení výstupů
    btn_state <= debounced;
    btn_press <= debounced and not(delayed); -- Puls při stisku

end Behavioral;
