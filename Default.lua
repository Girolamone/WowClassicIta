local addonName, addonTable = ...

---@class WowClassicIta
local WowClassicIta = _G.LibStub("AceAddon-3.0"):GetAddon(addonName)

--- This function is called when the add-on is loaded and initializes the default profile settings.
---@return WowClassicItaSettings
function WowClassicIta:GetDeafultProfile()
    return {
        profile = {
            spells = {
                enabled = true,
                name = true,
                description = true,
            },
            items = {
                enabled = true,
                name = true,
                description = true,
            },
            quests = {
                enabled = true,
                name = false,
                description = true,
                rewards = true,
                completion = true,
                objectives = true,
            },
            gossip = {
                enabled = true,
                name = false,
                description = true,
            },

            disabled = false,
            --@debug@
            logLevel = 3,
            debugButtons = true,
            --@end-debug@
            --[==[@non-debug
            logLevel = 0,
            debugButtons = false,
            @end-non-debug@]==]

        }
    }
end
