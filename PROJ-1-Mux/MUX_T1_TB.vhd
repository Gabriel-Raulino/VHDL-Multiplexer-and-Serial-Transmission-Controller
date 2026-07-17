--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:02:48 04/21/2025
-- Design Name:   
-- Module Name:   
-- Project Name: 
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MUX
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY MUX_T1_TB IS
END MUX_T1_TB;
 
ARCHITECTURE MUX_T1_TB OF MUX_T1_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MUX
    PORT(
	 
         in1 : IN  std_logic;
         in2 : IN  std_logic;
         in3 : IN  std_logic;
         in4 : IN  std_logic;
         ctrl : IN  std_logic_vector (1 downto 0);
         sai : OUT  std_logic
			
        );
    END COMPONENT;
    

   --Inputs
   signal in1 : std_logic := '1';
   signal in2 : std_logic := '0';
   signal in3 : std_logic := '1';
   signal in4 : std_logic := '0';
   signal ctrl :std_logic_vector(1 downto 0):= "00";

 	--Outputs
   signal sai : std_logic;

BEGIN
	
	in1 <= '0' after 5 ns;
	ctrl <= "00", "01" after 10 ns, "10" after 20 ns, "11" after 30 ns;

	-- Instantiate the Unit Under Test (UUT)
   uut: MUX PORT MAP (
          in1 => in1,
          in2 => in2,
          in3 => in3,
          in4 => in4,
          ctrl => ctrl,
          sai => sai
        );


   

END;
