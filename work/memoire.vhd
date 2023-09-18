--TP1 mu0 - entité mémoire - a faire evoluer suivant les fonctionnalités du processeur à tester

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram0 is
	port(clk		: in std_logic;
		 MEMrq		: in std_logic;
		 RnW		: in std_logic;
		 addr_bus	: in std_logic_vector(11 downto 0);
		 data_bus	: inout std_logic_vector(15 downto 0));
end ram0;

-------------------------------------------------------------------------- 
-- Instruction  | Code Operation  | Action Realisée
-------------------------------------------------------------------------- 
-- LDA addr     |   0000          | ACC <- mem[addr] 
-- STO addr     |   0001          | mem[addr] <- ACC  
-- ADD addr     |   0010          | ACC <- ACC + mem[addr]
-- SUB addr     |   0011          | ACC <- ACC - mem[addr]
-- JMP addr     |   0100          | PC  <- addr 
-- JGE addr     |   0101          | si ACC >= 0 --> PC <- addr
-- JNE addr     |   0110          | si ACC # 0  --> PC <- addr
-- STP          |   0111          | arrêter le processeur
-- AND addr     |   1000          | ACC <- ACC and mem[addr]
-- OR  addr     |   1001          | ACC <- ACC or mem[addr]
-- XOR addr     |   1010          | ACC <- ACC xor mem[addr]
-- LDR addr     |   1011          | reg_R <- mem[addr]
-- LDI addr     |   1100          | ACC <- mem[reg_R] ; reg_R <- reg_R + 1 
-- STI addr     |   1101          | mem[reg_R] <- ACC ; reg_R <- reg_R + 1
-- JSR addr     |   1110          | SPC <- PC ; PC <- mem[addr] 
-- RET          |   1111          | PC <- SPC


architecture syn of ram0 is

	type memory_type is array (integer range 0 to 15) of std_logic_vector(15 downto 0);

signal memory : memory_type := 
(                     -- ADRESSE -- DONNEE + NOTES JOHNNY
  "0000000000001100", --    0    -- LDA 0xC Load the value in Addr 12 into the ACCUMULATOR. Here ACC = 7
  "0010000000001100", --    1    -- ADD 0xC Add the value into the ACC: ACC = ACC + Value = 7+7 = 14
  "0001000000000101", --    2    -- STO 0x5 Store the value into the address 14
  "0100000000000110", --    3    -- JMP 0x6 Jump to addresse #6
  "0000000000000000", --    4    -- 
  "0000000000000000", --    5    -- 
  "0011000000001110", --    6    -- SUB 0xE ACC - Addresse 14 = 14 - 2 = 12
  "0101000000001101",  --   7    -- JGE 0xD Comparaison between ACC and Address 13
  "0001000000001010",  --   8    -- STO 0xA Store the value of ACC into Address 10
  "0100000000001011",  --   9    -- JMP 0xB Jump into the address 11
  "0000000000000000",  --   10   -- 
  "0111000000000000",  --   11   -- STP Stop the processor
  "0000000000000111",  --   12   -- donnée=7
  "0000000000000100",  --   13   -- donnée=4
  "0000000000000010",  --   14   -- donnée=2
  "0000000000000000"   --   15   -- 


);


begin

	data_bus <= memory(to_integer(unsigned(addr_bus)))  when (MEMrq = '1' and RnW = '1') else (others => 'Z');

	process (clk)
	begin
		if rising_edge(clk) then 
		      if (MEMrq = '1') and (RnW = '0') then
			     memory(to_integer(unsigned(addr_bus))) <= data_bus;
		      end if;
		end if;      
	end process;
end syn;
