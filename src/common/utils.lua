-- This file contains utility functions that are used in other scripts

-- Inventory functions

--- This function finds the slot of an item with the given name
--- If no item is found, it returns 0
function find_item_slot(name)
    for slot = 1, 16 do
        local details = turtle.getItemDetail(slot)

        if details and details.name == name then
            return slot
        end
    end

    return 0
end

--- This function finds the first empty slot in the turtle's inventory
--- If no empty slot is found, it returns 0
function find_first_empty_slot()
    for slot = 1, 16 do
        if turtle.getItemCount(slot) == 0 then
            return slot
        end
    end

    return 0
end

--- Checks if the whole inventory is empty
--- Returns true if the inventory is empty, and false otherwise
function is_inventory_empty()
    local slot = turtle.getSelectedSlot()

    for i = 1, 16 do
        if turtle.getItemCount(i) > 0 then
            turtle.select(slot) -- Restore the selected slot
            return false
        end
    end
    turtle.select(slot) -- Restore the selected slot
    return true
end

-- Peripheral functions

--- This function finds the side of a peripheral with the given name
--- If no peripheral is found, it returns nil
function find_peripheral_side(name)
    for _, side in ipairs(peripheral.getNames()) do
        if peripheral.getType(side) == name then
            return side
        end
    end

    return nil
end

--- This function checks if a peripheral with the given name exists
--- It returns true if the peripheral exists, and false otherwise
function has_peripheral(name)
    return find_peripheral_side(name) ~= nil
end

--- This function finds the peripheral with the given name and wraps it
--- If no peripheral is found, it returns nil
function find_peripheral_and_wrap(name)
    local side = find_peripheral_side(name)
    return side and peripheral.wrap(side) or nil
end

-- Math functions

--- This function checks if a value is within a tolerance of a target value
function is_within_tolerance(value, target, tolerance)
    return math.abs(value - target) <= tolerance
end

-- Time functions

--- Formats a duration in seconds as HH:MM:SS
function format_duration(duration_seconds)
    local hours = math.floor(duration_seconds / 3600)
    local minutes = math.floor((duration_seconds % 3600) / 60)
    local seconds = duration_seconds % 60

    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end
