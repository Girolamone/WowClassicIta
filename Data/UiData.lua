local _, addonTable = ...
addonTable.SharedUiTextData = {}

--- @class QuestsCommonTextsData
--- @field Details string
--- @field Objectives string
--- @field Rewards string
--- @field ItemChooseRewards1 string
--- @field ItemChooseRewards2 string
--- @field ItemSingleReward string
--- @field LearnSpell string
--- @field ReqMoney string
--- @field ReqItems string
--- @field Experience string
--- @field CurrQuests string
--- @field AvaiQuests string
--- @field MoneyReward string
--- @field Progress string
--- @field Completion string

--- @class AddonGuiTextData
--- @field Loaded string
--- @field IsActive string
--- @field IsInactive string
--- @field Missing string
--- @field Translator string

--- @class SharedUiTextData
--- @field SettingsFrameText AddonGuiTextData
--- @field QuestsCommonText QuestsCommonTextsData


-- itIT
--- @type SharedUiTextData
addonTable.SharedUiTextData['itIT'] = {
    SettingsFrameText = {
        Loaded     = "Caricato",
        IsActive   = "Attivo",
        IsInactive = "Non attivo",
        Missing    = "Perso",
        Translator = "Tradotto",
    },

    QuestsCommonText  = {
        Details            = "Descrizione",
        Progress           = "Progresso",
        Objectives         = "Obiettivo",
        Completion         = "Fine",
        Rewards            = "Ricompensa",
        Experience         = "Esperienza",
        ReqMoney           = "Denaro Richiesto:",
        ReqItems           = "Items Richiesti:",
        ItemChooseRewards1 = "Sarai in grado di scegliere una delle ricompense di seguito:",
        ItemChooseRewards2 = "Scegli uno dei seguenti Premi:",
        ItemSingleReward   = "Riceverai come ricompensa:",
        LearnSpell         = "Impara l'incantesimo:",
        MultipleID         = "Questa traduzione potrebbe non corrispondere all'originale",
        CurrQuests         = "Quest attuali",
        AvaiQuests         = "Quest Disponibili",
        MoneyReward        = "Riceverai anche:"
    }
}

-- enUS
--- @type SharedUiTextData
addonTable.SharedUiTextData['enUS'] = {
    SettingsFrameText = {
        Loaded     = "Loaded",
        IsActive   = "Active",
        IsInactive = "Inactive",
        Missing    = "Missing",
        Translator = "Translated",
    },
    QuestsCommonText  = {
        Details            = "Description",
        Progress           = "Progress",
        Objectives         = "Objectives",
        Completion         = "Complete",
        Rewards            = "Rewards",
        Experience         = "Experience",
        ReqMoney           = "Required Money:",
        ReqItems           = "Required items:",
        ItemChooseRewards1 = "You will be able to choose one of these rewards:",
        ItemChooseRewards2 = "Choose one of these rewards:",
        ItemSingleReward   = "You will receive as reward:",
        LearnSpell         = "Learn Spell:",
        MultipleID         = "This translation may not match the original",
        CurrQuests         = "Current Quests",
        AvaiQuests         = "Available Quests",
        MoneyReward        = "You will also receive:"
    }
}

--- @type SharedUiTextData
addonTable.SharedUiTextData['deDE'] = {
    SettingsFrameText = {
        Loaded     = "Geladen",
        IsActive   = "Aktiv",
        IsInactive = "Nicht aktiv",
        Missing    = "Fehlt",
        Translator = "Übersetzt",
    },

    QuestsCommonText = {
        Details            = "Beschreibung",
        Progress           = "Fortschritt",
        Objectives         = "Ziele",
        Completion         = "Abgeschlossen",
        Rewards            = "Belohnungen",
        Experience         = "Erfahrung",
        ReqMoney           = "Benötigtes Geld:",
        ReqItems           = "Benötigte Gegenstände:",
        ItemChooseRewards1 = "Du wirst in der Lage sein, eine dieser Belohnungen auszuwählen:",
        ItemChooseRewards2 = "Wähle eine dieser Belohnungen:",
        ItemSingleReward   = "Du erhältst die Belohnung:",
        LearnSpell         = "Zauber erlernen:",
        MultipleID         = "Diese Übersetzung könnte nicht mit dem Original übereinstimmen",
        CurrQuests         = "Aktuelle Quests",
        AvaiQuests         = "Verfügbare Quests",
        MoneyReward        = "Du erhältst auch:"
    }
}

--- @type SharedUiTextData
addonTable.SharedUiTextData['frFR'] = {
    SettingsFrameText = {
        Loaded     = "Chargé",
        IsActive   = "Actif",
        IsInactive = "Non actif",
        Missing    = "Manquant",
        Translator = "Traduit",
    },

    QuestsCommonText = {
        Details            = "Description",
        Progress           = "Progrès",
        Objectives         = "Objectifs",
        Completion         = "Terminé",
        Rewards            = "Récompenses",
        Experience         = "Expérience",
        ReqMoney           = "Argent requis:",
        ReqItems           = "Objets requis:",
        ItemChooseRewards1 = "Vous pourrez choisir l'une de ces récompenses:",
        ItemChooseRewards2 = "Choisissez l'une de ces récompenses:",
        ItemSingleReward   = "Vous recevrez la récompense:",
        LearnSpell         = "Apprendre le sort:",
        MultipleID         = "Cette traduction pourrait ne pas correspondre à l'original",
        CurrQuests         = "Quêtes actuelles",
        AvaiQuests         = "Quêtes disponibles",
        MoneyReward        = "Vous recevrez également:"
    }
}

--- @type SharedUiTextData
addonTable.SharedUiTextData['esES'] = {
    SettingsFrameText = {
        Loaded     = "Cargado",
        IsActive   = "Activo",
        IsInactive = "Inactivo",
        Missing    = "Faltante",
        Translator = "Traducido",
    },

    QuestsCommonText = {
        Details            = "Descripción",
        Progress           = "Progreso",
        Objectives         = "Objetivos",
        Completion         = "Completado",
        Rewards            = "Recompensas",
        Experience         = "Experiencia",
        ReqMoney           = "Dinero requerido:",
        ReqItems           = "Objetos requeridos:",
        ItemChooseRewards1 = "Podrás elegir una de estas recompensas:",
        ItemChooseRewards2 = "Elige una de estas recompensas:",
        ItemSingleReward   = "Recibirás la recompensa:",
        LearnSpell         = "Aprender hechizo:",
        MultipleID         = "Esta traducción puede no coincidir con el original",
        CurrQuests         = "Misiones actuales",
        AvaiQuests         = "Misiones disponibles",
        MoneyReward        = "También recibirás:"
    }
}
