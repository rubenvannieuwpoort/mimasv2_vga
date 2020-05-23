library ieee;
use ieee.std_logic_1164.all;

entity main is
	port (
		clk_in: in std_logic;
		dp_switch: in std_logic_vector(7 downto 0);
		push_switch: in std_logic_vector(5 downto 0);
		
		led: out std_logic_vector(7 downto 0);
		seven_segment: out std_logic_vector(7 downto 0);
		seven_segment_enable: out std_logic_vector(2 downto 0);
		vga_hsync: out std_logic;
		vga_vsync: out std_logic;
		vga_r: out std_logic_vector(2 downto 0);
		vga_g: out std_logic_vector(2 downto 0);
		vga_b: out std_logic_vector(2 downto 1)
	);
end main;

architecture Behavioral of main is

	signal clk, clk_generated: std_logic;
	
	component clock_generator
		port (
			clk_in : in std_logic;
			clk_out : out std_logic
		);
	end component;
	
	component vga_generator is
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
	end component;
	
begin

	led(7 downto 0) <= "00000000";
	seven_segment <= "11111111";
	seven_segment_enable <= "000";
		
	-- clocking
	clock_gen: clock_generator port map(clk_in => clk_in, clk_out => clk);
	
	-- vga generation
	vga_gen: vga_generator generic map (
		-- 640x480@60Hz -- use 25.175MHz clock
		--h_visible => 640, hsync_start => 656, hsync_stop => 752, h_total => 800,
	   --v_visible => 480,  vsync_start => 490,  vsync_stop => 492,  v_total => 525
		
		-- 800x600@60Hz -- use 40MHz clock
		--h_visible => 800, hsync_start => 840, hsync_stop => 968, h_total => 1056,
	   --v_visible => 600,  vsync_start => 601,  vsync_stop => 605,  v_total => 628
		
		-- 1280x720@60Hz -- use 74.25MHz clock
		--h_visible => 1280, hsync_start => 1390, hsync_stop => 1430, h_total => 1570,
	   --v_visible => 720,  vsync_start => 725,  vsync_stop => 730,  v_total => 750
		
		-- 1280x720@60Hz -- use 75MHz clock
		h_visible => 1280, hsync_start => 1352, hsync_stop => 1432, h_total => 1647,
	   v_visible => 720,  vsync_start => 723,  vsync_stop => 728,  v_total => 750
	)
	port map(clk => clk, red => vga_r, green => vga_g, blue => vga_b, hsync => vga_hsync, vsync => vga_vsync);

end Behavioral;
