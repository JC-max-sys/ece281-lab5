--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS : made by Jack Culp and Jamar Price
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
--|
--| ALU OPCODES:
--|
--|     ADD     000     A+B
--|     SUB     001     A-B
--|     RSHIFT  010     A>>B
--|     LSHIFT  011     A<<B
--|     AND     100     A and B
--|     OR      101     A or B
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity ALU is
    port(
        i_A : in std_logic_vector(7 downto 0); -- connection of A register to alu
        i_B : in std_logic_vector(7 downto 0); -- connection of b register to alu
        i_opcode : in std_logic_vector(2 downto 0); -- connection of opcode input to alu
        o_result : out std_logic_vector(7 downto 0); -- output of the desired calculation based on the opcode
        o_flags : out std_logic_vector(2 downto 0) -- output of the flags
    );
end ALU;

architecture behavioral of ALU is 
  
	-- declare components and signals
	
	-- component 4 bit mux
	component mux_4_to_1 is
	    Port ( i_sel : in STD_LOGIC_VECTOR (1 downto 0);
              i_data_in_a : in STD_LOGIC_VECTOR (7 downto 0);
              i_data_in_b : in STD_LOGIC_VECTOR (7 downto 0);
              i_data_in_c : in STD_LOGIC_VECTOR (7 downto 0);
              i_data_in_d : in STD_LOGIC_VECTOR (7 downto 0);
              o_data_out : out STD_LOGIC_VECTOR (7 downto 0)
              );
	end component mux_4_to_1;
	   
	
	-- component 3 bit opcode with shift selector
	component three_bit_shift_selector is
	 Port ( i_opcode : in STD_LOGIC_VECTOR (2 downto 0);
              o_shift : out STD_LOGIC;
              o_select : out STD_LOGIC_VECTOR (1 downto 0));
    end component three_bit_shift_selector;
	
	-- and
	
	-- or
	
	-- right/left shifter
	component right_left_shifter
	Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
               i_B : in STD_LOGIC_VECTOR (7 downto 0);
               i_R_L : in STD_LOGIC;
               o_result : out STD_LOGIC_VECTOR (7 downto 0));
	end component right_left_shifter;
	
	-- adder/subtractor
	component adder_subtractor is 
	 Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
              i_B : in STD_LOGIC_VECTOR (7 downto 0);
              i_add_sub : in STD_LOGIC;
              o_result : out STD_LOGIC_VECTOR (7 downto 0);
              o_overflow : out STD_LOGIC;
              o_carry : out STD_LOGIC );
    end component adder_subtractor;
    
	-- flag 2 led converter
	component flag_to_led_converter is
	   Port ( i_overflow : in STD_LOGIC;
               i_carry : in STD_LOGIC;
               o_led : out STD_LOGIC_VECTOR (2 downto 0));
	end component flag_to_led_converter;
	
	-- Signals
	signal w_A : std_logic_vector (7 downto 0); -- input wire for a
	signal w_B : std_logic_vector (7 downto 0); -- input wire for b
	signal w_result_final : std_logic_vector(7 downto 0); -- output for entire alu
	signal w_result_or : std_logic_vector(7 downto 0); -- the result of or calculation
	signal w_result_and : std_logic_vector(7 downto 0); -- the result for and calculation
	signal w_result_shifter : std_logic_vector(7 downto 0); -- result of shift calculation
	signal w_result_add_subtract : std_logic_vector(7 downto 0); -- result of add or subract calculation
	signal w_shift : std_logic; -- boolean value for shift of left right or add subtract
	signal w_opcode_in : std_logic_vector(2 downto 0); -- opcode that selects desired calculation
	signal w_opcode_selector_to_mux : std_logic_vector(1 downto 0);
	signal w_overflow : std_logic; -- boolean value for overflow
	signal w_carry : std_logic; -- boolean value for carry
	signal w_flag_to_led : std_logic_vector(2 downto 0); -- led output code for flags
	
	

  
begin
	-- PORT MAPS ----------------------------------------
    w_A <= i_A;
    w_B <= i_B;
    o_result <= w_result_final;
    w_opcode_in <= i_opcode;
    o_flags <= w_flag_to_led;
    
    w_result_and <= (w_A and w_B);
    w_result_or <= (w_A or w_B);
    
    three_bit_shift_selector_inst : three_bit_shift_selector
        port map(
            i_opcode => w_opcode_in,
            o_select => w_opcode_selector_to_mux,
            o_shift => w_shift
        );
    
    adder_subtractor_inst :adder_subtractor
        port map(
            i_A => w_A,
            i_B => w_B,
            i_add_sub => w_shift,
            o_result => w_result_add_subtract,
            o_carry => w_carry,
            o_overflow => w_overflow
        );
        
     right_left_shifter_inst : right_left_shifter
        port map(
            i_A => w_A,
            i_B => w_B,
            i_r_l => w_shift,
            o_result => w_result_shifter
        );
        
     flag_to_led_converter_inst : flag_to_led_converter
        port map (
            i_overflow => w_overflow,
            i_carry => w_carry,
            o_led => w_flag_to_led
        );
	
	 mux_4_to_1_inst : mux_4_to_1
	   port map (
	       i_data_in_a => w_result_add_subtract,
	       i_data_in_b => w_result_shifter,
	       i_data_in_c => w_result_and,
	       i_data_in_d => w_result_or, 
	       i_sel => w_opcode_selector_to_mux,
	       o_data_out => w_result_final
	   );
	
	
	-- CONCURRENT STATEMENTS ----------------------------
	
	
	
end behavioral;
