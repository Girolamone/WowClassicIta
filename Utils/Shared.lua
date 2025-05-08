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