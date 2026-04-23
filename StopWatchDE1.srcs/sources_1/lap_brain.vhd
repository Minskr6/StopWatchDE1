----------------------------------------------------------------------------------
-- Název projektu: StopWatch (Digitální stopky)
-- Název souboru:  lap_brain.vhd
-- Autor:          Tvarůžek Tomáš
-- Deska:          FPGA Nexys A7 50T
--
-- Popis: 
-- Logický modul pro správu mezičasů (Lap Memory).
-- 1. Ukládání: Při aktivaci 'lap_time' uloží aktuální hodnoty z '_in' portů 
--    do vnitřních registrů (celkem 6 paměťových slotů, cyklicky přepínaných).
-- 2. Reset: Signál 'rst' vynuluje ukazatel slotu i všechny uložené časy.
-- 3. Výběr: Multiplexor na výstupu zobrazuje uložený mezičas na základě 
--    jednobitového výběru v 'lap_mem'. Pokud není 
--    zvolen žádný mezičas, propouští na výstup aktuální hodnoty.
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lap_brain is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        lap_time : in  std_logic;                     
        lap_mem  : in  std_logic_vector(5 downto 0);
        
        h_set_in : in  std_logic_vector (3 downto 0);
        t_set_in : in  std_logic_vector (3 downto 0);
        u_sec_in : in  std_logic_vector (3 downto 0);
        t_sec_in : in  std_logic_vector (3 downto 0);
        u_min_in : in  std_logic_vector (3 downto 0);
        t_min_in : in  std_logic_vector (3 downto 0);
        
        h_set_out : out std_logic_vector (3 downto 0);
        t_set_out : out std_logic_vector (3 downto 0);
        u_sec_out : out std_logic_vector (3 downto 0);
        t_sec_out : out std_logic_vector (3 downto 0);
        u_min_out : out std_logic_vector (3 downto 0);
        t_min_out : out std_logic_vector (3 downto 0)
    );
end entity lap_brain;

architecture behavioral of lap_brain is

    signal sig_lap0_h_set : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap0_t_set : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap0_u_sec : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap0_t_sec : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap0_u_min : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap0_t_min : std_logic_vector(3 downto 0) := "0000";

    signal sig_lap1_h_set : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap1_t_set : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap1_u_sec : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap1_t_sec : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap1_u_min : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap1_t_min : std_logic_vector(3 downto 0) := "0000";

    signal sig_lap2_h_set : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap2_t_set : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap2_u_sec : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap2_t_sec : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap2_u_min : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap2_t_min : std_logic_vector(3 downto 0) := "0000";

    signal sig_lap3_h_set : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap3_t_set : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap3_u_sec : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap3_t_sec : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap3_u_min : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap3_t_min : std_logic_vector(3 downto 0) := "0000";

    signal sig_lap4_h_set : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap4_t_set : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap4_u_sec : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap4_t_sec : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap4_u_min : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap4_t_min : std_logic_vector(3 downto 0) := "0000";

    signal sig_lap5_h_set : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap5_t_set : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap5_u_sec : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap5_t_sec : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap5_u_min : std_logic_vector(3 downto 0) := "0000";
    signal sig_lap5_t_min : std_logic_vector(3 downto 0) := "0000";

    signal sig_ptr : integer range 0 to 5 := 0;

begin
    p_lap_memory : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sig_ptr <= 0;
                
                sig_lap0_h_set <= "0000"; sig_lap0_t_set <= "0000"; sig_lap0_u_sec <= "0000"; sig_lap0_t_sec <= "0000"; sig_lap0_u_min <= "0000"; sig_lap0_t_min <= "0000";
                sig_lap1_h_set <= "0000"; sig_lap1_t_set <= "0000"; sig_lap1_u_sec <= "0000"; sig_lap1_t_sec <= "0000"; sig_lap1_u_min <= "0000"; sig_lap1_t_min <= "0000";
                sig_lap2_h_set <= "0000"; sig_lap2_t_set <= "0000"; sig_lap2_u_sec <= "0000"; sig_lap2_t_sec <= "0000"; sig_lap2_u_min <= "0000"; sig_lap2_t_min <= "0000";
                sig_lap3_h_set <= "0000"; sig_lap3_t_set <= "0000"; sig_lap3_u_sec <= "0000"; sig_lap3_t_sec <= "0000"; sig_lap3_u_min <= "0000"; sig_lap3_t_min <= "0000";
                sig_lap4_h_set <= "0000"; sig_lap4_t_set <= "0000"; sig_lap4_u_sec <= "0000"; sig_lap4_t_sec <= "0000"; sig_lap4_u_min <= "0000"; sig_lap4_t_min <= "0000";
                sig_lap5_h_set <= "0000"; sig_lap5_t_set <= "0000"; sig_lap5_u_sec <= "0000"; sig_lap5_t_sec <= "0000"; sig_lap5_u_min <= "0000"; sig_lap5_t_min <= "0000";
                
            elsif lap_time = '1' then
                case sig_ptr is
                    when 0 =>
                        sig_lap0_h_set <= h_set_in; 
                        sig_lap0_t_set <= t_set_in;
                        sig_lap0_u_sec <= u_sec_in; 
                        sig_lap0_t_sec <= t_sec_in;
                        sig_lap0_u_min <= u_min_in; 
                        sig_lap0_t_min <= t_min_in;
                    when 1 =>
                        sig_lap1_h_set <= h_set_in; 
                        sig_lap1_t_set <= t_set_in;
                        sig_lap1_u_sec <= u_sec_in; 
                        sig_lap1_t_sec <= t_sec_in;
                        sig_lap1_u_min <= u_min_in; 
                        sig_lap1_t_min <= t_min_in;
                    when 2 =>
                        sig_lap2_h_set <= h_set_in; 
                        sig_lap2_t_set <= t_set_in;
                        sig_lap2_u_sec <= u_sec_in; 
                        sig_lap2_t_sec <= t_sec_in;
                        sig_lap2_u_min <= u_min_in; 
                        sig_lap2_t_min <= t_min_in;
                    when 3 =>
                        sig_lap3_h_set <= h_set_in; 
                        sig_lap3_t_set <= t_set_in;
                        sig_lap3_u_sec <= u_sec_in; 
                        sig_lap3_t_sec <= t_sec_in;
                        sig_lap3_u_min <= u_min_in; 
                        sig_lap3_t_min <= t_min_in;
                    when 4 =>
                        sig_lap4_h_set <= h_set_in; 
                        sig_lap4_t_set <= t_set_in;
                        sig_lap4_u_sec <= u_sec_in; 
                        sig_lap4_t_sec <= t_sec_in;
                        sig_lap4_u_min <= u_min_in; 
                        sig_lap4_t_min <= t_min_in;
                    when 5 =>
                        sig_lap5_h_set <= h_set_in; 
                        sig_lap5_t_set <= t_set_in;
                        sig_lap5_u_sec <= u_sec_in; 
                        sig_lap5_t_sec <= t_sec_in;
                        sig_lap5_u_min <= u_min_in; 
                        sig_lap5_t_min <= t_min_in;
                    when others =>
                        null;
                end case;
                
                if sig_ptr = 5 then
                    sig_ptr <= 0;
                else
                    sig_ptr <= sig_ptr + 1;
                end if;
            end if;
        end if;
    end process p_lap_memory;
    
    h_set_out <= sig_lap0_h_set when lap_mem(0) = '1' else
                 sig_lap1_h_set when lap_mem(1) = '1' else
                 sig_lap2_h_set when lap_mem(2) = '1' else
                 sig_lap3_h_set when lap_mem(3) = '1' else
                 sig_lap4_h_set when lap_mem(4) = '1' else
                 sig_lap5_h_set when lap_mem(5) = '1' else
                 h_set_in;

    t_set_out <= sig_lap0_t_set when lap_mem(0) = '1' else
                 sig_lap1_t_set when lap_mem(1) = '1' else
                 sig_lap2_t_set when lap_mem(2) = '1' else
                 sig_lap3_t_set when lap_mem(3) = '1' else
                 sig_lap4_t_set when lap_mem(4) = '1' else
                 sig_lap5_t_set when lap_mem(5) = '1' else
                 t_set_in;

    u_sec_out <= sig_lap0_u_sec when lap_mem(0) = '1' else
                 sig_lap1_u_sec when lap_mem(1) = '1' else
                 sig_lap2_u_sec when lap_mem(2) = '1' else
                 sig_lap3_u_sec when lap_mem(3) = '1' else
                 sig_lap4_u_sec when lap_mem(4) = '1' else
                 sig_lap5_u_sec when lap_mem(5) = '1' else
                 u_sec_in;

    t_sec_out <= sig_lap0_t_sec when lap_mem(0) = '1' else
                 sig_lap1_t_sec when lap_mem(1) = '1' else
                 sig_lap2_t_sec when lap_mem(2) = '1' else
                 sig_lap3_t_sec when lap_mem(3) = '1' else
                 sig_lap4_t_sec when lap_mem(4) = '1' else
                 sig_lap5_t_sec when lap_mem(5) = '1' else
                 t_sec_in;

    u_min_out <= sig_lap0_u_min when lap_mem(0) = '1' else
                 sig_lap1_u_min when lap_mem(1) = '1' else
                 sig_lap2_u_min when lap_mem(2) = '1' else
                 sig_lap3_u_min when lap_mem(3) = '1' else
                 sig_lap4_u_min when lap_mem(4) = '1' else
                 sig_lap5_u_min when lap_mem(5) = '1' else
                 u_min_in;

    t_min_out <= sig_lap0_t_min when lap_mem(0) = '1' else
                 sig_lap1_t_min when lap_mem(1) = '1' else
                 sig_lap2_t_min when lap_mem(2) = '1' else
                 sig_lap3_t_min when lap_mem(3) = '1' else
                 sig_lap4_t_min when lap_mem(4) = '1' else
                 sig_lap5_t_min when lap_mem(5) = '1' else
                 t_min_in;

end architecture behavioral;
