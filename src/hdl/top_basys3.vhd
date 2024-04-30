--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
-- TODO
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	-- declare components and signals

    -- Signals --
    signal w_clk : std_logic; -- the clock signal for the mux to select a digit from the calculations
    signal w_cycle : std_logic_vector (3 downto 0); -- the dataline for the current state, connects to output debugging leds
    signal w_reg_A : std_logic_vector (3 downto 0); -- the dataline for the first register
    signal w_reg_B : std_logic_vector (3 downto 0); -- the dataline for the second register
    signal w_flags : std_logic_vector (3 downto 0); -- the dataline for the output leds for the flags from the math
    signal w_result : std_logic_vector (3 downto 0); -- the dataline from the ALU to the mux
    signal w_mux_to_alu : std_logic_vector (3 downto 0); -- the dataline from the mux to the binary to decimal converter box
    signal w_tdm_to_7seg : std_logic_vector (3 downto 0); -- the dataline from the TDM to the Seven Segment Decoder
    signal w_sel : std_logic_vector (3 downto 0); -- the data line from the TDM which selects the anode to be on for the final output on the seven segmetn display
    -- input signals --
    signal w_sw_7_0_in : std_logic_vector ( 7 downto 0); -- the dataline from the switches 7:0 for the inputs
    signal w_sw_2_0_in : std_logic_vector ( 3 downto 0); -- the dataline from the op code selecting switches to the alu
    signal w_btnU_in : std_logic ; -- the reset button line
    signal w_btnC_in : std_logic ; -- the advance button line
     
  
begin
	-- PORT MAPS ----------------------------------------

	
	
	-- CONCURRENT STATEMENTS ----------------------------

	
	
	
end top_basys3_arch;
