local addonName, addonTable = ...

---@class WowClassicIta
local WowClassicIta = _G.LibStub("AceAddon-3.0"):GetAddon(addonName)

--- Get translation for given quest ID and return translated string if exists
--- @param questID number ID of the quest to translate
--- @param needed QuestTextSection Type of translation needed (e.g., "title", "description", "objectives", "complete", "progress")
--- @return string|nil TranslatedData string if available, otherwise nil
--- @private
function WowClassicIta:GetTranslatedQuest(questID, needed)
    self:Trace("|cFFFFC0CB[Quests:Translate]|r GetTranslatedQuest(" .. needed .. ") called!")
    local questsData = addonTable.QuestsData

    local needCamel = function() return needed ~= "questlevel" and needed ~= "minlevel" end

    -- Capitalize the first letter of the needed string
    local accesser = needCamel() and needed.gsub(needed, "^%l", string.upper) or needed

    -- Get the current quest data if exists nil otherwise
    local currentQuestData = questsData[tostring(questID)] and questsData[tostring(questID)][accesser]
    
    if not currentQuestData then
        if not questsData[tostring(questID)] then
            self:Error("Quest ID " .. tostring(questID) .. "is not defined in the database.")
        elseif not questsData[tostring(questID)][accesser] then
            self:Error(accesser .. " section does not exists for quest ID " .. tostring(questID))
        end
        self:Warn("Showing original text. {" .. tostring(needed) .. "," .. tostring(questID) .. "}")
        self:PurgeTranslationForThisQuest(questID)
        return nil
    end
    self:Trace("|cFFFFC0CB[Quests:Translate]|r |cFFDDA0DDCquestData[" ..
        tostring(questID) .. "][" .. accesser .. "] = |r\n\"" .. currentQuestData .. "\"")
    return self:ExpandUnitInfoFromMsg(currentQuestData)
end

--- Returns the original text of the quest based on the  user request
--- @param needed QuestTextSection quet section to get (e.g., "title", "description", "objectives", "complete", "progress")
--- @param isQuestLogFrame boolean? Flag to indicate if QuestLogFrame or QuestFrame is used
--- @return string OriginalData string if available, otherwise nil
--- @private
function WowClassicIta:GetOriginalQuest(needed, isQuestLogFrame)
    if needed == "title" then
        return isQuestLogFrame and select(1, GetQuestLogTitle(GetQuestLogSelection())) or GetTitleText()
    elseif needed == "description" then
        return isQuestLogFrame and select(1, GetQuestLogQuestText(GetQuestLogSelection())) or GetQuestText()
    elseif needed == "objectives" then
        return isQuestLogFrame and select(2, GetQuestLogQuestText(GetQuestLogSelection())) or GetObjectiveText()
    elseif needed == "completion" then
        return isQuestLogFrame and GetQuestLogCompletionText(GetQuestLogSelection()) or GetRewardText()
    elseif needed == "progress" then
        return isQuestLogFrame and GetQuestLogCompletionText(GetQuestLogSelection()) or GetProgressText()
    elseif needed == "questlevel" then
        return isQuestLogFrame and select(2, GetQuestLogTitle(GetQuestLogSelection()))
    else
        self:Error("Invalid section requested: " .. tostring(needed))
        self:Warn("Returning empty string.")
        return string.upper(needed)
    end
end