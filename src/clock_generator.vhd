library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

entity clock_generator is
	port(
		clk_in : in std_logic;
		clk_out : out std_logic
	);
end clock_generator;

architecture Behavioral of clock_generator is
	signal clk_in_buf, clk_feedback, clk_feedback_buf, clkout0 : std_logic;
begin
	input_buffer : IBUFG port map( I => clk_in, O => clk_in_buf );
	
	pll : PLL_BASE
	generic map(
		BANDWIDTH => "OPTIMIZED",
		CLK_FEEDBACK => "CLKFBOUT",
		COMPENSATION => "SYSTEM_SYNCHRONOUS",
		DIVCLK_DIVIDE => 5,
		CLKFBOUT_MULT => 52,
		CLKFBOUT_PHASE => 0.000,
		CLKOUT0_DIVIDE => 14,
		CLKOUT0_PHASE => 0.000,
		CLKOUT0_DUTY_CYCLE => 0.964,
		CLKIN_PERIOD => 10.000,
		REF_JITTER => 0.010
	)
	port map(
		CLKFBOUT => clk_feedback,
		CLKOUT0 => clkout0,
		RST => '0',
		CLKFBIN => clk_feedback_buf,
		CLKIN => clk_in_buf
	);

	feedback_buffer : BUFG port map( I => clk_feedback, O => clk_feedback_buf );
	
	output_buffer : BUFG port map( I => clkout0, O => clk_out);
end Behavioral;
