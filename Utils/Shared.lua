--- @class NewTooltipData
--- @field name string The name of the tooltip item.
--- @field description string The description of the tooltip item.

--- @alias SpellData NewTooltipData
--- @alias ItemData NewTooltipData
--- @alias SkillData NewTooltipData
--- @alias QuestTooltipData NewTooltipData

---@class QuestsStringsData
---@field Title string?
---@field Description string?
---@field Objectives string?
---@field Progress string?
---@field Completion string?
---@field minlevel string?
---@field questlevel string?

--- @alias QuestFrameType
--- | "q_log" # Quest Log Frame
--- | "q_info"  # Quest Info Frame
--- | "q_progress" # Quest Progress Frame
--- | "q_complete" # Quest Completion Frame
--- | "q_all" # All Frames

local addonName, addonTable = ...

--- @class WowClassicIta
local WowClassicIta = _G.LibStub("AceAddon-3.0"):GetAddon(addonName)

--- Expands unit information from a given message string
--- and returns the message with macros inside expanded.
---
--- @param msg string The input message containing unit information.
--- @return string expanded_msg message with macro expanded.
function WowClassicIta:ExpandUnitInfoFromMsg(msg)
    local expandedMsg = msg;

    expandedMsg = string.gsub(expandedMsg, "NEW_LINE", "\n");
    expandedMsg = string.gsub(expandedMsg, "YOUR_NAME", self.characterName);
    expandedMsg = string.gsub(expandedMsg, "YOUR_GENDER", self.characterSex);
    expandedMsg = string.gsub(expandedMsg, "YOUR_CLASS", self.characterClass);
    expandedMsg = string.gsub(expandedMsg, "YOUR_RACE", self.characterRace);

    return expandedMsg;
end

--- Returns smartly the shared fixed part quests texts (like, for example, quest sections titles)
--- the function will return the translated text or the current game locale text
--- based on the user settings (for example if translations are disabled return the current locale text data)
--- @return SharedUiTextData QuestsCommonText The shared text data for quests translated or of the current locale
function WowClassicIta:SmartGetUiSharedText()
    if self.db.profile.disabled or not self.db.profile.quests.enabled or not self.isCurrentQuestTranslated then
        self:Trace("Core:SmartGetUiSharedText: returning default text")
        return addonTable.SharedUiTextData[GetLocale()]
    else
        self:Trace("Core:SmartGetUiSharedText: returning translated text")
        return addonTable.SharedUiTextData["itIT"]
    end
end

function WowClassicIta:TurnAddonsOff()
    self.db.profile.disabled = true

    self:HideAllButtons()

    self:Info("Add-on disabled. All features are turned off.")
end

function WowClassicIta:TurnAddonOn()
    self.db.profile.disabled = false

    self:ShowAllButtons()

    self:Info("Add-on enabled. All features turned on according with the user setting.")
end

--- Updates the quest frame with the provided quest data.
--- This function is responsible for modifying the quest frame UI
--- based on the details of the given quest.
---
--- @param questData QuestsStringsData A table containing the quest information.
--- The structure of this table should include all necessary fields
--- required to update the quest frame (e.g., quest title, objectives, etc.).
function WowClassicIta:UpdateQuestFrame(questData)
    self:Trace("|cFFFFC0CB[Quests:UpdateFrame]|r UpdateQuestFrame() called!")

    --- Update quest/quest-log frame common static text (like titles, rewards text, ecc.)
    self:UpdateQuestsCommonTexts("q_all")

    local questTitle = questData.Title
    local questDescription = questData.Description
    local questObjectives = questData.Objectives
    local questProgress = questData.Progress
    local questCompletion = questData.Completion
    local questMinLevel = questData.minlevel
    local questLevel = questData.questlevel

    if questTitle then
        self:Debug("|cFFDDA0DDCurrent quest title:|r " .. questTitle)
        -- Quest Log
        QuestLogQuestTitle:SetFont(self.fontHeader, 18)
        QuestLogQuestTitle:SetText(questTitle)

        -- Quest Frame
        QuestInfoTitleHeader:SetFont(self.fontHeader, 18)
        QuestInfoTitleHeader:SetText(questTitle)

        -- Quest Progressing
        QuestProgressTitleText:SetFont(self.fontHeader, 18)
        QuestProgressTitleText:SetText(questTitle)
    end

    if questDescription then
        self:Debug("|cFFDDA0DDCurrent quest description:|r " .. questDescription)
        -- Quest Log
        QuestLogQuestDescription:SetFont(self.fontText, 13)
        QuestLogQuestDescription:SetText(questDescription)

        -- Quest Frame
        QuestInfoDescriptionText:SetFont(self.fontText, 13)
        QuestInfoDescriptionText:SetText(questDescription)
    end

    if questObjectives then
        self:Debug("|cFFDDA0DDCurrent quest objectives:|r " .. questObjectives)

        --- Quest Log
        QuestLogObjectivesText:SetFont(self.fontText, 13)
        QuestLogObjectivesText:SetText(questObjectives)

        --- Quest Frame
        QuestInfoObjectivesText:SetFont(self.fontText, 13)
        QuestInfoObjectivesText:SetText(questObjectives)
    end

    if questProgress then
        self:Debug("|cFFDDA0DDCurrent quest progress:|r " .. questProgress)

        --- Quest Progressing
        QuestProgressText:SetFont(self.fontText, 13)
        QuestProgressText:SetText(questProgress)
    end

    if questCompletion then
        self:Debug("|cFFDDA0DDCurrent quest completion:|r " .. questCompletion)

        -- Quest Frame
        QuestInfoRewardText:SetFont(self.fontText, 13)
        QuestInfoRewardText:SetText(questCompletion)
    end
end

--- Updates the common texts for quests based on the current on-screen frame.
--- This function is part of the WowClassicIta addon and is used to modify
--- or update quest-related text elements according to the given state.
---
--- @param onScreenFrame QuestFrameType A table containing the state information used to update the quest texts.
function WowClassicIta:UpdateQuestsCommonTexts(onScreenFrame)
    local isQuestLog = onScreenFrame == "q_log" or onScreenFrame == "q_all"
    local isQuestInfo = onScreenFrame == "q_info" or onScreenFrame == "q_all"
    local isQuestProgress = onScreenFrame == "q_progress" or onScreenFrame == "q_all"
    local isQuestComplete = onScreenFrame == "q_complete" or onScreenFrame == "q_all"

    --- load the quest common fixed text ('Titolo', 'Descrizione', 'Obiettivi', ecc.)
    --- load only the needed texts (see QuestFrameType)
    local commonQuestTextData = self:SmartGetUiSharedText().QuestsCommonText
    local sharedQuestDetailsText = commonQuestTextData.Details
    local sharedQuestRewardsText = commonQuestTextData.Rewards
    local sharedQuestReqItemsText = commonQuestTextData.ReqItems
    local sharedQuestFutureRewardsText = commonQuestTextData.ItemChooseRewards1
    local sharedQuestCompleteChooseText = commonQuestTextData.ItemChooseRewards2
    local sharedQuestMoneyRewardText = commonQuestTextData.MoneyReward
    local sharedQuestObjectiveText = commonQuestTextData.Objectives
    local sharedSingleRewardsText = commonQuestTextData.ItemSingleReward

    --- for now unused
    local sharedProgressText = commonQuestTextData.Progress
    local sharedCompletionText = commonQuestTextData.Completion

    self:Trace("|cFFFFC0CB[Core:QuestsUpdateQuestsCommonText(" ..
        onScreenFrame .. ")]|r CosharedObjectiveText: " .. sharedQuestObjectiveText)
    QuestInfoObjectivesHeader:SetFont(self.fontHeader, 18)
    QuestInfoObjectivesHeader:SetText(sharedQuestObjectiveText)
    QuestInfoObjectivesText:SetFont(self.fontText, 13)
    QuestInfoObjectivesText:SetText(sharedQuestObjectiveText)

    QuestLogObjectivesText:SetFont(self.fontText, 13)
    QuestLogObjectivesText:SetText(sharedQuestObjectiveText)

    --- Setup quests statc text elements
    self:Trace("|cFFFFC0CB[Quests:UpdateQuestsCommonTexts(" ..
        onScreenFrame .. ")]|r sharedRewardsText: " .. sharedQuestRewardsText)
    if isQuestInfo or isQuestComplete then
        QuestLogRewardTitleText:SetFont(self.fontHeader, 18)
        QuestLogRewardTitleText:SetText(sharedQuestRewardsText)
    end

    if isQuestLog then
        QuestInfoRewardsFrame.Header:SetFont(self.fontHeader, 18);
        QuestInfoRewardsFrame.Header:SetText(sharedQuestRewardsText);
    end

    if isQuestLog then
        self:Trace("|cFFFFC0CB[Quests:UpdateQuestsCommonTexts(" ..
            onScreenFrame .. ")]|r sharedDetailsText: " .. sharedQuestDetailsText)

        QuestLogDescriptionTitle:SetFont(self.fontText, 13)
        QuestLogDescriptionTitle:SetText(sharedQuestDetailsText)
    end

    self:Trace("|cFFFFC0CB[Quests:UpdateQuestsCommonTexts(" ..
        onScreenFrame .. ")]|r sharedReqItemsText: " .. sharedQuestReqItemsText)

    QuestProgressRequiredItemsText:SetFont(self.fontHeader, 18)
    QuestProgressRequiredItemsText:SetText(sharedQuestReqItemsText)

    if isQuestLog then
        self:Trace("|cFFFFC0CB[Quests:UpdateQuestsCommonTexts(" ..
            onScreenFrame .. ")]|r sharedItemChooseRewards1Text: " ..
            sharedQuestFutureRewardsText)

        QuestLogItemChooseText:SetFont(self.fontText, 13)
        QuestLogItemChooseText:SetText(sharedQuestFutureRewardsText)

        self:Trace("|cFFFFC0CB[Quests:UpdateQuestsCommonTexts(" ..
            onScreenFrame .. ")]|r sharedMoneyRewardText: " .. sharedQuestMoneyRewardText)

        QuestLogItemReceiveText:SetFont(self.fontText, 13)
        QuestLogItemReceiveText:SetText(sharedQuestMoneyRewardText)
    end

    if isQuestInfo then
        self:Trace("|cFFFFC0CB[Quests:UpdateQuestsCommonTexts(" ..
            onScreenFrame .. ")]|r sharedItemChooseRewards2Text: " ..
            sharedQuestCompleteChooseText)

        QuestInfoRewardsFrame.ItemChooseText:SetFont(self.fontText, 13)
        QuestInfoRewardsFrame.ItemChooseText:SetText(sharedQuestCompleteChooseText)
    end

    self:Trace("|cFFFFC0CB[Quests:UpdateQuestsCommonTexts(" ..
        onScreenFrame .. ")]|r sharedDetailsText: " .. sharedQuestDetailsText)

    if isQuestLog then
        QuestLogQuestDescription:SetFont(self.fontText, 13)
        QuestLogQuestDescription:SetText(sharedQuestDetailsText)
        QuestLogObjectivesText:SetFont(self.fontText, 13)
        QuestLogObjectivesText:SetText(sharedQuestDetailsText)
    end

    if isQuestInfo then
        QuestInfoDescriptionText:SetFont(self.fontText, 13)
        QuestInfoDescriptionText:SetText(sharedQuestDetailsText)
        QuestInfoRewardsFrame.ItemChooseText:SetFont(self.fontText, 13);
        QuestInfoRewardsFrame.ItemChooseText:SetText(sharedQuestCompleteChooseText);
        QuestInfoRewardsFrame.ItemReceiveText:SetFont(self.fontText, 13);
        QuestInfoRewardsFrame.ItemReceiveText:SetText(sharedSingleRewardsText);
    end
end

--- Updates the text of a tooltip with the provided data and type.
---
--- @param tooltip table The tooltip object to be updated.
--- @param tooltipData NewTooltipData The data to populate the tooltip with.
--- @param type string The type of data being used to update the tooltip.
function WowClassicIta:UpdateTooltipText(tooltip, tooltipData, type)
    if not tooltip or not tooltipData then
        self:Error("Tooltip or tooltip data is nil!")
        return
    end

    local name = tooltipData.name
    local description = tooltipData.description

    if not name or not description then
        self:Error("|cffFF7F7F[Shared:UpdateTooltipText('" .. type .. "')]|r name and description cannot be nil values!")
        return
    end

    local nameTextColor = nil
    if type == "spell" then
        nameTextColor = "|cff00ff00"
    elseif type == "item" then
        nameTextColor = "|cff00ffff"
    elseif type == "skill" then
        nameTextColor = "|cffff00ff"
    elseif type == "quest" then
        nameTextColor = "|cffff7f00"
    else
        self:Error("|cffFF7F7F[Shared:UpdateTooltipText('" .. type .. "')]|r Invalid type provided!")
        return
    end

    tooltip:ClearLines()
    tooltip:AddLine(nameTextColor .. name .. "|r", 1, 1, 1)
    tooltip:AddLine(description, 1, 1, 1, true)
    tooltip:Show()
end

--- Updates the spell tooltip with the provided spell data.
--- This function modifies the tooltip to display additional information
--- about a spell, based on the given spell data.
---
--- @param tooltip table The tooltip object to be updated.
--- @param spellData SpellData The data associated with the spell, which may include
--- details such as spell name, description, or other relevant information.
function WowClassicIta:UpdateSpellTooltip(tooltip, spellData)
    self:UpdateTooltipText(tooltip, spellData, "spell")
end

--- Updates the item tooltip with the provided item data.
---
--- This function modifies the tooltip to display additional information
--- about the item based on the given `itemData`.
---
--- @param tooltip table The tooltip object to be updated.
--- @param itemData ItemData The data associated with the item to display in the tooltip.
function WowClassicIta:UpdateItemTooltip(tooltip, itemData)
    self:UpdateTooltipText(tooltip, itemData, "item")
end

--- Updates the skill tooltip with the provided skill data.
--- This function modifies the given tooltip to display information
--- about a specific skill, based on the provided skill data.
---
--- @param tooltip table The tooltip object to be updated.
--- @param skillData SkillData A table containing data about the skill to display.
function WowClassicIta:UpdateSkillTooltip(tooltip, skillData)
    self:UpdateTooltipText(tooltip, skillData, "skill")
end

--- Updates the quest tooltip with the provided quest data.
---
--- This function modifies the given tooltip to display information
--- about a specific quest. It uses the provided quest data to populate
--- the tooltip with relevant details.
---
--- @param tooltip table The tooltip object to be updated.
--- @param questData QuestTooltipData The data of the quest to display in the tooltip.
---                        This should include all necessary information
---                        about the quest.
function WowClassicIta:UpdateQuestTooltip(tooltip, questData)
    self:UpdateTooltipText(tooltip, questData, "quest")
end
