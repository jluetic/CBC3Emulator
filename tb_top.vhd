----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/20/2016 11:53:54 AM
-- Design Name: 
-- Module Name: tb_i2cslave - Behavioral
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
use work.user_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.user_package.ALL;

entity tb_top is
--  Port ( );
end tb_top;

architecture Behavioral of tb_top is
    constant clk320MHz_period : time := 10 ns; --put to 10 ns for simplicity, in real life it is 3.125ns
    constant clk100kHz_period : time := 32 us; --if I put the 320MHz clock to a period of 10ns then this one should be 32us
--    signal ref_clk_i    : std_logic := '0';
    signal reset_i     : std_logic := '0';
    -- I2C lines
    signal scl_i       : std_logic := '0';
    signal sda_miso_o  : std_logic := '0';
    signal sda_mosi_i  : std_logic := '1';
    signal sda_tri_o   : std_logic := '0';
    signal clk320 : std_logic :='0';
    
    signal fast_cmd_i : std_logic :='0';
    
   -- signal regs_page1_top : array_reg_page1 := regs_page1_default;
   -- signal regs_page2_top : array_reg_page2 := regs_page2_default;
    
    


begin
    uut_top: entity work.CBC3_top
    port map(
        -- I2C lines
        scl_i_top => scl_i,
        sda_miso_o_top => sda_miso_o,
        sda_mosi_i_top => sda_mosi_i,
        sda_tri_o_top => sda_tri_o,
        clk320_top => clk320,
        fast_cmd_top => fast_cmd_i
        
        --regs_page1_top_o => regs_page1,
        --regs_page2_top_o => regs_page2
    );
    
--    clk40MHz_prc: process
--    begin
--        ref_clk_i <= '1';
--        wait for 125 ns;
--        ref_clk_i <= '0';
--        wait for 125 ns;
--    end process;
    
    clk100kHz_prc: process
    begin
        scl_i <= '1';
        wait for clk100kHz_period/2;
        scl_i <= '0';
        wait for clk100kHz_period/2;
    end process;
     
     clk320MHz_prc: process
     begin
         clk320 <= '1';
         wait for clk320MHz_period/2;
         clk320 <= '0';
         wait for clk320MHz_period/2;
      end process;
     
     --this will generate the 40MHz clock
     gen_fast_cmd : process
     begin
         wait for 3*clk320MHz_period/4;
         fast_cmd_i <= '1';
         wait for clk320MHz_period;
         fast_cmd_i <= '1';
         wait for clk320MHz_period;
         fast_cmd_i <= '0';                
         wait for clk320MHz_period;
         fast_cmd_i <= '0';
         wait for clk320MHz_period;
         fast_cmd_i <= '0';
         wait for clk320MHz_period;
         fast_cmd_i <= '0';
         wait for clk320MHz_period;
         fast_cmd_i <= '0';
         wait for clk320MHz_period;
         fast_cmd_i <= '1';
         wait for clk320MHz_period/4;
     end process;
    
    read_register : process
    begin
        --send start 
        wait for clk100kHz_period/4;
        sda_mosi_i <= '0';
        --send chip address
        wait for clk100kHz_period/2;
        sda_mosi_i <= '1';
        wait for clk100kHz_period;
        sda_mosi_i <= '1';
        wait for clk100kHz_period;
        sda_mosi_i <= '1';
        wait for clk100kHz_period;
        sda_mosi_i <= '1';
        wait for clk100kHz_period;
        sda_mosi_i <= '1';
        wait for clk100kHz_period;
        sda_mosi_i <= '1';
        wait for clk100kHz_period;
        sda_mosi_i <= '1';
        --send the write bit
        wait for clk100kHz_period;
        sda_mosi_i <= '0';
        --wait for ack bit
        wait for clk100kHz_period;
        --send register address (0100 1111)
        wait for clk100kHz_period;
        sda_mosi_i <= '0';
        wait for clk100kHz_period;
        sda_mosi_i <= '1';
        wait for clk100kHz_period;
        sda_mosi_i <= '0';
        wait for clk100kHz_period;
        sda_mosi_i <= '1';
        wait for clk100kHz_period;
        sda_mosi_i <= '0';
        wait for clk100kHz_period;
        sda_mosi_i <= '0';
        wait for clk100kHz_period;
        sda_mosi_i <= '0';
        wait for clk100kHz_period;
        sda_mosi_i <= '0';
        --wait for ack bit
        wait for clk100kHz_period;   
        --send data to register
        wait for clk100kHz_period;
        sda_mosi_i <= '0';
        wait for clk100kHz_period;
        sda_mosi_i <= '0';
        wait for clk100kHz_period;
        sda_mosi_i <= '0';
        wait for clk100kHz_period;
        sda_mosi_i <= '0';
        wait for clk100kHz_period;
        sda_mosi_i <= '0';
        wait for clk100kHz_period;
        sda_mosi_i <= '0';
        wait for clk100kHz_period;
        sda_mosi_i <= '0';
        wait for clk100kHz_period;
        sda_mosi_i <= '0';
        --wait for ack bit
        wait for clk100kHz_period;                                              
        --send a stop sequence, but mosi first has to go to 0
        wait for clk100kHz_period;
        sda_mosi_i <= '0';
        wait for clk100kHz_period;
        sda_mosi_i <= '1';
        wait;
    end process;  
    
    


end Behavioral;
