local addonName, addonTable = ...

---@class WowClassicIta
local WowClassicIta = _G.LibStub("AceAddon-3.0"):GetAddon(addonName)

addonTable.GitHubURL = "https://github.com/Rez23/WowClassicIta"

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
                set = function(info, value) if not value then self:HideAllButtons() else self:ShowAllButtons() end; self.db.profile.disabled = not value end,
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
                                disabled = function() return not self.db.profile.spells.enabled or self.db.profile.disabled end,
                                get = function(info) return self.db.profile.spells.name end,
                                set = function(info, value) self.db.profile.spells.name = value end,
                            },
                            description = {
                                type = "toggle",
                                name = "Spell Description",
                                desc = "Enable or disable spell description translations.",
                                disabled = function() return not self.db.profile.spells.enabled or self.db.profile.disabled end,
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
                                disabled = function() return not self.db.profile.items.enabled or self.db.profile.disabled end,
                                get = function(info) return self.db.profile.items.name end,
                                set = function(info, value) self.db.profile.items.name = value end,
                            },
                            description = {
                                type = "toggle",
                                name = "Item Description",
                                desc = "Enable or disable item description translations.",
                                disabled = function() return not self.db.profile.items.enabled or self.db.profile.disabled end,
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
                                set = function(info, value) if not value then self.widgets.questFrameToggle.frame:Hide(); self.widgets.questLogFrameToggle.frame:Hide(); end; self.db.profile.quests.enabled = value end,
                            },
                            name = {
                                type = "toggle",
                                name = "Quest Name",
                                desc = "Enable or disable quest name translations.",
                                disabled = function() return not self.db.profile.quests.enabled or self.db.profile.disabled end,
                                get = function(info) return self.db.profile.quests.name end,
                                set = function(info, value) self.db.profile.quests.name = value end,
                            },
                            description = {
                                type = "toggle",
                                name = "Quest Description",
                                desc = "Enable or disable quest description translations.",
                                disabled = function() return not self.db.profile.quests.enabled or self.db.profile.disabled end,
                                get = function(info) return self.db.profile.quests.description end,
                                set = function(info, value) self.db.profile.quests.description = value end,
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
                                set = function(info, value) if not value then self.widgets.gossipFrameToggle.frame:Hide() end; self.db.profile.gossip.enabled = value end,
                            },
                            name = {
                                type = "toggle",
                                name = "Gossip Name",
                                desc = "Enable or disable gossip name translations.",
                                disabled = function() return not self.db.profile.gossip.enabled or self.db.profile.disabled end,
                                get = function(info) return self.db.profile.gossip.name end,
                                set = function(info, value) self.db.profile.gossip.name = value end,
                            },
                            description = {
                                type = "toggle",
                                name = "Gossip Description",
                                desc = "Enable or disable gossip description translations.",
                                disabled = function() return not self.db.profile.gossip.enabled or self.db.profile.disabled end,
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
                    }
                },
            },
        },
    }
end