if not(GetLocale() == "zhTW") then
  return
end

local L = WeakAuras.L

-- WeakAuras
L["   • %d auras added"] = "   • 已新增 %d 個提醒效果"
L["   • %d auras deleted"] = "   • 已刪除 %d 個提醒效果"
L["   • %d auras modified"] = "   • 已修改 %d 個提醒效果"
L["%s - %i. Trigger"] = "%s - %i. 觸發"
L["%s - Alpha Animation"] = "%s - 透明度動畫"
L["%s - Color Animation"] = "%s - 顏色動畫"
L["%s - Condition Custom Chat"] = "%s - 條件符合時自訂聊天文字"
L["%s - Custom Text"] = "%s - 自訂文字"
L["%s - Finish"] = "%s - 結束時"
L["%s - Finish Action"] = "%s - 結束時動作"
L["%s - Finish Custom Text"] = "%s - 結束時自訂文字"
L["%s - Init Action"] = "%s - 初始化動作"
L["%s - Main"] = "%s - 主要"
L["%s - Rotate Animation"] = "%s - 旋轉動畫"
L["%s - Scale Animation"] = "%s - 縮放大小動畫"
L["%s - Start"] = "%s - 開始時"
L["%s - Start Action"] = "%s - 開始時動作"
L["%s - Start Custom Text"] = "%s - 開始時自訂文字"
L["%s - Translate Animation"] = "%s - 漸變動畫"
L["%s - Trigger Logic"] = "%s - 觸發邏輯"
L["%s Duration Function"] = "%s 持續時間函數"
L["%s Icon Function"] = "%s 圖示函數"
L["%s Name Function"] = "%s 名稱函數"
L["%s Overlay Color"] = "%s 疊加圖層顏色"
L["%s Stacks Function"] = "%s 堆疊層數函數"
L["%s Texture Function"] = "%s 材質函數"
L["%s total auras"] = "總共 %s 個提醒效果"
L["%s Trigger Function"] = "%s 觸發函數"
L["%s Untrigger Function"] = "%s 取消觸發函數"
L["/wa help - Show this message"] = "/wa help - 顯示這個訊息"
L["/wa minimap - Toggle the minimap icon"] = "/wa minimap - 切換顯示小地圖按鈕"
L["/wa pprint - Show the results from the most recent profiling"] = "/wa pprint - 顯示最近的分析結果"
L["/wa pstart - Start profiling. Optionally include a duration in seconds after which profiling automatically stops. To profile the next combat/encounter, pass a \"combat\" or \"encounter\" argument."] = [=[/wa pstart - 開始分析。可以選擇性的加上持續時間 (秒) 讓分析自動停止。要分析下一場戰鬥/首領戰，請加上 "combat" 或 "encounter" 參數。
]=]
L["/wa pstop - Finish profiling"] = "/wa pstop - 結束分析"
L["/wa repair - Repair tool"] = "/wa repair - 修復工具"
L["|cffeda55fLeft-Click|r to toggle showing the main window."] = "|cffeda55f左鍵|r 切換顯示主視窗。"
L["|cffeda55fMiddle-Click|r to toggle the minimap icon on or off."] = "|cffeda55f中鍵|r 切換開啟或關閉小地圖按鈕。"
L["|cffeda55fRight-Click|r to toggle performance profiling window."] = "|cffeda55f右鍵|r 切換顯示分析視窗。"
L["|cffeda55fShift-Click|r to pause addon execution."] = "|cffeda55fShift-左鍵|r 暫停執行插件。"
L["|cFFffcc00Extra Options:|r %s"] = "|cFFffcc00額外選項:|r %s"
L["|cFFffcc00Extra Options:|r None"] = "|cFFffcc00額外選項:|r 無"
L["10 Man Raid"] = "10人團隊"
L["20 Man Raid"] = "20人團隊"
L["25 Man Raid"] = "25人團隊"
L["40 Man Raid"] = "40人團隊"
L["5 Man Dungeon"] = "5人副本"
L["A WeakAura just tried to use a forbidden function but has been blocked from doing so. Please check your auras!"] = "WeakAura 正嘗試使用被禁止的功能，但是已經被阻擋。請檢查你的提醒效果設定!"
L["Absorb"] = "吸收量"
L["Absorb Display"] = "吸收量提醒效果"
L["Absorbed"] = "已吸收量"
L["Action Button Glow"] = "快捷列按鈕發光"
L["Action Usable"] = "動作可以使用"
L["Actions"] = "動作"
L["Active"] = "有效/作用中"
L["Add"] = "新增"
L["Add Missing Auras"] = "新增缺少的提醒效果"
L["Additional Trigger Replacements"] = "還有其他動態文字代碼:"
L["Affected"] = "被影響"
L["Affected Unit Count"] = "受影響單位數量"
L["Aggro"] = "仇恨"
L["Agility"] = "敏捷"
L["Ahn'Qiraj"] = "安琪拉"
L["Alert Type"] = "通知類型"
L["Alive"] = "存活"
L["All"] = "全部"
L["All Triggers"] = "全部的觸發"
L["Alliance"] = "聯盟"
L["Allow partial matches"] = "允許部分符合"
L["Alpha"] = "透明度"
L["Alternate Power"] = "特殊能量"
L["Always"] = "永遠"
L["Always active trigger"] = "永遠有作用的觸發"
L["Amount"] = "數量"
L["And Talent selected"] = "和選擇的天賦"
L["Animations"] = "動畫"
L["Anticlockwise"] = "逆時針"
L["Anub'Rekhan"] = "阿努比瑞克漢"
L["Any"] = "任何一種"
L["Any Triggers"] = "任何一個觸發"
L["AOE"] = "範圍技能 (AOE)"
L["Arcane Resistance"] = "祕法抗性"
L["Arena"] = "競技場"
L["Armor (%)"] = "護甲值 (%)"
L["Armor against Target (%)"] = "對目標的護甲值 (%)"
L["Armor Rating"] = "護甲值分數"
L["Array"] = "陣列"
L["Ascending"] = "升冪"
L["Assigned Role"] = "指派的角色"
L["At Least One Enemy"] = "至少一個敵人"
--[[Translation missing --]]
L["At missing Value"] = "At missing Value"
--[[Translation missing --]]
L["At Percent"] = "At Percent"
--[[Translation missing --]]
L["At Value"] = "At Value"
L["Attach to End"] = "附加到結尾"
L["Attach to Start"] = "附加到開頭"
L["Attack Power"] = "攻擊強度"
L["Attackable"] = "可攻擊"
L["Attackable Target"] = "可攻擊的目標"
L["Aura"] = "光環"
L["Aura Applied"] = "光環已加上"
L["Aura Applied Dose"] = "光環加上數量"
L["Aura Broken"] = "光環已失效"
L["Aura Broken Spell"] = "讓光環失效的法術"
L["Aura Name"] = "光環名稱"
L["Aura Names"] = "提醒效果名稱"
L["Aura Refresh"] = "光環刷新"
L["Aura Removed"] = "光環已移除"
L["Aura Removed Dose"] = "光環移除數量"
L["Aura Stack"] = "光環堆疊層數"
L["Aura Type"] = "光環類型"
L["Aura(s) Found"] = "有光環"
L["Aura(s) Missing"] = "沒有光環"
L["Aura:"] = "光環:"
L["Auras:"] = "光環:"
L["Author Options"] = "作者選項"
L["Auto"] = "自動"
L["Autocast Shine"] = "自動投射光影"
L["Automatic"] = "自動"
--[[Translation missing --]]
L["Automatic Length"] = "Automatic Length"
L["Automatic Repair Confirmation Dialog"] = "自訂修復確認對話框"
L["Automatic Rotation"] = "自動旋轉"
L["Avoidance (%)"] = "閃避 (%)"
L["Avoidance Rating"] = "閃避分數"
L["Ayamiss the Hunter"] = "『狩獵者』阿亞米斯"
L["Back and Forth"] = "往返"
L["Background"] = "背景"
L["Background Color"] = "背景顏色"
L["Bar"] = "進度條"
L["Bar Color"] = "進度條顏色"
L["Baron Geddon"] = "迦頓男爵"
L["Battle.net Whisper"] = "Battle.net 悄悄話"
L["Battleground"] = "戰場"
L["Battleguard Sartura"] = "沙爾圖拉"
L["BG>Raid>Party>Say"] = "戰場>團隊>隊伍>說"
L["BG-System Alliance"] = "聯盟戰場機制"
L["BG-System Horde"] = "部落戰場機制"
L["BG-System Neutral"] = "中立戰場機制"
L["BigWigs Addon"] = "BigWigs 插件"
L["BigWigs Message"] = "BigWigs 訊息"
L["BigWigs Timer"] = "BigWigs 計時條"
L["Black Wing Lair"] = "黑翼之巢"
L["Blizzard Combat Text"] = "暴雪浮動戰鬥文字"
L["Block"] = "格擋"
L["Block (%)"] = "格檔 (%)"
L["Block against Target (%)"] = "對目標的格檔 (%)"
L["Blocked"] = "被格擋"
L["Bloodlord Mandokir"] = "血領主曼多基爾"
L["Border"] = "邊框"
L["Border Color"] = "邊框顏色"
L["Boss"] = "首領"
L["Boss Emote"] = "首領表情動作"
L["Boss Whisper"] = "首領悄悄話"
L["Bottom"] = "下"
L["Bottom Left"] = "左下"
L["Bottom Right"] = "右下"
L["Bottom to Top"] = "下到上"
L["Bounce"] = "彈跳"
L["Bounce with Decay"] = "彈跳衰減"
L["Broodlord Lashlayer"] = "龍領主勒西雷爾"
L["Buff"] = "增益"
L["Buffed/Debuffed"] = "有增益/減益效果"
L["Buru the Gorger"] = "『暴食者』布魯"
L["Can be used for e.g. checking if \"boss1target\" is the same as \"player\"."] = "可用於，例如檢查 \"boss1target\" 和 \"player\" 是否相同。"
L["Cancel"] = "取消"
L["Can't schedule timer with %i, due to a World of Warcraft Bug with high computer uptime. (Uptime: %i). Please restart your Computer."] = "由於魔獸世界Bug具有很高的電腦運行時間，因此無法使用 ％i 排程計時器。 （運行時間：％i）。請重新啟動您的電腦。"
L["Cast"] = "施法"
L["Cast Bar"] = "施法條"
L["Cast Failed"] = "施法失敗"
L["Cast Start"] = "開始施法"
L["Cast Success"] = "施法成功"
L["Cast Type"] = "施法類型"
L["Caster"] = "施法者"
L["Caster Name"] = "施法者名字"
L["Caster Unit"] = "施法者單位"
L["Caster's Target "] = "施法者的目標"
L["Center"] = "中間"
L["Centered Horizontal"] = "中間水平"
L["Centered Vertical"] = "中間垂直"
L["Changed"] = "已變更"
L["Channel"] = "頻道"
L["Channel (Spell)"] = "引導 (法術)"
L["Character Stats"] = "角色屬性"
L["Character Type"] = "角色類型"
L["Charge gained/lost"] = "獲得/失去可用次數"
L["Charges"] = "可用次數"
L["Charges Changed (Spell)"] = "可用次數變更 (法術)"
L["Chat Frame"] = "聊天框架"
L["Chat Message"] = "聊天訊息"
L["Children:"] = "子項目:"
L["Choose a category"] = "選擇分類"
L["Chromaggus"] = "克洛瑪古斯"
L["Circle"] = "圓形"
L["Clamp"] = "內縮"
L["Class"] = "職業"
L["Class and Specialization"] = "職業和專精"
L["Classification"] = "分類"
L["Clockwise"] = "順時針"
L["Clone per Event"] = "複製每個事件"
L["Clone per Match"] = "複製每個符合"
L["Color"] = "顏色"
L["Combat Log"] = "戰鬥紀錄"
L["Conditions"] = "條件"
L["Contains"] = "包含"
L["Continuously update Movement Speed"] = "持續更新移動速度"
L["Cooldown"] = "冷卻"
L["Cooldown Progress (Equipment Slot)"] = "冷卻進度 (裝備欄位)"
L["Cooldown Progress (Item)"] = "冷卻進度 (物品)"
L["Cooldown Progress (Spell)"] = "冷卻進度 (法術)"
L["Cooldown Ready (Equipment Slot)"] = "冷卻完成 (裝備欄位)"
L["Cooldown Ready (Item)"] = "冷卻完成 (物品)"
L["Cooldown Ready (Spell)"] = "冷卻完成 (法術)"
L["Count"] = "數量"
L["Counter Clockwise"] = "逆時針"
L["Create"] = "建立"
L["Create a Copy"] = "建立複本"
L["Critical"] = "致命一擊"
L["Critical (%)"] = "致命一擊 (%)"
L["Critical Rating"] = "致命一擊分數"
L["Crowd Controlled"] = "群體控制"
L["Crushing"] = "碾壓"
L["C'thun"] = "克蘇恩"
L["Current Zone Group"] = "目前區域群組"
L[ [=[Current Zone
]=] ] = "目前區域"
L["Curse"] = "詛咒"
L["Custom"] = "自訂"
L["Custom Color"] = "自訂顏色"
L["Custom Configuration"] = "自訂設定選項"
L["Custom Function"] = "自訂功能"
L["Damage"] = "傷害"
L["Damage Shield"] = "傷害盾"
L["Damage Shield Missed"] = "傷害盾未命中"
L["Damage Split"] = "傷害分攤"
L["DBM Announce"] = "BigWigs 通知"
L["DBM Timer"] = "DBM 計時條"
L["Death Knight Rune"] = "死亡騎士符文"
L["Debuff"] = "減益"
L["Debuff Class"] = "減益類別"
L["Debuff Class Icon"] = "減益類別圖示"
L["Debuff Type"] = "減益類型"
L["Deflect"] = "偏斜"
L["Desaturate"] = "去色"
L["Desaturate Background"] = "背景去色"
L["Desaturate Foreground"] = "前景去色"
L["Descending"] = "降序"
L["Description"] = "說明"
L["Dest Raid Mark"] = "目標的標記圖示"
L["Destination In Group"] = "隊伍中的目標"
L["Destination Name"] = "目標名稱"
L["Destination NPC Id"] = "目標 NPC ID"
L["Destination Object Type"] = "目標物件類型"
L["Destination Reaction"] = "目標反應動作"
L["Destination Unit"] = "目標單位"
L["Disable Spell Known Check"] = "停用法術已知檢查"
L["Disease"] = "疾病"
L["Dispel"] = "驅散"
L["Dispel Failed"] = "驅散失敗"
L["Display"] = "顯示"
L["Distance"] = "距離"
L["Dodge"] = "閃躲"
L["Dodge (%)"] = "閃躲 (%)"
L["Dodge Rating"] = "閃躲分數"
L["Done"] = "完成"
L["Down"] = "下"
L["Down, then Left"] = "先下後左"
L["Down, then Right"] = "先下後右"
L["Drain"] = "抽取資源"
L["Dropdown Menu"] = "下拉選單"
L["Dungeons"] = "地城"
L["Durability Damage"] = "耐久度傷害"
L["Durability Damage All"] = "耐久性傷害所有"
L["Ease In"] = "淡入"
L["Ease In and Out"] = "淡入和淡出"
L["Ease Out"] = "淡出"
L["Ebonroc"] = "埃博諾克"
L["Edge"] = "邊緣"
L["Edge of Madness"] = "瘋狂之緣"
L["Elide"] = "符合寬度"
L["Elite"] = "精英"
L["Emote"] = "表情動作"
L["Emphasized"] = "強調"
L["Emphasized option checked in BigWigs's spell options"] = "已勾選 BigWigs 法術選項中的強調選項。"
L["Empty"] = "空"
L["Enchant Applied"] = "附魔已加上"
L["Enchant Found"] = "已附魔"
L["Enchant Missing"] = "缺少附魔"
L["Enchant Name or ID"] = "附魔名稱或 ID"
L["Enchant Removed"] = "附魔已移除"
L["Encounter ID(s)"] = "首領戰 ID"
L["Energize"] = "充能"
L["Enrage"] = "狂怒"
L["Enter static or relative values with %"] = "輸入靜態或相對的值加上 %"
L["Entering"] = "進入"
L["Entering/Leaving Combat"] = "進入/離開戰鬥"
L["Entry Order"] = "項目順序"
L["Environment Type"] = "環境類型"
L["Environmental"] = "環境"
L["Equipment Set"] = "裝備管理員設定"
L["Equipment Set Equipped"] = "已裝備裝備管理員設定"
L["Equipment Slot"] = "裝備欄位"
L["Equipped"] = "已裝備"
L["Error not receiving display information from %s"] = "錯誤：無法收到來自 %s 的顯示資訊"
L[ [=['ERROR: Anchoring %s': 
]=] ] = "'錯誤: 對齊 %s': "
L["Evade"] = "閃躲"
L["Event"] = "事件"
L["Event(s)"] = "事件"
L["Every Frame"] = "所有框架"
L["Extend Outside"] = "向外擴增"
L["Extra Amount"] = "額外數量"
L["Extra Attacks"] = "額外攻擊"
L["Extra Spell Name"] = "額外法術名稱"
L["Fade In"] = "淡入"
L["Fade Out"] = "淡出"
L["Fail Alert"] = "失敗警示"
L["False"] = "否 (False)"
L["Fankriss the Unyielding"] = "不屈的范克里斯"
L["Filter messages with format <message>"] = "使用 <訊息內容> 的格式來過濾訊息"
L["Fire Resistance"] = "火焰抗性"
L["Firemaw"] = "費爾默"
L["First"] = "第一個"
L["First Value of Tooltip Text"] = "滑鼠提示文字中的第一個值"
L["Fishing Lure / Weapon Enchant (Old)"] = "魚餌 / 武器附魔 (舊版本)"
L["Fixed"] = "固定"
L["Fixed Names"] = "固定名稱"
L["Fixed Size"] = "固定大小"
L["Flamegor"] = "弗萊格爾"
L["Flash"] = "動畫"
L["Flex Raid"] = "彈性團隊"
L["Flip"] = "翻轉"
L["Focus"] = "專注目標"
L["Font Size"] = "文字大小"
L["Foreground"] = "前景"
L["Foreground Color"] = "前景顏色"
L["Form"] = "形態"
L["Frame Selector"] = "框架選擇器"
L["Frequency"] = "頻率"
L["Friendly"] = "友善"
L["Friendly Fire"] = "友方開火"
L["From"] = "從"
L["Frost Resistance"] = "冰霜抗性"
L["Full"] = "滿"
L["Full Scan"] = "完整掃描"
L["Full/Empty"] = "滿/空"
L["Gahz'ranka"] = "加茲蘭卡"
L["Gained"] = "獲得"
L["Garr"] = "加爾"
L["Gehennas"] = "基赫納斯"
L["General Rajaxx"] = "拉賈克斯將軍"
L["Glancing"] = "偏斜"
L["Global Cooldown"] = "共用冷卻 (GCD)"
L["Glow"] = "發光"
L["Glow External Element"] = "發光外部元素"
L["Gluth"] = "古魯斯"
L["Golemagg the Incinerator"] = "『焚化者』古雷曼格"
L["Gothik the Harvester"] = "『收割者』高希"
L["Gradient"] = "漸層"
L["Gradient Pulse"] = "漸層跳動"
L["Grand Widow Faerlina"] = "大寡婦費琳娜"
L["Grid"] = "網格"
L["Grobbulus"] = "葛羅巴斯"
L["Group"] = "群組"
L["Group %s"] = "群組 %s"
L["Group Arrangement"] = "群組排列"
L["Grow"] = "延伸"
L["GTFO Alert"] = "GTFO 警示"
L["Guardian"] = "守護者"
L["Guild"] = "公會"
L["Hakkar"] = "哈卡"
L["Has Target"] = "有目標"
L["Has Vehicle UI"] = "有載具介面"
L["HasPet"] = "有寵物 (活著)"
L["Haste (%)"] = "加速 (%)"
L["Haste Rating"] = "加速分數"
L["Heal"] = "治療"
L["Health"] = "血量"
L["Health (%)"] = "血量 (%)"
L["Heigan the Unclean"] = "『骯髒者』海根"
L["Height"] = "高度"
L["Hide"] = "隱藏"
L["High Damage"] = "高傷害"
L["High Priest Thekal"] = "高階祭司塞卡爾"
L["High Priest Venoxis"] = "高階祭司溫諾希斯"
L["High Priestess Arlokk"] = "哈卡萊先知"
L["High Priestess Jeklik"] = "高階祭司耶克里克"
L["High Priestess Mar'li"] = "哈卡萊安魂者"
L["Higher Than Tank"] = "高於坦克"
L["Holy Resistance"] = "神聖抗性"
L["Horde"] = "部落"
L["Hostile"] = "敵對"
L["Hostility"] = "敵對"
L["Humanoid"] = "人形態"
L["Hybrid"] = "混合"
L["Icon"] = "圖示"
L["Icon Color"] = "圖示顏色"
L["Icon Desaturate"] = "圖示去色"
L["If you require additional assistance, please open a ticket on GitHub or visit our Discord at https://discord.gg/wa2!"] = "如果你需要額外的協助，請在 GitHub 開新的 ticket，或是拜訪我們的 Discord，https://discord.gg/wa2!"
L["Ignore Dead"] = "忽略死者"
L["Ignore Disconnected"] = "忽略離線者"
L["Ignore Rune CD"] = "忽略符文冷卻"
L["Ignore Rune CDs"] = "忽略符文冷卻"
L["Ignore Self"] = "忽略自己"
L["Ignore Unknown Spell"] = "忽略未知法術"
L["Immune"] = "免疫"
L["Import"] = "匯入"
L["Import as Copy"] = "匯入並多複製一份"
L["Import as Update"] = "匯入並更新原有的"
L["Import Group"] = "匯入群組"
L["Import in progress"] = "正在匯入"
L["Important"] = "重要"
L["Importing is disabled while in combat"] = "戰鬥中已停用匯入"
L["In Combat"] = "戰鬥中"
L["In Encounter"] = "在首領戰"
L["In Group"] = "在隊伍中"
L["In Pet Battle"] = "在寵物對戰"
L["In Raid"] = "在團隊中"
L["In Vehicle"] = "在載具"
L["Include Bank"] = "包含銀行"
L["Include Charges"] = "包含可用次數"
L["Incoming Heal"] = "即將獲得的治療"
L["Inherited"] = "繼承"
L["Inside"] = "裡面"
L["Instakill"] = "秒殺"
L["Instance"] = "副本"
L["Instance Difficulty"] = "副本難度"
L["Instance Type"] = "副本類型"
L["Instructor Razuvious"] = "講師拉祖維斯"
L["Insufficient Resources"] = "資源不足"
L["Intellect"] = "智力"
L["Interrupt"] = "中斷"
L["Interruptible"] = "可中斷"
L["Inverse"] = "反向"
L["Inverse Pet Behavior"] = "反向寵物行為"
L["Is Exactly"] = "完全符合"
L["Is Moving"] = "正在移動"
L["Is Off Hand"] = "副手"
L["is useable"] = "可使用"
L["It might not work correctly on Classic!"] = "在經典版可能無法正常運作!"
L["It might not work correctly on Retail!"] = "在正式版可能無法正常運作!"
L["It might not work correctly with your version!"] = "在你所使用的版本可能無法正常運作!"
L["Item"] = "物品"
L["Item Count"] = "物品數量"
L["Item Equipped"] = "已裝備物品"
L["Item in Range"] = "在物品範圍內"
L["Item Set Equipped"] = "已裝備物品套裝"
L["Item Set Id"] = "物品套裝 ID"
L["Jin'do the Hexxer"] = "『妖術師』金度"
L["Keep Inside"] = "保持在內"
L["Kel'Thuzad"] = "克爾蘇加德"
L["Kurinnaxx"] = "庫林納克斯"
L["Large"] = "大"
L["Least remaining time"] = "最小剩餘時間"
L["Leaving"] = "離開"
L["Leech"] = "吸取"
L["Leech (%)"] = "汲取 (%)"
L["Leech Rating"] = "汲取分數"
L["Left"] = "左"
L["Left to Right"] = "左到右"
L["Left, then Down"] = "先左後下"
L["Left, then Up"] = "先左後上"
L["Legacy Aura"] = "傳統光環"
L["Legacy RGB Gradient"] = "傳統 RGB 漸層"
L["Legacy RGB Gradient Pulse"] = "傳統 RGB 漸層脈衝"
L["Length"] = "長度"
L["Level"] = "等級"
L["Limited"] = "有限"
L["Lines & Particles"] = "直線 & 粒子"
L["Load Conditions"] = "載入條件"
L["Loatheb"] = "憎惡體"
L["Loop"] = "重複循環"
L["Lost"] = "失去"
L["Low Damage"] = "低傷害"
L["Lower Than Tank"] = "低於坦克"
L["Lucifron"] = "魯西弗隆"
L["Maexxna"] = "梅克絲娜"
L["Magic"] = "魔法"
L["Magmadar"] = "瑪格曼達"
L["Main Stat"] = "主屬性"
L["Majordomo Executus"] = "管理者埃克索圖斯"
L["Make sure you can trust the person who sent it!"] = "請確定你能信任傳送這段設定字串給你的人!"
L["Malformed WeakAuras link"] = "格式錯誤的 WeakAuras 連結"
L["Manual Repair Confirmation Dialog"] = "手動修復確認對話框"
L["Manual Rotation"] = "手動旋轉"
L["Marked First"] = "標記為第一個"
L["Marked Last"] = "標記為最後一個"
L["Master"] = "主聲道"
L["Mastery (%)"] = "精通 (%)"
L["Mastery Rating"] = "精通分數"
L["Match Count"] = "符合的數量"
L["Match Count per Unit"] = "每個單位符合的數量"
L["Matches (Pattern)"] = "符合模式 (Pattern)"
L["Max Charges"] = "最大可用次數"
L["Maximum"] = "最大值"
L["Maximum Estimate"] = "最大估計"
L["Medium"] = "中"
L["Message"] = "訊息"
L["Message Type"] = "訊息類型"
L["Message type:"] = "訊息類型:"
L["Meta Data"] = "Meta Data"
L["Minimum"] = "最小值"
L["Minimum Estimate"] = "最小估計"
L["Minus (Small Nameplate)"] = "減去 (小型血條/名條)"
L["Mirror"] = "鏡像"
L["Miss"] = "未命中"
L["Miss Type"] = "未命中類型"
L["Missed"] = "未命中"
L["Missing"] = "缺少"
L["Moam"] = "莫阿姆"
L["Model"] = "模組"
L["Molten Core"] = "熔火之心"
L["Monochrome"] = "無消除鋸齒"
L["Monochrome Outline"] = "無消除鋸齒外框"
L["Monochrome Thick Outline"] = "無消除鋸齒粗外框"
L["Monster Emote"] = "怪物表情動作"
L["Monster Party"] = "怪物隊伍說話"
L["Monster Say"] = "怪物一般說話"
L["Monster Whisper"] = "怪物悄悄話"
L["Monster Yell"] = "怪物大喊"
L["Most remaining time"] = "最大剩餘時間"
L["Mounted"] = "在坐騎"
L["Mouse Cursor"] = "滑鼠游標"
L["Movement Speed (%)"] = "移動速度 (%)"
L["Movement Speed Rating"] = "移動速度分數"
L["Multi-target"] = "多目標"
L["Mythic+ Affix"] = "傳奇+ 詞綴"
L["Name"] = "名稱"
L["Name of Caster's Target"] = "施法者目標的名字"
L["Nameplate"] = "血條/名條"
L["Nameplate Type"] = "血條/名條類型"
L["Nameplates"] = "血條/名條"
L["Names of affected Players"] = "受影響玩家的名字"
L["Names of unaffected Players"] = "未受影響玩家的名字"
L["Nature Resistance"] = "自然抗性"
L["Naxxramas"] = "納克薩瑪斯"
L["Nefarian"] = "奈法利安"
L["Neutral"] = "中立"
L["Never"] = "永不"
L["Next"] = "下一個"
L["Next Combat"] = "下一場戰鬥"
L["Next Encounter"] = "下一場首領戰"
L["No Children"] = "沒有子項目"
L["No Instance"] = "無副本"
L["No Profiling information saved."] = "沒有已儲存的分析資訊。"
L["None"] = "無"
L["Non-player Character"] = "非玩家角色 (NPC)"
L["Normal"] = "普通"
L["Not in Group"] = "不在隊伍中"
L["Not on Cooldown"] = "不在冷卻中"
L["Not On Threat Table"] = "不在仇恨列表"
L["Note, that cross realm transmission is possible if you are on the same group"] = "注意，相同隊伍中支援跨伺服器傳送"
L["Note: 'Hide Alone' is not available in the new aura tracking system. A load option can be used instead."] = "注意: 新的光環追蹤系統無法 '單獨隱藏'，可以改用載入選項。"
L["Note: The available text replacements for multi triggers match the normal triggers now."] = "注意: 多個觸發的可用文字替換現在和一般觸發相同。"
L["Note: This trigger type estimates the range to the hitbox of a unit. The actual range of friendly players is usually 3 yards more than the estimate. Range checking capabilities depend on your current class and known abilities as well as the type of unit being checked. Some of the ranges may also not work with certain NPCs.|n|n|cFFAAFFAAFriendly Units:|r %s|n|cFFFFAAAAHarmful Units:|r %s|n|cFFAAAAFFMiscellanous Units:|r %s"] = "注意：此觸發器類型預估到單位的命中框的範圍。友方玩家的實際射程通常比估計高3碼。範圍檢查功能取決於您當前的職業和已知功能以及所檢查單位的類型。某些範圍可能也不適用於某些NPC。|n|n|cFFAAFFAA友方單位：|r%s|n|n|cFFAAFFAA敵方單位：|r%s|n|cFFAAAAFF其他單位：|r%s"
L["Noth the Plaguebringer"] = "『瘟疫使者』諾斯"
L["NPC"] = "NPC"
L["Npc ID"] = "NPC ID"
L["Number"] = "數字"
L["Number Affected"] = "被影響的數量"
L["Object"] = "物件"
L["Officer"] = "幹部"
--[[Translation missing --]]
L["Offset from progress"] = "Offset from progress"
L["Offset Timer"] = "偏差計時"
L["Older set IDs can be found on websites such as wowhead.com/item-sets"] = "較舊的套裝 ID 可以在網站中查詢，例如 wowhead.com/item-sets"
L["On Cooldown"] = "冷卻中"
L["On Taxi"] = "乘坐船/鳥點時"
L["Only if BigWigs shows it on it's bar"] = "只有在 BigWigs 的計時條上有顯示時"
L["Only if DBM shows it on it's bar"] = "只有在 DBM 的計時條上有顯示時"
L["Only if Primary"] = "只有為主要時"
L["Onyxia"] = "奧妮克希亞"
L["Onyxia's Lair"] = "奧妮克希亞的巢穴"
L["Opaque"] = "不透明"
L["Option Group"] = "選項群組"
L["Options will finish loading after combat ends."] = "設定選項會在戰鬥結束後載入完成。"
L["Options will open after the login process has completed."] = "登入完成後會開啟設定選項。"
L["Orbit"] = "軌道"
L["Orientation"] = "方向"
L["Ossirian the Unscarred"] = "『無疤者』奧斯里安"
L["Ouro"] = "奧羅"
L["Outline"] = "外框"
L["Outside"] = "外面"
L["Overhealing"] = "過量治療"
L["Overkill"] = "過量擊殺"
L["Overlay %s"] = "疊加 %s"
L["Overlay Cost of Casts"] = "疊加施法消耗量"
L["Parry"] = "招架"
L["Parry (%)"] = "架招 (%)"
L["Parry Rating"] = "架招分數"
L["Party"] = "隊伍"
L["Party Kill"] = "隊伍擊殺"
L["Patchwerk"] = "縫補者"
L["Paused"] = "已暫停"
L["Periodic Spell"] = "週期法術"
L["Personal Resource Display"] = "個人資源條"
L["Pet"] = "寵物"
L["Pet Behavior"] = "寵物動作"
L["Pet Specialization"] = "寵物專精"
L["Pet Spell"] = "寵物技能"
L["Phase"] = "階段"
L["Pixel Glow"] = "像素發光"
--[[Translation missing --]]
L["Placement"] = "Placement"
--[[Translation missing --]]
L["Placement Mode"] = "Placement Mode"
L["Play"] = "播放"
L["Player"] = "玩家"
L["Player Character"] = "玩家角色"
L["Player Class"] = "玩家職業"
L["Player Effective Level"] = "玩家真實等級"
L["Player Faction"] = "玩家陣營"
L["Player Level"] = "玩家等級"
L["Player Name"] = "玩家名稱"
L["Player Race"] = "玩家種族"
L["Player(s) Affected"] = "玩家受影響"
L["Player(s) Not Affected"] = "玩家未被影響"
L["Please upgrade your Masque version"] = "請更新按鈕外觀插件 Masque 的版本"
L["Poison"] = "中毒"
L["Power"] = "能量"
L["Power (%)"] = "能量 (%)"
L["Power Type"] = "能量類型"
L["Preset"] = "預設"
L["Press Ctrl+C to copy"] = "按 Ctrl+C 複製"
L["Princess Huhuran"] = "哈霍蘭公主"
L["Print Profiling Results"] = "顯示分析結果"
L["Profiling already started."] = "分析早已開始了。"
L["Profiling automatically started."] = "分析已自動開始。"
L["Profiling not running."] = "分析沒有執行。"
L["Profiling started."] = "分析已開始。"
L["Profiling started. It will end automatically in %d seconds"] = "分析已開始，將會在 %d 秒後自動結束。"
L["Profiling still running, stop before trying to print."] = "分析仍在執行中，輸出資料前請先停止分析。"
L["Profiling stopped."] = "分析已停止。"
L["Progress Total"] = "總進度"
L["Progress Value"] = "進度值"
L["Pulse"] = "跳動"
L["PvP Flagged"] = "PvP 標幟"
L["PvP Talent %i"] = "PvP 天賦 %i"
L["PvP Talent selected"] = "選擇的 PvP 天賦"
L["Queued Action"] = "佇列動作"
L["Radius"] = "範圍"
L["Ragnaros"] = "拉格納羅斯"
L["Raid"] = "團隊"
L["Raid Warning"] = "團隊警告"
L["Raids"] = "團隊"
L["Range"] = "距離範圍"
L["Range Check"] = "距離範圍檢查"
L["Rare"] = "稀有"
L["Rare Elite"] = "稀有精英"
L["Razorgore the Untamed"] = "狂野的拉佐格爾"
L["Ready Check"] = "團隊確認"
L["Realm"] = "伺服器"
L["Receiving display information"] = "正在接收提醒效果資訊"
L["Reflect"] = "反射"
L["Region type %s not supported"] = "不支援的地區類型 %s"
L["Relative"] = "相對"
L["Relative X-Offset"] = "水平相對位置"
L["Relative Y-Offset"] = "垂直相對位置"
L["Remaining Duration"] = "剩餘持續時間"
L["Remaining Time"] = "剩餘時間"
L["Remove Obsolete Auras"] = "移除過時的提醒效果"
L["Repair"] = "修復"
L["Repeat"] = "重複"
L["Report Summary"] = "報告總結"
L["Requested display does not exist"] = "需求的提醒效果不存在"
L["Requested display not authorized"] = "需求的提醒效果沒有授權"
L["Requesting display information from %s ..."] = "正在請求來自於 %s 的顯示資訊..."
L["Require Valid Target"] = "需要有效目標"
L["Resist"] = "抵抗"
L["Resisted"] = "被抵抗"
L["Resolve collisions dialog"] = [=[你已經啟用插件定義|cFF8800FFWeakAuras|r顯示與你已存在的顯示有相同名稱。

你必須重新命名你的顯示讓插件顯示騰出空間。

已解決: |cFFFF0000]=]
L["Resolve collisions dialog singular"] = [=[你已經啟用插件定義|cFF8800FFWeakAuras|r顯示與你已存在的顯示有相同名稱。

你必須重新命名你的顯示讓插件顯示騰出空間。

已解決: |cFFFF0000]=]
L["Resolve collisions dialog startup"] = "開始處理衝突的對話框"
L["Resolve collisions dialog startup singular"] = "開始處理單一衝突的對話框"
L["Resting"] = "在休息"
L["Resurrect"] = "復活"
L["Right"] = "右"
L["Right to Left"] = "右到左"
L["Right, then Down"] = "先右後下"
L["Right, then Up"] = "先右後上"
L["Role"] = "角色"
L["Rotate Left"] = "向左旋轉"
L["Rotate Right"] = "向右旋轉"
L["Ruins of Ahn'Qiraj"] = "安其拉廢墟"
L["Run Custom Code"] = "執行自訂程式碼"
L["Rune"] = "符文"
L["Rune #1"] = "符文 #1"
L["Rune #2"] = "符文 #2"
L["Rune #3"] = "符文 #3"
L["Rune #4"] = "符文 #4"
L["Rune #5"] = "符文 #5"
L["Rune #6"] = "符文 #6"
L["Runes Count"] = "符文數量"
L["Sapphiron"] = "薩菲隆"
L["Say"] = "說"
L["Scale"] = "縮放大小"
L["Scenario"] = "事件"
L["Screen/Parent Group"] = "螢幕/所屬群組"
L["Second"] = "第二個"
L["Second Value of Tooltip Text"] = "滑鼠提示文字中的第二個值"
L["Seconds"] = "秒數"
L["Select Frame"] = "選擇的框架"
L["Separator"] = "分隔線"
L["Set IDs can be found on websites such as classic.wowhead.com/item-sets"] = "可以在網站上找到套裝 ID，像是 classic.wowhead.com/item-sets"
L["Set Maximum Progress"] = "設定最大進度"
L["Set Minimum Progress"] = "設定最小進度"
L["Shadow Resistance"] = "暗影抗性"
L["Shake"] = "震動"
L["Shazzrah"] = "沙斯拉爾"
L["Shift-Click to resume addon execution."] = "Shift-左鍵 恢復執行插件。"
L["Show"] = "顯示"
L["Show Absorb"] = "顯示吸收量"
L["Show Border"] = "顯示邊框"
L["Show CD of Charge"] = "顯示可用次數冷卻時間"
L["Show Code"] = "顯示程式碼"
L["Show GCD"] = "顯示共用冷卻 (GCD)"
L["Show Global Cooldown"] = "顯示共用冷卻 (GCD)"
L["Show Glow"] = "顯示發光"
L["Show Incoming Heal"] = "顯示即將獲得的治療"
L["Show On"] = "顯示於"
L["Shrink"] = "收縮"
L["Silithid Royalty"] = "異種蠍皇族"
L["Simple"] = "簡單"
L["Size & Position"] = "大小 & 位置"
L["Slide from Bottom"] = "從下面滑動"
L["Slide from Left"] = "從左邊滑動"
L["Slide from Right"] = "從右邊滑動"
L["Slide from Top"] = "從上面滑動"
L["Slide to Bottom"] = "滑動到下面"
L["Slide to Left"] = "滑動到左邊"
L["Slide to Right"] = "滑動到右邊"
L["Slide to Top"] = "滑動到上面"
L["Slider"] = "滑桿"
L["Small"] = "小"
L["Smart Group"] = "智慧型群組"
L["Sound"] = "音效"
L["Sound by Kit ID"] = "音效 Sound Kit ID"
L["Source In Group"] = "隊伍中的來源"
L["Source Name"] = "來源的名稱"
L["Source NPC Id"] = "來源 NPC ID"
L["Source Object Type"] = "來源物件類型"
L["Source Raid Mark"] = "來源的標記圖示"
L["Source Reaction"] = "來源反應動作"
L["Source Unit"] = "來源的單位"
L["Source: "] = "來源: "
L["Space"] = "間距"
L["Spacing"] = "間距"
L["Spark Color"] = "亮點顏色"
L["Spark Height"] = "亮點高度"
L["Spark Width"] = "亮點寬度"
L["Spec Role"] = "專精角色"
L["Specific Unit"] = "指定單位"
L["Spell"] = "法術"
L["Spell (Building)"] = "法術 (建築物)"
L["Spell Activation Overlay Glow"] = "法術可用時發光"
L["Spell Cost"] = "法術消耗"
L["Spell Count"] = "法術數量"
L["Spell ID"] = "法術 ID"
L["Spell Id"] = "法術 ID"
L["Spell ID:"] = "法術 ID:"
L["Spell IDs:"] = "法術 ID:"
L["Spell in Range"] = "在法術範圍內"
L["Spell Known"] = "已知法術"
L["Spell Name"] = "法術名稱"
L["Spell Usable"] = "法術可以使用"
L["Spin"] = "旋轉"
L["Spiral"] = "螺旋"
L["Spiral In And Out"] = "轉進和轉出"
L["Stack Count"] = "堆疊層數"
L["Stacks"] = "堆疊層數"
L["Stagger Scale"] = "醉仙緩勁縮放大小"
L["Stamina"] = "耐力"
L["Stance/Form/Aura"] = "姿態/形態/光環"
L["Star Shake"] = "搖光"
L["Start"] = "開始"
L["Start Now"] = "現在開始"
L["Status"] = "狀態"
L["Stolen"] = "被偷竊"
L["Stop"] = "停止"
L["Strength"] = "力量"
L["String"] = "文字字串"
L["Sulfuron Harbinger"] = "薩弗隆先驅者"
L["Summon"] = "召喚"
L["Supports multiple entries, separated by commas"] = "支援輸入多個項目，使用逗號分隔。"
L[ [=[Supports multiple entries, separated by commas
]=] ] = "支援輸入多個項目，使用逗號分隔。"
L["Swing"] = "揮動"
L["Swing Timer"] = "揮動時間"
L["Swipe"] = "轉圈動畫"
L["System"] = "系統"
L["Tab "] = "標籤頁面"
L["Talent Selected"] = "選擇的天賦"
L["Talent selected"] = "選擇的天賦"
L["Talent Specialization"] = "天賦專精"
L["Tanking And Highest"] = "坦怪中並且是最高"
L["Tanking But Not Highest"] = "坦怪中但不是最高"
L["Target"] = "目標"
L["Targeted"] = "當前目標"
L["Text"] = "文字"
L["Thaddius"] = "泰迪斯"
L["The effective level differs from the level in e.g. Time Walking dungeons."] = "真實等級和等級 (例如: 時光漫遊的) 不同。"
L["The Four Horsemen"] = "四騎士"
L["The Prophet Skeram"] = "預言者斯克拉姆"
L["The trigger number is optional, and uses the trigger providing dynamic information if not specified."] = "觸發編號是選用性的。沒有指定編號時，會使用提供動態資訊的那個觸發。"
L["There are %i updates to your auras ready to be installed!"] = "有 %i 個提醒效果的更新可供安裝!"
L["Thick Outline"] = "粗外框"
L["Thickness"] = "粗細"
L["Third"] = "第三個"
L["Third Value of Tooltip Text"] = "滑鼠提示文字中的第三個值"
L["This aura contains custom Lua code."] = "這個提醒效果包含自訂的 Lua 程式碼。"
L["This aura was created with a newer version of WeakAuras."] = "這個光環提醒效果是由較新版本的 WeakAuras 所建立。"
L["This aura was created with the Classic version of World of Warcraft."] = "這個提醒效果是用魔獸世界經典版建立的。"
L["This aura was created with the retail version of World of Warcraft."] = "這個提醒效果是用魔獸世界正式版本建立的。"
L["This is a modified version of your aura, |cff9900FF%s.|r"] = "這是你的提醒效果的修改版本，|cff9900FF%s。|r"
L["This is a modified version of your group, |cff9900FF%s.|r"] = "這是你的群組的修改版本，|cff9900FF%s。|r"
L["Threat Situation"] = "仇恨狀況"
--[[Translation missing --]]
L["Tick"] = "Tick"
L["Tier "] = "天賦層級"
L["Timed"] = "時間"
L["Timer Id"] = "計時條 ID"
L["Toggle"] = "勾選方塊"
L["Toggle List"] = "勾選方塊清單"
L["Toggle Options Window"] = "切換顯示設定選項視窗"
L["Toggle Performance Profiling Window"] = "切換顯示效能分析視窗"
L["Tooltip"] = "滑鼠提示"
L["Tooltip Value 1"] = "滑鼠提示值 1"
L["Tooltip Value 2"] = "滑鼠提示值 2"
L["Tooltip Value 3"] = "滑鼠提示值 3"
L["Top"] = "上"
L["Top Left"] = "上左"
L["Top Right"] = "上右"
L["Top to Bottom"] = "上到下"
L["Total Duration"] = "總共持續時間"
L["Total Match Count"] = "符合的數量總計"
L["Total Stacks"] = "總共堆疊層數"
L["Total stacks over all matches"] = "所有符合中的堆疊層數總計"
L["Total Unit Count"] = "單位數量總計"
L["Total Units"] = "單位數量總計"
L["Totem"] = "圖騰"
L["Totem #%i"] = "圖騰 #%i"
L["Totem Name"] = "圖騰名稱"
L["Totem Name Pattern Match"] = "圖騰名稱模式符合"
L["Totem Number"] = "圖騰編號"
L["Track Cooldowns"] = "監控冷卻"
L["Tracking Charge %i"] = "監控次數 %i"
L["Tracking Charge CDs"] = "監控次數冷卻"
L["Tracking Only Cooldown"] = "只監控冷卻"
L["Transmission error"] = "傳輸錯誤"
L["Trigger"] = "觸發"
L["Trigger 1"] = "觸發 1"
L["Trigger State Updater (Advanced)"] = "觸發狀態更新器 (進階)"
L["Trigger Update"] = "觸發更新"
L["Trigger:"] = "觸發:"
L["Trivial (Low Level)"] = "不重要的 (低等級)"
L["True"] = "是 (True)"
L["Twin Emperors"] = "雙子皇帝"
L["Type"] = "類型"
L["Unaffected"] = "未受影響"
L["Undefined"] = "未定義"
L["Unit"] = "單位"
L["Unit Characteristics"] = "單位特徵"
L["Unit Destroyed"] = "單位破壞"
L["Unit Died"] = "單位死亡"
L["Unit Dissipates"] = "單位消散"
L["Unit Frame"] = "單位框架"
L["Unit Frames"] = "單位框架"
L["Unit is Unit"] = "單位相同"
L["Unit Name"] = "單位名字"
L["Units Affected"] = "受影響的單位"
L["Unlimited"] = "無限"
L["Up"] = "上"
L["Up, then Left"] = "先上後左"
L["Up, then Right"] = "先上後右"
L["Update Auras"] = "更新提醒效果"
L["Usage:"] = "用法:"
L["Use /wa minimap to show the minimap icon again"] = "輸入 /wa minimap 再次顯示小地圖按鈕"
L["Use Custom Color"] = "使用自訂顏色"
L["Vaelastrasz the Corrupt"] = "墮落的瓦拉斯塔茲"
L["Values/Remaining Time above this value are displayed as full progress."] = "大於這個值的數值/剩餘時間會顯示為進度已完成。"
L["Values/Remaining Time below this value are displayed as no progress."] = "小於這個值的數值/剩餘時間會顯示為完全沒有進度。"
L["Versatility (%)"] = "臨機應變 (%)"
L["Versatility Rating"] = "臨機應變分數"
L["Version: "] = "版本: "
L["Viscidus"] = "維希度斯"
L["Visibility"] = "顯示"
L["War Mode Active"] = "開啟戰爭模式"
L["Warning: Full Scan auras checking for both name and spell id can't be converted."] = "警告: 完整掃描光環會同時檢查名稱和法術 ID，無法轉換。"
L["Warning: Name info is now available via %affected, %unaffected. Number of affected group members via %unitCount. Some options behave differently now. This is not automatically adjusted."] = "警告: 現在改為使用 %affected, %unaffected 來取得名字資訊，使用 %unitCount 取得受影響的隊友數量。一些選項的行為已經和以往不同了，並且不會自動調整。"
L["Warning: Tooltip values are now available via %tooltip1, %tooltip2, %tooltip3 instead of %s. This is not automatically adjusted."] = "警告: 現在改為使用 %tooltip1, %tooltip2, %tooltip3 來取得滑鼠提示中的值，而不是 %s。並且不會自動調整。"
L["WeakAuras has encountered an error during the login process. Please report this issue at https://github.com/WeakAuras/Weakauras2/issues/new."] = "WeakAuras 在登入的過程中遇到錯誤。請將這個問題回報到 https://github.com/WeakAuras/Weakauras2/issues/new"
L["WeakAuras Profiling"] = "WeakAuras 效能分析"
L["WeakAuras Profiling Report"] = "WeakAuras 分析報告"
L["Weapon"] = "武器"
L["Weapon Enchant"] = "武器附魔"
L["What do you want to do?"] = "你想做什麼?"
L["Whisper"] = "悄悄話"
L["Whole Area"] = "整個區域"
L["Width"] = "寬度"
L["Wobble"] = "搖晃"
L["World Boss"] = "世界王"
L["Wrap"] = "自動換行"
L["X-Offset"] = "水平位置"
L["Yell"] = "大喊"
L["Y-Offset"] = "垂直位置"
L["You already have this group/aura. Importing will create a duplicate."] = "你已經有這個群組/提醒效果，匯入將會建立一份重覆的複本。"
L["Your next encounter will automatically be profiled."] = "將會自動開始分析你的下一場首領戰。"
L["Your next instance of combat will automatically be profiled."] = "將會自動開始分析你的下一場戰鬥。"
L["Your scheduled automatic profile has been cancelled."] = "已取消排程的自動分析。"
L["Zone Group ID(s)"] = "區域群組 ID"
L["Zone ID(s)"] = "區域 ID"
L["Zone Name"] = "區域名稱"
L["Zoom"] = "縮放"
L["Zul'Gurub"] = "祖爾格拉布"

