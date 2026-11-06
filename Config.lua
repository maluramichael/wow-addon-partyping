local addonName, addon = ...
local PartyPing = addon

-- Helper to create an event config group (header + toggle + sound picker + test button)
local function EventConfig(self, key, label, order)
    local prefix = key
    return {
        [prefix .. "Header"] = {
            type = "header",
            name = label,
            order = order,
        },
        [prefix .. "Enabled"] = {
            type = "toggle",
            name = "Enable",
            order = order + 1,
            get = function() return self.db.profile.events[key].enabled end,
            set = function(_, val) self.db.profile.events[key].enabled = val end,
        },
        [prefix .. "Sound"] = {
            type = "select",
            name = "Sound",
            order = order + 2,
            dialogControl = "LSM30_Sound",
            values = function() return self.LSM:HashTable("sound") end,
            get = function() return self.db.profile.events[key].sound end,
            set = function(_, val) self.db.profile.events[key].sound = val end,
        },
        [prefix .. "Test"] = {
            type = "execute",
            name = "Test",
            order = order + 3,
            func = function()
                self:PlaySound(self.db.profile.events[key].sound)
            end,
        },
    }
end

-- Merge helper
local function MergeArgs(target, source)
    for k, v in pairs(source) do
        target[k] = v
    end
end

function PartyPing:GetOptionsTable()
    local args = {
        headerDesc = {
            type = "description",
            name = "PartyPing v" .. self.version .. " - Party event sounds\n\nMacro: /run PartyPing:Toggle()",
            fontSize = "medium",
            order = 1,
        },
        enabled = {
            type = "toggle",
            name = "Enable All Sounds",
            desc = "Master toggle for all PartyPing sounds",
            order = 10,
            get = function() return self.db.profile.enabled end,
            set = function(_, val) self.db.profile.enabled = val end,
            width = "full",
        },
        soundChannel = {
            type = "select",
            name = "Sound Channel",
            desc = "Which audio channel to play sounds on",
            order = 11,
            values = self.soundChannels,
            get = function() return self.db.profile.soundChannel end,
            set = function(_, val) self.db.profile.soundChannel = val end,
        },
        testSounds = {
            type = "execute",
            name = "Test All Sounds",
            desc = "Play all enabled sounds in sequence",
            order = 12,
            func = function() self:TestSounds() end,
        },
        -- Section headers for visual grouping
        chatSectionHeader = {
            type = "header",
            name = "|cFF69CCF0Chat Events|r",
            order = 19,
        },
        groupSectionHeader = {
            type = "header",
            name = "|cFF69CCF0Group Events|r",
            order = 59,
        },
    }

    -- Chat events
    MergeArgs(args, EventConfig(self, "partyChat", "Party Chat Message", 20))
    MergeArgs(args, EventConfig(self, "raidChat", "Raid Chat Message", 25))
    MergeArgs(args, EventConfig(self, "raidWarning", "Raid Warning", 30))
    MergeArgs(args, EventConfig(self, "instanceChat", "Instance Chat Message", 35))
    MergeArgs(args, EventConfig(self, "whisper", "Whisper Received", 40))

    -- Group events
    MergeArgs(args, EventConfig(self, "playerJoined", "Player Joined Group", 60))
    MergeArgs(args, EventConfig(self, "playerLeft", "Player Left Group", 65))
    MergeArgs(args, EventConfig(self, "groupDisbanded", "Group Disbanded", 70))
    MergeArgs(args, EventConfig(self, "readyCheck", "Ready Check", 75))
    MergeArgs(args, EventConfig(self, "rolePoll", "Role Poll", 80))
    MergeArgs(args, EventConfig(self, "summon", "Summon Received", 85))
    MergeArgs(args, EventConfig(self, "dungeonReady", "Dungeon Ready (Queue Pop)", 90))

    return {
        name = "PartyPing",
        handler = PartyPing,
        type = "group",
        args = args,
    }
end
