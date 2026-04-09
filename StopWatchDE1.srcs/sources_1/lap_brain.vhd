library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LAP_BRAIN is
    Port (
        CLK      : in  STD_LOGIC;                     -- Hlavní hodiny
        RST      : in  STD_LOGIC;                     -- Reset
        CNT      : in  STD_LOGIC_VECTOR (6 downto 0);  -- Vstupní data z čítače (SIG_CNT)
        LAP_TIME : in  STD_LOGIC;                     -- Impuls pro uložení času (SIG_LAPT)
        LAP_MEM  : in  STD_LOGIC;                     -- Přepínač zobrazení (SIG_LAP_MEM)
        DATA_OUT : out STD_LOGIC_VECTOR (6 downto 0)  -- Výstup na dekodér (DATA 6:0)
    );
end LAP_BRAIN;

architecture Behavioral of LAP_BRAIN is
    -- Vnitřní registr pro uložení mezičasu
    signal sig_lap_reg : std_logic_vector(6 downto 0) := (others => '0');
begin

    -- Synchronní proces pro uložení hodnoty při impulsu LAP_TIME
    p_lap_memory : process(CLK)
    begin
        if rising_edge(CLK) then
            if (RST = '1') then
                sig_lap_reg <= (others => '0');
            elsif (LAP_TIME = '1') then
                -- "Vyfotíme" aktuální stav čítače do paměti
                sig_lap_reg <= CNT;
            end if;
        end if;
    end process p_lap_memory;

    -- Výstupní multiplexor ovládaný signálem LAP_MEM
    -- Pokud je LAP_MEM = '1', na displej jde uložená hodnota (Memory)
    -- Pokud je LAP_MEM = '0', na displej jde aktuální čas (Live)
    DATA_OUT <= sig_lap_reg when (LAP_MEM = '1') else
                CNT;

end Behavioral;