---@alias QuestTextSection
---| '"title"'         # Quest title section
---| '"description"'   # Quest description section
---| '"objectives"'    # Quest objectives section
---| '"completion"'    # Quest completion section
---| '"progress"'      # Quest progress section
---| '"rewards"'       # Quest rewards section
---| '"minlevel"'      # Quest minimum level section
---| '"questlevel"'         # Quest level section

local addonName, addonTable = ...

--- @class WowClassicIta
local WowClassicIta = _G.LibStub("AceAddon-3.0"):GetAddon(addonName)

--- Returns the title of the current quest translated or original, according to the addon user settings.
--- @param questID number ID of the quest to translated
--- @param isQuestLogFrame boolean? Flag to indicate if QuestLogFrame or QuestFrame is used
--- @return string translatedData TranslatedData translation text if available, original text if not
function WowClassicIta:GetQuestTitle(questID, isQuestLogFrame)
    if self:FetchCurrentSetting().disabled then
        return self:GetOriginalQuest("title", isQuestLogFrame)
    end

    if self:FetchCurrentSetting().quests.name then
        if self.isCurrentQuestTranslated then
            -- return translated string if available original string if not
            return self:GetTranslatedQuest(questID, "title") or self:GetOriginalQuest("title", isQuestLogFrame)
        else
            return self:GetOriginalQuest("title", isQuestLogFrame)
        end
    else
        return self:GetOriginalQuest("title", isQuestLogFrame)
    end
end

---Returns the description of the current quest translated or original, according to the addon user settings
---@param questID number ID of the quest to translated
---@param isQuestLogFrame boolean? Flag to indicate if QuestLogFrame or QuestFrame is used
---@return string translatedData TranslatedData translation text if available, original text if not
function WowClassicIta:GetQuestDescription(questID, isQuestLogFrame)
    if self:FetchCurrentSetting().disabled then
        return self:GetOriginalQuest("description", isQuestLogFrame)
    end

    if self:FetchCurrentSetting().quests.description then
        if self.isCurrentQuestTranslated then
            -- return translated string if available original string if not
            return self:GetTranslatedQuest(questID, "description") or self:GetOriginalQuest("description", isQuestLogFrame)
        else
            return self:GetOriginalQuest("description", isQuestLogFrame)
        end
    else
        return self:GetOriginalQuest("description", isQuestLogFrame)
    end
end

--- Returns the objectives of the current quest translated or original, according to the addon user settings.
---
--- @param questID number The unique identifier of the quest.
--- @param isQuestLogFrame boolean? Flag to indicate if QuestLogFrame or QuestFrame is used
--- @return string translatedData translation text if available, original text if not
function WowClassicIta:GetQuestObjectives(questID, isQuestLogFrame)
    self:Trace("|cFFFFC0CB[Quests:GetQuestObjectives]|r GetQuestObjectives() called!")
    if self:FetchCurrentSetting().disabled then
        self:Trace("|cFFFFC0CB[Quests:GetQuestObjectives]|r FetchCurrentSetting().disabled == true")
        return self:GetOriginalQuest("objectives", isQuestLogFrame)
    end

    if self:FetchCurrentSetting().quests.objectives then
        self:Trace("|cFFFFC0CB[Quests:GetQuestObjectives]|r FetchCurrentSetting().quests.objectives == true")
        if self.isCurrentQuestTranslated then
            self:Trace("|cFFFFC0CB[Quests:GetQuestObjectives]|r isCurrentQuestTranslated == true")
            -- return translated string if available original string if not
            return self:GetTranslatedQuest(questID, "objectives") or self:GetOriginalQuest("objectives", isQuestLogFrame)
        else
            self:Trace("|cFFFFC0CB[Quests:GetQuestObjectives]|r isCurrentQuestTranslated == false")
            return self:GetOriginalQuest("objectives", isQuestLogFrame)
        end
    else
        self:Trace("|cFFFFC0CB[Quests:GetQuestObjectives]|r FetchCurrentSetting().quests.objectives == false")
        return self:GetOriginalQuest("objectives", isQuestLogFrame)
    end
end

--- Returns the rewards of the current quest translated or original, according to the addon user settings.
--- @param questID number The unique identifier of the quest.
--- @param isQuestLogFrame boolean? Flag to indicate if QuestLogFrame or QuestFrame is used
--- @return string translatedData translation text if available, original text if not
function WowClassicIta:GetQuestRewards(questID, isQuestLogFrame)
    if self:FetchCurrentSetting().disabled then
        return self:GetOriginalQuest("rewards", isQuestLogFrame)
    end

    if self:FetchCurrentSetting().quests.rewards then
        if self.isCurrentQuestTranslated then
            -- return translated string if available original string if not
            return self:GetTranslatedQuest(questID, "rewards") or self:GetOriginalQuest("rewards", isQuestLogFrame)
        else
            return self:GetOriginalQuest("rewards", isQuestLogFrame)
        end
    else
        return self:GetOriginalQuest("rewards", isQuestLogFrame)
    end
end

--- Returns the completion text of the current quest translated or original, according to the addon user settings.
--- @param questID number The unique identifier of the quest.
--- @param isQuestLogFrame boolean? Flag to indicate if QuestLogFrame or QuestFrame is used
--- @return string translatedData translation text if available, original text if not
function WowClassicIta:GetQuestCompletion(questID, isQuestLogFrame)
    if self:FetchCurrentSetting().disabled then
        return self:GetOriginalQuest("completion", isQuestLogFrame)
    end

    if self:FetchCurrentSetting().quests.completion then
        if self.isCurrentQuestTranslated then
            -- return translated string if available original string if not
            return self:GetTranslatedQuest(questID, "completion") or self:GetOriginalQuest("completion", isQuestLogFrame)
        else
            return self:GetOriginalQuest("completion", isQuestLogFrame)
        end
    else
        return self:GetOriginalQuest("completion", isQuestLogFrame)
    end
end

--- Retrieves the ID for the currently active quest.
--- @return number|nil questID The ID of the active quest or nil if not found.
function WowClassicIta:GetQuestID()
    if QuestFrame:IsShown() and QuestFrame:IsVisible() then
        return GetQuestID();
    elseif QuestLogFrame and QuestLogFrame:IsVisible() then
        return select(8, GetQuestLogTitle(GetQuestLogSelection()));
    else
        return nil
    end
end

function WowClassicIta:PurgeTranslationForThisQuest(questID)
    self.questFrameIdButton:SetDisabled(true)
    self.questLogIdButton:SetDisabled(true)

    local text = "Quest ID=" .. tostring(questID) .. " (" .. GetLocale() .. ") ";
    --- Set language in quest button
    self.questFrameIdButton:SetText(text)
    self.questLogIdButton:SetText(text)
    self.gossipIdButton:SetText(text)
end

function WowClassicIta:PermitTranslationForThisQuest(questID)
    local language =
        self.isCurrentQuestTranslated and
        self:FetchCurrentSetting().quests.enabled and
        "itIT" or GetLocale()

    local text = "Quest ID=" .. tostring(questID) .. " (" .. language .. ") ";

    self.questFrameIdButton:SetDisabled(not self:FetchCurrentSetting().quests.enabled)
    self.questFrameIdButton:SetText(text)
end

function WowClassicIta:GetQuestUxMessages()

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
    self:UpdateQuestsCommonTexts()

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

function WowClassicIta:UpdateQuestsCommonTexts()
    --- Save the quest frame fixed text (usually titles of the quests sections)
    local commonQuestTextData = self:SmartGetUiSharedText().QuestsCommonText
    local sharedDetailsText = commonQuestTextData.Details
    local sharedRewardsText = commonQuestTextData.Rewards
    local sharedReqItemsText = commonQuestTextData.ReqItems
    local sharedItemChooseRewards1Text = commonQuestTextData.ItemChooseRewards1
    local sharedItemChooseRewards2Text = commonQuestTextData.ItemChooseRewards2
    local sharedMoneyRewardText = commonQuestTextData.MoneyReward
    local sharedProgressText = commonQuestTextData.Progress
    local sharedCompletionText = commonQuestTextData.Completion
    local sharedObjectiveText = commonQuestTextData.Objectives
    local sharedItemSingleRewardsText = commonQuestTextData.ItemSingleReward

    self:Trace("|cFFFFC0CB[Core:QuestsUpdateQuestsCommonText]|r CosharedObjectiveText: " .. sharedObjectiveText)
    QuestInfoObjectivesHeader:SetFont(self.fontHeader, 18)
    QuestInfoObjectivesHeader:SetText(sharedObjectiveText)
    QuestInfoObjectivesText:SetFont(self.fontText, 13)
    QuestInfoObjectivesText:SetText(sharedObjectiveText)
    QuestLogObjectivesText:SetFont(self.fontText, 13)
    QuestLogObjectivesText:SetText(sharedObjectiveText)

    --- Setup quests statc text elements
    self:Trace("|cFFFFC0CB[Quests:UpdateQuestsCommonTexts]|r sharedRewardsText: " .. sharedRewardsText)
    QuestLogRewardTitleText:SetFont(self.fontHeader, 18)
    QuestLogRewardTitleText:SetText(sharedRewardsText)

    QuestInfoRewardsFrame.Header:SetFont(self.fontHeader, 18);
    QuestInfoRewardsFrame.Header:SetText(sharedRewardsText);

    self:Trace("|cFFFFC0CB[Quests:UpdateQuestsCommonTexts]|r sharedDetailsText: " .. sharedDetailsText)
    QuestLogDescriptionTitle:SetFont(self.fontText, 13)
    QuestLogDescriptionTitle:SetText(sharedDetailsText)

    self:Trace("|cFFFFC0CB[Quests:UpdateQuestsCommonTexts]|r sharedReqItemsText: " .. sharedReqItemsText)
    QuestProgressRequiredItemsText:SetFont(self.fontHeader, 18)
    QuestProgressRequiredItemsText:SetText(sharedReqItemsText)

    self:Trace("|cFFFFC0CB[Quests:UpdateQuestsCommonTexts]|r sharedItemChooseRewards1Text: " ..
        sharedItemChooseRewards1Text)
    QuestLogItemChooseText:SetFont(self.fontText, 13)
    QuestLogItemChooseText:SetText(sharedItemChooseRewards1Text)

    self:Trace("|cFFFFC0CB[Quests:UpdateQuestsCommonTexts]|r sharedMoneyRewardText: " .. sharedMoneyRewardText)
    QuestLogItemReceiveText:SetFont(self.fontText, 13)
    QuestLogItemReceiveText:SetText(sharedMoneyRewardText)

    self:Trace("|cFFFFC0CB[Quests:UpdateQuestsCommonTexts]|r sharedItemChooseRewards2Text: " ..
        sharedItemChooseRewards2Text)
    QuestInfoRewardsFrame.ItemChooseText:SetFont(self.fontText, 13)
    QuestInfoRewardsFrame.ItemChooseText:SetText(sharedItemChooseRewards2Text)

    self:Trace("|cFFFFC0CB[Quests:UpdateQuestsCommonTexts]|r sharedDetailsText: " .. sharedDetailsText)
    QuestLogQuestDescription:SetFont(self.fontText, 13)
    QuestLogQuestDescription:SetText(sharedDetailsText)
    QuestInfoDescriptionText:SetFont(self.fontText, 13)
    QuestInfoDescriptionText:SetText(sharedDetailsText)
    QuestLogObjectivesText:SetFont(self.fontText, 13)
    QuestLogObjectivesText:SetText(sharedDetailsText)

    QuestInfoRewardsFrame.ItemChooseText:SetFont(self.fontText, 13);
    QuestInfoRewardsFrame.ItemChooseText:SetText(sharedItemChooseRewards2Text);
    QuestInfoRewardsFrame.ItemReceiveText:SetFont(self.fontText, 13);
    QuestInfoRewardsFrame.ItemReceiveText:SetText(sharedItemSingleRewardsText);
end

function WowClassicIta:GetQuesLevel(questID, isQuestLogFrame)
    if self:FetchCurrentSetting().disabled then
        return self:GetOriginalQuest("questlevel", isQuestLogFrame)
    end

    if self:FetchCurrentSetting().quests.completion then
        if self.isCurrentQuestTranslated then
            -- return translated string if available original string if not
            return self:GetTranslatedQuest(questID, "questlevel") or self:GetOriginalQuest("questlevel", isQuestLogFrame)
        else
            return self:GetOriginalQuest("questlevel", isQuestLogFrame)
        end
    else
        return self:GetOriginalQuest("questlevel", isQuestLogFrame)
    end
end

function WowClassicIta:GetMinLevel(questID, isQuestLogFrame)
    return self:GetOriginalQuest("minlevel", isQuestLogFrame)
end
