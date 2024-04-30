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
        o_led : out std_logic_vector(2 downto 0) -- output of the flags
    );
end ALU;

architecture behavioral of ALU is 
  
	-- declare components and signals
	
	-- component 4 bit mux
	
	-- component 3 bit opcode with shift selector
	
	-- and
	
	-- or
	
	-- right/left shifter
	
	-- adder/subtractor
	
	-- flag 2 led converter
	
	-- Signals
	signal w_A : std_logic_vector (7 downto 0); -- input wire for a
	signal w_B : std_logic_vector (7 downto 0); -- input wire for b
	signal w_result_final : std_logic_vector(7 downto 0); -- output for entire alu
	signal w_result_or : std_logic_vector(7 downto 0); -- the result of or calculation
	signal w_result_and : std_logic_vector(7 downto 0); -- the result for and calculation
	signal w_result_shifter : std_logic_vector(7 downto 0); -- result of shift calculation
	signal w_result_add_subtract : std_logic_vector(7 downto 0); -- result of add or subract calculation
	signal w_shift : std_logic; -- boolean value for shift of left right or add subtract
	signal w_opcode_select : std_logic_vector(1 downto 0); -- opcode that selects desired calculation
	signal w_overflow : std_logic; -- boolean value for overflow
	signal w_carry : std_logic; -- boolean value for carry
	signal w_flag_to_led : std_logic_vector(2 downto 0); -- led output code for flags
	
	

  
begin
	-- PORT MAPS ----------------------------------------

	
	
	-- CONCURRENT STATEMENTS ----------------------------
	
	
	
end behavioral;
