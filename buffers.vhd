----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2016 02:49:46 PM
-- Design Name: 
-- Module Name: buffers - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;
use work.user_package.ALL;

entity buffers is
  Port (   
  --stub data        
    stub_data_to_fc7_dp_p_o: out cbc_dp_to_buf; 
    stub_data_to_fc7_dp_n_o: out cbc_dp_to_buf; 
    
    stub_data_to_fc7_dp_i: in cbc_dp_to_buf; 
  
  --clocking      
    clk320_p_o     : out std_logic;
    clk320_n_o     : out std_logic;
    clk320_i       : in std_logic; 
  --reset
    reset_o          : out std_logic;
    reset_i          : in std_logic
    
--    SCL_i            : in std_logic;   
    --SCL_o            : out std_logic; only the master drives the scl clock right now
--    SCL_io           : inout std_logic;
       
--    SDA_io           : inout std_logic;
--    SDA_mosi_i        : in std_logic;
--    SDA_miso_o        : out std_logic;
--    SDA_tri_i         : in std_logic
    
  );
end buffers;

architecture Behavioral of buffers is
    signal clk320_i_oddr : std_logic;
begin

    GEN_dps: for J in 0 to 5 generate
        CBC_dp_obufds :  obufds
        generic map(
            iostandard      => "lvds_25"
        )
        port map(    
            i               => stub_data_to_fc7_dp_i(J),
            o               => stub_data_to_fc7_dp_p_o(J),
            ob              => stub_data_to_fc7_dp_n_o(J)
        );
    end generate GEN_dps;
          
    clk320_oddr : oddr
    generic map(
        ddr_clk_edge    => "opposite_edge",
        init            => '0',
        srtype          => "sync"
    )
    port map (
        q               => clk320_i_oddr,
        c               => clk320_i,
        ce              => '1',
        d1              => '1',
        d2              => '0',
        r               => '0',
        s               => '0'
    );
    
    clk320_obufds : obufds
    generic map(
        iostandard  => "lvds_25"
    )
    port map (
        i           => clk320_i_oddr,
        o           => clk320_p_o,
        ob          => clk320_n_o
    );
    
    
    reset_obuf : obuf
    generic map(
        drive       => 12,
        iostandard  => "lvcmos25",
        slew        => "slow"
    )
    port map(
        o           => reset_o,
        i           => reset_i
    );
    --Jarne??
--    slc_obuf : iobuf -- right now t => '0' is always output mode so the CBC does not drive the scl clock
--    generic map(
--        drive       => 12,
--        iostandard  => "lvcmos25",
--        slew        => "slow"
--    )
--    port map(
--        o           => open,
--        io          => scl_io,
--        i           => scl_i,
--        t           => '0'
--    );
    
--    SDA_iobuf : iobuf
--    generic map (
--        drive       => 12,
--        iostandard  => "lvcmos25",
--        slew        => "slow"
--    )
--    port map (
--        o           => SDA_miso_o,
--        io          => SDA_io,
--        i           => SDA_mosi_i,
--        t           => SDA_tri_i
--    );


end Behavioral;
