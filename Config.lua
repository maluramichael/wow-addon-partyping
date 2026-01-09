local addonName, addon = ...
local PartyPing = addon

function PartyPing:GetOptionsTable()
    return {
        name = "PartyPing",
        handler = PartyPing,
        type = "group",
        args = {
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
            -- Party Chat
            partyChatHeader = {
                type = "header",
                name = "Party Chat Message",
                order = 20,
            },
            partyChatEnabled = {
                type = "toggle",
                name = "Enable",
                order = 21,
                get = function() return self.db.profile.events.partyChat.enabled end,
                set = function(_, val) self.db.profile.events.partyChat.enabled = val end,
            },
            partyChatSound = {
                type = "select",
                name = "Sound",
                order = 22,
                dialogControl = "LSM30_Sound",
                values = function() return self.LSM:HashTable("sound") end,
                get = function() return self.db.profile.events.partyChat.sound end,
                set = function(_, val) self.db.profile.events.partyChat.sound = val end,
            },
            partyChatTest = {
                type = "execute",
                name = "Test",
                order = 23,
                func = function()
                    self:PlaySound(self.db.profile.events.partyChat.sound)
                end,
            },
            -- Player Joined
            playerJoinedHeader = {
                type = "header",
                name = "Player Joined Group",
                order = 30,
            },
            playerJoinedEnabled = {
                type = "toggle",
                name = "Enable",
                order = 31,
                get = function() return self.db.profile.events.playerJoined.enabled end,
                set = function(_, val) self.db.profile.events.playerJoined.enabled = val end,
            },
            playerJoinedSound = {
                type = "select",
                name = "Sound",
                order = 32,
                dialogControl = "LSM30_Sound",
                values = function() return self.LSM:HashTable("sound") end,
                get = function() return self.db.profile.events.playerJoined.sound end,
                set = function(_, val) self.db.profile.events.playerJoined.sound = val end,
            },
            playerJoinedTest = {
                type = "execute",
                name = "Test",
                order = 33,
                func = function()
                    self:PlaySound(self.db.profile.events.playerJoined.sound)
                end,
            },
            -- Player Left
            playerLeftHeader = {
                type = "header",
                name = "Player Left Group",
                order = 40,
            },
            playerLeftEnabled = {
                type = "toggle",
                name = "Enable",
                order = 41,
                get = function() return self.db.profile.events.playerLeft.enabled end,
                set = function(_, val) self.db.profile.events.playerLeft.enabled = val end,
            },
            playerLeftSound = {
                type = "select",
                name = "Sound",
                order = 42,
                dialogControl = "LSM30_Sound",
                values = function() return self.LSM:HashTable("sound") end,
                get = function() return self.db.profile.events.playerLeft.sound end,
                set = function(_, val) self.db.profile.events.playerLeft.sound = val end,
            },
            playerLeftTest = {
                type = "execute",
                name = "Test",
                order = 43,
                func = function()
                    self:PlaySound(self.db.profile.events.playerLeft.sound)
                end,
            },
            -- Group Disbanded
            groupDisbandedHeader = {
                type = "header",
                name = "Group Disbanded",
                order = 50,
            },
            groupDisbandedEnabled = {
                type = "toggle",
                name = "Enable",
                order = 51,
                get = function() return self.db.profile.events.groupDisbanded.enabled end,
                set = function(_, val) self.db.profile.events.groupDisbanded.enabled = val end,
            },
            groupDisbandedSound = {
                type = "select",
                name = "Sound",
                order = 52,
                dialogControl = "LSM30_Sound",
                values = function() return self.LSM:HashTable("sound") end,
                get = function() return self.db.profile.events.groupDisbanded.sound end,
                set = function(_, val) self.db.profile.events.groupDisbanded.sound = val end,
            },
            groupDisbandedTest = {
                type = "execute",
                name = "Test",
                order = 53,
                func = function()
                    self:PlaySound(self.db.profile.events.groupDisbanded.sound)
                end,
            },
        },
    }
end
