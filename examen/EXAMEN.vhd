----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:03:47 10/03/2023 
-- Design Name: 
-- Module Name:    EXAMEN - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity EXAMEN is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           dig : out  STD_LOGIC_VECTOR (3 downto 0);
           seg : out  STD_LOGIC_VECTOR (7 downto 0));
end EXAMEN;

architecture Behavioral of EXAMEN is
	signal countU : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- Contador de 4 bits
	signal countD : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- Contador de 4 bits
	signal countC : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- Contador de 4 bits
	signal countM : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- Contador de 4 bits
	signal count_P : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- Contador de 4 bits
	signal sec : STD_LOGIC_VECTOR(1 downto 0) := "00";
	signal clk_count : STD_LOGIC_VECTOR(25 downto 0) := (others => '0');  -- Contador para 1 segundo
   signal clk_count2 : STD_LOGIC_VECTOR(19 downto 0) := (others => '0');
	signal seg_signal : STD_LOGIC_VECTOR(7 downto 0) := "00000000"; 


begin
process (clk, rst)
		begin
			if rst = '1' then
				countU <= "0000"; 				
				countD <= "0000";
				countC <= "0000";
				countM <= "0000";
            clk_count <= (others => '0');
					elsif rising_edge(clk) then
						clk_count <= clk_count + 1;  -- Incrementar el contador de 1 segundo
						if clk_count = "00010011000100101101000000"then  
                   	clk_count <= (others => '0');
					
                     countU <= countU + 1;  -- Incrementar el contador en 1
					if countU = "1001" then
                  countU <= "0000";
						countD <= countD + 1;  -- Incrementar el contador en 1
							if countD = "1001" then
								countD <= "0000";
								countC <= countC + 1;  -- Incrementar el contador en 1
									if countC = "1001" then
										countC <= "0000";
										countM <= countM + 1;
									end if;
							end if;
                end if;
            end if;				
        end if;
end process;
	 
process (clk)
begin
 if rising_edge(clk) then
            clk_count2 <= clk_count2 + 1; 
            if clk_count2 = "00110010110111001101" then  
					sec <= sec + 1;
					clk_count2 <= (others => '0');
				end if;
end if;			
end process;

process (sec,countU,countD,countC,countM) -- Decodificador de secuencia a binario 
		begin 
		case sec is 
		when "00" => 
				count_P <= countU;
				dig <= "1110";
		when "01" => 
				count_P <= countD;
				dig <= "1101";
			when "10" => 
				count_P <= countC;
				dig <= "1011";
			when "11" => 
				count_P <= countM;
				dig <= "0111";
			when others =>
				count_P <= "1111";
				dig <= "1111";
			end case;
end process;


process (count_P)				-- decodificador de binario de 7 segmentos
		begin
			case count_P is	
			when "0000" =>
                seg_signal <= not "00111111";  -- Mostrar 0
            when "0001" =>
                seg_signal <= not "00000110";  -- Mostrar 1
            when "0010" =>
                seg_signal <= not "01011011";  -- Mostrar 2
				when "0011" =>
					seg_signal <= not "01001111";   -- Mostrar 3
				when "0100" =>
                seg_signal <= not "01100110";  -- Mostrar 4
            when "0101" =>
                seg_signal <= not "01101101";  -- Mostrar 5
				when "0110" =>	
					 seg_signal <= not "01111101";  -- Mostrar 6
				when "0111" =>
                seg_signal <= not "00000111";  -- Mostrar 7
            when "1000" =>
                seg_signal <= not "01111111";  -- Mostrar 8
				when "1001" =>
                seg_signal <= not "01101111";  -- Mostrar 9
            when others =>
					seg_signal <= not "00000000";  -- Mostrar algo no válido (todos los segmentos apagados)
			end case;
end process;

seg <= seg_signal;

end Behavioral;

