---@class WowClassicItaSettings Current addon configuration settings
---@field disabled boolean Whether the add-on is disabled or not
---@field quests table Quests settings
---@field quests.enabled boolean Whether quest translations are enabled or not
---@field quests.name boolean Whether quest name translations are enabled or not
---@field quests.description boolean Whether quest description translations are enabled or not
---@field quests.objectives boolean Whether quest objectives translations are enabled or not
---@field quests.rewards boolean Whether quest rewards translations are enabled or not
---@field quests.completion boolean Whether quest completion translations are enabled or not
---@field spells table Spells settings
---@field spells.enabled boolean Whether spell translations are enabled or not
---@field spells.name boolean Whether spell name translations are enabled or not
---@field spells.description boolean Whether spell description translations are enabled or not
---@field items table Items settings
---@field items.enabled boolean Whether item translations are enabled or not
---@field items.name boolean Whether item name translations are enabled or not
---@field items.description boolean Whether item description translations are enabled or not
---@field gossip table Gossip settings
---@field gossip.enabled boolean Whether gossip translations are enabled or not
---@field gossip.name boolean Whether gossip name translations are enabled or not
---@field gossip.description boolean Whether gossip description translations are enabled or not
---@field logLevel number The log level for debugging purposes
---@field debugButtons boolean Whether debug mode is enabled or not

local addonName, addonTable = ...

---@class WowClassicIta
local WowClassicIta = _G.LibStub("AceAddon-3.0"):GetAddon(addonName)

addonTable.GitHubURL = "https://github.com/Rez23/WowClassicIta"

--- Get current settings for the add-on.
--- This function retrieves the current settings for the add-on, including whether it is disabled and the status of various features.
--- @return WowClassicItaSettings
function WowClassicIta:FetchCurrentSetting()
    return {
        disabled = self.db.profile.disabled,
        quests = {
            enabled = self.db.profile.quests.enabled and not self.db.profile.disabled,
            name = self.db.profile.quests.name and not self.db.profile.disabled,
            description = self.db.profile.quests.description and not self.db.profile.disabled,
            objectives = self.db.profile.quests.objectives and not self.db.profile.disabled,
            rewards = self.db.profile.quests.rewards and not self.db.profile.disabled,
            completion = self.db.profile.quests.completion and not self.db.profile.disabled,
        },
        spells = {
            enabled = self.db.profile.spells.enabled and not self.db.profile.disabled,
            name = self.db.profile.spells.name and not self.db.profile.disabled,
            description = self.db.profile.spells.description and not self.db.profile.disabled,
        },
        items = {
            enabled = self.db.profile.items.enabled and not self.db.profile.disabled,
            name = self.db.profile.items.name and not self.db.profile.disabled,
            description = self.db.profile.items.description and not self.db.profile.disabled,
        },
        gossip = {
            enabled = self.db.profile.gossip.enabled and not self.db.profile.disabled,
            name = self.db.profile.gossip.name and not self.db.profile.disabled,
            description = self.db.profile.gossip.description and not self.db.profile.disabled,
        },
        logLevel = self.db.profile.logLevel,
        debugButtons = self.db.profile.debugButtons,
    }
end

--- Retrieves the data structure for the options configuration of the WowClassicIta addon.
--- This function is expected to return a table containing the configuration options
--- and their associated metadata, which can be used to manage addon settings.
--- @return table optionsDataStruct A table representing the options configuration.
function WowClassicIta:GetOptionsDataStruct()
    return {
        type = "group",
        name = addonName,
        args = {
            enabled = {
                type = "toggle",
                name = "Enable",
                desc = "Enable or disable the add-on.",
                get = function(info) return not self.db.profile.disabled end,
                set = function(info, value) if not value then self:TurnAddonsOff() else self:TurnAddonOn() end; end,
            },
            features = {
                type = "group",
                name = "Features",
                desc = "Enable or disable specific features.",
                disabled = function() return self.db.profile.disabled end,
                args = {
                    spells = {
                        type = "group",
                        name = "Spells",
                        desc = "Enable or disable spell translations specific features.",
                        args = {
                            enabled = {
                                type = "toggle",
                                name = "Enable",
                                desc = "Enable or disable spell translations.",
                                disabled = function() return self.db.profile.disabled end,
                                get = function(info) return self.db.profile.spells.enabled end,
                                set = function(info, value) self.db.profile.spells.enabled = value end,
                            },
                            name = {
                                type = "toggle",
                                name = "Spell Name",
                                desc = "Enable or disable spell name translations.",
                                disabled = function()
                                    return not self.db.profile.spells.enabled or
                                        self.db.profile.disabled
                                end,
                                get = function(info) return self.db.profile.spells.name end,
                                set = function(info, value) self.db.profile.spells.name = value end,
                            },
                            description = {
                                type = "toggle",
                                name = "Spell Description",
                                desc = "Enable or disable spell description translations.",
                                disabled = function()
                                    return not self.db.profile.spells.enabled or
                                        self.db.profile.disabled
                                end,
                                get = function(info) return self.db.profile.spells.description end,
                                set = function(info, value) self.db.profile.spells.description = value end,
                            },
                        }
                    },
                    items = {
                        type = "group",
                        name = "Items",
                        desc = "Enable or disable item translations.",
                        args = {
                            enabled = {
                                type = "toggle",
                                name = "Enable",
                                desc = "Enable or disable item translations.",
                                disabled = function() return self.db.profile.disabled end,
                                get = function(info) return self.db.profile.items.enabled end,
                                set = function(info, value) self.db.profile.items.enabled = value end,
                            },
                            name = {
                                type = "toggle",
                                name = "Item Name",
                                desc = "Enable or disable item name translations.",
                                disabled = function()
                                    return not self.db.profile.items.enabled or
                                        self.db.profile.disabled
                                end,
                                get = function(info) return self.db.profile.items.name end,
                                set = function(info, value) self.db.profile.items.name = value end,
                            },
                            description = {
                                type = "toggle",
                                name = "Item Description",
                                desc = "Enable or disable item description translations.",
                                disabled = function()
                                    return not self.db.profile.items.enabled or
                                        self.db.profile.disabled
                                end,
                                get = function(info) return self.db.profile.items.description end,
                                set = function(info, value) self.db.profile.items.description = value end,
                            },
                        }
                    },
                    quests = {
                        type = "group",
                        name = "Quests",
                        desc = "Enable or disable quest translations.",
                        args = {
                            enabled = {
                                type = "toggle",
                                name = "Enable",
                                desc = "Enable or disable quest translations.",
                                get = function(info) return self.db.profile.quests.enabled end,
                                set = function(info, value)
                                    if not value then
                                        self.widgets.questFrameToggle.frame:Hide(); self.widgets.questLogFrameToggle
                                            .frame:Hide();
                                    end; self.db.profile.quests.enabled = value
                                end,
                            },
                            name = {
                                type = "toggle",
                                name = "Quest Name",
                                desc = "Enable or disable quest name translations.",
                                disabled = function()
                                    return not self.db.profile.quests.enabled or
                                        self.db.profile.disabled
                                end,
                                get = function(info) return self.db.profile.quests.name end,
                                set = function(info, value) self.db.profile.quests.name = value end,
                            },
                            description = {
                                type = "toggle",
                                name = "Quest Description",
                                desc = "Enable or disable quest description translations.",
                                disabled = function()
                                    return not self.db.profile.quests.enabled or
                                        self.db.profile.disabled
                                end,
                                get = function(info) return self.db.profile.quests.description end,
                                set = function(info, value) self.db.profile.quests.description = value end,
                            },
                            objectives = {
                                type = "toggle",
                                name = "Quest Objectives",
                                desc = "Enable or disable quest objectives translations.",
                                disabled = function()
                                    return not self.db.profile.quests.enabled or
                                        self.db.profile.disabled
                                end,
                                get = function(info) return self.db.profile.quests.objectives end,
                                set = function(info, value) self.db.profile.quests.objectives = value end,
                            },
                        },
                    },
                    gossip = {
                        type = "group",
                        name = "Gossip",
                        desc = "Enable or disable gossip translations.",
                        args = {
                            enabled = {
                                type = "toggle",
                                name = "Enable",
                                desc = "Enable or disable gossip translations.",
                                get = function(info) return self.db.profile.gossip.enabled end,
                                set = function(info, value)
                                    if not value then self.widgets.gossipFrameToggle.frame:Hide() end; self.db.profile.gossip.enabled =
                                        value
                                end,
                            },
                            name = {
                                type = "toggle",
                                name = "Gossip Name",
                                desc = "Enable or disable gossip name translations.",
                                disabled = function()
                                    return not self.db.profile.gossip.enabled or
                                        self.db.profile.disabled
                                end,
                                get = function(info) return self.db.profile.gossip.name end,
                                set = function(info, value) self.db.profile.gossip.name = value end,
                            },
                            description = {
                                type = "toggle",
                                name = "Gossip Description",
                                desc = "Enable or disable gossip description translations.",
                                disabled = function()
                                    return not self.db.profile.gossip.enabled or
                                        self.db.profile.disabled
                                end,
                                get = function(info) return self.db.profile.gossip.description end,
                                set = function(info, value) self.db.profile.gossip.description = value end,
                            },
                        },
                    },
                },
            },
            advanced = {
                type = "group",
                name = "Advanced Settings",
                desc = "Advanced configuration options.",
                args = {
                    reset = {
                        type = "execute",
                        name = "Reset Settings",
                        desc = "Reset all settings to their default values.",
                        func = function() self.db:ResetProfile() end,
                    },
                },
            },
            about = {
                type = "group",
                name = "About",
                desc = "Information about the add-on.",
                args = {
                    author = {
                        type = "description",
                        name = "Author: Rez23",
                        order = 1,
                    },
                    version = {
                        type = "description",
                        name = "Version: " .. self:GetVersion(),
                        order = 2,
                    },
                    website = {
                        type = "description",
                        name = "Website: |cFF00FF00" .. addonTable.GitHubURL .. "|r",
                        order = 3,
                    },
                },
            },
            --@do-not-package@
            debug = {
                --[===[@non-debug@
                hidden = true,
                @end-non-debug@]===]
                type = "group",
                name = "Debug Settings",
                desc = "Debug settings for development purposes.",
                args = {
                    logLevel = {
                        type = "select",
                        name = "Setting up log level",
                        desc = "Increase log level for debugging.",
                        values = {
                            [-1] = "None",
                            [0] = "Error",
                            [1] = "Warning",
                            [2] = "Info",
                            [3] = "Debug",
                            [4] = "Trace",
                        },
                        get = function() return self.db.profile.logLevel end,
                        set = function(_, value) self.db.profile.logLevel = value end,
                    },
                    debugButtons = {
                        type = "toggle",
                        name = "Enable Debug Mode",
                        desc = "Enable or disable debug buttons and set log level to Error mode.",
                        get = function() return self.db.profile.debugButtons end,
                        set = function(_, value)
                            self.db.profile.debugButtons = value
                            if value then
                                self:Info("Debug buttons enabled")
                                self.db.profile.logLevel = self.db.profile.oldLogLevel or 4
                                ---@diagnostic disable-next-line: invisible
                                self.debugButtonsContainer.frame:Show()
                            else
                                self:Info("Debug buttons disabled")
                                self.db.profile.oldLogLevel = self.db.profile.logLevel
                                self.db.profile.logLevel = 0
                                ---@diagnostic disable-next-line: invisible
                                self.debugButtonsContainer.frame:Hide()
                            end
                        end,
                    },
                },
            },
            --@end-do-not-package@
        },
    }
end
