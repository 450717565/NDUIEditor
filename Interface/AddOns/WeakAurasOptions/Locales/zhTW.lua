if not(GetLocale() == "zhTW") then
  return
end

local L = WeakAuras.L

-- WeakAuras/Options
	L["-- Do not remove this comment, it is part of this trigger: "] = "-- Do not remove this comment, it is part of this trigger: "
	L["% of Progress"] = "進度%"
	L["%i Matches"] = "%i符合"
	L["1 Match"] = "1符合"
	L["1. Text"] = "1. 文字"
	L["1. Text Settings"] = "1. 文字設定"
	L["2. Text"] = "2. 文字"
	L["2. Text Settings"] = "2. 文字設定"
	L["A 20x20 pixels icon"] = "20x20 大小的圖示"
	L["A 32x32 pixels icon"] = "32x32 大小的圖示"
	L["A 40x40 pixels icon"] = "40x40 大小的圖示"
	L["A 48x48 pixels icon"] = "48x48 大小的圖示"
	L["A 64x64 pixels icon"] = "64x64 大小的圖示"
	L["A group that dynamically controls the positioning of its children"] = "可動態控制子元素位置的群組"
	L["Actions"] = "動作"
	L["Activate when the given aura(s) |cFFFF0000can't|r be found"] = "指定的光環|cFFFF0000無法找到時|r啟動"
	L["Add a new display"] = "新增特效"
	--Translation missing 
	-- L["Add to group %s"] = ""
	L["Add to new Dynamic Group"] = "新增動態群組"
	L["Add to new Group"] = "新增群組"
	L["Add Trigger"] = "新增觸發"
	--Translation missing 
	-- L["Addon"] = ""
	L["Addons"] = "插件"
	L["Align"] = "置中"
	L["Allow Full Rotation"] = "允許完整旋轉"
	L["Alpha"] = "透明度"
	L["Anchor"] = "對齊點"
	L["Anchor Point"] = "對齊點"
	--Translation missing 
	-- L["anchored to"] = ""
	--Translation missing 
	-- L["Anchored To"] = ""
	L["Angle"] = "角度"
	L["Animate"] = "閃爍"
	L["Animated Expand and Collapse"] = "動畫展開和收合"
	L["Animation relative duration description"] = [=[動畫的持續時間相對持續時間的顯示，表示為一小部分(1 / 2)，百分比(50％)，或十進制(0.5)。
|cFFFF0000注意：|r 如果顯示沒有進度(它沒有時間事件觸發，是光環沒有持續時間，或其他)，動畫將不會撥放。

|cFF4444FF舉例：|r
如果動畫的持續時間設定為 |cFF00CC0010%|r，然後顯示觸發的增益持續20秒，開始動畫將會撥放2秒。
如果動畫的持續時間設定為 |cFF00CC0010%|r，然後顯示觸發的增益沒有設定持續時間，將不會撥放開始動畫(儘管這樣如果你指定動畫在數秒內)。"]=]
	L["Animation Sequence"] = "動畫序列"
	L["Animations"] = "動畫"
	L["Apply Template"] = "套用範本"
	L["Arcane Orb"] = "祕法光球"
	L["At a position a bit left of Left HUD position."] = "比左方 HUD 更左一點的位置"
	L["At a position a bit left of Right HUD position"] = "比右方 HUD 更右一點的位置"
	L["At the same position as Blizzard's spell alert"] = "和暴雪法術警告效果相同的位置"
	L["Aura Name"] = "光環名稱"
	L["Aura Type"] = "光環類型"
	L["Aura(s)"] = "光環"
	--Translation missing 
	-- L["Aura:"] = ""
	--Translation missing 
	-- L["Auras:"] = ""
	L["Auto"] = "自動"
	--Translation missing 
	-- L["Auto-cloning enabled"] = ""
	L["Automatic Icon"] = "自動圖示"
	L["Backdrop Color"] = "背景顏色"
	L["Backdrop Style"] = "背景類型"
	L["Background"] = "背景"
	L["Background Color"] = "背景顏色"
	L["Background Inset"] = "背景小圖"
	L["Background Offset"] = "背景位置"
	L["Background Texture"] = "背景材質"
	L["Bar Alpha"] = "條透明度"
	L["Bar Color"] = "條顏色"
	L["Bar Color Settings"] = "狀態條顏色設定"
	L["Bar in Front"] = "狀態條置頂"
	L["Bar Texture"] = "條材質"
	L["Big Icon"] = "大圖示"
	L["Blend Mode"] = "混合模式"
	L["Blue Rune"] = "藍色符文"
	L["Blue Sparkle Orb"] = "藍色光球"
	L["Border"] = "邊框"
	L["Border Color"] = "邊框顏色"
	L["Border Inset"] = "邊框內縮"
	L["Border Offset"] = "邊框位置"
	L["Border Settings"] = "邊框設定"
	L["Border Size"] = "邊框大小"
	L["Border Style"] = "邊框樣式"
	L["Bottom Text"] = "底部文字"
	--Translation missing 
	-- L["Bracket Matching"] = ""
	L["Button Glow"] = "按鈕發光"
	--Translation missing 
	-- L["Can be a name or a UID (e.g., party1). A name only works on friendly players in your group."] = ""
	L["Can be a name or a UID (e.g., party1). Only works on friendly players in your group."] = "可能是名稱或是用戶名稱(例如，隊伍1)。只在你群組裡的友善玩家作用。"
	L["Cancel"] = "取消"
	L["Channel Number"] = "頻道編號"
	L["Chat Message"] = "聊天訊息文字"
	L["Check On..."] = "檢查..."
	L["Children:"] = "子項目:"
	L["Choose"] = "選擇"
	L["Choose Trigger"] = "選擇觸發"
	L["Choose whether the displayed icon is automatic or defined manually"] = "選擇在特效顯示的圖示是自動或手動定義"
	L["Clone option enabled dialog"] = [=[你已經啟用一項設定來使用|cFFFF0000自動複製|r。

|cFFFF0000自動複製|r造成顯示自動重複來顯示多個訊息來源。
直到你讓顯示在|cFF22AA22動態群組|r，所有複製被顯示在其它所有的一大堆的上面。

你想要讓顯示被放到新的|cFF22AA22動態群組|r？]=]
	L["Close"] = "關閉"
	--Translation missing 
	-- L["Collapse"] = ""
	L["Collapse all loaded displays"] = "收合所有已載入的特效"
	L["Collapse all non-loaded displays"] = "收合所有未載入的特效"
	L["Color"] = "顏色"
	L["Compress"] = "精簡"
	--Translation missing 
	-- L["Conditions"] = ""
	L["Constant Factor"] = "常數因子"
	--Translation missing 
	-- L["Control-click to select multiple displays"] = ""
	L["Controls the positioning and configuration of multiple displays at the same time"] = "同時控制多個特效的位置和設定"
	--Translation missing 
	-- L["Convert to..."] = ""
	L["Cooldown"] = "冷卻時間"
	--Translation missing 
	-- L["Copy settings from %s"] = ""
	--Translation missing 
	-- L["Copy settings from..."] = ""
	--Translation missing 
	-- L["Copy URL"] = ""
	L["Count"] = "計數"
	L["Creating buttons: "] = "創建按鈕："
	L["Creating options: "] = "創建設定："
	L["Crop"] = "裁剪"
	L["Crop X"] = "裁剪X"
	L["Crop Y"] = "裁剪Y"
	L["Custom"] = "自訂"
	L["Custom Code"] = "自訂編碼"
	L["Custom Function"] = "自訂函數"
	L["Custom Trigger"] = "自訂觸發"
	L["Custom trigger event tooltip"] = [=[選擇用於自訂觸發檢查的事件。
多事件可以使用逗號或空格分隔開。

|cFF4444FF舉例：|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED]=]
	L["Custom trigger status tooltip"] = [=[選擇用於自訂觸發檢查的事件。
這是狀態類型的觸發器，指定的事件不需預計參數就可以被WeakAuras調用。
多事件可以使用逗號或空格分隔開。

|cFF4444FF舉例：|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED]=]
	L["Custom Untrigger"] = "自訂無效觸發"
	L["Debuff Type"] = "減益類型"
	L["Default"] = "預設"
	--Translation missing 
	-- L["Delete"] = ""
	L["Delete all"] = "刪除全部"
	--Translation missing 
	-- L["Delete children and group"] = ""
	L["Delete Trigger"] = "刪除觸發"
	L["Desaturate"] = "去色"
	L["Disabled"] = "停用"
	L["Discrete Rotation"] = "分離旋轉"
	L["Display"] = "特效"
	L["Display Icon"] = "特效圖示"
	L["Display Text"] = "特效文字"
	L["Displays a text, works best in combination with other displays"] = "顯示文字，最適合和其他顯示效果一起搭配使用"
	L["Distribute Horizontally"] = "水平分佈"
	L["Distribute Vertically"] = "垂直分佈"
	--Translation missing 
	-- L["Do not copy any settings"] = ""
	--Translation missing 
	-- L["Do not group this display"] = ""
	L["Done"] = "完成"
	--Translation missing 
	-- L["Drag to move"] = ""
	--Translation missing 
	-- L["Duplicate"] = ""
	L["Duration (s)"] = "持續時間(秒)"
	L["Duration Info"] = "持續時間訊息"
	L["Dynamic Group"] = "動態群組"
	L["Dynamic information"] = "動態資訊"
	--Translation missing 
	-- L["Dynamic Information"] = ""
	--Translation missing 
	-- L["Dynamic information from first active trigger"] = ""
	L["Dynamic information from first Active Trigger"] = "來自第一個啟用的觸發的動態資訊"
	L["Dynamic information from Trigger %i"] = "來自觸發 %i 的動態資訊"
	L["Dynamic text tooltip"] = [=[這裡有幾個特別的編碼允許用到文字動畫：

|cFFFF0000%p|r - 進度 - 剩餘時間的時間條或是不是時間條的數值
|cFFFF0000%t|r - 總共 - 最大時間條的持續時間或是最大不是時間條的數值
|cFFFF0000%n|r - 名稱 - 顯示名稱(通常是光環名稱)或是顯示編號如果沒有動態名稱
|cFFFF0000%i|r - 圖示 - 圖示關連到顯示
|cFFFF0000%s|r - 堆疊 - 光環堆疊數量(通常)
|cFFFF0000%c|r - 自訂 - 允許你定義一個自訂的Lua回傳字傳數值到顯示的函數]=]
	L["Enabled"] = "啟用"
	L["End Angle"] = "結束角度"
	L["Enter an aura name, partial aura name, or spell id"] = "輸入光環名稱，部分光環名稱，或是法術編號"
	L["Event"] = "事件"
	L["Event Type"] = "事件類型"
	L["Event(s)"] = "事件"
	--Translation missing 
	-- L["Expand"] = ""
	L["Expand all loaded displays"] = "展開所有已載入的特效"
	L["Expand all non-loaded displays"] = "展開所有未載入的特效"
	L["Expand Text Editor"] = "擴展文字編輯"
	--Translation missing 
	-- L["Expansion is disabled because this group has no children"] = ""
	--Translation missing 
	-- L["Export to Lua table..."] = ""
	--Translation missing 
	-- L["Export to string..."] = ""
	L["Fade"] = "淡化"
	L["Fade In"] = "淡入"
	L["Fade Out"] = "淡出"
	L["Finish"] = "結束"
	L["Fire Orb"] = "火球"
	L["Font"] = "字型"
	L["Font Flags"] = "字型標記"
	L["Font Size"] = "字型大小"
	L["Font Type"] = "字型類型"
	L["Foreground Color"] = "前景顏色"
	L["Foreground Texture"] = "前景材質"
	L["Frame"] = "框架"
	L["Frame Strata"] = "框架層級"
	--Translation missing 
	-- L["frame's"] = ""
	L["From Template"] = "從範本建立 (**推薦**)"
	--Translation missing 
	-- L["Full Scan"] = ""
	--Translation missing 
	-- L["General Text Settings"] = ""
	--Translation missing 
	-- L["Glow"] = ""
	L["Glow Action"] = "發光動作"
	L["Green Rune"] = "綠色符文"
	L["Group"] = "群組"
	--Translation missing 
	-- L["Group (verb)"] = ""
	L["Group aura count description"] = [=[%s的成員總數必須受到一個或多個給予的光環為顯示觸發。
如果輸入的數字是一個整數(如5)，受影響的團隊成員數量將與輸入的數字相比。
如果輸入的數字是一個小數(如0.5)，分數(例如1/ 2)，或百分比(例如50%%)，那麼這部分的%s必須受到影響。

|cFF4444FF舉例：|r
|cFF00CC00> 0|r 當%s中的任何人受影響時觸發
|cFF00CC00= 100%%|r 當%s中的所有人受影響時觸發
|cFF00CC00!= 2|r 當%s中受影響的人數不為 2 時觸發
|cFF00CC00<= 0.8|r 當%s中受影響的人數少於 80%% 時觸發(5人隊伍時為4人、10人團隊時為8人、25人團隊時為20人)
|cFF00CC00> 1/2|r 當%s中受影響的人數超過一半時觸發
|cFF00CC00>= 0|r 無論何時總是觸發]=]
	L["Group Member Count"] = "群組成員總數"
	L["Grow"] = "增長"
	L["Hawk"] = "老鷹"
	L["Height"] = "高度"
	L["Hide"] = "隱藏"
	L["Hide on"] = "隱藏"
	--Translation missing 
	-- L["Hide this group's children"] = ""
	L["Hide When Not In Group"] = "不在群組中時隱藏"
	L["Horizontal Align"] = "水平對齊"
	L["Horizontal Bar"] = "水平進度條"
	L["Horizontal Blizzard Raid Bar"] = "暴雪團隊水平進度條"
	L["Huge Icon"] = "超大圖示"
	L["Hybrid Position"] = "混合位置"
	L["Hybrid Sort Mode"] = "混合模式"
	L["Icon"] = "圖示"
	L["Icon Color"] = "圖示顏色"
	L["Icon Info"] = "圖示訊息"
	L["Icon Inset"] = "圖示內嵌"
	L["Ignored"] = "忽略"
	L["Import"] = "匯入"
	L["Import a display from an encoded string"] = "從編碼字串匯入特效"
	L["Inverse"] = "反向"
	L["Justify"] = "對齊"
	L["Leaf"] = "葉子"
	L["Left 2 HUD position"] = "左2 HUD 位置"
	L["Left HUD position"] = "左方 HUD 位置"
	L["Left Text"] = "左邊文字"
	L["Load"] = "載入"
	L["Loaded"] = "已載入"
	--Translation missing 
	-- L["Loop"] = ""
	L["Low Mana"] = "低法力"
	L["Main"] = "主要"
	L["Manage displays defined by Addons"] = "由插件管理已定義的特效"
	L["Medium Icon"] = "中圖示"
	L["Message"] = "訊息"
	L["Message Prefix"] = "訊息字首"
	L["Message Suffix"] = "訊息字尾"
	L["Message Type"] = "訊息類型"
	--Translation missing 
	-- L["Message type:"] = ""
	L["Mirror"] = "鏡像"
	L["Model"] = "模組"
	--Translation missing 
	-- L["Move Down"] = ""
	--Translation missing 
	-- L["Move this display down in its group's order"] = ""
	--Translation missing 
	-- L["Move this display up in its group's order"] = ""
	--Translation missing 
	-- L["Move Up"] = ""
	L["Multiple Displays"] = "多個特效"
	L["Multiple Triggers"] = "多觸發"
	L["Multiselect ignored tooltip"] = [=[|cFFFF0000忽略|r - |cFF777777單一|r - |cFF777777多個|r
這設定將不會被使用來判斷當顯示應該載入]=]
	L["Multiselect multiple tooltip"] = [=[|cFFFF0000忽略|r - |cFF777777單一|r - |cFF777777多個|r
任何數量的匹配值可以被挑選]=]
	L["Multiselect single tooltip"] = [=[|cFFFF0000忽略|r - |cFF777777單一|r - |cFF777777多個|r
只有單一的匹配值可以被挑選]=]
	L["Name Info"] = "名稱訊息"
	L["Negator"] = "不"
	L["Never"] = "從不"
	L["New"] = "新增"
	L["No"] = "取消"
	--Translation missing 
	-- L["No Children"] = ""
	L["No tooltip text"] = "取消提示資訊文字"
	L["None"] = "無"
	L["Not all children have the same value for this option"] = "並非所有子元素對這項設定有相同的數值"
	L["Not Loaded"] = "未載入"
	L["Offer a guided way to create auras for your class"] = "提供導引，建立與你職業有關的光環"
	L["Okay"] = "確認"
	L["On Hide"] = "事件隱藏視窗時觸發"
	L["On Init"] = "初始化時"
	L["On Show"] = "顯示時觸發"
	L["Only match auras cast by people other than the player"] = "只匹配其他玩家施放的光環"
	L["Only match auras cast by the player"] = "只匹配玩家自己施放的光環"
	L["Operator"] = "運算符"
	L["or"] = "或"
	L["Orange Rune"] = "橘色符文"
	L["Orientation"] = "方向"
	L["Outline"] = "輪廓"
	L["Own Only"] = "只顯示自己的"
	L["Paste text below"] = "在下面貼上文字"
	L["Play Sound"] = "播放音效"
	L["Portrait Zoom"] = "放大頭像"
	L["Preset"] = "預設配置"
	L["Prevents duration information from decreasing when an aura refreshes. May cause problems if used with multiple auras with different durations."] = "當光環刷新防止持續時間下降的訊息。如果使用多個光環用不同持續時間，可能會造成問題。"
	L["Processed %i chars"] = "處理進度 %i 個字元"
	L["Progress Bar"] = "進度條"
	L["Progress Texture"] = "進度材質"
	L["Purple Rune"] = "紫色符文"
	--Translation missing 
	-- L["Put this display in a group"] = ""
	L["Radius"] = "半徑"
	L["Re-center X"] = "重新置中X"
	L["Re-center Y"] = "重新置中Y"
	L["Remaining Time"] = "剩餘時間"
	L["Remaining Time Precision"] = "精確剩餘時間"
	--Translation missing 
	-- L["Remove this display from its group"] = ""
	--Translation missing 
	-- L["Rename"] = ""
	--Translation missing 
	-- L["Repeat After"] = ""
	--Translation missing 
	-- L["Required for Activation"] = ""
	L["Required For Activation"] = "需激活"
	L["Right 2 HUD position"] = "右2 HUD 位置"
	L["Right HUD position"] = "右方 HUD 位置"
	L["Right Text"] = "右邊文字"
	L["Right-click for more options"] = "右鍵點擊顯示更多設定"
	L["Rotate"] = "旋轉"
	L["Rotate In"] = "旋轉進入"
	L["Rotate Out"] = "旋轉退出"
	L["Rotate Text"] = "旋轉文字"
	L["Rotation"] = "旋轉"
	L["Rotation Mode"] = "旋轉模式"
	L["Same"] = "相同"
	L["Scale"] = "縮放大小"
	L["Search"] = "搜尋"
	L["Select the auras you always want to be listed first"] = "選擇要列在前面的特效"
	L["Send To"] = "發送到"
	--Translation missing 
	-- L["Set Parent to Anchor"] = ""
	--Translation missing 
	-- L["Set tooltip description"] = ""
	--Translation missing 
	-- L["Settings"] = ""
	--Translation missing 
	-- L["Shift-click to create chat link"] = ""
	L["Show all matches (Auto-clone)"] = "顯示所有相符的(自動複製)"
	--Translation missing 
	-- L["Show Cooldown Text"] = ""
	L["Show model of unit "] = "顯示單位的模組"
	L["Show players that are |cFFFF0000not affected"] = "顯示|cFFFF0000未被影響|r的玩家"
	--Translation missing 
	-- L["Show this group's children"] = ""
	L["Shows a 3D model from the game files"] = "顯示遊戲檔案中的3D模組"
	L["Shows a custom texture"] = "顯示自訂材質"
	L["Shows a progress bar with name, timer, and icon"] = "顯示一個包含名稱，時間和圖示的進度條"
	L["Shows a spell icon with an optional cooldown overlay"] = "顯示法術圖示，可選擇是否要在上面顯示冷卻時間。"
	L["Shows a texture that changes based on duration"] = "顯示根據時間變動的材質"
	L["Shows one or more lines of text, which can include dynamic information such as progress or stacks"] = "顯示包含動態訊息文字(例如進度或是堆疊數量,允許一行或多行)"
	L["Size"] = "大小"
	L["Slide"] = "滑動"
	L["Slide In"] = "滑入"
	L["Slide Out"] = "滑出"
	L["Small Icon"] = "小圖示"
	L["Sort"] = "排序"
	L["Sound"] = "音效"
	L["Sound Channel"] = "聲道"
	L["Sound File Path"] = "音效檔案路徑"
	L["Sound Kit ID"] = "Sound Kit ID"
	L["Space"] = "間隔"
	L["Space Horizontally"] = "橫向間隔"
	L["Space Vertically"] = "縱向間隔"
	L["Spark"] = "火花"
	L["Spark Settings"] = "火花設定"
	L["Spark Texture"] = "火花材質"
	L["Specific Unit"] = "指定單位"
	L["Spell ID"] = "法術編號"
	L["Spell ID dialog"] = [=[你使用|cFFFF0000法術編號|r指定了光環。

預設情況下,|cFF8800FFWeakAuras|r無法區分相同名稱的光環名稱(這個有別於|cFFFF0000法術編號|r)。 
不過在啟用完整掃描設定後，|cFF8800FFWeakAuras|r可以搜尋指定的|cFFFF0000法術編號|r。

你確定要啟用完整掃描來匹配該cFFFF0000法術編號|r嗎？]=]
	L["Stack Count"] = "堆疊數量"
	L["Stack Info"] = "堆疊訊息"
	L["Stacks"] = "堆疊層數"
	L["Stacks Settings"] = "堆疊設定"
	L["Stagger"] = "交錯"
	L["Star"] = "星星"
	L["Start"] = "開始"
	L["Start Angle"] = "開始角度"
	L["Status"] = "狀態"
	L["Stealable"] = "可法術竊取"
	L["Sticky Duration"] = "置頂時間"
	--Translation missing 
	-- L["Stop Sound"] = ""
	L["Symbol Settings"] = "符號設定"
	L["Temporary Group"] = "臨時群組"
	L["Text"] = "文字"
	L["Text Color"] = "文字顏色"
	L["Text Position"] = "文字位置"
	L["Texture"] = "材質"
	L["Texture Info"] = "材質資料"
	L["The children of this group have different display types, so their display options cannot be set as a group."] = "群組的子元素有不同的特效類型，所以特效的選項無法設定到群組。"
	L["The duration of the animation in seconds."] = "動畫的持續時間(秒)。"
	L["The type of trigger"] = "觸發類型"
	--Translation missing 
	-- L["This display is currently loaded"] = ""
	--Translation missing 
	-- L["This display is not currently loaded"] = ""
	L["This region of type \"%s\" is not supported."] = "不支援的地區類型 \"%s\"。"
	L["Time in"] = "時間"
	L["Tiny Icon"] = "小小圖示"
	--Translation missing 
	-- L["To Frame's"] = ""
	L["to group's"] = "到群組"
	--Translation missing 
	-- L["To Personal Ressource Display's"] = ""
	--Translation missing 
	-- L["to Personal Ressource Display's"] = ""
	--Translation missing 
	-- L["To Screen's"] = ""
	L["to screen's"] = "對齊螢幕的"
	L["Toggle the visibility of all loaded displays"] = "切換所有已載入特效的可見狀態"
	L["Toggle the visibility of all non-loaded displays"] = "切換所有未載入特效的可見狀態"
	--Translation missing 
	-- L["Toggle the visibility of this display"] = ""
	L["Tooltip"] = "提示資訊"
	L["Tooltip on Mouseover"] = "滑鼠經過提示"
	L["Top HUD position"] = "上方 HUD 位置"
	L["Top Text"] = "頂部文字"
	L["Total Time Precision"] = "總共時間精度"
	L["Trigger"] = "觸發"
	L["Trigger %d"] = "觸發%d"
	--Translation missing 
	-- L["Trigger:"] = ""
	L["Type"] = "類型"
	--Translation missing 
	-- L["Undefined"] = ""
	--Translation missing 
	-- L["Ungroup"] = ""
	L["Unit"] = "單位"
	L["Unlike the start or finish animations, the main animation will loop over and over until the display is hidden."] = "不同於開始或結束的動畫，主要動畫將重複循環直到特效被隱藏。"
	L["Update Custom Text On..."] = "更新自訂文字在..."
	L["Use Full Scan (High CPU)"] = "使用完整掃描(高CPU)"
	--Translation missing 
	-- L["Use SetTransform (will change behaviour in 7.3)"] = ""
	L["Use SetTransform api"] = "使用 SetTransform API"
	L["Use tooltip \"size\" instead of stacks"] = "使用提示資訊中的數字代替堆疊數量"
	L["Vertical Align"] = "垂直對齊"
	L["Vertical Bar"] = "垂直進度條"
	--Translation missing 
	-- L["View"] = ""
	L["WeakAurasOptions"] = "WA 技能提醒設定"
	L["Width"] = "寬度"
	L["X Offset"] = "水平位置"
	L["X Rotation"] = "水平旋轉"
	L["X Scale"] = "水平縮放"
	L["Y Offset"] = "垂直位置"
	L["Y Rotation"] = "垂直旋轉"
	L["Y Scale"] = "垂直縮放"
	L["Yellow Rune"] = "黃色符文"
	L["Yes"] = "是的"
	L["Z Offset"] = "Z軸位置"
	L["Z Rotation"] = "Z軸旋轉"
	L["Zoom"] = "縮放"
	L["Zoom In"] = "放大"
	L["Zoom Out"] = "縮小"

