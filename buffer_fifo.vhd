----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2016 04:40:07 PM
-- Design Name: 
-- Module Name: buffer_fifo - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity buffer_fifo is
    Generic (
        constant DATA_WIDTH : positive := 280;
        constant FIFO_DEPTH : positive := 32
    );
    Port (
        clk_40 : in std_logic;
        clk_320 : in std_logic;
        reset : in std_logic;
        data_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
        data_bit_out : out std_logic
    );
end buffer_fifo;

architecture Behavioral of buffer_fifo is
signal tmp_data : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
signal read_en : std_logic := '0';
signal is_empty : std_logic := '1';
signal is_full : std_logic := '0';

begin

fifo_shift: process(clk_320)
    type FIFO_memory is array (0 to FIFO_DEPTH - 1) of std_logic_vector (DATA_WIDTH-1 downto 0);
    variable Memory : FIFO_memory;
    
    variable Head : natural range 0 to FIFO_DEPTH - 1;
    variable Tail : natural range 0 to FIFO_DEPTH - 1;
    variable looped : boolean;
    
    variable prev_clock : std_logic := '0';
    variable curr_clock : std_logic := '0';
    variable index : natural range 0 to DATA_WIDTH;
    
    variable prev_ev : natural range 0 to FIFO_DEPTH - 1 := 0;
    variable curr_ev : natural range 0 to FIFO_DEPTH - 1 := 0;
    
    begin
        if(rising_edge(clk_320)) then
            prev_clock := curr_clock;
            curr_clock := clk_40;
            if (prev_clock='0' and curr_clock='1') then
                if(reset='1') then
                    Head := 0;
                    Tail := 0;
                    Looped := false;
                    
                    is_empty <='1';
                    is_full <= '0';
                else
                    if(read_en='1') then
                        if ((Looped = true) or (Head/=Tail)) then
                            tmp_data <= Memory(Tail);
                            curr_ev := Tail; 
                            if (Tail = FIFO_DEPTH - 1) then
                                Tail := 0;
                                Looped := false;
                            else   
                                Tail := Tail + 1;
                            end if;
                        else
                            tmp_data <= (others=>'0');
                        end if;
                    end if;
                    
                    if(data_in(1 downto 0)="11") then -- write en
                    --if (true) then
                        if ((Looped=false) or (Head/=Tail)) then
                            Memory(Head) := data_in;
                            
                            if (Head = FIFO_DEPTH -1) then
                                Head := 0;
                                Looped := true;
                            else
                                Head := Head+1;
                            end if;--change pointer
                        end if;--looped
                    end if;--write_en 
                    
                    if (Head = Tail) then
                        if Looped then
                            is_full<='1';
                            --tmp_data(2) <='1'; -- fifo full error bit FIXME??
                        else
                            is_empty<='1';
                        end if;
                    else
                        is_empty <= '0';
                        is_full <= '0';
                    end if;
                        
                end if; --reset
           end if; --clk_40
           
          
           if ((index < DATA_WIDTH-1) and prev_ev/=curr_ev) then
               data_bit_out <= tmp_data(index);
               index := index+1;
               read_en <='0';
           else
               index := 0;
               read_en <='1';
               data_bit_out <= '0';
               prev_ev := curr_ev;
           end if;
           
       end if; --clk320
    end process;

end Behavioral;
