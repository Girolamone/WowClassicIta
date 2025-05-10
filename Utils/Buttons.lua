local addonName, addonTable = ...

--- @class WowClassicIta
local WowClassicIta = _G.LibStub("AceAddon-3.0"):GetAddon(addonName)

---@class BtnsStateRules
---@field questsLogBtn boolean? Whether to show quest buttons
---@field gossipFrameBtn boolean? Whether to show gossip buttons
---@field questFrameBtn boolean? Whether to show quest frame buttons

--- Creates custom buttons for the quest frame in the WowClassicIta addon.
--- This function is responsible for adding UI elements to the quest frame,
--- allowing users to interact with the WowClassicIta addon features.
--- It modifies the quest frame to include additional functionality.
--- @return table|AceGUIButton|Button, table|AceGUIButton|Button, table|AceGUIButton|Button
--- @private
function WowClassicIta:CreateButtonsOnGameFrames()
    local AceGUI = LibStub("AceGUI-3.0")

    ---@type AceGUIButton
    local questFrameIdButton = AceGUI:Create("Button")
    ---@type AceGUIButton
    local gossipIdButton = AceGUI:Create("Button")
    ---@type AceGUIButton
    local questLogIdButton = AceGUI:Create("Button")
    ---@type AceGUIButton
    local questSettingsButton = AceGUI:Create("Button")

    --- QuestFrame button
    questFrameIdButton:SetWidth(170)
    questFrameIdButton:SetText("Quest ID=?")

    --- QuestLogFrame button
    questLogIdButton:SetWidth(170)
    questLogIdButton:SetHeight(22)
    questLogIdButton:SetText("Quest Log ID=?")

    --- GossipFrame button
    gossipIdButton:SetWidth(150)
    gossipIdButton:SetHeight(20)
    gossipIdButton:SetText("Gossip ID=?")

    --- QuestSettings button
    questSettingsButton:SetText("WCI")

    ---@type AceGUISimpleGroup
    local questFrameWidgetContainer = AceGUI:Create("SimpleGroup")

    ---@type AceGUISimpleGroup
    local questLogWidgetContainer = AceGUI:Create("SimpleGroup")

    ---@type AceGUISimpleGroup
    local gossipFrameWidgetContainer = AceGUI:Create("SimpleGroup")

    --[[
    gossipFrameWidgetContainer.frame:SetParent(QuestFrame)
    gossipFrameWidgetContainer.frame:ClearAllPoints()
    gossipFrameWidgetContainer.frame:SetPoint("TOPLEFT", QuestFrame, "TOPLEFT", 120, -50)

    gossipFrameWidgetContainer:SetFullWidth(true)
    gossipFrameWidgetContainer:SetFullHeight(true)
    gossipFrameWidgetContainer:SetLayout("Flow")
    gossipFrameWidgetContainer:AddChild(gossipIdButton)
    gossipFrameWidgetContainer:DoLayout()]]

    ---@diagnostic disable: invisible
    questFrameWidgetContainer.frame:SetParent(QuestFrame)
    questFrameWidgetContainer.frame:ClearAllPoints()
    questFrameWidgetContainer.frame:SetPoint("TOP", QuestFrame, "TOP", 55, -45)
    questFrameWidgetContainer:SetFullWidth(true)
    questFrameWidgetContainer:SetFullHeight(true)
    questFrameWidgetContainer:SetLayout("Flow")
    questFrameWidgetContainer:AddChild(questFrameIdButton)
    --questFrameWidgetContainer:AddChild(gossipIdButton)
    questFrameWidgetContainer:DoLayout()

    questLogWidgetContainer.frame:SetParent(QuestLogFrame)
    questLogWidgetContainer.frame:ClearAllPoints()
    questLogWidgetContainer.frame:SetPoint("BOTTOMRIGHT", QuestLogFrame, "BOTTOMRIGHT", -50, 53.5)
    questLogWidgetContainer:SetFullWidth(true)
    questLogWidgetContainer:SetFullHeight(true)
    questLogWidgetContainer:SetLayout("Flow")
    questLogWidgetContainer:AddChild(questLogIdButton)
    --questLogWidgetContainer:AddChild(questSettingsButton)
    questLogWidgetContainer:DoLayout()
    ---@diagnostic enable: invisible

    --- save widget cotainers
    self.widgetContainer = {
        questFrameWidgetContainer = questFrameWidgetContainer,
        questLogWidgetContainer = questLogWidgetContainer,
        gossipFrameWidgetContainer = gossipFrameWidgetContainer,
    }

    questFrameIdButton:SetCallback("OnClick", function()
        self:Trace("|cFFFFC0CB[Buttons:OnClickHandler]|r Quest button clicked -> onClickHandler() fired!")

        --- When the button is clicked, toggle the translation
        self.isCurrentQuestTranslated = not self.isCurrentQuestTranslated

        local questID = self:GetQuestID()
        if not questID then
            self:Error("Impossible to retrieve current Quest ID from WOW API!")
            return
        end

        local language =
            self.isCurrentQuestTranslated and
            self:FetchCurrentSetting().quests.enabled and
            "itIT" or GetLocale()
        local text = "Quest ID=" .. tostring(questID) .. " (" .. language .. ") ";

        local button = self.widgets.questFrameToggle
        button:SetDisabled(not self:FetchCurrentSetting().quests.enabled)
        button:SetText(text)

        -- Update quest frame text based on the current user settings
        self:UpdateQuestFrame({
            Description = self:GetQuestDescription(questID),
            Objectives = self:GetQuestObjectives(questID),
            Completion = self:GetQuestCompletion(questID),
        })
    end);

    questLogIdButton:SetCallback("OnClick", function()
        self:Trace("|cFFFFC0CB[Buttons:OnClickHandler]|r Quest button clicked -> onClickHandler() fired!")

        --- When the button is clicked, toggle the translation
        self.isCurrentQuestTranslated = not self.isCurrentQuestTranslated

        local questID = self:GetQuestID()
        if not questID then
            self:Error("Impossible to retrieve current Quest ID from WOW API!")
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
            Description = self:GetQuestDescription(questID, QuestLogFrame:IsShown()),
            Objectives = self:GetQuestObjectives(questID, QuestLogFrame:IsShown()),
            Completion = self:GetQuestCompletion(questID, QuestLogFrame:IsShown()),
        })
    end);

    gossipIdButton:SetCallback("OnClick", function()
        self:Trace("|cFFFFC0CB[Buttons:OnClickHandler]|r Quest button clicked -> onClickHandler() fired!")

        --- When the button is clicked, toggle the translation
        self.isCurrentQuestTranslated = not self.isCurrentQuestTranslated

        local questID = self:GetQuestID()
        if not questID then
            self:Error("Impossible to retrieve current Quest ID from WOW API!")
            return
        end

        local language =
            self.isCurrentQuestTranslated and
            self:FetchCurrentSetting().quests.enabled and
            "itIT" or GetLocale()
        local text = "Quest ID=" .. tostring(questID) .. " (" .. language .. ") ";

        local button = self.widgets.gossipFrameToggle
        button:SetDisabled(not self:FetchCurrentSetting().quests.enabled)
        button:SetText(text)

        -- Update quest frame text based on the current user settings
        self:UpdateQuestFrame({
            Description = self:GetQuestDescription(questID),
            Objectives = self:GetQuestObjectives(questID),
            Completion = self:GetQuestCompletion(questID),
        })
    end);

    return questFrameIdButton, questLogIdButton, gossipIdButton
end

--- Set the state of the buttons based on the provided setting.
---@param btnStatus BtnsStateRules Contain state rules for the buttons.
function WowClassicIta:SetButtonsState(btnStatus)
    if btnStatus.gossipFrameBtn ~= nil then self.widgets.gossipFrameToggle.SetDiabled(not btnStatus.gossipFrameBtn) end
    if btnStatus.questsLogBtn ~= nil then self.widgets.questLogFrameToggle.SetDisabled(not btnStatus.questsLogBtn) end
    if btnStatus.questFrameBtn ~= nil then self.widgets.questFrameToggle.SetDisabled(not btnStatus.questFrameBtn) end
end

function WowClassicIta:HideAllButtons()
    for _, widget in pairs(self.widgetContainer) do
        widget.frame:Hide()
    end
end

function WowClassicIta:ShowAllButtons()
    for _, widget in pairs(self.widgetContainer) do
        widget.frame:Show()
    end
end

--- Enable interface buttons and set button interface ui text to questID 
---
--- @param questID number The unique identifier of the quest to permit translation for.
function WowClassicIta:PermitTranslationForThisQuest(questID)
    local language =
        self.isCurrentQuestTranslated and
        self:FetchCurrentSetting().quests.enabled and
        "itIT" or GetLocale()

    local text = "Quest ID=" .. tostring(questID) .. " (" .. language .. ") ";

    for _, button in pairs(self.widgets) do
        button:SetDisabled(not self:FetchCurrentSetting().quests.enabled)
        button:SetText(text)
    end
end