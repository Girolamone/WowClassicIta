local addonName, addonTable = ...

--- @class WowClassicIta
local WowClassicIta = _G.LibStub("AceAddon-3.0"):GetAddon(addonName)

local loggingLevels = {
    ["INACTIVE"] = -1,
    ["ERROR"] = 0,
    ["WARN"] = 1,
    ["INFO"] = 2,
    ["DEBUG"] = 3,
    ["TRACE"] = 4,
}

function WowClassicIta:Debug(str)
    if self.db.profile.logLevel >= loggingLevels["DEBUG"] then
        self:Printf("|cFF00FFFF[v%s][DEBUG]|r %s", self:GetVersion(), str)
    end
end

function WowClassicIta:Info(str)
    if self.db.profile.logLevel >= loggingLevels["INFO"] then
        self:Printf("|cFF00FF00[v%s][INFO]|r %s", self:GetVersion(), str)
    end
end

function WowClassicIta:Error(str)
    if self.db.profile.logLevel >= loggingLevels["ERROR"] then
        self:Printf("|cFFFF0000[v%s][ERROR]|r %s", self:GetVersion(), str)
    end
end

function WowClassicIta:Warn(str)
    if self.db.profile.logLevel >= loggingLevels["WARN"] then
        self:Printf("|cFFFF0000[v%s][WARN]|r %s", self:GetVersion(), str)
    end
end

function WowClassicIta:Trace(str)
    if self.db.profile.logLevel >= loggingLevels["TRACE"] then
        self:Printf("|cFFFFA500[v%s][TRACE]|r %s", self:GetVersion(), str)
    end
end

function WowClassicIta:GetVersion()
    --@debug@
    return "v0.1-debug"
    --@end-debug@
    --[==[@non-debug@
    -- Get the version of the add-on from its metadata
    local version = GetAddOnMetadata(addonName, "Version")
    return version or "Unknown"
    @end-non-debug]==]
end
