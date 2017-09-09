-- Lucid Nightmare Helper
-- by Vildiesel EU - Well of Eternity

local _, addonTable = ...

local locale = GetLocale()
addonTable.L = setmetatable({}, { __index = function(_, k)
                                             return k
                                            end})
local L = addonTable.L

if locale == "esES" then 
--Translation missing 
-- L["Clear"] = ""
--Translation missing 
-- L["Clear Markers"] = ""
--Translation missing 
-- L["Click again to confirm"] = ""
--Translation missing 
-- L["Click to center the camera to the current room"] = ""
--Translation missing 
-- L["Click to erase the current map and start over"] = ""
--Translation missing 
-- L["Current Room: %s"] = ""
--Translation missing 
-- L["Disabled"] = ""
--Translation missing 
-- L["Enabled"] = ""
--Translation missing 
-- L["Hold the Ctrl key, then click on the desired room to select it (a round circle will appear around the room), then click the 'Set player location' button twice"] = ""
--Translation missing 
-- L["How can I reposition the player on the map?"] = ""
--Translation missing 
-- L["How does the Endless Halls tool work?"] = ""
--Translation missing 
-- L["It tracks player movement through the halls, generating a map that can be used to mark special rooms and retrace your steps into them when necessary."] = ""
--Translation missing 
-- L["Markers"] = ""
--Translation missing 
-- L["No, jump over"] = ""
--Translation missing 
-- L["Selected Room: %s"] = ""
--Translation missing 
-- L["Set Player location"] = ""
--Translation missing 
-- L["There is a shenanigan, however: in every maze there are a few one-directional doors that lead to a random location, they cannot be recognized by either the addon or the player. If you feel you got teleported or you're simply lost, I'd recommend to use the Enabled button to deactivate mapping until you find a familiar room, then reposition the player into that room on the map and re-enable to restart mapping from there."] = ""
--Translation missing 
-- L["This button pauses/unpauses the map generation"] = ""
--Translation missing 
-- L["Transparency"] = ""
--Translation missing 
-- L["Yes, keep it linked"] = ""
--Translation missing 
-- L["You can navigate the map by Right-Click Dragging it"] = ""
--Translation missing 
-- L["You have encountered an existing room on the map, do you recognize it as the room that you wanted to enter?"] = ""

elseif locale == "esMX" then 
--Translation missing 
-- L["Clear"] = ""
--Translation missing 
-- L["Clear Markers"] = ""
--Translation missing 
-- L["Click again to confirm"] = ""
--Translation missing 
-- L["Click to center the camera to the current room"] = ""
--Translation missing 
-- L["Click to erase the current map and start over"] = ""
--Translation missing 
-- L["Current Room: %s"] = ""
--Translation missing 
-- L["Disabled"] = ""
--Translation missing 
-- L["Enabled"] = ""
--Translation missing 
-- L["Hold the Ctrl key, then click on the desired room to select it (a round circle will appear around the room), then click the 'Set player location' button twice"] = ""
--Translation missing 
-- L["How can I reposition the player on the map?"] = ""
--Translation missing 
-- L["How does the Endless Halls tool work?"] = ""
--Translation missing 
-- L["It tracks player movement through the halls, generating a map that can be used to mark special rooms and retrace your steps into them when necessary."] = ""
--Translation missing 
-- L["Markers"] = ""
--Translation missing 
-- L["No, jump over"] = ""
--Translation missing 
-- L["Selected Room: %s"] = ""
--Translation missing 
-- L["Set Player location"] = ""
--Translation missing 
-- L["There is a shenanigan, however: in every maze there are a few one-directional doors that lead to a random location, they cannot be recognized by either the addon or the player. If you feel you got teleported or you're simply lost, I'd recommend to use the Enabled button to deactivate mapping until you find a familiar room, then reposition the player into that room on the map and re-enable to restart mapping from there."] = ""
--Translation missing 
-- L["This button pauses/unpauses the map generation"] = ""
--Translation missing 
-- L["Transparency"] = ""
--Translation missing 
-- L["Yes, keep it linked"] = ""
--Translation missing 
-- L["You can navigate the map by Right-Click Dragging it"] = ""
--Translation missing 
-- L["You have encountered an existing room on the map, do you recognize it as the room that you wanted to enter?"] = ""

elseif locale == "itIT" then 
L["Clear"] = "Pulisci"
--Translation missing 
-- L["Clear Markers"] = ""
--Translation missing 
-- L["Click again to confirm"] = ""
L["Click to center the camera to the current room"] = "Clicca per centrare la telecamera sulla stanza corrente"
L["Click to erase the current map and start over"] = "Clicca per cancellare la mappa e ricominciare da capo"
--Translation missing 
-- L["Current Room: %s"] = ""
--Translation missing 
-- L["Disabled"] = ""
--Translation missing 
-- L["Enabled"] = ""
--Translation missing 
-- L["Hold the Ctrl key, then click on the desired room to select it (a round circle will appear around the room), then click the 'Set player location' button twice"] = ""
--Translation missing 
-- L["How can I reposition the player on the map?"] = ""
--Translation missing 
-- L["How does the Endless Halls tool work?"] = ""
--Translation missing 
-- L["It tracks player movement through the halls, generating a map that can be used to mark special rooms and retrace your steps into them when necessary."] = ""
L["Markers"] = "Simboli"
--Translation missing 
-- L["No, jump over"] = ""
--Translation missing 
-- L["Selected Room: %s"] = ""
--Translation missing 
-- L["Set Player location"] = ""
--Translation missing 
-- L["There is a shenanigan, however: in every maze there are a few one-directional doors that lead to a random location, they cannot be recognized by either the addon or the player. If you feel you got teleported or you're simply lost, I'd recommend to use the Enabled button to deactivate mapping until you find a familiar room, then reposition the player into that room on the map and re-enable to restart mapping from there."] = ""
--Translation missing 
-- L["This button pauses/unpauses the map generation"] = ""
L["Transparency"] = "Trasparenza"
--Translation missing 
-- L["Yes, keep it linked"] = ""
L["You can navigate the map by Right-Click Dragging it"] = "Puoi esplorare la mappa trascinandola con il Click-Destro"
--Translation missing 
-- L["You have encountered an existing room on the map, do you recognize it as the room that you wanted to enter?"] = ""

elseif locale == "ptBR" then 
--Translation missing 
-- L["Clear"] = ""
--Translation missing 
-- L["Clear Markers"] = ""
--Translation missing 
-- L["Click again to confirm"] = ""
--Translation missing 
-- L["Click to center the camera to the current room"] = ""
--Translation missing 
-- L["Click to erase the current map and start over"] = ""
--Translation missing 
-- L["Current Room: %s"] = ""
--Translation missing 
-- L["Disabled"] = ""
--Translation missing 
-- L["Enabled"] = ""
--Translation missing 
-- L["Hold the Ctrl key, then click on the desired room to select it (a round circle will appear around the room), then click the 'Set player location' button twice"] = ""
--Translation missing 
-- L["How can I reposition the player on the map?"] = ""
--Translation missing 
-- L["How does the Endless Halls tool work?"] = ""
--Translation missing 
-- L["It tracks player movement through the halls, generating a map that can be used to mark special rooms and retrace your steps into them when necessary."] = ""
--Translation missing 
-- L["Markers"] = ""
--Translation missing 
-- L["No, jump over"] = ""
--Translation missing 
-- L["Selected Room: %s"] = ""
--Translation missing 
-- L["Set Player location"] = ""
--Translation missing 
-- L["There is a shenanigan, however: in every maze there are a few one-directional doors that lead to a random location, they cannot be recognized by either the addon or the player. If you feel you got teleported or you're simply lost, I'd recommend to use the Enabled button to deactivate mapping until you find a familiar room, then reposition the player into that room on the map and re-enable to restart mapping from there."] = ""
--Translation missing 
-- L["This button pauses/unpauses the map generation"] = ""
--Translation missing 
-- L["Transparency"] = ""
--Translation missing 
-- L["Yes, keep it linked"] = ""
--Translation missing 
-- L["You can navigate the map by Right-Click Dragging it"] = ""
--Translation missing 
-- L["You have encountered an existing room on the map, do you recognize it as the room that you wanted to enter?"] = ""

elseif locale == "frFR" then
L["Clear"] = "Nettoyer"
--Translation missing 
-- L["Clear Markers"] = ""
--Translation missing 
-- L["Click again to confirm"] = ""
L["Click to center the camera to the current room"] = "Cliquez pour centrer la caméra dans la salle actuelle"
L["Click to erase the current map and start over"] = "Cliquer pour effacer cette carte et recommencer"
--Translation missing 
-- L["Current Room: %s"] = ""
--Translation missing 
-- L["Disabled"] = ""
--Translation missing 
-- L["Enabled"] = ""
--Translation missing 
-- L["Hold the Ctrl key, then click on the desired room to select it (a round circle will appear around the room), then click the 'Set player location' button twice"] = ""
--Translation missing 
-- L["How can I reposition the player on the map?"] = ""
--Translation missing 
-- L["How does the Endless Halls tool work?"] = ""
--Translation missing 
-- L["It tracks player movement through the halls, generating a map that can be used to mark special rooms and retrace your steps into them when necessary."] = ""
L["Markers"] = "Marqueurs"
--Translation missing 
-- L["No, jump over"] = ""
--Translation missing 
-- L["Selected Room: %s"] = ""
--Translation missing 
-- L["Set Player location"] = ""
--Translation missing 
-- L["There is a shenanigan, however: in every maze there are a few one-directional doors that lead to a random location, they cannot be recognized by either the addon or the player. If you feel you got teleported or you're simply lost, I'd recommend to use the Enabled button to deactivate mapping until you find a familiar room, then reposition the player into that room on the map and re-enable to restart mapping from there."] = ""
--Translation missing 
-- L["This button pauses/unpauses the map generation"] = ""
L["Transparency"] = "Transparence"
--Translation missing 
-- L["Yes, keep it linked"] = ""
L["You can navigate the map by Right-Click Dragging it"] = "Vous pouvez naviguer dans la carte en la faisant glisser à l'aide du clic-droit"
--Translation missing 
-- L["You have encountered an existing room on the map, do you recognize it as the room that you wanted to enter?"] = ""

elseif locale == "deDE" then 
L["Clear"] = "Löschen"
L["Clear Markers"] = "Markierungen löschen"
L["Click again to confirm"] = "Klicke zur Bestätigung erneut"
L["Click to center the camera to the current room"] = "Klicken, um die Karte auf den momentanen Raum zu zentrieren"
L["Click to erase the current map and start over"] = "Klicken, um die aktuelle Karte löschen und von vorne zu beginnen"
L["Current Room: %s"] = "Momentaner Raum: %s"
L["Disabled"] = "Deaktiviert"
L["Enabled"] = "Aktiviert"
L["Hold the Ctrl key, then click on the desired room to select it (a round circle will appear around the room), then click the 'Set player location' button twice"] = "Halte die Strg-Taste, klicke auf den gewünschten Raum, um ihn auszuwählen (ein Kreis wird den Raum umgeben), klicke danach zweimal auf den Button 'Spielerposition festlegen'"
L["How can I reposition the player on the map?"] = "Wie kann ich den Spieler auf der Karte neu positionieren?"
L["How does the Endless Halls tool work?"] = "Wie funktioniert die Hilfe für die Endlosen Hallen?"
L["It tracks player movement through the halls, generating a map that can be used to mark special rooms and retrace your steps into them when necessary."] = "Zeichnet die Bewegungen des Spielers durch die Hallen auf, erzeugt eine Karte, die verwendet werden kann, um besondere Räume zu markieren und den Weg zu diesen Räumen erneut zu finden."
L["Markers"] = "Markierungen"
L["No, jump over"] = "Nein, überspringen"
L["Selected Room: %s"] = "Ausgewählter Raum: %s"
L["Set Player location"] = "Spielerposition festlegen"
--Translation missing 
-- L["There is a shenanigan, however: in every maze there are a few one-directional doors that lead to a random location, they cannot be recognized by either the addon or the player. If you feel you got teleported or you're simply lost, I'd recommend to use the Enabled button to deactivate mapping until you find a familiar room, then reposition the player into that room on the map and re-enable to restart mapping from there."] = ""
L["This button pauses/unpauses the map generation"] = "Dieser Button pausiert/startet die Kartenerzeugung"
L["Transparency"] = "Transparenz"
L["Yes, keep it linked"] = "Ja, lasse sie verbunden"
L["You can navigate the map by Right-Click Dragging it"] = "Du kannst die Karte mit gedrückter rechter Maustaste verschieben"
L["You have encountered an existing room on the map, do you recognize it as the room that you wanted to enter?"] = "Du hast einen bereits auf der Karte existierenden Raum betreten, ist dies der Raum den du betreten wolltest?"

elseif locale == "ruRU" then 
L["Clear"] = "Очистить"
L["Clear Markers"] = "Очистить маркеры"
L["Click again to confirm"] = "Нажмите ещё раз, чтобы подтвердить"
L["Click to center the camera to the current room"] = "Нажмите, чтобы централизовать камеру на текущую комнату"
L["Click to erase the current map and start over"] = "Нажмите, чтобы удалить текущую карту и начать сначала"
L["Current Room: %s"] = "Комната: %s"
L["Disabled"] = "Выключен"
L["Enabled"] = "Включен"
--Translation missing 
-- L["Hold the Ctrl key, then click on the desired room to select it (a round circle will appear around the room), then click the 'Set player location' button twice"] = ""
--Translation missing 
-- L["How can I reposition the player on the map?"] = ""
--Translation missing 
-- L["How does the Endless Halls tool work?"] = ""
--Translation missing 
-- L["It tracks player movement through the halls, generating a map that can be used to mark special rooms and retrace your steps into them when necessary."] = ""
L["Markers"] = "Маркеры"
L["No, jump over"] = "Нет, перепрыгнуть"
--Translation missing 
-- L["Selected Room: %s"] = ""
--Translation missing 
-- L["Set Player location"] = ""
--Translation missing 
-- L["There is a shenanigan, however: in every maze there are a few one-directional doors that lead to a random location, they cannot be recognized by either the addon or the player. If you feel you got teleported or you're simply lost, I'd recommend to use the Enabled button to deactivate mapping until you find a familiar room, then reposition the player into that room on the map and re-enable to restart mapping from there."] = ""
--Translation missing 
-- L["This button pauses/unpauses the map generation"] = ""
--Translation missing 
-- L["Transparency"] = ""
L["Yes, keep it linked"] = "Да, соединить"
L["You can navigate the map by Right-Click Dragging it"] = "Вы можете перемещать карту удерживая правую кнопку мыши"
--Translation missing 
-- L["You have encountered an existing room on the map, do you recognize it as the room that you wanted to enter?"] = ""

elseif locale == "zhCN" then 
L["Clear"] = "清除"
--Translation missing 
-- L["Clear Markers"] = ""
--Translation missing 
-- L["Click again to confirm"] = ""
L["Click to center the camera to the current room"] = "点击保存当前房间快照"
L["Click to erase the current map and start over"] = "点击删除当前地图并重新开始"
L["Current Room: %s"] = "当前房间：%s"
--Translation missing 
-- L["Disabled"] = ""
--Translation missing 
-- L["Enabled"] = ""
--Translation missing 
-- L["Hold the Ctrl key, then click on the desired room to select it (a round circle will appear around the room), then click the 'Set player location' button twice"] = ""
--Translation missing 
-- L["How can I reposition the player on the map?"] = ""
--Translation missing 
-- L["How does the Endless Halls tool work?"] = ""
--Translation missing 
-- L["It tracks player movement through the halls, generating a map that can be used to mark special rooms and retrace your steps into them when necessary."] = ""
L["Markers"] = "标记"
--Translation missing 
-- L["No, jump over"] = ""
--Translation missing 
-- L["Selected Room: %s"] = ""
--Translation missing 
-- L["Set Player location"] = ""
--Translation missing 
-- L["There is a shenanigan, however: in every maze there are a few one-directional doors that lead to a random location, they cannot be recognized by either the addon or the player. If you feel you got teleported or you're simply lost, I'd recommend to use the Enabled button to deactivate mapping until you find a familiar room, then reposition the player into that room on the map and re-enable to restart mapping from there."] = ""
--Translation missing 
-- L["This button pauses/unpauses the map generation"] = ""
L["Transparency"] = "透明度"
--Translation missing 
-- L["Yes, keep it linked"] = ""
L["You can navigate the map by Right-Click Dragging it"] = "你可以点击右键来开启地图导航"
--Translation missing 
-- L["You have encountered an existing room on the map, do you recognize it as the room that you wanted to enter?"] = ""

elseif locale == "zhTW" then 
--Translation missing 
-- L["Clear"] = ""
--Translation missing 
-- L["Clear Markers"] = ""
--Translation missing 
-- L["Click again to confirm"] = ""
--Translation missing 
-- L["Click to center the camera to the current room"] = ""
--Translation missing 
-- L["Click to erase the current map and start over"] = ""
--Translation missing 
-- L["Current Room: %s"] = ""
--Translation missing 
-- L["Disabled"] = ""
--Translation missing 
-- L["Enabled"] = ""
--Translation missing 
-- L["Hold the Ctrl key, then click on the desired room to select it (a round circle will appear around the room), then click the 'Set player location' button twice"] = ""
--Translation missing 
-- L["How can I reposition the player on the map?"] = ""
--Translation missing 
-- L["How does the Endless Halls tool work?"] = ""
--Translation missing 
-- L["It tracks player movement through the halls, generating a map that can be used to mark special rooms and retrace your steps into them when necessary."] = ""
--Translation missing 
-- L["Markers"] = ""
--Translation missing 
-- L["No, jump over"] = ""
--Translation missing 
-- L["Selected Room: %s"] = ""
--Translation missing 
-- L["Set Player location"] = ""
--Translation missing 
-- L["There is a shenanigan, however: in every maze there are a few one-directional doors that lead to a random location, they cannot be recognized by either the addon or the player. If you feel you got teleported or you're simply lost, I'd recommend to use the Enabled button to deactivate mapping until you find a familiar room, then reposition the player into that room on the map and re-enable to restart mapping from there."] = ""
--Translation missing 
-- L["This button pauses/unpauses the map generation"] = ""
--Translation missing 
-- L["Transparency"] = ""
--Translation missing 
-- L["Yes, keep it linked"] = ""
--Translation missing 
-- L["You can navigate the map by Right-Click Dragging it"] = ""
--Translation missing 
-- L["You have encountered an existing room on the map, do you recognize it as the room that you wanted to enter?"] = ""

elseif locale == "koKR" then
L["Clear"] = "지우기"
L["Clear Markers"] = "징표 지우기"
L["Click again to confirm"] = "확인을 위해 다시 클릭하십시오."
L["Click to center the camera to the current room"] = "카메라를 현재 방 중앙에 배치하려면 클릭하십시오."
L["Click to erase the current map and start over"] = "현재 지도를 지우고 다시 시작하려면 클릭하십시오."
L["Current Room: %s"] = "현재 방: %s"
--Translation missing 
-- L["Disabled"] = ""
--Translation missing 
-- L["Enabled"] = ""
--Translation missing 
-- L["Hold the Ctrl key, then click on the desired room to select it (a round circle will appear around the room), then click the 'Set player location' button twice"] = ""
--Translation missing 
-- L["How can I reposition the player on the map?"] = ""
--Translation missing 
-- L["How does the Endless Halls tool work?"] = ""
--Translation missing 
-- L["It tracks player movement through the halls, generating a map that can be used to mark special rooms and retrace your steps into them when necessary."] = ""
L["Markers"] = "징표"
L["No, jump over"] = "No, jump over"
L["Selected Room: %s"] = "선택된 방: %s"
L["Set Player location"] = "플레이어 위치 설정"
--Translation missing 
-- L["There is a shenanigan, however: in every maze there are a few one-directional doors that lead to a random location, they cannot be recognized by either the addon or the player. If you feel you got teleported or you're simply lost, I'd recommend to use the Enabled button to deactivate mapping until you find a familiar room, then reposition the player into that room on the map and re-enable to restart mapping from there."] = ""
--Translation missing 
-- L["This button pauses/unpauses the map generation"] = ""
L["Transparency"] = "투명도"
L["Yes, keep it linked"] = "예, 연결된 상태로 유지하십시오."
L["You can navigate the map by Right-Click Dragging it"] = "마우스 오른쪽 클릭을 하여 지도를 드래그하여 탐색 할 수 있습니다."
L["You have encountered an existing room on the map, do you recognize it as the room that you wanted to enter?"] = "지도에서 기존 방을 발견했습니다. 입력하려는 방으로 인식하고 할까요?"

end
