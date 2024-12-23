library ieee;
use ieee.std_logic_1164.all;

entity BTNReset is
    generic (
        DEBOUNCE_CYCLES: in integer
    );
    port (
        clk: in std_logic;
        arstn_i: in std_logic;
        rstn_o: out std_logic
    );
end;

architecture impl of BTNReset is
    signal counter: integer range 0 to DEBOUNCE_CYCLES;
    signal rstn_last: std_logic;
begin

    shift: process(clk)
    begin
        if rising_edge(clk) then
            if (arstn_i /= rstn_last) then
                -- If the input signal changed, start counting from 0 again
                counter <= 0;
            else
                -- If it was stable, count up iff not reached final count
                if counter /= DEBOUNCE_CYCLES then
                    counter <= counter + 1;
                end if;
            end if;

            rstn_last <= arstn_i;

            -- We count how long the input signal was stable
            -- If it was stable for long enough, propagate to output
            if counter = DEBOUNCE_CYCLES then
                rstn_o <= rstn_last;
            end if;
        end if;
    end process;
end;