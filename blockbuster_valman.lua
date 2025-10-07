-- Setting variables to use for other mods to test whether this mod is loaded
if not Blockbuster then
    Blockbuster = {}
end

Blockbuster.ValueManipulation = {}
Blockbuster.ValueManipulation.mod_dir = ''..SMODS.current_mod.path

Blockbuster.ValueManipulation_config = SMODS.current_mod.config


-- Read in Atlases
local atlases = 
{
    {'modicon', 32, 32, 'modicon.png'},
}

for _index, _object in ipairs(atlases) do
    SMODS.Atlas {
        key = _object[1],
        px = _object[2],
        py = _object[3],
        path = _object[4]
    }
end

-- Read in Files
function Blockbuster.load_file(file_address)
    local helper, load_error = SMODS.load_file(file_address)
    if load_error then
        sendDebugMessage ("The error is: "..load_error)
    else
        helper()
    end
end

local _list_of_folders = {
    "src",
    "items/value_manip_guides"
}

for _index, _folder in ipairs(_list_of_folders) do
    local files = NFS.getDirectoryItems(Blockbuster.ValueManipulation.mod_dir .. _folder)
    for _, _filename in ipairs(files) do
        Blockbuster.load_file(_folder .. "/" .. _filename)
    end
end

Blockbuster.vanilla_joker_qualities()