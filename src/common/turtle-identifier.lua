-- Turtle identifier module that allows the turtle to identify itself with a unique Id

-- Turtle Identifier Module
local TurtleIdentifier = {}

--- Source that fetches the turtle identifier from the file system
local FILE_SYSTEM_SOURCE = "fs"

-- Internal functions

--- Reads the turtle identifier from the file system
local function _read_turtle_identifier_fs()
    if fs.exists("identifier") then
        local file = fs.open("identifier", "r")
        local id = file.readLine()
        file.close()

        return id
    end
    return "unknown-turtle"
end

-- Public functions

--- Returns the turtle identifier based on the given source
function TurtleIdentifier.get(src)
    if src == FILE_SYSTEM_SOURCE then
        return _read_turtle_identifier_fs()
    end

    error("Unknown source: " .. src)
end

return TurtleIdentifier
