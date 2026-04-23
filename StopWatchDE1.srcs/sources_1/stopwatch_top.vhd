----------------------------------------------------------------------------------
-- Název projektu: StopWatch (Digitální stopky) 
-- Název souboru:  stopwatch_top.vhd
-- Autor:          Truong Hong Minh
-- Deska:          FPGA Nexys A7 50T
--
-- Popis: 
-- Toto je hlavní (top) modul celého projektu stopek. Propojuje jednotlivé části:
-- 1. Debounce: Ošetření zákmitů tlačítek (Reset, Start/Stop, Lap).
-- 2. Clk_en: Generování hodinových impulsů pro 100 Hz (měření) a 1 kHz (displej).
-- 3. Counter_core: Samotné počítání času (setiny, sekundy, minuty).
-- 4. Lap_brain: Logika pro ukládání a prohlížení mezičasů pomocí přepínačů.
-- 5. Display_driver: Řízení 7-segmentového displeje (multiplexing).
--
-- Ovládání: BTNC resetuje vše, BTND funguje jako Start/Stop a BTNU ukládá 
-- aktuální mezičas. Přepínače SW vybírají mezičasy pro zobrazení na displeji.
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity stopwatch_top is
    port (
        clk   : in  std_logic;                     
        btnc  : in  std_logic;                     -- Tlačítko Reset
        btnu  : in  std_logic;                     -- Tlačítko Lap/Mezičas 
        btnd  : in  std_logic;                     -- Tlačítko Start/Stop
        sw    : in  std_logic_vector(5 downto 0); 
        
        seg   : out std_logic_vector(6 downto 0);  
        dp    : out std_logic;                     
        an    : out std_logic_vector(7 downto 0)   
    );
end entity stopwatch_top;

architecture structural of stopwatch_top is

    component debounce is
        port ( 
            clk       : in std_logic; 
            rst       : in std_logic; 
            btn_in    : in std_logic; 
            btn_state : out std_logic; 
            btn_press : out std_logic 
        );
    end component debounce;

    component clk_en is
        generic ( 
            G_MAX : positive 
        );
        port ( 
            clk : in std_logic; 
            rst : in std_logic; 
            ce  : out std_logic 
        );
    end component clk_en;

    component counter_core is
        port ( 
            clk   : in std_logic; 
            rst   : in std_logic; 
            ce    : in std_logic; 
            h_set : out std_logic_vector(3 downto 0); 
            t_set : out std_logic_vector(3 downto 0); 
            u_sec : out std_logic_vector(3 downto 0); 
            t_sec : out std_logic_vector(3 downto 0); 
            u_min : out std_logic_vector(3 downto 0); 
            t_min : out std_logic_vector(3 downto 0) 
        );
    end component counter_core;

    component lap_brain is
        port ( 
            clk       : in std_logic; 
            rst       : in std_logic; 
            lap_time  : in std_logic; 
            lap_mem   : in std_logic_vector(5 downto 0);
            h_set_in  : in std_logic_vector(3 downto 0); 
            t_set_in  : in std_logic_vector(3 downto 0); 
            u_sec_in  : in std_logic_vector(3 downto 0); 
            t_sec_in  : in std_logic_vector(3 downto 0); 
            u_min_in  : in std_logic_vector(3 downto 0); 
            t_min_in  : in std_logic_vector(3 downto 0); 
            h_set_out : out std_logic_vector(3 downto 0); 
            t_set_out : out std_logic_vector(3 downto 0); 
            u_sec_out : out std_logic_vector(3 downto 0); 
            t_sec_out : out std_logic_vector(3 downto 0); 
            u_min_out : out std_logic_vector(3 downto 0); 
            t_min_out : out std_logic_vector(3 downto 0) 
        );
    end component lap_brain;

    component display_driver is
        port ( 
            clk      : in std_logic; 
            rst      : in std_logic; 
            ce_1khz  : in std_logic; 
            h_set_in : in std_logic_vector(3 downto 0); 
            t_set_in : in std_logic_vector(3 downto 0); 
            u_sec_in : in std_logic_vector(3 downto 0); 
            t_sec_in : in std_logic_vector(3 downto 0); 
            u_min_in : in std_logic_vector(3 downto 0); 
            t_min_in : in std_logic_vector(3 downto 0); 
            seg      : out std_logic_vector(6 downto 0); 
            dp       : out std_logic; 
            anode    : out std_logic_vector(7 downto 0) 
        );
    end component display_driver;

    signal sig_rst_clean   : std_logic;
    signal sig_lap_pulse   : std_logic;
    signal sig_pause_pulse : std_logic; 
    signal sig_running     : std_logic := '0'; 
    
    signal sig_ce_100hz    : std_logic;
    signal sig_ce_1khz     : std_logic;
    signal sig_ce_core     : std_logic;  

    signal sig_live_h_set, sig_live_t_set : std_logic_vector(3 downto 0);
    signal sig_live_u_sec, sig_live_t_sec : std_logic_vector(3 downto 0);
    signal sig_live_u_min, sig_live_t_min : std_logic_vector(3 downto 0);

    signal sig_disp_h_set, sig_disp_t_set : std_logic_vector(3 downto 0);
    signal sig_disp_u_sec, sig_disp_t_sec : std_logic_vector(3 downto 0);
    signal sig_disp_u_min, sig_disp_t_min : std_logic_vector(3 downto 0);

begin

    debounce_rst : component debounce
        port map ( 
            clk       => clk, 
            rst       => '0', 
            btn_in    => btnc, 
            btn_state => sig_rst_clean, 
            btn_press => open 
        );

    debounce_lap : component debounce
        port map ( 
            clk       => clk, 
            rst       => '0', 
            btn_in    => btnu, 
            btn_state => open, 
            btn_press => sig_lap_pulse 
        );

    debounce_pause : component debounce
        port map ( 
            clk       => clk, 
            rst       => '0', 
            btn_in    => btnd, 
            btn_state => open, 
            btn_press => sig_pause_pulse 
        );

    p_run_toggle : process(clk)
    begin
        if rising_edge(clk) then
            if sig_rst_clean = '1' then
                sig_running <= '0'; 
            elsif sig_pause_pulse = '1' then
                sig_running <= not sig_running; 
            end if;
        end if;
    end process;

    sig_ce_core <= sig_ce_100hz and sig_running;

    clk_en_100hz : component clk_en
        generic map ( 
            G_MAX => 1_000_000 
        )
        port map ( 
            clk => clk, 
            rst => sig_rst_clean, 
            ce  => sig_ce_100hz 
        );

    clk_en_1khz : component clk_en
        generic map ( 
            G_MAX => 100_000 
        )
        port map ( 
            clk => clk, 
            rst => sig_rst_clean, 
            ce  => sig_ce_1khz 
        );

    stopwatch_core_inst : component counter_core
        port map (
            clk   => clk, 
            rst   => sig_rst_clean, 
            ce    => sig_ce_core, 
            h_set => sig_live_h_set, 
            t_set => sig_live_t_set, 
            u_sec => sig_live_u_sec, 
            t_sec => sig_live_t_sec, 
            u_min => sig_live_u_min, 
            t_min => sig_live_t_min
        );

    lap_brain_inst : component lap_brain
        port map (
            clk       => clk, 
            rst       => sig_rst_clean, 
            lap_time  => sig_lap_pulse, 
            lap_mem   => sw,      -- Zatím poue sw0
            h_set_in  => sig_live_h_set, 
            t_set_in  => sig_live_t_set, 
            u_sec_in  => sig_live_u_sec, 
            t_sec_in  => sig_live_t_sec, 
            u_min_in  => sig_live_u_min, 
            t_min_in  => sig_live_t_min,
            h_set_out => sig_disp_h_set, 
            t_set_out => sig_disp_t_set, 
            u_sec_out => sig_disp_u_sec, 
            t_sec_out => sig_disp_t_sec, 
            u_min_out => sig_disp_u_min, 
            t_min_out => sig_disp_t_min
        );

    display_driver_inst : component display_driver
        port map (
            clk      => clk, 
            rst      => sig_rst_clean, 
            ce_1khz  => sig_ce_1khz,
            h_set_in => sig_disp_h_set, 
            t_set_in => sig_disp_t_set, 
            u_sec_in => sig_disp_u_sec, 
            t_sec_in => sig_disp_t_sec, 
            u_min_in => sig_disp_u_min, 
            t_min_in => sig_disp_t_min,
            seg      => seg, 
            dp       => dp, 
            anode    => an
        );

end architecture structural;
