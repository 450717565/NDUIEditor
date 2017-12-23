local L = LibStub("AceLocale-3.0"):NewLocale("WorldQuestGroupFinder", "zhTW") 
if not L then return end 
L = L or {}
L["WQGF_ADDON_DESCRIPTION"] = "透過隊伍搜尋器輕鬆找到解世界任務的隊伍。"
L["WQGF_ALREADY_IS_GROUP_FOR_WQ"] = "你已經在進行這個世界任務的隊伍了。"
L["WQGF_ALREADY_QUEUED_BG"] = "你正在戰場的佇列中，請離開佇列並重新試一次。"
L["WQGF_ALREADY_QUEUED_DF"] = "你正在隨機地城（地城搜尋器）的佇列中，請離開佇列並重試一次。"
L["WQGF_ALREADY_QUEUED_RF"] = "你正在隨機團隊（團隊搜尋器）的佇列中，請離開佇列並重新試一次。"
L["WQGF_APPLIED_TO_GROUPS"] = "你已經申請了世界任務 |c00bfffff%s|c00ffffff 的 |c00bfffff%d|c00ffffff 個隊伍。"
L["WQGF_APPLIED_TO_GROUPS_QUEST"] = "你巳經為任務 |c00bfffff%s|c00ffffff 申請了 |c00bfffff%d|c00ffffff 個隊伍。"
L["WQGF_AUTO_LEAVING_DIALOG"] = [=[你已經完成這個世界任務並會在 %d 秒後離開隊伍。

說聲再見吧！]=]
L["WQGF_AUTO_LEAVING_DIALOG_QUEST"] = [=[你已經完成了任務，將在 %d 秒後離隊

說聲再見吧!]=]
L["WQGF_CANCEL"] = "取消"
L["WQGF_CANNOT_DO_WQ_IN_GROUP"] = "這個世界任務無法在隊伍中完成。"
L["WQGF_CANNOT_DO_WQ_TYPE_IN_GROUP"] = "這項世界任務類型無法在隊伍中完成。"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_ENABLE"] = "在戰鬥外時，自動接受WQGF的隊伍邀請"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_HOVER"] = "將會自動於戰鬥外時接受隊伍邀請"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_TITLE"] = "自動接受隊伍邀請"
L["WQGF_CONFIG_AUTOINVITE"] = "自動邀請"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE"] = "自動邀請任何人"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE_HOVER"] = "所有申請者會自動邀請進隊伍，直到5人上限。"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS"] = "自動邀請WQGF使用者"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS_HOVER"] = "World Quest Group Finder的使用者會自動被邀請到隊伍中"
L["WQGF_CONFIG_BINDING_ADVICE"] = "提示：你可以在遊戲的按鍵設定中為WQGF按扭綁定一個按鍵。"
L["WQGF_CONFIG_LANGUAGE_FILTER_ENABLE"] = "搜尋任何語言的隊伍（忽略隊伍搜尋器的語言選項）"
L["WQGF_CONFIG_LANGUAGE_FILTER_HOVER"] = "將會搜尋所有可加入的隊伍，不管它們的語言"
L["WQGF_CONFIG_LANGUAGE_FILTER_TITLE"] = "隊伍搜尋語言過濾"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE"] = "WQGF登入訊息"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_ENABLE"] = "隱藏登入遊戲時的WQGF初始訊息"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_HOVER"] = "不會再於登入時顯示WQGF的訊息"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_ENABLE"] = "如果不在隊伍時自動開始搜尋"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_HOVER"] = "進入新的世界任務地區時會自動搜尋隊伍"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_ENABLE"] = "開啟新的世界任務地區偵測模式"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_HOVER"] = "當進入新的世界任務地區時，你會被詢問是否要尋找隊伍"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_SWITCH_ENABLE"] = "如果已在其他世界任務隊伍中則不提示"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_TITLE"] = "在第一次進入世界任務地區時提示搜尋隊伍"
L["WQGF_CONFIG_PAGE_CREDITS"] = "由 Robou, EU-Hyjal 開發"
L["WQGF_CONFIG_PARTY_NOTIFICATION_ENABLE"] = "啟用隊伍通知"
L["WQGF_CONFIG_PARTY_NOTIFICATION_HOVER"] = "世界任務完成會發送訊息到隊伍中"
L["WQGF_CONFIG_PARTY_NOTIFICATION_TITLE"] = "世界任務完成時會通知隊伍"
L["WQGF_CONFIG_PVP_REALMS_ENABLE"] = "避免加入PvP伺服器的隊伍"
L["WQGF_CONFIG_PVP_REALMS_HOVER"] = "將避免加入PvP伺服器的隊伍（如為PvP伺服器的角色，這個選項將會忽略）"
L["WQGF_CONFIG_PVP_REALMS_TITLE"] = "PvP伺服器"
L["WQGF_CONFIG_QUEST_SUPPORT_ENABLE"] = "啟用常規任務支持 "
L["WQGF_CONFIG_QUEST_SUPPORT_HOVER"] = "啟用后將在任務追蹤列表后增加搜尋組隊按扭， 以便于常規任務組隊。"
L["WQGF_CONFIG_QUEST_SUPPORT_TITLE"] = "常規任務支持 "
L["WQGF_CONFIG_SILENT_MODE_ENABLE"] = "啟用無干擾模式"
L["WQGF_CONFIG_SILENT_MODE_HOVER"] = "當啟用無干擾模式時，只有重要的WQGF訊息會顯示"
L["WQGF_CONFIG_SILENT_MODE_TITLE"] = "無干擾模式"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_ENABLE"] = "10秒後自動離開隊伍"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_HOVER"] = "將會於完成世界任務的10秒鐘後離開隊伍。"
L["WQGF_CONFIG_WQ_END_DIALOG_ENABLE"] = "開啟結束世界任務對話"
L["WQGF_CONFIG_WQ_END_DIALOG_HOVER"] = "當世界任務完成時，你會被提示離開隊伍或從清單中移除"
L["WQGF_CONFIG_WQ_END_DIALOG_TITLE"] = "世界任務完成時顯示離開隊伍的對話"
L["WQGF_DEBUG_CONFIGURATION_DUMP"] = "角色設定檔："
L["WQGF_DEBUG_CURRENT_WQ_ID"] = "現在的世界任務ID為 |c00bfffff%s|c00ffffff."
L["WQGF_DEBUG_MODE_DISABLED"] = "已停用除錯模式"
L["WQGF_DEBUG_MODE_ENABLED"] = "開啟除錯模式。"
L["WQGF_DEBUG_NO_CURRENT_WQ_ID"] = "非目前的世界任務"
L["WQGF_DEBUG_WQ_ZONES_ENTERED"] = "這一次登入所進入的世界任務地區:"
L["WQGF_DELIST"] = "除名"
L["WQGF_DROPPED_WB_SUPPORT"] = "WQGF 0.21.3 已經取消了世界boss任務的支持，請使用默認UI按扭搜尋隊伍。"
L["WQGF_FIND_GROUP_TOOLTIP"] = "用 WQGF 搜尋隊伍"
L["WQGF_FIND_GROUP_TOOLTIP_2"] = "點擊滑鼠右鍵打開隊伍搜尋器窗口"
L["WQGF_FRAME_ACCEPT_INVITE"] = "點擊按鈕加入隊伍 "
L["WQGF_FRAME_APPLY_DONE"] = "向所有未滿的隊伍提交申請了。"
L["WQGF_FRAME_CLICK_TWICE"] = "點擊按鈕 %d 次開啓新的組隊。"
L["WQGF_FRAME_CREATE_WAIT"] = "如果你沒有響應，你將建立一個新隊伍。"
L["WQGF_FRAME_FOUND_GROUPS"] = "找到 %d 个組隊，點擊按鈕加入。"
L["WQGF_FRAME_GROUPS_LEFT"] = "離開 %d 個隊伍，點擊繼續。"
L["WQGF_FRAME_INIT_SEARCH"] = "單擊按鈕初始化搜索。"
L["WQGF_FRAME_NO_GROUPS"] = "未找到組隊，單擊按鈕創建新隊伍。"
L["WQGF_FRAME_RELIST_GROUP"] = "點擊按扭補充隊伍"
L["WQGF_FRAME_SEARCH_GROUPS"] = "點擊按鈕搜尋新的隊伍……"
L["WQGF_GLOBAL_CONFIGURATION"] = "共通選項:"
L["WQGF_GROUP_CREATION_ERROR"] = "嘗試建立隊伍時出問題了，請重新試一次。"
L["WQGF_GROUP_NO_LONGER_DOING_QUEST"] = "你的隊伍不再進行任務 ： |c00bfffff%s|c00ffffff "
L["WQGF_GROUP_NO_LONGER_DOING_WQ"] = "你的隊伍沒有在進行世界任務： |c00bfffff%s|c00ffffff 。"
L["WQGF_GROUP_NOW_DOING_QUEST"] = "你的隊伍正在進行任務 ： |c00bfffff%s|c00ffffff "
L["WQGF_GROUP_NOW_DOING_QUEST_ALREADY_COMPLETE"] = "你的隊伍正在進行任務： |c00bfffff%s|c00ffffff ，你已經完成了。"
L["WQGF_GROUP_NOW_DOING_QUEST_NOT_ELIGIBLE"] = "你的隊伍正在進行： | c00bfffff %s | c00ffffff ，你沒有辦法解這個任務。"
L["WQGF_GROUP_NOW_DOING_WQ"] = "你的隊伍正在進行世界任務：|c00bfffff%s|c00ffffff。"
L["WQGF_GROUP_NOW_DOING_WQ_ALREADY_COMPLETE"] = "你的隊伍正在進行： |c00bfffff%s|c00ffffff 。你已經完成這個任務了。"
L["WQGF_GROUP_NOW_DOING_WQ_NOT_ELIGIBLE"] = "你的隊伍正在進行： |c00bfffff%s|c00ffffff 。你沒辦法進行這個任務。"
L["WQGF_INIT_MSG"] = "在追蹤目標的世界任務上，點擊滑鼠中鍵開始搜尋隊伍。"
L["WQGF_JOINED_WQ_GROUP"] = "你已經加入 |c00bfffff%s|c00ffffff的隊伍（|c00bfffff%s|c00ffffff）。玩得愉快！"
L["WQGF_KICK_TOOLTIP"] = "移除所有距離過遠的玩家"
L["WQGF_LEADERS_BL_CLEARED"] = "隊長黑名單清空了"
L["WQGF_LEAVE"] = "離開"
L["WQGF_MEMBER_TOO_FAR_AWAY"] = "隊伍成員 %s 的距離有 %s 碼，使用自動移除按扭將其移出隊伍。"
L["WQGF_NEW_ENTRY_CREATED"] = "任務  |c00bfffff%s|c00ffffff 的隊伍搜尋器登錄已經建立 "
L["WQGF_NO"] = "不要"
L["WQGF_NO_APPLICATIONS_ANSWERED"] = "沒有任何一個申請加入 |c00bfffff%s|c00ffffff 的要求於時間內回應。試圖尋找新的隊伍中..."
L["WQGF_NO_APPLY_BLACKLIST"] = "你沒有申請 %d 的隊伍，因為這名隊長在黑名單中。你可以使用 |c00bfffff/wqgf unbl |c00ffffffto 清除黑名單。"
L["WQGF_PLAYER_IS_NOT_LEADER"] = "你並不是隊長。"
L["WQGF_QUEST_COMPLETE_LEAVE_DIALOG"] = [=[你已經完成任務了。

想要離開隊伍嗎？]=]
L["WQGF_QUEST_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[你已經完成任務了。

想要離開隊伍或從隊伍搜尋器中除名嗎？]=]
L["WQGF_RAID_MODE_WARNING"] = "|c0000ffff警告:|c00ffffff 這個隊伍處於團隊模式中，意味著你將無法完成世界任務。你應該建議隊長是否轉回隊伍模式。當你是此隊伍的隊長時，將自動切換到隊伍模式。"
L["WQGF_REFRESH_TOOLTIP"] = "搜尋其它的隊伍"
L["WQGF_SEARCH_OR_CREATE_GROUP"] = "搜尋或建立隊伍"
L["WQGF_SEARCHING_FOR_GROUP"] = "正在尋找世界任務 |c00bfffff%s|c00ffffff 的隊伍..."
L["WQGF_SEARCHING_FOR_GROUP_QUEST"] = "為任務 |c00bfffff%s|c00ffffff 搜索組隊"
L["WQGF_SLASH_COMMANDS_1"] = "|c00bfffff 指令 (/wqgf):"
L["WQGF_SLASH_COMMANDS_2"] = "|c00bfffff /wqgf config : 打開插件設定"
L["WQGF_SLASH_COMMANDS_3"] = "|c00bfffff /wqgf unbl : 清除隊長黑名單"
L["WQGF_SLASH_COMMANDS_4"] = "|c00bfffff /wqgf toggle : 切换新的世界任务区域偵測"
L["WQGF_START_ANOTHER_QUEST_DIALOG"] = [=[您目前已經有一個任務組隊了。

您確定要開始另一個嗎？
]=]
L["WQGF_START_ANOTHER_WQ_DIALOG"] = "你在另一個世界任務的隊伍裡面了。確定要開始另一個？"
L["WQGF_STAY"] = "留下"
L["WQGF_STOP_TOOLTIP"] = "停止解這個世界任務"
L["WQGF_TRANSLATION_INFO"] = "繁體中文由 PTT/asgard1991（蟹腳） 翻譯"
L["WQGF_USER_JOINED"] = "一位World Quest Group Finder的使用者加入了隊伍！"
L["WQGF_USERS_JOINED"] = "有幾位World Quest Group Finder的使用者加入了隊伍！"
L["WQGF_WQ_AREA_ENTERED_ALREADY_GROUPED_DIALOG"] = [=[你進入了新的世界任務地區，但在其他世界任務的隊伍中。

你想要離開現在的隊伍，然後搜尋另一個解 "%s" 的隊伍嗎？]=]
L["WQGF_WQ_AREA_ENTERED_DIALOG"] = [=[你進入了新的世界任務地區。

你想要搜尋解 "%s" 的隊伍嗎？]=]
L["WQGF_WQ_COMPLETE_LEAVE_DIALOG"] = [=[你已經完成世界任務了。

想要離開隊伍嗎？]=]
L["WQGF_WQ_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[你已經完成世界任務了。

想要離開隊伍或自隊伍搜尋器中除名嗎？]=]
L["WQGF_WQ_GROUP_APPLY_CANCELLED"] = "你已經取消申請 |c00bfffff%s|c00ffffff 的隊伍（世界任務: |c00bfffff%s|c00ffffff）。 WQGF 不會再嘗試加入這個團隊，直到你重新登入或把隊長黑名單清空。"
L["WQGF_WQ_GROUP_DESCRIPTION"] = "由WQGF自動創建 %s "
L["WQGF_WRONG_LOCATION_FOR_WQ"] = "你不在這個世界任務的正確位置。"
L["WQGF_YES"] = "好"
L["WQGF_ZONE_DETECTION_DISABLED"] = "新世界任務區域侦测現已禁用"
L["WQGF_ZONE_DETECTION_ENABLED"] = "新世界任務區域侦测現已啟用"
