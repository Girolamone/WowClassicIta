-- The ellipsis captures the arguments passed to the script.
-- WoW passes the add-on name as the first argument and an empty table
-- as the second argument.
local addonName, addonTable = ...

--- @class WowItaWidgets Holds references to main addon widgets
--- @field questFrameToggle table The frame of the button
--- @field questLogFrameToggle table The frame of the quest log button
--- @field gossipFrameToggle table The frame of the gossip button

--- @class WowItaWidgetContainer
--- @field questFrameWidgetContainer table The frame of the quest widget container
--- @field questLogWidgetContainer table The frame of the quest log widget container
--- @field gossipFrameWidgetContainer table The frame of the gossip widget container

--- @class WowClassicIta : AceAddon-3.0, AceConsole-3.0, AceEvent-3.0, AceHook-3.0, AceTimer-3.0
--- @field db table A reference to persistent saved val in DB
--- @field db.profile WowClassicItaSettings The current profile settings
--- @field options table Options table for the add-on
--- @field configFrame table The configuration frame for the add-on
--- @field default table Default settings for the add-on
--- @field characterName string The name of the current character
--- @field characterRace string The race of the current character
--- @field characterClass string The class of the current character
--- @field characterSex string The sex of the current character
--- @field fontHeader string The font used for the quest title
--- @field fontText string The font used for the quest description
--- @field isCurrentQuestTranslated boolean Indicates whether the current quest is translated or not
--- @field questButton table The button used to toggle quest translation
--- @field questFrameIdButton table The button used to toggle quest frame translation
--- @field questLogIdButton table The button used to toggle quest log translation
--- @field gossipIdButton table The button used to toggle gossip translation
--- @field GitHubURL string The URL of the add-on's GitHub repository
--- @field widgets WowItaWidgets Table containing the buttons of the add-on
--- @field widgetContainer WowItaWidgetContainer Table containing the widget containers of the add-on
local WowClassicIta = _G.LibStub("AceAddon-3.0"):NewAddon(addonTable, addonName, "AceConsole-3.0", "AceEvent-3.0",
    "AceHook-3.0", "AceTimer-3.0")

local cmdAliases = { "wci", "ita", "wowita", "italian", addonName }

--- When Addon is initialized
function WowClassicIta:OnInitialize()
    -- Initialize the database
    self.db = LibStub("AceDB-3.0"):New("WowClassicItaDB", self:GetDeafultProfile(), true)
    -- Initialize internal default
    self.isCurrentQuestTranslated = true

    self.fontHeader = "Interface\\AddOns\\WoWita_Quests\\Fonts\\morpheus_pl.ttf"
    self.fontText = "Interface\\AddOns\\WoWita_Quests\\Fonts\\frizquadratatt_pl.ttf"

    --- Register the options table
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, self:GetOptionsDataStruct(), cmdAliases)

    --- Add the options to the Blizzard Interface Options
    self.configFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName)

    --- Register all slash commands
    for _, cmd in ipairs(cmdAliases) do
        self:RegisterChatCommand(cmd, function(input)
            if not input or input:trim() == "" then
                -- Simulate the auto-generated help output.
                print("\n")
                print("Aliases:")
                print("  /" .. table.concat(cmdAliases, ", /"))
                print("\n")
                print("Usage:")
                print("  /" .. cmd .. " <command> [arguments]\n\n")
                print("Commands:")

                -- Loop through available commands from your options table.
                for key, option in pairs(self:GetOptionsDataStruct().args) do
                    local desc = option.desc or "No description provided."
                    print("  " .. key .. " - " .. desc)
                end
            else
                LibStub("AceConfigCmd-3.0"):HandleCommand(cmd, addonName, input)
            end
        end)
    end

    --@do-not-package@
    -- Register separate slash command for reset DB manually
    self:RegisterChatCommand("wciresetdb", function()
        self:Print("Resetting the database...")
        self.db:ResetProfile()
        self:Print("Database resetted!")
    end)
    --@end-to-not-package@
end

--- When Addon is enabled
function WowClassicIta:OnEnable()
    self:Trace("|cFFFFC0CB[Core:OnEnable()]|r Addon correctly loaded and enabled!")

    --@do-not-package@
    --- Debug porpuse buttons (that not will be available in the release)
    ---@type AceGUISimpleGroup
    local debugButtonsContainer = LibStub("AceGUI-3.0"):Create("SimpleGroup")
    ---@type AceGUIButton
    local reloadUiButton = LibStub("AceGUI-3.0"):Create("Button")
    ---@type AceGUIButton
    local resetDbButton = LibStub("AceGUI-3.0"):Create("Button")
    ---@type AceGUIButton
    local globalExtOnOffButton = LibStub("AceGUI-3.0"):Create("Button")

    reloadUiButton:SetWidth(100)
    reloadUiButton:SetHeight(22)
    reloadUiButton:SetText("reload-ui")
    reloadUiButton:SetCallback("OnClick", function()
        self:Print("Reloading UI...")
        ReloadUI()
    end)

    resetDbButton:SetWidth(100)
    resetDbButton:SetHeight(22)
    resetDbButton:SetText("reset-db")
    resetDbButton:SetCallback("OnClick", function()
        self:Print("Resetting the database...")
        self.db:ResetProfile()
        self:Print("Database resetted!")
    end)

    globalExtOnOffButton:SetWidth(100)
    globalExtOnOffButton:SetHeight(22)
    globalExtOnOffButton:SetText("Enable/Disable addon")
    self.addonOnOffSwitch = self:FetchCurrentSetting().disabled
    globalExtOnOffButton:SetCallback("OnClick", function()
        if not self.addonOnOffSwitch then
            self:TurnAddonOn()
        else
            self:TurnAddonsOff()
        end
        self.addonOnOffSwitch = not self.addonOnOffSwitch
        self.db.profile.disabled = self.addonOnOffSwitch
        self:Info("Add-on is now " .. (self.addonOnOffSwitch and "disabled" or "enabled"))
    end)

    ---@diagnostic disable-next-line: invisible
    debugButtonsContainer.frame:SetPoint("TOPRIGHT", QuestFrame, "TOPRIGHT", 520, 100)
    debugButtonsContainer:SetFullWidth(true)
    debugButtonsContainer:SetFullHeight(true)
    debugButtonsContainer:SetLayout("Flow")
    debugButtonsContainer:AddChild(reloadUiButton)
    debugButtonsContainer:AddChild(resetDbButton)
    debugButtonsContainer:AddChild(globalExtOnOffButton)
    debugButtonsContainer:DoLayout()
    --@end-do-not-package@

    local questFrameIdButton, questLogIdButton, gossipIdButton = self:CreateButtonsOnGameFrames()

    if not questFrameIdButton or not questLogIdButton or not gossipIdButton then
        self:Error("Impossible to create the quest/questlog/gossip frame button!")
        self:Error("Extension cannot be loaded, so will be disabled.")
        self:Error("If you want, open an issue at: " .. addonTable.GitHubURL)
        self:UnregisterAllEvents()
        return
    elseif (not questFrameIdButton or not questLogIdButton) and self:FetchCurrentSetting().quests.enabled and not self:FetchCurrentSetting().disabled then
        self:Error("Impossible to create the quest/questlog frame button!")
        self:Error("Extension cannot be loaded, so will be disabled.")
        self:Error("If you want, open an issue at: " .. addonTable.GitHubURL)
        self:UnregisterAllEvents()
        return
    elseif not gossipIdButton and self:FetchCurrentSetting().gossip.enable and not self:FetchCurrentSetting().disabled then
        self:Error("Impossible to create the gossip frame button!")
        self:Error("Extension cannot be loaded, so will be disabled.")
        self:Error("If you want, open an issue at: " .. addonTable.GitHubURL)
        self:UnregisterAllEvents()
        return
    end

    ---@diagnostic disable: invisible
    questFrameIdButton.frame:Show()
    questFrameIdButton:SetDisabled(false)

    questLogIdButton.frame:Show()
    questLogIdButton:SetDisabled(false)

    gossipIdButton.frame:Show()
    gossipIdButton:SetDisabled(false)
    ---@diagnostic enable: invisible

    self.questFrameIdButton = questFrameIdButton
    self.questLogIdButton = questLogIdButton
    self.gossipIdButton = gossipIdButton

    self.widgets = {
        gossipFrameToggle = gossipIdButton,
        questFrameToggle = questFrameIdButton,
        questLogFrameToggle = questLogIdButton,
    }

    local onSelectQuestLogEntry = function()
        self:Trace("|cFFFFC0CB[Core:onSelectQuestLogEntry]|r Fired function handler")
        local questID = self:GetQuestID()
        if not QuestLogFrame:IsShown() then
            self:Trace("|cFFFFC0CB[Core:onSelectQuestLogEntry]|r Quest Log Frame is not shown!")
            return
        end

        if not questID then
            --- If the quest ID is not available, log an error
            --- and return without doing anything.
            self:Error("Impossible retrieve current Quest ID from WOW API!")
            return
        end

        local language =
            self.isCurrentQuestTranslated and
            self:FetchCurrentSetting().quests.enabled and
            "itIT" or GetLocale()

        local text = "Quest ID=" .. tostring(questID) .. " (" .. language .. ") ";

        local button = self.widgets.questLogFrameToggle
        button:SetDisabled(not self:FetchCurrentSetting().quests.enabled)
        button:SetText(text)

        -- Update quest frame text based on the current user settings
        self:UpdateQuestFrame({
            Description = self:GetQuestDescription(questID),
            Objectives = self:GetQuestObjectives(questID),
            Completion = self:GetQuestCompletion(questID),
        })
    end

    --QuestLogDetailScrollFrame:HookScript("OnShow", onQuestLogEntryClick)
    --[[EmptyQuestLogFrame:HookScript("OnShow", function()
        self:Trace("|cFFFFC0CB[Core:EmptyQuestLogFrame:Hooks:OnShow]|r EmptyQuestLogFrame hoocked OnShow() started!")
        self.questLogIdButton:Hide()
    end)]]

    self:SecureHook('SelectQuestLogEntry', function()
        self:Trace("|cFFFFC0CB[Core:Hooks:SelectQuestLogEntry]|r Quest Log Entry clicked!")
        if not self:FetchCurrentSetting().quests.enabled or self:FetchCurrentSetting().disabled then
            --- If the quest translation is disabled, return without doing anything.
            self:Trace("Quest translation is disabled, so return without doing anything.")
            return
        end

        -- Schedule the delayed execution after 1 second (adjust the delay as needed)
        self:ScheduleTimer(onSelectQuestLogEntry, 0.1)
    end)

    --QuestLogDetailScrollFrame:HookScript("OnShow", onSelectQuestLogEntry);



    self:RegisterEvent('PLAYER_LOGIN', function()
        -- save current player informations for lather
        self.characterName = UnitName("player")
        self.characterClass = UnitClass("player")
        self.characterRace = UnitRace("player")
        self.characterSex = UnitSex("player")

        self:Debug("|cFFDDA0DDPlayer name:|r " .. self.characterName)
        self:Debug("|cFFDDA0DDPlayer class:|r " .. self.characterClass)
        self:Debug("|cFFDDA0DDPlayer race:|r " .. self.characterRace)
        self:Debug("|cFFDDA0DDPlayer sex:|r " .. self.characterSex)
    end)

    --- Handles the quest frame events
    local onQuestFrameShown = function(eventName)
        if not self:FetchCurrentSetting().quests.enabled then
            --- If the quest translation is disabled, return without doing anything.
            return
        end

        local questID = self:GetQuestID()

        if not questID then
            --- If the quest ID is not available, log an error
            --- and return without doing anything.
            self:Error("Impossible retrieve current Quest ID!")
            return
        end

        self:PermitTranslationForThisQuest(questID)

        --- Update the quest frame with the retrieved data
        --- based on current event
        if eventName == "QUEST_DETAIL" then 
            self:Trace("|cFFFFC0CB[Core:RegisterEvent(QUEST_DETAIL)]|r event fired!")
            self:UpdateQuestFrame({
                Description = self:GetQuestDescription(questID),
                Objectives = self:GetQuestObjectives(questID),
            })
        elseif eventName == "QUEST_COMPLETE" then
            self:Trace("|cFFFFC0CB[Core:RegisterEvent(QUEST_COMPLETE)]|r event fired!")
            self:UpdateQuestFrame({
                Completion = self:GetQuestCompletion(questID),
            })
        elseif eventName == "QUEST_PROGRESS" then
            self:Trace("|cFFFFC0CB[Core:RegisterEvent(QUEST_PROGRESS)]|r event fired!")
            self:UpdateQuestFrame({
                Objectives = self:GetQuestObjectives(questID),
            })
        end
    end
    --- the player progress inside a quest.
    self:RegisterEvent('QUEST_PROGRESS', onQuestFrameShown);
    --- the player get details from a quest.
    self:RegisterEvent('QUEST_DETAIL', onQuestFrameShown);
    --- the player complete a quest.
    self:RegisterEvent('QUEST_COMPLETE', onQuestFrameShown);
end
