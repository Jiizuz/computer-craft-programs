-- Fetches the latest version of the program from a repository

-- Fetch utility functions
fs.delete("fetch-repository.lua")
shell.run("wget", "https://raw.githubusercontent.com/Jiizuz/computer-craft-programs/refs/heads/main/src/common/fetch-repository.lua", "fetch-repository.lua")

local FetchRepository = require("fetch-repository")

local args = { ... }
local repository = args[1] or FetchRepository.Repository.GITHUB

print("Fetching Mob Farm Drop Filter program from " .. repository .. " repository...")

FetchRepository.fetch_files({
    "mob-farm-drop-filter/fetch.lua",
    "mob-farm-drop-filter/mob-farm-drop-filter.lua",
    "mob-farm-drop-filter/startup.lua"
}, repository)

print("Mob Farm Drop Filter program fetched successfully.")
