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
-- L["Markers"] = ""
--Translation missing 
-- L["Transparency"] = ""
--Translation missing 
-- L["You can navigate the map by Right-Click Dragging it"] = ""

elseif locale == "itIT" then 
L["Clear"] = "Pulisci"
L["Click to center the camera to the current room"] = "Clicca per centrare la telecamera sulla stanza corrente"
L["Click to erase the current map and start over"] = "Clicca per cancellare la mappa e ricominciare da capo"
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
-- L["Markers"] = ""
--Translation missing 
-- L["Transparency"] = ""
--Translation missing 
-- L["You can navigate the map by Right-Click Dragging it"] = ""

elseif locale == "frFR" then
L["Clear"] = "Nettoyer"
L["Click to center the camera to the current room"] = "Cliquez pour centrer la caméra dans la salle actuelle"
L["Click to erase the current map and start over"] = "Cliquer pour effacer cette carte et recommencer"
L["Markers"] = "Marqueurs"
L["Transparency"] = "Transparence"
L["You can navigate the map by Right-Click Dragging it"] = "Vous pouvez naviguer dans la carte en la faisant glisser à l'aide du clic-droit"

elseif locale == "deDE" then 
--Translation missing 
-- L["Clear"] = ""
--Translation missing 
-- L["Click to center the camera to the current room"] = ""
--Translation missing 
-- L["Click to erase the current map and start over"] = ""
--Translation missing 
-- L["Markers"] = ""
--Translation missing 
-- L["Transparency"] = ""
--Translation missing 
-- L["You can navigate the map by Right-Click Dragging it"] = ""

elseif locale == "ruRU" then 
--Translation missing 
-- L["Clear"] = ""
--Translation missing 
-- L["Click to center the camera to the current room"] = ""
--Translation missing 
-- L["Click to erase the current map and start over"] = ""
--Translation missing 
-- L["Markers"] = ""
--Translation missing 
-- L["Transparency"] = ""
--Translation missing 
-- L["You can navigate the map by Right-Click Dragging it"] = ""

elseif locale == "zhCN" then 
--Translation missing 
L["Clear"] = "清除"
--Translation missing 
L["Click to center the camera to the current room"] = "点击保存当前房间快照"
--Translation missing 
L["Click to erase the current map and start over"] = "点击删除当前地图并重新开始"
--Translation missing 
L["Markers"] = "标记"
--Translation missing 
L["Transparency"] = "透明度"
--Translation missing 
L["You can navigate the map by Right-Click Dragging it"] = "你可以点击右键来开启地图导航"

elseif locale == "zhTW" then 
--Translation missing 
-- L["Clear"] = ""
--Translation missing 
-- L["Click to center the camera to the current room"] = ""
--Translation missing 
-- L["Click to erase the current map and start over"] = ""
--Translation missing 
-- L["Markers"] = ""
--Translation missing 
-- L["Transparency"] = ""
--Translation missing 
-- L["You can navigate the map by Right-Click Dragging it"] = ""

elseif locale == "koKR" then
--Translation missing 
-- L["Clear"] = ""
--Translation missing 
-- L["Click to center the camera to the current room"] = ""
--Translation missing 
-- L["Click to erase the current map and start over"] = ""
--Translation missing 
-- L["Markers"] = ""
--Translation missing 
-- L["Transparency"] = ""
--Translation missing 
-- L["You can navigate the map by Right-Click Dragging it"] = ""

end
