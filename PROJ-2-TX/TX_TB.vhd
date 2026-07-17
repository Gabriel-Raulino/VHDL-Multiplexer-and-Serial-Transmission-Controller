library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity TX_TB is
end TX_TB;

architecture TX_TB of TX_TB is

	signal busy, linha, clock, reset, send: std_logic;
	signal palavra : std_logic_vector(7 downto 0);
	
begin
	
	UUT : entity work.TX
		port map (clock => clock, reset => reset, send => send,
		palavra => palavra, busy => busy, linha => linha);
		
	process
	begin
	
	clock <= '1' after 5 ns, '0' after 10 ns;
	
	wait for 10 ns;
	end process;
	
	
 reset <= '1', '0' after 3 ns;
 send <= '0', '1' after 23 ns, '0' after 50 ns, '1' after 160 ns, '0' after 200 ns;
 palavra <= "11010001", "00100110" after 150 ns;
 
end TX_TB;
