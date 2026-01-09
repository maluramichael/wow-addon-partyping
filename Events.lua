local addonName, addon = ...
local PartyPing = addon

function PartyPing:RegisterEvents()
    self:RegisterEvent("CHAT_MSG_PARTY")
    self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
    self:RegisterEvent("GROUP_ROSTER_UPDATE")
end

function PartyPing:CHAT_MSG_PARTY(event, message, sender, ...)
    self:OnPartyChat(sender, message)
end

function PartyPing:CHAT_MSG_PARTY_LEADER(event, message, sender, ...)
    self:OnPartyChat(sender, message)
end

function PartyPing:OnPartyChat(sender, message)
    if not self.db.profile.enabled then return end

    local playerName = UnitName("player")
    if sender == playerName or sender:match("^" .. playerName .. "%-") then
        return
    end

    local settings = self.db.profile.events.partyChat
    if settings.enabled then
        self:Debug("Party chat from " .. sender)
        self:PlaySound(settings.sound)
    end
end

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
