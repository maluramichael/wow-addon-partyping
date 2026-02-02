std = "lua51"
codes = true
quiet = 1
max_line_length = false
exclude_files = { ".release/", "libs/", "Libs/" }

globals = { "PartyPing", "BINDING_HEADER_PARTYPING", "BINDING_NAME_PARTYPING_TOGGLE" }

read_globals = {
    "_G", "LibStub",
    "CreateFrame", "UIParent", "GameTooltip", "Settings", "PlaySoundFile",
    "GetNumGroupMembers", "IsInGroup", "UnitName", "UnitGUID",
    "InterfaceOptionsFrame_OpenToCategory", "C_Timer",
    "pairs", "ipairs", "select", "string", "table", "math", "format",
    "tonumber", "tostring", "type", "unpack",
}
