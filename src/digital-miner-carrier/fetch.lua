-- Fetches the latest version of the program from a repository

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
