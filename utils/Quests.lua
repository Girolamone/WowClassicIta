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

--- Get translation for given quest ID and return translated string if exists
--- @param questID number ID of the quest to translate
--- @param needed QuestTextSection Type of translation needed (e.g., "title", "description", "objectives", "complete", "progress")
--- @return string|nil TranslatedData string if available, otherwise nil
--- @private
function WowClassicIta:translate(questID, needed)
    local questsData = addonTable.QuestsData

    local needCamel = function() return needed ~= "questlevel" and needed ~= "minlevel" end

    -- Capitalize the first letter of the needed string
    local accesser = needCamel() and needed.gsub(needed, "^%l", string.upper) or needed

    -- Get the current quest data if exists nil otherwise
    local currentQuestData = questsData[tostring(questID)] and questsData[tostring(questID)][accesser]

    if not currentQuestData then
        if not questsData[tostring(questID)] then
            self:Error("Quest ID " .. tostring(questID).. "is not defined in the database.")
        elseif not questsData[tostring(questID)][accesser] then
            self:Error(accesser .. " section does not exists for quest ID " .. tostring(questID))
        end
        self:Warn("Showing original text. {" .. tostring(needed) .. "," .. tostring(questID) .. "}")
        self:PurgeTranslationForThisQuest(questID)
        return nil
    end

    self:Debug("text(it): '" .. self:ExpandUnitInfoFromMsg(currentQuestData) .. "'")
    self:Debug("text(en): '" .. self:original(needed, QuestLogFrame:IsShown()) .. "'")

    return self:ExpandUnitInfoFromMsg(currentQuestData)
end

--- Returns the original text of the quest based on the  user request
--- @param needed QuestTextSection quet section to get (e.g., "title", "description", "objectives", "complete", "progress")
--- @param isQuestLogFrame boolean? Flag to indicate if QuestLogFrame or QuestFrame is used
--- @return string OriginalData string if available, otherwise nil
--- @private
function WowClassicIta:original(needed, isQuestLogFrame)
    if needed == "title" then
        return isQuestLogFrame and select(1, GetQuestLogTitle(GetQuestLogSelection())) or GetTitleText()
    elseif needed == "description" then
        return isQuestLogFrame and select(1, GetQuestLogQuestText(GetQuestLogSelection())) or GetQuestText()
    elseif needed == "objectives" then
        return isQuestLogFrame and select(1, GetQuestLogQuestText(GetQuestLogSelection())) or GetObjectiveText()
    elseif needed == "completion" then
        return isQuestLogFrame and GetQuestLogCompletionText(GetQuestLogSelection()) or GetRewardText()
    elseif needed == "progress" then
        return isQuestLogFrame and GetQuestLogCompletionText(GetQuestLogSelection()) or GetProgressText()
    elseif needed == "questlevel" then
        return isQuestLogFrame and select(2, GetQuestLogTitle(GetQuestLogSelection()))
    else
        self:Error("Invalid section requested: " .. tostring(needed))
        self:Warn("Returning empty string.")
        return ""
    end
end

--- Returns the title of the current quest translated or original, according to the addon user settings.
--- @param questID number ID of the quest to translated
--- @param isQuestLogFrame boolean? Flag to indicate if QuestLogFrame or QuestFrame is used
--- @return string translatedData TranslatedData translation text if available, original text if not
function WowClassicIta:GetQuestTitle(questID, isQuestLogFrame)
    if self.db.profile.disabled then
        return self:original("title", isQuestLogFrame)
    end

    if self.db.profile.quests.name then
        if self.isCurrentQuestTranslated then
            -- return translated string if available original string if not
            return self:translate(questID, "title") or self:original("title", isQuestLogFrame)
        else
            return self:original("title", isQuestLogFrame)
        end
    else
        return self:original("title", isQuestLogFrame)
    end
end

---Returns the description of the current quest translated or original, according to the addon user settings
---@param questID number ID of the quest to translated
---@param isQuestLogFrame boolean? Flag to indicate if QuestLogFrame or QuestFrame is used
---@return string translatedData TranslatedData translation text if available, original text if not
function WowClassicIta:GetQuestDescription(questID, isQuestLogFrame)
    if self.db.profile.disabled then
        return self:original("description", isQuestLogFrame)
    end

    if self.db.profile.quests.description then
        if self.isCurrentQuestTranslated then
            -- return translated string if available original string if not
            return self:translate(questID, "description") or self:original("description", isQuestLogFrame)
        else
            return self:original("description", isQuestLogFrame)
        end
    else
        return self:original("description", isQuestLogFrame)
    end
end

--- Returns the objectives of the current quest translated or original, according to the addon user settings.
---
--- @param questID number The unique identifier of the quest.
--- @param isQuestLogFrame boolean? Flag to indicate if QuestLogFrame or QuestFrame is used
--- @return string translatedData translation text if available, original text if not
function WowClassicIta:GetQuestObjectives(questID, isQuestLogFrame)
    if self.db.profile.disabled then
        return self:original("objectives", isQuestLogFrame)
    end

    if self.db.profile.quests.objectives then
        if self.isCurrentQuestTranslated then
            -- return translated string if available original string if not
            return self:translate(questID, "objectives") or self:original("objectives", isQuestLogFrame)
        else
            return self:original("objectives", isQuestLogFrame)
        end
    else
        return self:original("objectives", isQuestLogFrame)
    end
end

--- Returns the rewards of the current quest translated or original, according to the addon user settings.
--- @param questID number The unique identifier of the quest.
--- @param isQuestLogFrame boolean? Flag to indicate if QuestLogFrame or QuestFrame is used
--- @return string translatedData translation text if available, original text if not
function WowClassicIta:GetQuestRewards(questID, isQuestLogFrame)
    if self.db.profile.disabled then
        return self:original("rewards", isQuestLogFrame)
    end

    if self.db.profile.quests.rewards then
        if self.isCurrentQuestTranslated then
            -- return translated string if available original string if not
            return self:translate(questID, "rewards") or self:original("rewards", isQuestLogFrame)
        else
            return self:original("rewards", isQuestLogFrame)
        end
    else
        return self:original("rewards", isQuestLogFrame)
    end
end

--- Returns the completion text of the current quest translated or original, according to the addon user settings.
--- @param questID number The unique identifier of the quest.
--- @param isQuestLogFrame boolean? Flag to indicate if QuestLogFrame or QuestFrame is used
--- @return string translatedData translation text if available, original text if not
function WowClassicIta:GetQuestCompletion(questID, isQuestLogFrame)
    if self.db.profile.disabled then
        return self:original("completion", isQuestLogFrame)
    end

    if self.db.profile.quests.completion then
        if self.isCurrentQuestTranslated then
            -- return translated string if available original string if not
            return self:translate(questID, "completion") or self:original("completion", isQuestLogFrame)
        else
            return self:original("completion", isQuestLogFrame)
        end
    else
        return self:original("completion", isQuestLogFrame)
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
    self.gossipIdButton:SetDisabled(true)

    local text = "Quest ID=" .. tostring(questID) .. " (" .. GetLocale() .. ") ";
    --- Set language in quest button
    self.questFrameIdButton:SetText(text)
    self.questLogIdButton:SetText(text)
    self.gossipIdButton:SetText(text)
end

function WowClassicIta:PermitTranslationForThisQuest(questID)
    local language = self.isCurrentQuestTranslated and "itIT" or GetLocale()
    local text = "Quest ID=" .. tostring(questID) .. " (" .. language .. ") ";

    for _, button in pairs(self.widgets) do
        button:SetDisabled(false)
        button:SetText(text)
    end
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
    self:Trace("[Quests:UpdateFrame] UpdateQuestFrame() called!")

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
        self:Debug("Current quest title: " .. questTitle)
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
        self:Debug("Current quest description: " .. questDescription)
        -- Quest Log
        QuestLogQuestDescription:SetFont(self.fontText, 13)
        QuestLogQuestDescription:SetText(questDescription)

        -- Quest Frame
        QuestInfoDescriptionText:SetFont(self.fontText, 13)
        QuestInfoDescriptionText:SetText(questDescription)
    end

    if questObjectives then
        self:Debug("Current quest objectives: " .. questObjectives)

        --- Quest Log
        QuestLogObjectivesText:SetFont(self.fontText, 13)
        QuestLogObjectivesText:SetText(questObjectives)

        --- Quest Frame
        QuestInfoObjectivesText:SetFont(self.fontText, 13)
        QuestInfoObjectivesText:SetText(questDescription)
    end

    if questProgress then
        self:Debug("Current quest progress: " .. questProgress)

        --- Quest Progressing
        QuestProgressText:SetFont(self.fontText, 13)
        QuestProgressText:SetText(questProgress)
    end

    if questCompletion then
        self:Debug("Current quest completion: " .. questCompletion)

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

    self:Trace("[Core:QuestsUpdateQuestsCommonText] CosharedObjectiveText: " .. sharedObjectiveText)
    QuestInfoObjectivesHeader:SetFont(self.fontHeader, 18)
    QuestInfoObjectivesHeader:SetText(sharedObjectiveText)
    QuestInfoObjectivesText:SetFont(self.fontText, 13)
    QuestInfoObjectivesText:SetText(sharedObjectiveText)
    QuestLogObjectivesText:SetFont(self.fontText, 13)
    QuestLogObjectivesText:SetText(sharedObjectiveText)

    --- Setup quests statc text elements
    self:Trace("[Quests:UpdateQuestsCommonTexts] sharedRewardsText: " .. sharedRewardsText)
    QuestLogRewardTitleText:SetFont(self.fontHeader, 18)
    QuestLogRewardTitleText:SetText(sharedRewardsText)

    QuestInfoRewardsFrame.Header:SetFont(self.fontHeader, 18);
    QuestInfoRewardsFrame.Header:SetText(sharedRewardsText);

    self:Trace("[Quests:UpdateQuestsCommonTexts] sharedDetailsText: " .. sharedDetailsText)
    QuestLogDescriptionTitle:SetFont(self.fontText, 13)
    QuestLogDescriptionTitle:SetText(sharedDetailsText)

    self:Trace("[Quests:UpdateQuestsCommonTexts] sharedReqItemsText: " .. sharedReqItemsText)
    QuestProgressRequiredItemsText:SetFont(self.fontHeader, 18)
    QuestProgressRequiredItemsText:SetText(sharedReqItemsText)

    self:Trace("[Quests:UpdateQuestsCommonTexts] sharedItemChooseRewards1Text: " .. sharedItemChooseRewards1Text)
    QuestLogItemChooseText:SetFont(self.fontText, 13)
    QuestLogItemChooseText:SetText(sharedItemChooseRewards1Text)

    self:Trace("[Quests:UpdateQuestsCommonTexts] sharedMoneyRewardText: " .. sharedMoneyRewardText)
    QuestLogItemReceiveText:SetFont(self.fontText, 13)
    QuestLogItemReceiveText:SetText(sharedMoneyRewardText)

    self:Trace("[Quests:UpdateQuestsCommonTexts] sharedItemChooseRewards2Text: " .. sharedItemChooseRewards2Text)
    QuestInfoRewardsFrame.ItemChooseText:SetFont(self.fontText, 13)
    QuestInfoRewardsFrame.ItemChooseText:SetText(sharedItemChooseRewards2Text)

    self:Trace("[Quests:UpdateQuestsCommonTexts] sharedDetailsText: " .. sharedDetailsText)
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
    if self.db.profile.disabled then
        return self:original("questlevel", isQuestLogFrame)
    end

    if self.db.profile.quests.completion then
        if self.isCurrentQuestTranslated then
            -- return translated string if available original string if not
            return self:translate(questID, "questlevel") or self:original("questlevel", isQuestLogFrame)
        else
            return self:original("questlevel", isQuestLogFrame)
        end
    else
        return self:original("questlevel", isQuestLogFrame)
    end
end

function WowClassicIta:GetMinLevel(questID, isQuestLogFrame)
    return self:original("minlevel", isQuestLogFrame)
end
