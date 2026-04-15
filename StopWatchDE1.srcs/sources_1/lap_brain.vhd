library ieee;
use ieee.std_logic_1164.all;

entity lap_brain is
    port (
        clk      : in  std_logic;                     
        rst      : in  std_logic;                     
        lap_time : in  std_logic;                     
        lap_mem  : in  std_logic;                     
        
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

    signal sig_lap_h_set : std_logic_vector(3 downto 0) := (others => '0');
    signal sig_lap_t_set : std_logic_vector(3 downto 0) := (others => '0');
    signal sig_lap_u_sec : std_logic_vector(3 downto 0) := (others => '0');
    signal sig_lap_t_sec : std_logic_vector(3 downto 0) := (others => '0');
    signal sig_lap_u_min : std_logic_vector(3 downto 0) := (others => '0');
    signal sig_lap_t_min : std_logic_vector(3 downto 0) := (others => '0');
begin

    p_lap_memory : process(clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                sig_lap_h_set <= (others => '0');
                sig_lap_t_set <= (others => '0');
                sig_lap_u_sec <= (others => '0');
                sig_lap_t_sec <= (others => '0');
                sig_lap_u_min <= (others => '0');
                sig_lap_t_min <= (others => '0');
            elsif (lap_time = '1') then
                sig_lap_h_set <= h_set_in;
                sig_lap_t_set <= t_set_in;
                sig_lap_u_sec <= u_sec_in;
                sig_lap_t_sec <= t_sec_in;
                sig_lap_u_min <= u_min_in;
                sig_lap_t_min <= t_min_in;
            end if;
        end if;
    end process p_lap_memory;

    h_set_out <= sig_lap_h_set when (lap_mem = '1') else h_set_in;
    t_set_out <= sig_lap_t_set when (lap_mem = '1') else t_set_in;
    u_sec_out <= sig_lap_u_sec when (lap_mem = '1') else u_sec_in;
    t_sec_out <= sig_lap_t_sec when (lap_mem = '1') else t_sec_in;
    u_min_out <= sig_lap_u_min when (lap_mem = '1') else u_min_in;
    t_min_out <= sig_lap_t_min when (lap_mem = '1') else t_min_in;

end architecture behavioral;