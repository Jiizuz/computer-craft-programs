-- Program to fill an area with a block

require("utils")

--- Settings for the area filler
Settings = {
    BASE_BLOCK = "minecraft:oak_log"
}

--- Loads the internal inventory, fills the area, returns to the base
function main()
    load_inventory()
    go_to_start()
    fill_area()
    go_to_end_of_row()
    go_to_base()
end

-- Area functions

--- Returns true if the area is filled
function area_is_filled()
    -- When there are no more space to move, the area is filled
    local front_blocked = turtle.detect()
    turtle.turnRight()
    local right_blocked = turtle.detect()
    turtle.turnRight()
    local back_blocked = turtle.detect()
    turtle.turnRight()
    local left_blocked = turtle.detect()
    turtle.turnRight()
    return front_blocked and right_blocked and back_blocked and left_blocked
end

-- Block placement functions

--- Fills the area with the items in the inventory in front
function fill_area()
    while true do
        place_sector_blocks()
        if is_inventory_empty() or not move_to_next_position() then
            break
        end
    end
end

--- Places blocks where the turtle is positioned
function place_sector_blocks()
    turtle.placeUp()
    select_where_available()
    turtle.place()
    select_where_available()
    turtle.placeDown()
    select_where_available()
end

-- Movement functions

--- Positions the turtle at the start of the area to fill
function go_to_start()
    turtle.back()
    turtle.back()
end

--- Moves the turtle to the next position
--- Returns true if the turtle moved to the next position, and false otherwise
function move_to_next_position()
    local moved = turtle.back()
    if moved then
        return true
    end

    if area_is_filled() then
        return false
    end

    -- Find the next available position
    turtle.turnRight()
    if turtle.detect() then
        turtle.turnRight()
        turtle.turnRight()
        turtle.forward()
        turtle.turnLeft()
        turtle.back()
        return true
    end

    turtle.forward()
    turtle.turnRight()
    turtle.back()
    return true
end

--- Moves the turtle to the end of the row
function go_to_end_of_row()
    if turtle.back() then
        go_to_end_of_row()
    end
end

--- Moves the turtle to the base, i.e. the start of the area to fill
function go_to_base()
    turtle.select(find_first_empty_slot()) -- Store in the empty slot the block that is going to be broken

    turtle.turnRight()
    turtle.turnRight()
    turtle.dig()
    turtle.forward()
    turtle.turnRight()
    turtle.turnRight()
    turtle.down()
    turtle.placeUp()

    -- Go in clockwise direction
    turtle.turnLeft()

    while true do
        while not turtle.detect() do
            turtle.forward()
        end
        turtle.digDown()
        if turtle.getItemDetail() and turtle.getItemDetail().name == Settings.BASE_BLOCK then
            turtle.placeDown()
            break
        end
        turtle.placeDown()

        turtle.turnRight()
    end

    turtle.turnLeft()
    turtle.up()
end

-- Inventory functions

--- Fills the inventory of the turtle with the items from the inventory on the front
function load_inventory()
    for i = 1, 16 do
        if turtle.getItemCount(i) == 0 then
            turtle.select(i)
            if not turtle.suck() then
                break
            end
        end
    end
    turtle.select(1)
end

--- Selects the next slot with available blocks
function select_where_available()
    if turtle.getItemCount() > 0 then
        -- There is still available blocks in the selected slot
        return
    end
    -- Find the next available slot
    for i = turtle.getSelectedSlot() + 1, 16 do
        if turtle.getItemCount(i) > 0 then
            turtle.select(i)
            return
        end
    end
end
