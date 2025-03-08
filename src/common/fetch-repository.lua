-- Fetches the latest version of the program from a repository

local FetchRepository = {}

-- Repository types
FetchRepository.Repository = {
    GITHUB = "github"
}

--- Deletes the file if it already exists and fetches the file from the given URL
local function delete_and_fetch_file(file_name, url)
    fs.delete(file_name) -- Delete the file if it already exists
    shell.run("wget", url, file_name)
end

-- GitHub repository functions

--- Returns the URL of the file in the GitHub repository
local function github_url_file(file_name)
    return "https://raw.githubusercontent.com/Jiizuz/computer-craft-programs/refs/heads/main/src/" .. file_name
end

-- Repository resolve functions

--- Returns the formatted URL of the file in the repository
local function format_file_url(path, repository)
    if repository == FetchRepository.Repository.GITHUB then
        return github_url_file(path)
    end
    error("Unknown repository: " .. repository)
end

--- Returns the file name without the path
local function strip_file_name(path)
    return path:match("([^/]+)$")
end

--- Fetches the files from the repository
function FetchRepository.fetch_files(files, repository)
    delete_and_fetch_file("fetch-repository.lua",
            format_file_url("common/fetch-repository.lua", repository))
    for _, path in ipairs(files) do
        delete_and_fetch_file(strip_file_name(path), format_file_url(path, repository))
    end
end

return FetchRepository
