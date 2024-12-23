library ieee;
use ieee.std_logic_1164.all;

entity LEDBlink is
    generic (
        TOGGLE_CYCLES: in integer
    );
    port (
        clk: in std_logic;
        arstn: in std_logic;
        led: out std_logic
    );
end;

architecture impl of LEDBlink is
    signal counter: integer range 0 to TOGGLE_CYCLES;
    signal led_buf: std_logic;
begin

    shift: process(arstn, clk)
    begin
        if (arstn = '0') then
            counter <= 0;
            led_buf <= '0';
        elsif rising_edge(clk) then
            counter <= counter + 1;
            if counter = TOGGLE_CYCLES then
                counter <= 0;
                led_buf <= not led_buf;
            end if;
        end if;
    end process;

    led <= led_buf;
end;