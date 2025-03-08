-- Fetches the latest version of the program from a repository

-- Fetch utility functions
fs.delete("fetch-repository.lua")
shell.run("wget", "https://raw.githubusercontent.com/Jiizuz/computer-craft-programs/refs/heads/main/src/common/fetch-repository.lua", "fetch-repository.lua")

local FetchRepository = require("fetch-repository")

local args = { ... }
local repository = args[1] or FetchRepository.Repository.GITHUB

print("Fetching Digital Miner Carrier program from " .. repository .. " repository...")

FetchRepository.fetch_files({
    "common/turtle-identifier.lua",
    "common/utils.lua",
    "digital-miner-carrier/digital-miner-carrier.lua",
    "digital-miner-carrier/fetch.lua",
    "digital-miner-carrier/startup.lua"
}, repository)

print("Digital Miner Carrier program fetched successfully.")
