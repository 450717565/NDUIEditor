-- $Id: zhTW.lua 27 2017-05-14 14:37:20Z arith $

local L = LibStub("AceLocale-3.0"):NewLocale("HandyNotes_SuramarShalAranTelemancy", "zhTW", false)

if not L then return end

if L then
L["AddOn Settings"] = "插件設定"
L["Entrance"] = "入口"
L["Entrance of %s"] = "%s的入口"
L["Fountain"] = "噴泉"
L["Garden"] = "花園"
L["Great Eagle"] = "巨鷹"
L["HandyNotes - Suramar & Shal'Aran Telemancy"] = "HandyNotes - 蘇拉瑪爾與沙亞蘭的傳送"
L["Icon Alpha"] = "圖示透明度"
L["Icon Scale"] = "圖示大小"
L["Icon settings"] = "圖示設定"
L["Ignore in-/out-door"] = "忽略室內外"
L["Ignore whether it is currently indoor or outdoor, show all nodes."] = "忽略目前是否在室內或室外的差異，一律顯示所有節點。"
L["Leyline Entrances"] = "脈能入口"
L["Library"] = "圖書館"
L["Outside of The Drift"] = "幻時之境外面"
L["Portal"] = "傳送門"
L["Portal to %s"] = "到%s的傳送門"
L["Query from server"] = "向伺服器查詢"
L["Reset hidden nodes"] = "重設所有被隱藏的節點"
L["Send query request to server to lookup NPC's localized name. May be a little bit slower for the first time lookup but would be very fast once the name is found and cached."] = "向伺服器送出查詢 NPC 名稱的請求。首次查詢名稱時可能會顯示稍慢，一旦查詢到或該名稱已有快取時則會立即顯示。"
L["Shal'Aran Portals"] = "沙亞蘭傳送門"
L["Show all nodes that you manually hid by right-clicking on them and choosing \"hide\"."] = "將您手動把 POI 設為隱藏的節點還原成全部都顯示。"
L["Show entrances which lead to the leyline."] = "顯示所有脈能站的入口。"
L["Show note"] = "顯示說明"
L["Show portals inside Shal'Aran."] = "顯示在沙亞蘭裡的傳送門位置。"
L["Show Telemetry Lab related telemancies, mainly quest related from Oculeth's quest: \"The Delicate Art of Telemancy\"."] = "顯示遙距勘測實驗室相關的傳送點，主線任務為歐庫雷斯提供的：「傳送師的精湛技藝」。"
L["Show the entrances which are not specified more precisely."] = "顯示所有不明洞穴的入口。"
L["Show the entrances which lead to known caves or space."] = "顯示知名的洞穴或空間的入口。"
L["Show the node's additional notes when it's available."] = "當節點有額外說明時，同時顯示該說明。"
L["Shows the telemancy between Shal'Aran and nodes in Suramar"] = "顯示在沙亞蘭與蘇拉瑪爾之間的各個傳送點位置"
L["Specified Entrances"] = "知名入口"
L["Storage"] = "儲藏室"
L["Suramar & Shal'Aran Telemancy"] = "蘇拉瑪爾與沙亞蘭的傳送"
L[ [=[Telemancy to: 
  - Garden]=] ] = [=[傳送到：
  - 花園]=]
L[ [=[Telemancy to: 
  - Storage]=] ] = [=[傳送到：
  - 儲藏室]=]
L[ [=[Telemancy to: 
  o Fountain]=] ] = [=[傳送到：
  o 噴泉]=]
L[ [=[Telemancy to: 
  o Fountain
  o Warp Lab
  - Library]=] ] = [=[傳送到：
  o 噴泉
  o 躍傳實驗室
  - 圖書館]=]
L[ [=[Telemancy to: 
  o Garden
  - Test Chamber]=] ] = [=[傳送到：
  o 花園
  - 試驗室]=]
L[ [=[Telemancy to: 
  o Telemetry Lab
  o Garden
  x Breakfast Nook]=] ] = [=[傳送到：
  o 遙距勘測實驗室
  o 花園
  x 早餐角落]=]
L[ [=[Telemancy to: 
  o Workshop]=] ] = [=[傳送到：
  o 工坊]=]
L["Telemetry Lab"] = "遙距勘測實驗室"
L["Teleportation Nexus"] = "傳送網路"
L["The alpha transparency of the icons"] = "圖示的透明度"
L["The scale of the icons"] = "圖示的大小"
L["These settings control the look and feel of the icon."] = "以下的設定控制了圖示的外觀及風格。"
L["These settings control what type of icons to be displayed."] = "以下的設定控制了哪些類型的節點要被顯示。"
L["Unspecified Entrances"] = "不明入口"
L["Warp Lab"] = "躍傳實驗室"
L["What to display"] = "哪些要被呈現"

-- ToC
L["Description"] = "顯示在沙亞蘭與蘇拉瑪爾之間的各個傳送點位置"
L["Title"] = "HandyNotes - 蘇拉瑪爾與沙亞蘭的傳送"

end
