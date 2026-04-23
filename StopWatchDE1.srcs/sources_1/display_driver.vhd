----------------------------------------------------------------------------------
-- Název projektu:  StopWatch (Digitální stopky)
-- Název souboru:   display_driver.vhd
-- Autor:           Vocilka Jiří
-- Deska:           FPGA Nexys A7 50T
--
-- Popis: 
-- Modul pro řízení 7-segmentového displeje metodou časového multiplexu.
-- 1. Čítač (sig_digit) přepíná mezi 6 aktivními pozicemi na displeji frekvencí 1 kHz.
-- 2. Multiplexor vybírá odpovídající vstupní data (setiny, sekundy, minuty)
--    a aktivuje příslušnou anodu (aktivní v log. 0).
-- 3. Tečky (dp) jsou nastaveny napevno tak, aby oddělovaly setiny od sekund a sekundy od minut.
-- 4. Pro převod čísel na segmenty je použit dříve vytvořený modul 'bin2seg'.
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_driver is
    port ( 
           clk       : in  std_logic;
           rst       : in  std_logic;
           ce_1khz   : in  std_logic;
           
           h_set_in  : in  std_logic_vector (3 downto 0);
           t_set_in  : in  std_logic_vector (3 downto 0);
           u_sec_in  : in  std_logic_vector (3 downto 0);
           t_sec_in  : in  std_logic_vector (3 downto 0);
           u_min_in  : in  std_logic_vector (3 downto 0);
           t_min_in  : in  std_logic_vector (3 downto 0);
           
           seg       : out std_logic_vector (6 downto 0);
           dp        : out std_logic;                     
           anode     : out std_logic_vector (7 downto 0)
    );
end display_driver;

architecture behavioral of display_driver is

    component bin2seg is
        port ( 
            bin : in  std_logic_vector (3 downto 0);
            seg : out std_logic_vector (6 downto 0)
        );
    end component bin2seg;
 
    signal sig_digit : unsigned(2 downto 0) := (others => '0'); 
    signal sig_bin   : std_logic_vector(3 downto 0);
    
begin

    p_digit_counter : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sig_digit <= (others => '0');
            elsif ce_1khz = '1' then
                sig_digit <= sig_digit + 1;
            end if;
        end if;
    end process;

    p_mux : process(sig_digit, h_set_in, t_set_in, u_sec_in, t_sec_in, u_min_in, t_min_in)
    begin

        sig_bin <= "0000";
        dp      <= '1'; 
        anode   <= "11111111";

        case sig_digit is
            when "000" =>
                sig_bin <= h_set_in;
                anode   <= "11111110";
            when "001" =>
                sig_bin <= t_set_in;
                anode   <= "11111101";
            when "010" =>
                sig_bin <= u_sec_in;
                dp      <= '0';
                anode   <= "11111011";
            when "011" =>
                sig_bin <= t_sec_in;
                anode   <= "11110111";
            when "100" =>
                sig_bin <= u_min_in;
                dp      <= '0';
                anode   <= "11101111";
            when "101" =>
                sig_bin <= t_min_in;
                anode   <= "11011111";
            when others =>
                null;
        end case;
    end process;

    decoder_0 : bin2seg
        port map (
            bin => sig_bin,
            seg => seg
        );

end behavioral;
