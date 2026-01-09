local addonName, addon = ...

-- Create the addon using AceAddon with mixins
local PartyPing = LibStub("AceAddon-3.0"):NewAddon(addon, addonName,
    "AceEvent-3.0", "AceConsole-3.0")

-- Expose globally for macro support: /run PartyPing:Toggle()
_G["PartyPing"] = PartyPing

-- Get LibSharedMedia
PartyPing.LSM = LibStub("LibSharedMedia-3.0")

-- Addon version
PartyPing.version = C_AddOns.GetAddOnMetadata(addonName, "Version") or "1.0.0"

-- Register built-in WoW sounds with LibSharedMedia
PartyPing.LSM:Register("sound", "PP: Bell", [[Sound\Doodad\BellTollAlliance.ogg]])
PartyPing.LSM:Register("sound", "PP: Chime", [[Sound\Interface\iQuestComplete.ogg]])
PartyPing.LSM:Register("sound", "PP: Raid Warning", [[Sound\Interface\RaidWarning.ogg]])
PartyPing.LSM:Register("sound", "PP: Ready Check", [[Sound\Interface\ReadyCheck.ogg]])
PartyPing.LSM:Register("sound", "PP: Level Up", [[Sound\Interface\LevelUp.ogg]])
PartyPing.LSM:Register("sound", "PP: Auction Open", [[Sound\Interface\AuctionWindowOpen.ogg]])
PartyPing.LSM:Register("sound", "PP: Auction Close", [[Sound\Interface\AuctionWindowClose.ogg]])
PartyPing.LSM:Register("sound", "PP: PvP Enter", [[Sound\Spells\PVPEnterQueue.ogg]])
PartyPing.LSM:Register("sound", "PP: Tell Message", [[Sound\Interface\iTellMessage.ogg]])

-- Sound channels
PartyPing.soundChannels = {
    ["Master"] = "Master",
    ["SFX"] = "Sound Effects",
    ["Ambience"] = "Ambience",
    ["Music"] = "Music",
}

-- Default database values
local defaults = {
    profile = {
        enabled = true,
        debug = false,
        soundChannel = "Master",
        events = {
            partyChat = {
                enabled = true,
                sound = "PP: Chime",
            },
            playerJoined = {
                enabled = true,
                sound = "PP: Bell",
            },
            playerLeft = {
                enabled = true,
                sound = "PP: Ready Check",
            },
            groupDisbanded = {
                enabled = true,
                sound = "PP: Raid Warning",
            },
        },
    },
}

function PartyPing:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("PartyPingDB", defaults, true)

    self:RegisterChatCommand("pp", "SlashCommand")
    self:RegisterChatCommand("partyping", "SlashCommand")

    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, self:GetOptionsTable())
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, "PartyPing")

    self.lastMemberCount = GetNumGroupMembers()
    self.wasInGroup = IsInGroup()

    self:Print("PartyPing v" .. self.version .. " loaded. Type /pp help for commands.")
end

function PartyPing:OnEnable()
    self:RegisterEvents()
end

function PartyPing:OnDisable()
    self:UnregisterAllEvents()
end

function PartyPing:Toggle()
    self.db.profile.enabled = not self.db.profile.enabled
    if self.db.profile.enabled then
        self:Print("PartyPing |cFF00FF00ENABLED|r")
    else
        self:Print("PartyPing |cFFFF0000DISABLED|r")
    end
    return self.db.profile.enabled
end

function PartyPing:Enable()
    self.db.profile.enabled = true
    self:Print("PartyPing |cFF00FF00ENABLED|r")
end

function PartyPing:Disable()
    self.db.profile.enabled = false
    self:Print("PartyPing |cFFFF0000DISABLED|r")
end

function PartyPing:IsEnabled()
    return self.db.profile.enabled
end

function PartyPing:Debug(...)
    if self.db.profile.debug then
        self:Print("|cFF888888[Debug]|r", ...)
    end
end

function PartyPing:ToggleDebug()
    self.db.profile.debug = not self.db.profile.debug
    if self.db.profile.debug then
        self:Print("Debug mode |cFF00FF00ENABLED|r")
    else
        self:Print("Debug mode |cFFFF0000DISABLED|r")
    end
end

function PartyPing:SlashCommand(input)
    local cmd = input:lower():trim()

    if cmd == "toggle" then
        self:Toggle()
    elseif cmd == "enable" or cmd == "on" then
        self:Enable()
    elseif cmd == "disable" or cmd == "off" then
        self:Disable()
    elseif cmd == "debug" then
        self:ToggleDebug()
    elseif cmd == "config" or cmd == "options" then
        Settings.OpenToCategory("PartyPing")
    elseif cmd == "test" then
        self:TestSounds()
    elseif cmd == "help" or cmd == "" then
        self:PrintHelp()
    else
        self:PrintHelp()
    end
end

function PartyPing:PrintHelp()
    self:Print("PartyPing Commands:")
    self:Print("  /pp toggle - Toggle sounds on/off")
    self:Print("  /pp enable|on - Enable sounds")
    self:Print("  /pp disable|off - Disable sounds")
    self:Print("  /pp debug - Toggle debug output")
    self:Print("  /pp config - Open configuration panel")
    self:Print("  /pp test - Play all configured sounds")
    self:Print("Macro: /run PartyPing:Toggle()")
end

function PartyPing:TestSounds()
    self:Print("Testing sounds...")

    local delay = 0
    local eventNames = {
        partyChat = "Party Chat",
        playerJoined = "Player Joined",
        playerLeft = "Player Left",
        groupDisbanded = "Group Disbanded",
    }

    for eventKey, eventLabel in pairs(eventNames) do
        local eventSettings = self.db.profile.events[eventKey]
        if eventSettings and eventSettings.enabled then
            C_Timer.After(delay, function()
                self:Print("  Playing: " .. eventLabel)
                self:PlaySound(eventSettings.sound)
            end)
            delay = delay + 1.5
        end
    end
end

function PartyPing:PlaySound(soundName)
    if not self.db.profile.enabled then return end

    local soundFile = self.LSM:Fetch("sound", soundName)
    if soundFile then
        PlaySoundFile(soundFile, self.db.profile.soundChannel)
    end
end
