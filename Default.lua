local addonName, addonTable = ...

---@class WowClassicIta
local WowClassicIta = _G.LibStub("AceAddon-3.0"):GetAddon(addonName)

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
            },
            gossip = {
                enabled = true,
                name = false,
                description = true,
            },

            disabled = false,
            --@debug@
            logLevel = 4
            --@end-debug@
            --[==[@non-debug
            logLevel = 0
            @end-non-debug@]==]

        }
    }
end
