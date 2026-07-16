----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:26:02 04/24/2025 
-- Design Name: 
-- Module Name:    TX - Behavioral 
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TX is

    Port ( palavra : in std_logic_vector(7 downto 0);
           send : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           busy : out  STD_LOGIC;
           linha : out  STD_LOGIC);
end TX;

architecture TX of TX is

type STATES is (STANDBY,SEND_B,STOP_B); 
signal atual : STATES;
signal contador : std_logic_vector(2 downto 0) := (others => '0');
signal palavra_reg : std_logic_vector(7 downto 0); -- registrador
signal palavra_sm : STD_LOGIC; -- palavra saida do mux


begin
		--ajuste sugerido pelo professor na revisao do projeto na última aula  
		palavra_sm <= palavra_reg(to_integer(unsigned(contador)));
		
		process(clock, reset)
		
		begin
		
			 if reset = '1' then
			 
					atual <= STANDBY;
					busy <= '0';
					linha <= '1';
					palavra_reg<= (others=>'0'); 
				
			
			elsif clock'event and clock = '1' then
			
				--todas as acoes da maquina de estados sao executadas em bordas de subida de clock
				case atual is
				
					when STANDBY=>
					
						busy <= '0';
						linha <= '1';
						
							if send = '1' then
							
								atual <= SEND_B;
								busy <= '1';
								linha <= '0';
								contador <= "111";
								palavra_reg <= palavra; 
								
							end if;			
				
					when SEND_B =>
					
						-- contador vai de 7 a 0, sendo assim esse if envia o ultimo bit e atribui o proximo estado 
						if contador = "000" then 
						
							linha <= palavra_sm;
							atual <= STOP_B;
							
						else
						
							linha <= palavra_sm;
							contador <= std_logic_vector(unsigned(contador) - 1);
						
						end if;

					when STOP_B =>
						 
						linha <= '0';  
						busy <= '0';   
						atual <= STANDBY;  
							  
					end case;
					
			end if;
			
		end process;

end TX;

