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
--        sw3 : in std_logic_vector(2 downto 0);
        sw : in std_logic_vector(7 downto 0);
        led : out std_logic_vector(15 downto 0);
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0)
       
        
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
	signal w_cycle_out : std_logic_vector(1 downto 0); -- binary signal for the fsm state, selects which number is displayed in the mux, and outputs to leds for debugging, connects to both registers and decides which one receives an input in a current state within the FSM
	signal w_A_out : std_logic_vector(7 downto 0); -- signal from the register A, connects to AUL
	signal w_B_out : std_logic_vector(7 downto 0); -- signal from the register B, connects to ALU
	signal w_ALU_out : std_logic_vector(7 downto 0); -- result of the alu
	signal w_flags_out : std_logic_vector(2 downto 0); -- signal for the output flags, make sure to connect it to led 15-13
	signal w_mux_out : std_logic_vector(7 downto 0); -- signal for the selected item to be displayed from the mux, goes to 2s compt converter
	signal w_sign : std_logic_vector(3 downto 0); -- signal for the sign of the value, connects to TDM4
	signal w_hund : std_logic_vector(3 downto 0); -- signal for the hundreds place, connects to TDM4
	signal w_tens : std_logic_vector(3 downto 0); -- signal for the tens place, connects to TDM4
	signal w_ones : std_logic_vector(3 downto 0); -- signal for the ones place, connects to TDM4
	signal w_seven_seg_val : std_logic_vector(3 downto 0); -- signal for the current number to be displayed to the 7seg decoder, connects to 7seg
	signal w_clk_out : std_logic ; -- signal for the clock that cycles the TDM faster than the eye can see, connects to the TDM4
	signal w_annode_out : std_logic_vector(7 downto 0); -- signal for the output of the annodes
	signal w_cathode_out : std_logic_vector(3 downto 0); -- signal for to select which 7 seg is on
	signal sw3 : std_logic_vector(2 downto 0);
	signal sw7 : std_logic_vector(7 downto 0);
	 
-- connection of all the wires to the outside world occure here

    
    






	--component Register A
	component reg is 
	   Port ( val_in : in STD_LOGIC_VECTOR (7 downto 0);
               cycle_in : in STD_LOGIC_VECTOR (1 downto 0);
               val_out : out STD_LOGIC_VECTOR (7 downto 0)
      );
      end component reg;
           
	
	--component Register B
	  component reg1 is 
           Port ( val_in : in STD_LOGIC_VECTOR (7 downto 0);
                   cycle_in : in STD_LOGIC_VECTOR (1 downto 0);
                   val_out : out STD_LOGIC_VECTOR (7 downto 0)
          );
          end component reg1;
	
	--component ALU
	component ALU is
	 port(
           i_A : in std_logic_vector(7 downto 0); -- connection of A register to alu
           i_B : in std_logic_vector(7 downto 0); -- connection of b register to alu
           i_opcode : in std_logic_vector(2 downto 0); -- connection of opcode input to alu
           o_result : out std_logic_vector(7 downto 0); -- output of the desired calculation based on the opcode
           o_flags : out std_logic_vector(2 downto 0) -- output of the flags
       );
       end component ALU;
	
	
	--component 4:1 MUX
	component mux_4_to_1 is
        Port ( i_sel : in STD_LOGIC_VECTOR (1 downto 0);
               i_data_in_a : in STD_LOGIC_VECTOR (7 downto 0);
               i_data_in_b : in STD_LOGIC_VECTOR (7 downto 0);
               i_data_in_c : in STD_LOGIC_VECTOR (7 downto 0);
               i_data_in_d : in STD_LOGIC_VECTOR (7 downto 0);
               o_data_out : out STD_LOGIC_VECTOR (7 downto 0)
               );
     end component mux_4_to_1;
	
	
	--component Twos Complement to decimal converter
	component twoscomp_decimal is
	 port (
             i_binary: in std_logic_vector(7 downto 0);
             o_negative: out std_logic_vector(3 downto 0);
             o_hundreds: out std_logic_vector(3 downto 0);
             o_tens: out std_logic_vector(3 downto 0);
             o_ones: out std_logic_vector(3 downto 0)
       );
    end component twoscomp_decimal;
	
	
	--component TDM4
	component TDM4 is 
	 generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
	 Port ( i_clk		: in  STD_LOGIC;
                i_reset        : in  STD_LOGIC; -- asynchronous
                i_D3         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
                i_D2         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
                i_D1         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
                i_D0         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
                o_data        : out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
                o_sel        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
       );
      end component TDM4;
	
	
	--component Seven Segment Decoder
    component positive_negative_7_segment_display is
        Port ( i_D : in STD_LOGIC_VECTOR (3 downto 0);
              o_s : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component positive_negative_7_segment_display;	
	
	--component Clock Divider
    component clock_divider is
               generic ( constant k_DIV : natural := 2 );
               port (
                   i_clk : in STD_LOGIC;
                   i_reset  : in std_logic;  
                   o_clk : out STD_LOGIC
                   
                   
               );
               end component clock_divider;
	
	--component Controller FSM
	component controller_FSM is
	    Port ( i_reset : in STD_LOGIC;
              i_advance : in STD_LOGIC;
              o_cycle : out STD_LOGIC_VECTOR (1 downto 0);
              i_clk : in STD_LOGIC
        );
        end component controller_FSM;
        
              
     
  
begin
    sw3 <= sw(2 downto 0);
  
    sw7 <= sw(7 downto 0);
    led(12 downto 4) <= x"00"&'0';
    w_btnU_in <= btnU;
    w_btnC_in <= btnC;
    
	-- PORT MAPS ----------------------------------------
        -- Register A 
            -- inputs
                -- w_sw_7_0_in 
                -- w_cycle_out
            -- outputs
                -- w_A_out
        Reg_inst : reg
           Port map(
                   val_in =>  sw7, 
                   cycle_in => w_cycle_out,
                   val_out => w_A_out
            );
         

        -- Register B
            -- inputs
                 -- w_sw_7_0_in 
                 -- w_cycle_out
            -- outputs
                 -- w_B_out
          Reg1_inst : reg1
                   Port map(
                           val_in => sw7(7 downto 0),
                           cycle_in => w_cycle_out,
                           val_out => w_B_out
                    );
        
        -- ALU
            -- inputs
                -- w_reg_A
                -- w_reg_B
                -- w_sw_2_0_in -- this is the opcode slectlines
            -- outputs
                -- w_result -- result from alu
                -- w_flags_out 
         ALU_inst : ALU
             Port map(
                i_A => w_A_out, -- connection of A register to alu
                i_B => w_B_out, -- connection of b register to alu
                i_opcode => sw(2 downto 0),-- connection of opcode input to alu
                o_result => w_ALU_out,  -- output of the desired calculation based on the opcode
                o_flags => led(15 downto 13) -- output of the flags
            );
              

        -- MUX
            -- inputs
               -- w_reg_A
               -- w_reg_B
               -- w_result
               -- w_cycle_out
           -- outputs 
              -- w_mux_to_converter   
            mux_4_to_1_inst : mux_4_to_1
                 Port map (
                      i_sel => w_cycle_out(1 downto 0), -- current working directory
                      i_data_in_a => w_A_out,
                      i_data_in_b => w_B_out,
                      i_data_in_c => w_ALU_out,
                      i_data_in_d => "00011010",
                      o_data_out => w_mux_out
                      );
           
          
        -- Twos Complement to decimal converter
            -- inputs
                -- w_mux_to_converter
            -- outputs
                -- w_sign
                -- w_hund
                -- w_tens
                -- w_ones
         twoscomp_decimal_inst : twoscomp_decimal
             port map (
                i_binary => w_mux_out,
                o_negative => w_sign,
                o_hundreds => w_hund,
                o_tens => w_tens,
                o_ones => w_ones
            );
                
        
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
         TDM4_inst : TDM4
            generic map ( k_WIDTH => 4)
            Port map (
                    i_clk => w_clk_out,
                    i_reset => w_btnU_in,
                    i_D0 => w_ones,
                    i_D1 => w_tens,
                    i_D2 => w_hund,
                    i_D3 => w_sign,
                    o_data => w_seven_seg_val,
                    o_sel => an
             );
                    
                    
        -- Seven Segment Decoder
            -- inputs
                -- w_tdm_to_7seg
            -- outputs
                -- w_7seg_out
         positive_negative_7_segment_display_inst : positive_negative_7_segment_display
          Port map (
             i_D =>  w_seven_seg_val,
             o_s => seg(6 downto 0)
           );
          
              
        -- Clock Divider
            -- inputs 
                -- w_clk_in
            -- outputs
                -- w_clk
        clock_divider_inst : clock_divider
        generic map (k_div => 250000)
           port map (
            	i_clk   => clk,
                i_reset   => w_btnU_in,          -- unnessecary but there
                o_clk   => w_clk_out         -- divided (slow) clock
            );
        
        
        -- Controller FSM
            -- inputs
                -- w_btnU_in
                -- w_btnC_in
            -- outputs
                -- w_cycle_out
        controller_FSM_inst : controller_FSM
            Port map (
                     i_reset =>btnU,
                     i_advance  => btnC,
                     o_cycle => w_cycle_out,
                     i_clk => clk
                );
            

	-- CONCURRENT STATEMENTS ----------------------------

	
	
	
end top_basys3_arch;
