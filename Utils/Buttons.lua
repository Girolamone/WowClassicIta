local addonName, addonTable = ...

--- @class WowClassicIta
local WowClassicIta = _G.LibStub("AceAddon-3.0"):GetAddon(addonName)

---@class BtnsStateRules
---@field questsLogBtn boolean Whether to show quest buttons
---@field gossipFrameBtn boolean Whether to show gossip buttons
---@field questFrameBtn boolean Whether to show quest frame buttons

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
    questFrameWidgetContainer.frame:SetPoint("TOP", QuestFrame, "TOP", 55,-45)
    questFrameWidgetContainer:SetFullWidth(true)
    questFrameWidgetContainer:SetFullHeight(true)
    questFrameWidgetContainer:SetLayout("Flow")
    questFrameWidgetContainer:AddChild(questFrameIdButton)
    questFrameWidgetContainer:DoLayout()

    questLogWidgetContainer.frame:SetParent(QuestLogFrame)
    questLogWidgetContainer.frame:ClearAllPoints()
    questLogWidgetContainer.frame:SetPoint("BOTTOMRIGHT", QuestLogFrame, "BOTTOMRIGHT", -50, 53.5)
    questLogWidgetContainer:SetFullWidth(true)
    questLogWidgetContainer:SetFullHeight(true)
    questLogWidgetContainer:SetLayout("Flow")
    questLogWidgetContainer:AddChild(questLogIdButton)
    questLogWidgetContainer:DoLayout()
    ---@diagnostic enable: invisible

    --- save widget cotainers
    self.widgetContainer = {
        questFrameWidgetContainer = questFrameWidgetContainer,
        questLogWidgetContainer = questLogWidgetContainer,
        gossipFrameWidgetContainer = gossipFrameWidgetContainer,
    }

    --- Handle click events for the button
    local onCLickHandler = function(button)
        self:Trace("[Buttons:OnClickHandler] Quest button clicked -> onClickHandler() fired!")

        --- When the button is clicked, toggle the translation
        self.isCurrentQuestTranslated = not self.isCurrentQuestTranslated

        local questID = self:GetQuestID()
        if not questID then
            self:Error("Impossible to retrieve current Quest ID from WOW API!")
            return
        end

        self:PermitTranslationForThisQuest(questID)

        -- Update quest frame text based on the current user settings
        self:UpdateQuestFrame({
            --Title = self:GetQuestTitle(questID),
            Description = self:GetQuestDescription(questID),
            Objectives = self:GetQuestObjectives(questID),
            Completion = self:GetQuestCompletion(questID),
        })
    end

    questFrameIdButton:SetCallback("OnClick", onCLickHandler);
    questLogIdButton:SetCallback("OnClick", onCLickHandler);
    gossipIdButton:SetCallback("OnClick", onCLickHandler);

    return questFrameIdButton, questLogIdButton, gossipIdButton
end

function WowClassicIta:HideAllButtons()
    self.questFrameIdButton.frame:Hide()
    self.questLogIdButton.frame:Hide()
    self.gossipIdButton.frame:Hide()
    self:Info("Add-on disabled. All features are turned off.")
end

function WowClassicIta:ShowAllButtons()
    if self.db.profile.quests.enabled then self.widgets.questFrameToggle.frame:Show() end
    if self.db.profile.quests.enabled then self.widgets.questLogFrameToggle.frame:Show() end
    if self.db.profile.gossip.enabled then self.widgets.gossipFrameToggle.frame:Show() end
    self:Info("Add-on enabled. All features turned on according with the user setting.")
end

--- Set the state of the buttons based on the provided setting.
---@param btnStatus BtnsStateRules Contain state rules for the buttons.
function WowClassicIta:SetButtonsState(btnStatus)
    self.widgets.gossipFrameToggle.SetDiabled(not btnStatus.gossipFrameBtn)
    self.widgets.questLogFrameToggle.SetDisabled(not btnStatus.questsLogBtn)
    self.widgets.questFrameToggle.SetDisabled(not btnStatus.questFrameBtn)
end
