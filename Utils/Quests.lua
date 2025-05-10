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
            return self:GetTranslatedQuest(questID, "description") 
                or self:GetOriginalQuest("description", isQuestLogFrame)
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

function WowClassicIta:GetQuestUxMessages()

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
