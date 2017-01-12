----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/28/2016 03:48:43 PM
-- Design Name: 
-- Module Name: stub_data_readout - Behavioral
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

use work.user_package.ALL;

entity fast_cmd is

    port (
    
        clk320 : in std_logic;
        clk40_o : out std_logic;
            
        fast_cmd_i: in std_logic; -- at 320 MHz
        fast_reset_o: out std_logic;
        trigger_o : out std_logic;
        test_pulse_trigger_o : out std_logic;
        orbit_reset_o : out std_logic
        
    );

end fast_cmd;

architecture Behavioral of fast_cmd is

    type state_t is (SYNCING, DONE);
    signal state : state_t := SYNCING;
    signal clk40_internal : std_logic := '0';
    --signal counter : integer := 0;
begin
    clk40_o <= clk40_internal;
   
    process(clk320)
    variable counter : integer := 0;   
    variable sync_bit_candidate : std_logic_vector(2 downto 0) := (others => '0');   
    variable fast_reset : std_logic := '0';
    variable trigger : std_logic := '0';
    variable test_pulse_trigger : std_logic := '0';
    variable orbit_reset : std_logic := '0';
    
    begin
        if(rising_edge(clk320)) then
            case state is
            
                when SYNCING =>
                
                    --== reset output ==--                    
                    fast_reset_o <= '0';
                    trigger_o <= '0';
                    test_pulse_trigger_o <= '0';
                    orbit_reset_o <= '0';
                    clk40_internal <= '0';
                    
                    --save the input to a 4 bit signal
                    sync_bit_candidate := sync_bit_candidate(1 downto 0) & fast_cmd_i;
                    --check if the input sequence is equal to the sync pattern                    
                    if (sync_bit_candidate = "110") then 
                        counter := 5 ; 
                        state <= DONE;                         
                    end if;
                                   
                when DONE =>
                  case counter is
                  
                    when 8 => 
                        clk40_internal <= '1';
                        counter := 7;
                        
                    when 7 => 
                        counter := 6;                      

                    when 6 =>    
                        counter := 5;                         

                    when 5 =>                             
                        fast_reset := fast_cmd_i;
                        counter := 4;

                    when 4 =>                             
                        trigger := fast_cmd_i;
                        clk40_internal <= '0';
                        counter := 3;

                    when 3 =>                             
                        test_pulse_trigger := fast_cmd_i;
                        counter := 2;

                    when 2 =>                             
                        orbit_reset := fast_cmd_i;
                        counter := 1;
                        
                        --make fast commands available
                        fast_reset_o <= fast_reset;
                        trigger_o <= trigger;
                        test_pulse_trigger_o <= test_pulse_trigger;
                        orbit_reset_o <= orbit_reset;
                        

                    when 1 =>                             
                        --== reset counter for next batch ==-
                        counter := 8; 
                        
                        
                        
                    when others =>
                         --== reset output ==--
                         fast_reset_o <= '0';
                         trigger_o <= '0';
                         test_pulse_trigger_o <= '0';
                         orbit_reset_o <= '0';
                         clk40_internal <= '0';    
                                                
                  end case;  --end case counter
                  
              when others =>
                       --== reset output ==--
                       fast_reset_o <= '0';
                       trigger_o <= '0';
                       test_pulse_trigger_o <= '0';
                       orbit_reset_o <= '0';
                       clk40_internal <= '0';
                
            end case; --end case states
            
            
        
        end if;    
    end process;

end Behavioral;
