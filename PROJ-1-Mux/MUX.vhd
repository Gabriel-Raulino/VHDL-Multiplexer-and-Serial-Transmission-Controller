----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:55:33 04/21/2025 
-- Design Name: 
-- Module Name:    MUX - MUX_S 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX is
    Port ( in1 : in  STD_LOGIC;
           in2 : in  STD_LOGIC;
           in3 : in  STD_LOGIC;
           in4 : in  STD_LOGIC;
           ctrl : in std_logic_vector (1 downto 0);
           sai : out  STD_LOGIC);
end MUX;

architecture MUX_S of MUX is

begin

	process (in1,in2, in3, in4,ctrl)
	
	begin
	
	case ctrl is
	
		when "00" => sai <= in1;
		when "01" => sai <= in2;
		when "10" => sai <= in3;
		when "11" => sai <= in4;
		when others => null;
		
	end case;

end process;


end MUX_S;

