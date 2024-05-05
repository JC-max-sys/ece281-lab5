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
    port(
        -- inputs
        clk : in std_logic;
        btnU : in std_logic;
        btnC : in std_logic;
        sw3 : in std_logic_vector(3 downto 0);
        sw7 : in std_logic_vector(7 downto 0);
        led_cycle : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(7 downto 0);
        an : out std_logic_vector(3 downto 0);
        led_flags : out std_logic_vector(15 downto 13)
        
        
        -- outputs

    );
end top_basys3;



architecture top_basys3_arch of top_basys3 is 
  
	-- declare components and signals
	  
	
	signal w_clk_in : std_logic; -- wire for the tdm clock to have multiple 7seg displays cycled through, connects to the clk divider
	signal w_btnU_in : std_logic; -- wire for the reset, connects to FSM
	signal w_btnC_in : std_logic; -- wire for the advance command, connects to FSM
	signal w_sw_2_0_in : std_logic_vector(2 downto 0); -- wire for opcode input, connects to ALU
	signal w_sw_7_0_in : std_logic_vector(7 downto 0); -- wire for the numerical value input, connects to reg a, connects to reg b
	signal w_cycle_out : std_logic_vector(3 downto 0); -- one hot signal for the fsm state, selects which number is displayed in the mux, and outputs to leds for debugging, connects to both registers and decides which one receives an input in a current state within the FSM
	signal w_A_out : std_logic_vector(7 downto 0); -- signal from the register A, connects to AUL
	signal w_b_out : std_logic_vector(7 downto 0); -- signal from the register B, connects to ALU
	signal w_flags_out : std_logic_vector(2 downto 0); -- signal for the output flags, make sure to connect it to led 15-13
	signal w_mux_out : std_logic_vector(7 downto 0); -- signal for the selected item to be displayed from the mux, goes to 2s compt converter
	signal w_sign : std_logic_vector(3 downto 0); -- signal for the sign of the value, connects to TDM4
	signal w_hund : std_logic_vector(3 downto 0); -- signal for the hundreds place, connects to TDM4
	signal w_tens : std_logic_vector(3 downto 0); -- signal for the tens place, connects to TDM4
	signal w_ones : std_logic_vector(3 downto 0); -- signal for the ones place, connects to TDM4
	signal w_seven_seg_val : std_logic_vector(3 downto 0); -- signal for the current number to be displayed to the 7seg decoder, connects to 7seg
	signal w_clk_out : std_logic ; -- signal for the clock that cycles the TDM faster than the eye can see, connects to the TDM4
	signal w_annode_out : std_logic_vector(7 downto 0); -- signal for the output of the annodes
	 
	
	--component Register A
	
	
	--component Register B
	
	
	--component ALU
	
	
	
	--component MUX
	
	
	--component Twos Complement to decimal converter
	
	
	
	--component TDM4
	
	
	--,component Seven Segment Decoder
	
	
	
	--component Clock Divider
	
	
	--component Controller FSM
	
	
	
	
	
	
	
	
	

    -- Signals --
    signal w_clk : std_logic; -- the clock signal for the mux to select a digit from the calculations
    signal w_cycle_out : std_logic_vector (3 downto 0); -- the dataline for the current state, connects to output debugging leds
    signal w_reg_A : std_logic_vector (3 downto 0); -- the dataline for the first register
    signal w_reg_B : std_logic_vector (3 downto 0); -- the dataline for the second register
    signal w_flags : std_logic_vector (3 downto 0); -- the dataline for the output leds for the flags from the math
    signal w_result : std_logic_vector (3 downto 0); -- the dataline from the ALU to the mux
    signal w_mux_to_converter : std_logic_vector (3 downto 0); -- the dataline from the mux to the binary to decimal converter box
    signal w_tdm_to_7seg : std_logic_vector (3 downto 0); -- the dataline from the TDM to the Seven Segment Decoder
    signal w_7seg_out : std_logic_vector (3 downto 0); -- dataline from seven segment decoder to the seven segment display
    signal w_sel : std_logic_vector (3 downto 0); -- the data line from the TDM which selects the anode to be on for the final output on the seven segmetn display
    -- input signals --
    signal w_sw_7_0_in : std_logic_vector ( 7 downto 0); -- the dataline from the switches 7:0 for the inputs
    signal w_sw_2_0_in : std_logic_vector ( 3 downto 0); -- the dataline from the op code selecting switches to the alu
    signal w_btnU_in : std_logic ; -- the reset button line
    signal w_btnC_in : std_logic ; -- the advance button line
     
  
begin
	-- PORT MAPS ----------------------------------------
        -- Register A 
            -- inputs
                -- w_sw_7_0_in 
                -- w_cycle_out
            -- outputs
                -- w_A_out
           
        
        
    
        -- Register B
            -- inputs
                 -- w_sw_7_0_in 
                 -- w_cycle_out
            -- outputs
                 -- w_B_out
        
        -- ALU
            -- inputs
                -- w_reg_A
                -- w_reg_B
                -- w_sw_2_0_in -- this is the opcode slectlines
            -- outputs
                -- w_result -- result from alu
                -- w_flags_out 
             
        
        -- MUX
            -- inputs
               -- w_reg_A
               -- w_reg_B
               -- w_result
               -- w_cycle_out
           -- outputs 
              -- w_mux_to_converter   
           
                   
        -- Twos Complement to decimal converter
            -- inputs
                -- w_mux_to_converter
            -- outputs
                -- w_sign
                -- w_hund
                -- w_tens
                -- w_ones
                
        
        -- TDM4
            -- inputs
                -- w_sign
                -- w_hund
                -- w_tens
                -- w_ones
                -- w_clk
           -- outputs
                -- w_sel
                -- w_tdm_to_7seg
             
        
        -- Seven Segment Decoder
            -- inputs
                -- w_tdm_to_7seg
            -- outputs
                -- w_7seg_out
        
        
        -- Clock Divider
            -- inputs 
                -- w_clk_in
            -- outputs
                -- w_clk
        
        
        -- Controller FSM
            -- inputs
                -- w_btnU_in
                -- w_btnC_in
            -- outputs
                -- w_cycle_out
	
	
	-- CONCURRENT STATEMENTS ----------------------------

	
	
	
end top_basys3_arch;
