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
-- L["Click to center the camera to the current room"] = ""
--Translation missing 
-- L["Click to erase the current map and start over"] = ""
--Translation missing 
-- L["Current Room: %s"] = ""
--Translation missing 
-- L["Markers"] = ""
--Translation missing 
-- L["Transparency"] = ""
--Translation missing 
-- L["You can navigate the map by Right-Click Dragging it"] = ""

elseif locale == "esMX" then 
--Translation missing 
-- L["Clear"] = ""
--Translation missing 
-- L["Click to center the camera to the current room"] = ""
--Translation missing 
-- L["Click to erase the current map and start over"] = ""
--Translation missing 
-- L["Current Room: %s"] = ""
--Translation missing 
-- L["Markers"] = ""
--Translation missing 
-- L["Transparency"] = ""
--Translation missing 
-- L["You can navigate the map by Right-Click Dragging it"] = ""

elseif locale == "itIT" then 
L["Clear"] = "Pulisci"
L["Click to center the camera to the current room"] = "Clicca per centrare la telecamera sulla stanza corrente"
L["Click to erase the current map and start over"] = "Clicca per cancellare la mappa e ricominciare da capo"
--Translation missing 
-- L["Current Room: %s"] = ""
L["Markers"] = "Simboli"
L["Transparency"] = "Trasparenza"
L["You can navigate the map by Right-Click Dragging it"] = "Puoi esplorare la mappa trascinandola con il Click-Destro"

elseif locale == "ptBR" then 
--Translation missing 
-- L["Clear"] = ""
--Translation missing 
-- L["Click to center the camera to the current room"] = ""
--Translation missing 
-- L["Click to erase the current map and start over"] = ""
--Translation missing 
-- L["Current Room: %s"] = ""
--Translation missing 
-- L["Markers"] = ""
--Translation missing 
-- L["Transparency"] = ""
--Translation missing 
-- L["You can navigate the map by Right-Click Dragging it"] = ""

elseif locale == "frFR" then
L["Clear"] = "Nettoyer"
L["Click to center the camera to the current room"] = "Cliquez pour centrer la caméra dans la salle actuelle"
L["Click to erase the current map and start over"] = "Cliquer pour effacer cette carte et recommencer"
--Translation missing 
-- L["Current Room: %s"] = ""
L["Markers"] = "Marqueurs"
L["Transparency"] = "Transparence"
L["You can navigate the map by Right-Click Dragging it"] = "Vous pouvez naviguer dans la carte en la faisant glisser à l'aide du clic-droit"

elseif locale == "deDE" then 
L["Clear"] = "Löschen"
L["Click to center the camera to the current room"] = "Klicken um zum anvisierten Raum die Kamera zentrieren"
L["Click to erase the current map and start over"] = "Klicken, um die aktuelle Karte löschen und neustarten"
--Translation missing 
-- L["Current Room: %s"] = ""
L["Markers"] = "Markierungen"
L["Transparency"] = "Transparenz"
L["You can navigate the map by Right-Click Dragging it"] = "Du kannst die Karte mit gedrückten Rechtsklick verschieben"

elseif locale == "ruRU" then 
--Translation missing 
-- L["Clear"] = ""
--Translation missing 
-- L["Click to center the camera to the current room"] = ""
--Translation missing 
-- L["Click to erase the current map and start over"] = ""
--Translation missing 
-- L["Current Room: %s"] = ""
--Translation missing 
-- L["Markers"] = ""
--Translation missing 
-- L["Transparency"] = ""
--Translation missing 
-- L["You can navigate the map by Right-Click Dragging it"] = ""

elseif locale == "zhCN" then 
L["Clear"] = "清除"
L["Click to center the camera to the current room"] = "点击保存当前房间快照"
L["Click to erase the current map and start over"] = "点击删除当前地图并重新开始"
--Translation missing 
-- L["Current Room: %s"] = ""
L["Markers"] = "标记"
L["Transparency"] = "透明度"
L["You can navigate the map by Right-Click Dragging it"] = "你可以点击右键来开启地图导航"

elseif locale == "zhTW" then 
--Translation missing 
-- L["Clear"] = ""
--Translation missing 
-- L["Click to center the camera to the current room"] = ""
--Translation missing 
-- L["Click to erase the current map and start over"] = ""
--Translation missing 
-- L["Current Room: %s"] = ""
--Translation missing 
-- L["Markers"] = ""
--Translation missing 
-- L["Transparency"] = ""
--Translation missing 
-- L["You can navigate the map by Right-Click Dragging it"] = ""

elseif locale == "koKR" then
L["Clear"] = "지우기"
L["Click to center the camera to the current room"] = "카메라를 현재 방 중앙에 배치하려면 클릭하십시오."
L["Click to erase the current map and start over"] = "현재 지도를 지우고 다시 시작하려면 클릭하십시오."
--Translation missing 
-- L["Current Room: %s"] = ""
L["Markers"] = "징표"
L["Transparency"] = "투명도"
L["You can navigate the map by Right-Click Dragging it"] = "마우스 오른쪽 클릭을 하여 지도를 드래그하여 탐색 할 수 있습니다."

end
