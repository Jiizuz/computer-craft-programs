-- Filters out certain items from a chest and drops them down, while pushing the rest to the front inventory

-- Constants

--- Filters to apply to the items. If the item passes the filter, it will be dropped down i.e. destroyed
local filters_to_apply = {
    is_potion = function(item_detail)
        return string.find(item_detail.name, "potion$")
    end,
    is_damaged = function(item_detail)
        return item_detail.damage and item_detail.maxDamage and item_detail.damage > 0
    end
}

-- Mob farm drop filter functions

--- Cleans up the inventory by analyzing each item and determining whether to drop it down or not
function cleanup()
    for i = 1, 16 do
        turtle.select(i)
        analyze_item_and_determine_drop(turtle.getItemDetail(i, true))
    end
end

--- Filters out available items from the inventory above the turtle
function filter_out_available_items()
    turtle.select(1)
    while turtle.suckUp() do
        analyze_item_and_determine_drop(turtle.getItemDetail(1, true))
    end
end

--- Analyzes the item and determines whether to drop it down or not
function analyze_item_and_determine_drop(item_detail)
    if apply_filters(item_detail, filters_to_apply) then
        turtle.dropDown()
    else
        turtle.drop()
    end
end

--- Applies the filters to the item detail, returning true if the item should be dropped down
function apply_filters(item_detail, filters)
    if not item_detail then
        -- Cannot apply filters to an item without details
        return false
    end

    for _, predicate in ipairs(filters) do
        if predicate(item_detail) then
            return true
        end
    end
    return false
end

-- Debug functions

--- Converts an item detail to a string
function item_detail_to_string(item_detail)
    return textutils.serialise(item_detail)
end

--- Writes an item detail to a file
function write_item_detail(file_name, item_detail)
    local file = fs.open(file_name, "w+")
    file.write(item_detail_to_string(item_detail))
    file.close()
end
