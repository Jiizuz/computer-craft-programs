-- Fetches the latest version of the program from a repository

-- Fetch utility functions
fs.delete("fetch-repository.lua")
shell.run("wget", "https://raw.githubusercontent.com/Jiizuz/computer-craft-programs/refs/heads/main/src/common/fetch-repository.lua", "fetch-repository.lua")

local FetchRepository = require("fetch-repository")

local args = { ... }
local repository = args[1] or FetchRepository.Repository.GITHUB

print("Fetching Place Dig Timed program from " .. repository .. " repository...")

FetchRepository.fetch_files({
    "place-dig-timed/fetch.lua",
    "place-dig-timed/place-dig-timed.lua",
    "place-dig-timed/startup.lua"
}, repository)

print("Place Dig Timed program fetched successfully.")
