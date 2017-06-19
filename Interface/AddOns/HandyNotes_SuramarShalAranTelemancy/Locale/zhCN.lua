-- $Id: zhCN.lua 27 2017-05-14 14:37:20Z arith $

local L = LibStub("AceLocale-3.0"):NewLocale("HandyNotes_SuramarShalAranTelemancy", "zhCN", false)

if not L then return end

if L then
L["AddOn Settings"] = "插件设定"
L["Entrance"] = "入口"
L["Entrance of %s"] = "%s的入口"
L["Fountain"] = "喷泉"
L["Garden"] = "花园"
L["Great Eagle"] = "巨鹰"
L["HandyNotes - Suramar & Shal'Aran Telemancy"] = "HandyNotes - 苏拉玛东与沙尔艾兰的传送"
L["Icon Alpha"] = "图示透明度"
L["Icon Scale"] = "图示大小"
L["Icon settings"] = "图示设定"
L["Ignore in-/out-door"] = "忽略室内外设定"
L["Ignore whether it is currently indoor or outdoor, show all nodes."] = "忽略目前是否在室内或室外的差异，一律显示所有节点"
L["Leyline Entrances"] = "脉能入口"
L["Library"] = "图书馆"
L["Outside of The Drift"] = "逐流魔窟外面"
L["Portal"] = "传送门"
L["Portal to %s"] = "到%s的传送门"
L["Query from server"] = "从服务器查询 NPC 名称"
L["Reset hidden nodes"] = "重设所有被隐藏的节点"
L["Send query request to server to lookup NPC's localized name. May be a little bit slower for the first time lookup but would be very fast once the name is found and cached."] = "向服务器送出查询 NPC 名称的请求。首次查询名称时可能会显示稍慢，一旦查询到或该名称已有快取时则会立即显示。"
L["Shal'Aran Portals"] = "沙尔艾兰的传送门"
L["Show all nodes that you manually hid by right-clicking on them and choosing \"hide\"."] = "将您手动把 POI 设为隐藏的节点还原成全部都显示。"
L["Show entrances which lead to the leyline."] = "显示所有脉能站的入口。"
L["Show note"] = "显示节点说明"
L["Show portals inside Shal'Aran."] = "显示在沙尔艾兰的传送门。"
L["Show the entrances which are not specified more precisely."] = "显示所有不明洞穴的入口。"
L["Show the entrances which lead to known caves or space."] = "显示知名的洞穴或空间的入口。"
L["Show the node's additional notes when it's available."] = "当节点有额外说明时，同时显示该说明"
L["Shows the telemancy between Shal'Aran and nodes in Suramar"] = "显示在沙尔艾兰与苏拉玛尔之间的各个传送点位置"
L["Specified Entrances"] = "知名入口"
L["Storage"] = "储藏室"
L["Suramar & Shal'Aran Telemancy"] = "苏拉玛尔与沙尔艾兰的传送"
L[ [=[Telemancy to: 
  - Garden]=] ] = [=[传送到：
  - 花园]=]
L[ [=[Telemancy to: 
  - Storage]=] ] = [=[传送到：
  - 储藏室]=]
L[ [=[Telemancy to: 
  o Fountain]=] ] = [=[传送到：
  o 喷泉]=]
L[ [=[Telemancy to: 
  o Fountain
  o Warp Lab
  - Library]=] ] = [=[传送到：
  o 喷泉
  o 跃传实验室
  - 图书馆]=]
L[ [=[Telemancy to: 
  o Garden
  - Test Chamber]=] ] = [=[传送到：
  o 花园
  - 试验室]=]
L[ [=[Telemancy to: 
  o Telemetry Lab
  o Garden
  x Breakfast Nook]=] ] = [=[传送到：
  o 遥距勘测实验室
  o 花园
  x 早餐角落]=]
L[ [=[Telemancy to: 
  o Workshop]=] ] = [=[传送到：
  o 工坊]=]
L["Telemetry Lab"] = "遥距勘测实验室"
L["The alpha transparency of the icons"] = "图示的透明度"
L["The scale of the icons"] = "图示的大小"
L["These settings control the look and feel of the icon."] = "以下的设定控制了图示的外观及风格。"
L["These settings control what type of icons to be displayed."] = "以下的设定控制了哪些类型的节点要被显示。"
L["Unspecified Entrances"] = "不明入口"
L["Warp Lab"] = "跃传实验室"
L["What to display"] = "哪些要被呈现"

-- ToC
L["Description"] = "显示在沙尔艾兰与苏拉玛尔之间的各个传送点位置"
L["Title"] = "HandyNotes - 苏拉玛东与沙尔艾兰的传送"

end
