local L = LibStub("AceLocale-3.0"):NewLocale("WorldQuestGroupFinder", "deDE") 
if not L then return end 
L = L or {}
L["WQGF_ADDON_DESCRIPTION"] = "Macht es dir einfach Gruppen für Weltquests mit dem Gruppenfinder zu finden."
L["WQGF_ALREADY_IS_GROUP_FOR_WQ"] = "Du bist bereits in einer Gruppe für diese Weltquest."
L["WQGF_ALREADY_QUEUED_BG"] = "Du bist momentan in der Warteschlange für ein Schlachtfeld. Bitte verlasse die Warteschlange und versuche es erneut."
L["WQGF_ALREADY_QUEUED_DF"] = "Du bist momentan in der Warteschlange des Dungeonbrowsers. Bitte verlasse die Warteschlange und versuche es erneut."
L["WQGF_ALREADY_QUEUED_RF"] = "Du bist momentan in der Warteschlange des Schlachtzugsbrowsers. Bitte verlasse die Warteschlange und versuche es erneut."
L["WQGF_APPLIED_TO_GROUPS"] = "Du wirst bei |c00bfffff%d|c00ffffff Gruppe(n) für die Weltquest |c00bfffff%s|c00ffffff angemeldet."
L["WQGF_APPLIED_TO_GROUPS_QUEST"] = "Du wurdest bei |c00bfffff%d|c00ffffff Gruppe(n) für die Quest |c00bfffff%s|c00ffffff angemeldet."
L["WQGF_AUTO_LEAVING_DIALOG"] = [=[Du hast die Weltquest abgeschlossen und verlässt die Gruppe in %d Sekunden.

Sag auf Wiedersehen!]=]
L["WQGF_AUTO_LEAVING_DIALOG_QUEST"] = [=[Du hast die Quest abgeschlossen und wirst die Gruppe in %d Sekunden verlassen.

Sag auf Wiedersehen!]=]
L["WQGF_CANCEL"] = "Abbrechen"
L["WQGF_CANNOT_DO_WQ_IN_GROUP"] = "Diese Weltquest kann nicht als Gruppe durchgeführt werden."
L["WQGF_CANNOT_DO_WQ_TYPE_IN_GROUP"] = "Diese Art von Weltquest kann nicht als Gruppe durchgeführt werden."
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_ENABLE"] = "Gruppeneinladungen, die durch WQGF durchgeführt wurden, automatisch annehmen"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_HOVER"] = "Nimmt Gruppeneinladungen automatisch an, wenn du nicht im Kampf bist"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_TITLE"] = "Gruppeneinladungen automatisch annehmen"
L["WQGF_CONFIG_AUTOINVITE"] = "Automatisch einladen"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE"] = "Jeden automatisch einladen"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE_HOVER"] = "Jeder Anwärter wird automatisch in die Gruppe eingeladen bis zu einer Maximalanzahl von 5 Spielern"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS"] = "WQGF-Nutzer automatisch einladen"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS_HOVER"] = "Lädt Nutzer von World Quest Group Finder automatisch in die Gruppe ein"
L["WQGF_CONFIG_BINDING_ADVICE"] = "Denke daran, dass du den WQGF-Button in Blizzards Tastaturbelegungsmenü einer Taste zuweisen kannst!"
L["WQGF_CONFIG_LANGUAGE_FILTER_ENABLE"] = "Nach Gruppen mit beliebiger Sprache suchen (Ignoriert die Sprachauswahl im Dungeonbrowser)"
L["WQGF_CONFIG_LANGUAGE_FILTER_HOVER"] = "Sucht immer nach verfügbaren Gruppen ungeachtet deren Sprache"
L["WQGF_CONFIG_LANGUAGE_FILTER_TITLE"] = "Sprachfilter der Gruppensuche"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE"] = "WQGF-Einloggnachricht"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_ENABLE"] = "WQGF-Startnachricht beim Einloggen ausblenden"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_HOVER"] = "Zeigt die WQGF-Nachricht beim Einloggen nicht mehr an"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_ENABLE"] = "Die Suche automatisch starten, wenn ich in keiner Gruppe bin"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_HOVER"] = "Sucht automatisch eine Gruppe, wenn ein neues Weltquestgebiet betreten wurde"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_ENABLE"] = "Die Erkennung neuer Weltquestgebiete aktivieren"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_HOVER"] = "Du wirst gefragt, ob du nach einer Gruppe suchen willst, wenn du ein neues Weltquestgebiet betrittst."
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_SWITCH_ENABLE"] = "Nicht vorschlagen, wenn ich bereits in einer Gruppe für eine andere Weltquest bin"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_TITLE"] = "Die Suche nach einer Gruppe vorschlagen, wenn Du ein Weltquestgebiet zum ersten Mal betrittst"
L["WQGF_CONFIG_PAGE_CREDITS"] = "Erstellt von Robou, EU-Hyjal"
L["WQGF_CONFIG_PARTY_NOTIFICATION_ENABLE"] = "Gruppenbenachrichtigung aktivieren"
L["WQGF_CONFIG_PARTY_NOTIFICATION_HOVER"] = "An die Gruppe wird eine Nachricht gesendet, sobald die Weltquest abgeschlossen wurde."
L["WQGF_CONFIG_PARTY_NOTIFICATION_TITLE"] = "Die Gruppe benachrichtigen, wenn die Weltquest abgeschlossen wurde"
L["WQGF_CONFIG_PVP_REALMS_ENABLE"] = "Den Beitritt in Gruppen auf PvP-Realms vermeiden"
L["WQGF_CONFIG_PVP_REALMS_HOVER"] = "Vermeidet den Beitritt in Gruppe auf PvP-Realms (dieser Parameter wird bei Charakteren, die sich auf PvP-Realms befinden, ignoriert)"
L["WQGF_CONFIG_PVP_REALMS_TITLE"] = "PvP-Realms"
L["WQGF_CONFIG_QUEST_SUPPORT_ENABLE"] = "Unterstützung gewöhnlicher Quests aktivieren"
L["WQGF_CONFIG_QUEST_SUPPORT_HOVER"] = "Wenn du diese Option aktivierst, wird ein Button zur Suche nach Gruppen für unterstützte normale Quests angezeigt"
L["WQGF_CONFIG_QUEST_SUPPORT_TITLE"] = "Unterstützung gewöhnlicher Quests"
L["WQGF_CONFIG_SILENT_MODE_ENABLE"] = "Lautlosmodus aktivieren"
L["WQGF_CONFIG_SILENT_MODE_HOVER"] = "Wenn der Lautlosmodus aktiviert ist, werden nur die wichtigsten WQGF-Nachrichten angezeigt"
L["WQGF_CONFIG_SILENT_MODE_TITLE"] = "Lautlosmodus"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_ENABLE"] = "Die Gruppe automatisch nach 10 Sekunden verlassen"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_HOVER"] = "Verlässt automatisch die Gruppe nach 10 Sekunden, nachdem eine Weltquest abgeschlossen wurde."
L["WQGF_CONFIG_WQ_END_DIALOG_ENABLE"] = "Dialog bei Abschluss von Weltquests aktivieren"
L["WQGF_CONFIG_WQ_END_DIALOG_HOVER"] = "Dir wird vorgeschlagen, die Gruppe zu verlassen oder die Gruppe von der Suche abzumelden, wenn die Weltquest abgeschlossen wurde"
L["WQGF_CONFIG_WQ_END_DIALOG_TITLE"] = "Einen Dialog zum Verlassen der Gruppe anzeigen, wenn die Weltquest abgeschlossen wurde"
L["WQGF_DEBUG_CONFIGURATION_DUMP"] = "Charakterspezifische Konfiguration:"
L["WQGF_DEBUG_CURRENT_WQ_ID"] = "Momentane Quest-ID ist |c00bfffff%s|c00ffffff."
L["WQGF_DEBUG_MODE_DISABLED"] = "Debugmodus ist jetzt deaktiviert."
L["WQGF_DEBUG_MODE_ENABLED"] = "Debugmodus ist jetzt aktiviert."
L["WQGF_DEBUG_NO_CURRENT_WQ_ID"] = "Keine aktuelle Quest."
L["WQGF_DEBUG_WQ_ZONES_ENTERED"] = "Betretene Weltquestgebiete in dieser Sitzung:"
L["WQGF_DELIST"] = "Abmelden"
L["WQGF_DROPPED_WB_SUPPORT"] = "WQGF unterstüzt ab der Version 0.21.3 keine Weltquests für Weltbosse mehr. Bitte nutze den Button des Standard-UIs, um eine Gruppe zu finden."
L["WQGF_FIND_GROUP_TOOLTIP"] = "Gruppe mit WQGF finden"
L["WQGF_FIND_GROUP_TOOLTIP_2"] = "Mittelklick, um eine neue Gruppe zu erstellen"
L["WQGF_FRAME_ACCEPT_INVITE"] = "Der Gruppe beitreten"
L["WQGF_FRAME_APPLY_DONE"] = "Du wurdest bei allen verfügbaren Gruppen angemeldet."
L["WQGF_FRAME_CLICK_TWICE"] = "%d-mal klicken, um eine neue Gruppe zu erstellen."
L["WQGF_FRAME_CREATE_WAIT"] = "Du kannst eine neue Gruppe erstellen, falls du keine Antworten erhältst."
L["WQGF_FRAME_FOUND_GROUPS"] = "%d Gruppe(n) gefunden. Klicken, um Dich anzumelden. "
L["WQGF_FRAME_GROUPS_LEFT"] = "%d Gruppe(n) verbleibend, Klicke weiter!"
L["WQGF_FRAME_INIT_SEARCH"] = "Klicke auf den Button, um die Suche einzuleiten"
L["WQGF_FRAME_NO_GROUPS"] = "Gruppe erstellen (keine gefunden)"
L["WQGF_FRAME_RELIST_GROUP"] = "Gruppe erneut listen"
L["WQGF_FRAME_SEARCH_GROUPS"] = "Gruppen suchen"
L["WQGF_GLOBAL_CONFIGURATION"] = "Allgemeine Konfiguration:"
L["WQGF_GROUP_CREATION_ERROR"] = "Ein Fehler ist bei der Erstellung eines neuen Eintrages im Dungeonbrowser aufgetreten. Bitte erneut versuchen."
L["WQGF_GROUP_NO_LONGER_DOING_QUEST"] = "Deine Gruppe macht nicht mehr die Quest |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NO_LONGER_DOING_WQ"] = "Deine Gruppe macht nicht mehr die Weltquest |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_QUEST"] = "Deine Gruppe macht jetzt die Quest |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_QUEST_ALREADY_COMPLETE"] = "Deine Gruppe macht jetzt die Quest |c00bfffff%s|c00ffffff. Du hast diese Quest bereits abgeschlossen."
L["WQGF_GROUP_NOW_DOING_QUEST_NOT_ELIGIBLE"] = "Deine Gruppe macht jetzt die Quest |c00bfffff%s|c00ffffff. Du bist nicht für diese Quest berechtigt."
L["WQGF_GROUP_NOW_DOING_WQ"] = "Deine Gruppe macht jetzt die Weltquest |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_WQ_ALREADY_COMPLETE"] = "Deine Gruppe macht jetzt die Weltquest |c00bfffff%s|c00ffffff. Du hast diese Weltquest bereits abgeschlossen."
L["WQGF_GROUP_NOW_DOING_WQ_NOT_ELIGIBLE"] = "Deine Gruppe macht jetzt die Weltquest |c00bfffff%s|c00ffffff. Du bist nicht für diese Weltquest berechtigt."
L["WQGF_INIT_MSG"] = "Klicke mit der mittleren Maustaste auf eine Weltquest in der Zielverfolgung, oder auf der Weltkarte, um nach einer Gruppe zu suchen."
L["WQGF_JOINED_WQ_GROUP"] = "Du bist der Gruppe von |c00bfffff%s|c00ffffff für |c00bfffff%s|c00ffffff beigetreten. Viel Spaß!"
L["WQGF_KICK_TOOLTIP"] = "Alle zu weit entfernten Spieler aus der Gruppe entfernen"
L["WQGF_LEADERS_BL_CLEARED"] = "Die Ignorierliste für Anführer wurde geleert."
L["WQGF_LEAVE"] = "Verlassen"
L["WQGF_MEMBER_TOO_FAR_AWAY"] = "Das Gruppenmitglied %s ist %s Meter entfernt. Verwende den Auto-Kick-Button, um ihn aus der Gruppe zu entfernen."
L["WQGF_NEW_ENTRY_CREATED"] = "Ein neuer Eintrag im Dungeonbrowser wurde für |c00bfffff%s|c00ffffff erstellt."
L["WQGF_NO"] = "Nein"
L["WQGF_NO_APPLICATIONS_ANSWERED"] = "Keine deiner Anmeldungen für |c00bfffff%s|c00ffffff wurden rechtzeitig beantwortet. Suche nach neuen Gruppen..."
L["WQGF_NO_APPLY_BLACKLIST"] = "Du wurdest nicht bei %d Gruppe(n) angemeldet, weil deren Anführer auf der Ignorierliste steht. Du kannst mit |c00bfffff/wqgf unbl |c00ffffffdie Ignorierliste leeren."
L["WQGF_PLAYER_IS_NOT_LEADER"] = "Du bist nicht der Gruppenanführer"
L["WQGF_QUEST_COMPLETE_LEAVE_DIALOG"] = [=[Du hast die Quest abgeschlossen.

Willst du die Gruppe verlassen?]=]
L["WQGF_QUEST_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[Du hast die Quest abgeschlossen.

Willst du die Gruppe verlassen oder sie vom Dungeonbrowser abmelden?]=]
L["WQGF_RAID_MODE_WARNING"] = "|c0000ffffWARNUNG:|c00ffffff Diese Gruppe ist ein Schlachtzug, das bedeutet, dass du die Weltquest nicht abschließen kannst. Du solltest den Anführer bitten, den Schlachtzug in eine Gruppe umzuwandeln. Der Schlachtzug wird automatisch in eine Gruppe umgewandelt, wenn du der Anführer wirst."
L["WQGF_REFRESH_TOOLTIP"] = "Eine andere Gruppe suchen"
L["WQGF_SEARCH_OR_CREATE_GROUP"] = "Gruppe suchen oder erstellen"
L["WQGF_SEARCHING_FOR_GROUP"] = "Suche nach einer Gruppe für die Weltquest |c00bfffff%s|c00ffffff..."
L["WQGF_SEARCHING_FOR_GROUP_QUEST"] = "Suche nach einer Gruppe für die Quest |c00bfffff%s|c00ffffff..."
L["WQGF_SLASH_COMMANDS_1"] = "|c00bfffffSlash-Befehle (/wqgf):"
L["WQGF_SLASH_COMMANDS_2"] = "|c00bfffff /wqgf config : Öffnet die Addon-Konfiguration"
L["WQGF_SLASH_COMMANDS_3"] = "|c00bfffff /wqgf unbl : Leert die Ignorierliste für Anführer"
L["WQGF_SLASH_COMMANDS_4"] = "|c00bfffff /wqgf toggle : Schaltet die Erkennung neuer Weltquestgebiete ein/aus"
L["WQGF_START_ANOTHER_QUEST_DIALOG"] = [=[Du bist momentan in einer Gruppe für eine andere Quest.

Bist du sicher, dass du eine andere anfangen möchtest?]=]
L["WQGF_START_ANOTHER_WQ_DIALOG"] = [=[Du bist momentan in einer Gruppe für eine andere Weltquest.

Bist du sicher, dass du eine andere anfangen möchtest?]=]
L["WQGF_STAY"] = "Bleiben"
L["WQGF_STOP_TOOLTIP"] = "Mit dieser Weltquest aufhören"
L["WQGF_TRANSLATION_INFO"] = "Ins Deutsche übersetzt von Bullsei"
L["WQGF_USER_JOINED"] = "Ein Nutzer von World Quest Group Finder ist der Gruppe beigetreten!"
L["WQGF_USERS_JOINED"] = "Eine Gruppe mit WQGF-Nutzern sind der Gruppe beigetreten!"
L["WQGF_WQ_AREA_ENTERED_ALREADY_GROUPED_DIALOG"] = [=[Du hast eine neues Weltquestgebiet betreten, aber du bist momentan in einer Gruppe für eine andere Weltquest.

Willst du deine momentane Gruppe verlassen und eine andere für "%s" suchen?]=]
L["WQGF_WQ_AREA_ENTERED_DIALOG"] = [=[Du hast eine neues Weltquestgebiet betreten.

Willst du eine Gruppe für "%s" suchen?]=]
L["WQGF_WQ_COMPLETE_LEAVE_DIALOG"] = [=[Du hast die Weltquest abgeschlossen.

Willst du die Gruppe verlassen?]=]
L["WQGF_WQ_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[Du hast die Weltquest abgeschlossen.

Willst du die Gruppe verlassen oder sie vom Dungeonbrowser abmelden?]=]
L["WQGF_WQ_GROUP_APPLY_CANCELLED"] = "Du hast deine Anmeldung für die Gruppe von |c00bfffff%s|c00ffffff für |c00bfffff%s|c00ffffff abgebrochen. WQGF wird nicht versuchen, dieser Gruppe erneut beizutreten, bis du dich erneut in das Spiel einloggst oder die Ignorierliste für Anführer leerst."
L["WQGF_WQ_GROUP_DESCRIPTION"] = "Automatisch erstellt durch World Quest Group Finder %s."
L["WQGF_WRONG_LOCATION_FOR_WQ"] = "Du bist nicht am richtigen Ort für diese Weltquest"
L["WQGF_YES"] = "Ja"
L["WQGF_ZONE_DETECTION_DISABLED"] = "Die Erkennung neuer Weltquestgebiete ist jetzt deaktiviert."
L["WQGF_ZONE_DETECTION_ENABLED"] = "Die Erkennung neuer Weltquestgebiete ist jetzt aktiviert."
