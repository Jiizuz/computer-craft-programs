local turtle_identifier = require("turtle-identifier")
require("utils")

-- Reference: https://docs.google.com/spreadsheets/d/1sheh1BIeP_vSto881H6UtgXvxdbyJEfILM_uUW_UD7Q/edit?gid=895766350#gid=895766350&range=A159
-- Reference: https://docs.advanced-peripherals.de/0.7/peripherals/chat_box/#sendmessage

-- Configuration

Settings = {}
Settings.REPORT_STATUS = true

Settings.Types = {}
Settings.Types.DIGITAL_MINER = "mekanism:digital_miner" -- Required
Settings.Types.ENERGY_SOURCE = "mekanism:quantum_entangloporter" -- Required
Settings.Types.EJECT_HANDLER = "mekanism:quantum_entangloporter" -- Required
Settings.Types.STATE_HANDLER = "advancedperipherals:chat_box"
Settings.Types.CHUNK_HANDLER = ""
Settings.Types.TELEPORT_TYPE = "mekanism:teleporter"
Settings.Types.FUEL_FOUNTAIN = "enderstorage:ender_chest"
Settings.Types.REFUEL_OBJECT = "mekanism:block_charcoal"

Settings.Fuel = {}
Settings.Fuel.FUEL_STRENGTH = 800 -- The strength of the fuel in terms of fuel points
Settings.Fuel.FUEL_FOUNTAIN_SUPPLY = 64 -- The number of fuel items the fuel fountain can supply at once

Components = {}
Components.digital_miner = nil
Components.state_handler = nil

-- Constants

--- The length of a sector in blocks that a Digital Miner can mine
local SECTOR_LENGTH = 64
--- The fuel limit of the turtle, typically 20,000 for normal turtles, and 100,000 for advanced turtles
local FUEL_LIMIT = turtle.getFuelLimit()
--- How many fuel points can be refueled per refuel
local REFUEL_STRENGTH = Settings.Fuel.FUEL_STRENGTH * Settings.Fuel.FUEL_FOUNTAIN_SUPPLY
--- The unique identifier of the turtle
local UNIQUE_ID = turtle_identifier.get("fs")

-- Main program

--- Resumes the state of the turtle after a crash or a reboot and the turtle is left for a fresh start
function resume_state()
    if turtle.detect() then
        -- With hopes and dreams, we can expect the block in front to be the miner
        break_digital_miner()
    end
end

--- Validates the carrier by checking the most important necessary components
function validate_carrier()
    if find_item_slot(Settings.Types.DIGITAL_MINER) == 0 then
        error("Digital Miner not found in inventory.")
    end
    if find_item_slot(Settings.Types.ENERGY_SOURCE) == 0 then
        error("Energy Source not found in inventory.")
    end
    if find_item_slot(Settings.Types.EJECT_HANDLER) == 0 then
        error("Eject Handler not found in inventory.")
    end
    if find_item_slot(Settings.Types.FUEL_FOUNTAIN) == 0 then
        print("WARNING: Fuel Fountain not found in inventory.")
        if turtle.getFuelLevel() == 0 then
            error("Fuel Fountain not found in inventory and turtle has no fuel.")
        end
    end
end

--- Mines a sector using the Digital Miner, this function will take care of placing and retrieving the Digital Miner
function mine_sector()
    place_digital_miner()

    Components.digital_miner = find_peripheral_and_wrap("digitalMiner")
    Components.state_handler = get_state_handler()

    Components.digital_miner.start()

    local to_mine_total = Components.digital_miner.getToMine()

    while Components.digital_miner.isRunning() do
        if (Components.digital_miner.getToMine() == 0) then
            break
        end

        os.sleep(1)
    end

    if Components.state_handler then
        local mined = to_mine_total - Components.digital_miner.getToMine()
        Components.state_handler.sendMessage("Sector finished, " .. mined .. " ores extracted.", UNIQUE_ID)
    end

    Components.digital_miner = nil
    Components.state_handler = nil

    break_digital_miner()
end

--- Places the Digital Miner and its components, the final position of the turtle is in front of the Digital Miner
--- and with the state handler above it
function place_digital_miner()
    turtle.select(find_item_slot(Settings.Types.DIGITAL_MINER))
    turtle.placeUp()

    turtle.turnRight()
    turtle.forward()
    turtle.forward()
    turtle.turnLeft()
    turtle.select(find_item_slot(Settings.Types.ENERGY_SOURCE))
    turtle.placeUp()

    turtle.forward()
    turtle.up()

    local chunk_handler_slot = find_item_slot(Settings.Types.CHUNK_HANDLER)
    if chunk_handler_slot > 0 and not is_chunky_turtle() then
        turtle.select(chunk_handler_slot)
        turtle.placeUp()
    end

    turtle.forward()
    turtle.turnLeft()
    turtle.forward()

    local teleporter_slot = find_item_slot(Settings.Types.TELEPORT_TYPE)
    if teleporter_slot > 0 then
        turtle.select(teleporter_slot)
        turtle.placeUp()
    end

    turtle.forward()
    turtle.select(find_item_slot(Settings.Types.EJECT_HANDLER))
    turtle.placeUp()

    turtle.forward()
    turtle.forward()
    turtle.turnLeft()
    turtle.forward()
    turtle.forward()
    turtle.turnLeft()

    local state_handler_slot = find_item_slot(Settings.Types.STATE_HANDLER)
    if state_handler_slot > 0 and Settings.REPORT_STATUS then
        turtle.select(state_handler_slot)
        turtle.placeUp()
    end

    os.sleep(0.45)
end

--- Breaks the Digital Miner and its components
function break_digital_miner()
    turtle.select(1) -- Select the first slot to retrieve all components in the first available slots
    turtle.dig()
    turtle.digUp()
    turtle.forward()
    turtle.forward()
    turtle.forward()
    turtle.dig()
    turtle.forward()
    turtle.turnLeft()
    turtle.forward()
    turtle.digUp()
    turtle.forward()
    turtle.turnLeft()
    turtle.forward()
    turtle.digUp()
    turtle.forward()
    turtle.digUp()
    turtle.turnRight()
    turtle.down()
    turtle.back()
    turtle.back()
end

--- Refuels the turtle only if necessary
function refuel_efficiently()
    -- Check if a refuel is needed
    if FUEL_LIMIT >= REFUEL_STRENGTH then
        -- Refuel cannot overload the turtle, so refuel if the fuel level is below the refuel strength
        if FUEL_LIMIT - turtle.getFuelLevel() < REFUEL_STRENGTH then
            return
        end
    elseif turtle.getFuelLevel() > Settings.Types.FUEL_STRENGTH then
        -- Refueling can overload the turtle, so only refuel if the fuel level is below the fuel strength
        return
    end

    local fuel_source_slot = find_item_slot(Settings.Types.FUEL_FOUNTAIN)
    if (fuel_source_slot == 0) then
        -- No fuel fountain found, cannot refuel
        return
    end

    turtle.select(fuel_source_slot)
    turtle.place()
    turtle.suck()
    local refuel_object_slot = find_item_slot(Settings.Types.REFUEL_OBJECT)
    if refuel_object_slot > 0 then
        -- Refuel with object found, die otherwise
        turtle.select(refuel_object_slot)
        turtle.refuel()
        turtle.dropDown() -- Drop excess fuel
    end
    turtle.select(fuel_source_slot) -- Retrieve the fuel fountain in the same slot it was found
    turtle.dig()
end

--- Travels through a sector to allow the Digital Miner to mine fully new chunks
function travel_through_a_sector()
    for _ = 1, SECTOR_LENGTH do
        turtle.forward()
    end
end

-- Components utility functions

--- Returns the state handler that will be used to report the status of the turtle
--- The state handler has a sendMessage function that takes a message and an identifier
--- Can be nil if the state handler is not found or if the reporting is disabled
function get_state_handler()
    if not Settings.REPORT_STATUS then
        return nil
    end

    local chat_box = find_peripheral_and_wrap("chatBox")
    if chat_box then
        -- Chat Box already has a sendMessage function
        return chat_box
    end

    return {
        sendMessage = function(message, id)
            print("[" .. id .. "] " .. message)
        end
    }
end

-- Turtle general utility functions

--- Checks if the turtle has a chunky peripheral
--- i.e. whether it is a Chunky Turtle
function is_chunky_turtle()
    -- Reference: https://docs.advanced-peripherals.de/0.7/turtles/chunky_turtle/
    return has_peripheral("chunky")
end
