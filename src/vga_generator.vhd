library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_generator is
	-- VGA parameters
	generic (
		h_visible : integer;
		hsync_start : integer;
		hsync_stop : integer;
		h_total : integer;
		v_visible : integer;
		vsync_start : integer;
		vsync_stop : integer;
		v_total : integer
	);
	port (
		clk: in std_logic;
		hsync: out std_logic := '0';
		vsync: out std_logic := '0';
		red: out std_logic_vector(2 downto 0) := "000";
		green: out std_logic_vector(2 downto 0) := "000";
		blue: out std_logic_vector(1 downto 0) := "00"
	);
end vga_generator;

architecture behavioral of vga_generator is
	signal x, y : std_logic_vector(10 downto 0) := "00000000000";
	signal color : std_logic_vector(7 downto 0) := "00000000";
begin

	red <= color(7 downto 5);
	green <= color(4 downto 2);
	blue <= color(1 downto 0);

	process (clk)
		variable xxory : std_logic_vector(10 downto 0);
	begin
		if rising_edge(clk) then
			
			-- generate x, y counters
			if unsigned(x) < h_total - 1 then
				x <= std_logic_vector(unsigned(x) + 1);
			else
				x <= "00000000000";
				if unsigned(y) < v_total - 1 then
					y <= std_logic_vector(unsigned(y) + 1);
				else
					y <= "00000000000";
				end if;
			end if;
			
			-- hsync and vsync signal generation
			if hsync_start <= unsigned(x) and unsigned(x) < hsync_stop then hsync <= '0'; else hsync <= '1'; end if;
			if vsync_start <= unsigned(y) and unsigned(y) < vsync_stop then vsync <= '0'; else vsync <= '1'; end if;

			-- color generation
			xxory := x xor y;
			if unsigned(x) < h_visible and unsigned(y) < v_visible then color <= xxory(7 downto 0); else color <= "00000000"; end if;
		end if;
	end process;
	
end behavioral;

