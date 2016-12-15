----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2016 02:12:51 PM
-- Design Name: 
-- Module Name: CBC3_top - Behavioral
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

entity CBC3_top is
    Port ( 
           clk_320_p : in STD_LOGIC;
           clk_320_n : in STD_LOGIC;
           dp1_p : out STD_LOGIC;
           dp2_p : out STD_LOGIC;
           dp3_p : out STD_LOGIC;
           dp4_p : out STD_LOGIC;
           dp5_p : out STD_LOGIC;
           dp6_p : out STD_LOGIC;
           dp1_n : out STD_LOGIC;
           dp2_n : out STD_LOGIC;
           dp3_n : out STD_LOGIC;
           dp4_n : out STD_LOGIC;
           dp5_n : out STD_LOGIC;
           dp6_n : out STD_LOGIC;
           fast_cmd_p : in STD_LOGIC;
           fast_cmd_n : in STD_LOGIC; 
           i2c_sda : inout STD_LOGIC;
           i2c_scl : inout STD_LOGIC);
end CBC3_top;

architecture top of CBC3_top is

begin


end top;
