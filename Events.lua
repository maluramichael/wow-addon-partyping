local addonName, addon = ...
local PartyPing = addon

function PartyPing:RegisterEvents()
    -- Party/raid chat
    self:RegisterEvent("CHAT_MSG_PARTY")
    self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
    self:RegisterEvent("CHAT_MSG_RAID")
    self:RegisterEvent("CHAT_MSG_RAID_LEADER")
    self:RegisterEvent("CHAT_MSG_RAID_WARNING")
    self:RegisterEvent("CHAT_MSG_INSTANCE_CHAT")
    self:RegisterEvent("CHAT_MSG_INSTANCE_CHAT_LEADER")
    self:RegisterEvent("CHAT_MSG_WHISPER")

    -- Group roster
    self:RegisterEvent("GROUP_ROSTER_UPDATE")

    -- Group actions
    self:RegisterEvent("READY_CHECK")
    self:RegisterEvent("ROLE_POLL_BEGIN")
    self:RegisterEvent("CONFIRM_SUMMON")
    self:RegisterEvent("LFG_PROPOSAL_SHOW")
end

-- Helper: check if sender is the player
local function IsSelf(sender)
    local playerName = UnitName("player")
    return sender == playerName or sender:match("^" .. playerName .. "%-")
end

-- Party chat
function PartyPing:CHAT_MSG_PARTY(event, message, sender, ...)
    self:OnChatEvent(sender, "partyChat", "Party chat")
end

function PartyPing:CHAT_MSG_PARTY_LEADER(event, message, sender, ...)
    self:OnChatEvent(sender, "partyChat", "Party leader chat")
end

-- Raid chat
function PartyPing:CHAT_MSG_RAID(event, message, sender, ...)
    self:OnChatEvent(sender, "raidChat", "Raid chat")
end

function PartyPing:CHAT_MSG_RAID_LEADER(event, message, sender, ...)
    self:OnChatEvent(sender, "raidChat", "Raid leader chat")
end

-- Raid warning
function PartyPing:CHAT_MSG_RAID_WARNING(event, message, sender, ...)
    self:OnChatEvent(sender, "raidWarning", "Raid warning")
end

-- Instance chat
function PartyPing:CHAT_MSG_INSTANCE_CHAT(event, message, sender, ...)
    self:OnChatEvent(sender, "instanceChat", "Instance chat")
end

function PartyPing:CHAT_MSG_INSTANCE_CHAT_LEADER(event, message, sender, ...)
    self:OnChatEvent(sender, "instanceChat", "Instance leader chat")
end

-- Whisper
function PartyPing:CHAT_MSG_WHISPER(event, message, sender, ...)
    if not self.db.profile.enabled then return end

    local settings = self.db.profile.events.whisper
    if settings.enabled then
        self:Debug("Whisper from " .. sender)
        self:PlaySound(settings.sound)
    end
end

-- Generic chat event handler (filters self messages)
function PartyPing:OnChatEvent(sender, eventKey, debugLabel)
    if not self.db.profile.enabled then return end
    if IsSelf(sender) then return end

    local settings = self.db.profile.events[eventKey]
    if settings.enabled then
        self:Debug(debugLabel .. " from " .. sender)
        self:PlaySound(settings.sound)
    end
end

-- Group roster tracking
function PartyPing:GROUP_ROSTER_UPDATE()
    local currentCount = GetNumGroupMembers()
    local isInGroup = IsInGroup()

    if self.wasInGroup and not isInGroup then
        self:OnGroupDisbanded()
    elseif currentCount > self.lastMemberCount then
        self:OnPlayerJoined(currentCount - self.lastMemberCount)
    elseif currentCount < self.lastMemberCount and currentCount > 0 then
        self:OnPlayerLeft(self.lastMemberCount - currentCount)
    end

    self.lastMemberCount = currentCount
    self.wasInGroup = isInGroup
end

function PartyPing:OnPlayerJoined(count)
    if not self.db.profile.enabled then return end

    local settings = self.db.profile.events.playerJoined
    if settings.enabled then
        self:Debug("Player joined group (" .. count .. " new)")
        self:PlaySound(settings.sound)
    end
end

function PartyPing:OnPlayerLeft(count)
    if not self.db.profile.enabled then return end

    local settings = self.db.profile.events.playerLeft
    if settings.enabled then
        self:Debug("Player left group (" .. count .. " left)")
        self:PlaySound(settings.sound)
    end
end

function PartyPing:OnGroupDisbanded()
    if not self.db.profile.enabled then return end

    local settings = self.db.profile.events.groupDisbanded
    if settings.enabled then
        self:Debug("Group disbanded")
        self:PlaySound(settings.sound)
    end
end

-- Ready check
function PartyPing:READY_CHECK(event, initiator, duration)
    if not self.db.profile.enabled then return end

    local settings = self.db.profile.events.readyCheck
    if settings.enabled then
        self:Debug("Ready check from " .. (initiator or "unknown"))
        self:PlaySound(settings.sound)
    end
end

-- Role poll
function PartyPing:ROLE_POLL_BEGIN()
    if not self.db.profile.enabled then return end

    local settings = self.db.profile.events.rolePoll
    if settings.enabled then
        self:Debug("Role poll started")
        self:PlaySound(settings.sound)
    end
end

-- Summon
function PartyPing:CONFIRM_SUMMON()
    if not self.db.profile.enabled then return end

    local settings = self.db.profile.events.summon
    if settings.enabled then
        self:Debug("Summon received")
        self:PlaySound(settings.sound)
    end
end

-- Dungeon ready (LFG queue pop)
function PartyPing:LFG_PROPOSAL_SHOW()
    if not self.db.profile.enabled then return end

    local settings = self.db.profile.events.dungeonReady
    if settings.enabled then
        self:Debug("Dungeon ready (queue popped)")
        self:PlaySound(settings.sound)
    end
end
