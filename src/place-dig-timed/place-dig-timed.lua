-- Places and digs an item continuously with a timed delay

-- Constants

--- The delay between placing and digging an item
local DIG_DELAY = 1
--- The delay between digging and placing an item
local PLACE_DELAY = 90

-- Main functions

--- Places and digs an item with a timed delay
function place_and_dig()
    turtle.select(1) -- Select the first slot to place and dig

    turtle.place()
    os.sleep(DIG_DELAY)
    turtle.place()
    os.sleep(PLACE_DELAY)
end
