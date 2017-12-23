local L = LibStub("AceLocale-3.0"):NewLocale("WorldQuestGroupFinder", "zhCN") 
if not L then return end 
L = L or {}
L["WQGF_ADDON_DESCRIPTION"] = "使用WorldQuestGroupFinder（WQGF），轻松找到世界任务队伍."
L["WQGF_ALREADY_IS_GROUP_FOR_WQ"] = "你已经在进行这个世界任务的队伍了。"
L["WQGF_ALREADY_QUEUED_BG"] = "你正在战场的队列中，请离开队列并重新试一次。"
L["WQGF_ALREADY_QUEUED_DF"] = "你正在随机地城（地城查找器）的队列中，请离开队列并重试一次。"
L["WQGF_ALREADY_QUEUED_RF"] = "你正在随机团队（团队查找器）的队列中，请离开队列并重新试一次。"
L["WQGF_APPLIED_TO_GROUPS"] = "你已经为世界任务 |c00bfffff%s|c00ffffff 申请了 |c00bfffff%d|c00ffffff 个队伍。"
L["WQGF_APPLIED_TO_GROUPS_QUEST"] = "你已经为任务 |c00bfffff%s|c00ffffff 申请了 |c00bfffff%d|c00ffffff 个队伍。"
L["WQGF_AUTO_LEAVING_DIALOG"] = [=[你已经完成这个世界任务并会在 %d 秒后自动离队。

说声再见吧！]=]
L["WQGF_AUTO_LEAVING_DIALOG_QUEST"] = [=[你已经完成了任务，将在 %d 秒后离队

说声再见吧!]=]
L["WQGF_CANCEL"] = "取消"
L["WQGF_CANNOT_DO_WQ_IN_GROUP"] = "这个世界任务无法在队伍中完成。"
L["WQGF_CANNOT_DO_WQ_TYPE_IN_GROUP"] = "这种类型的世界任务无法在队伍中完成。"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_ENABLE"] = "在非战斗时，自动接受WQGF的组队邀请"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_HOVER"] = "非战斗时将会自动接受组队邀请"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_TITLE"] = "自动接受组队邀请"
L["WQGF_CONFIG_AUTOINVITE"] = "自动邀请"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE"] = "自动邀请任何人"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE_HOVER"] = "所有申请人都会被自动邀请进队伍，达到5人上限。"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS"] = "自动邀请WQGF的使用者"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS_HOVER"] = "World Quest Group Finder的使用者会自动被邀请到队伍中"
L["WQGF_CONFIG_BINDING_ADVICE"] = "提示：你可以在游戏的按键设定中为WQGF按扭绑定一个按键。"
L["WQGF_CONFIG_LANGUAGE_FILTER_ENABLE"] = "搜索任何语言的队伍（忽略队伍搜索器的语言选项）"
L["WQGF_CONFIG_LANGUAGE_FILTER_HOVER"] = "将会搜索所有可加入的队伍，并忽略他们的语言"
L["WQGF_CONFIG_LANGUAGE_FILTER_TITLE"] = "队伍搜索语言过滤"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE"] = "WQGF登入信息"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_ENABLE"] = "隐藏登入游戏时的WQGF初始信息"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_HOVER"] = "登入时不会再显示WQGF的信息"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_ENABLE"] = "如果不在队伍时自动开始搜索"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_HOVER"] = "进入新的世界任务区域时会自动搜索队伍"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_ENABLE"] = "开启新的世界任务区域检测模式"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_HOVER"] = "当进入新的世界任务区域时，你会被询问是否要寻找队伍"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_SWITCH_ENABLE"] = "如果已在其他世界任务队伍中则不提示"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_TITLE"] = "在第一次进入世界任务区域时提示查找队伍"
L["WQGF_CONFIG_PAGE_CREDITS"] = "由 Robou, EU-Hyjal 开发"
L["WQGF_CONFIG_PARTY_NOTIFICATION_ENABLE"] = "启用队伍通知"
L["WQGF_CONFIG_PARTY_NOTIFICATION_HOVER"] = "世界任务完成会发送信息到队伍中"
L["WQGF_CONFIG_PARTY_NOTIFICATION_TITLE"] = "世界任务完成时会通知队伍"
L["WQGF_CONFIG_PVP_REALMS_ENABLE"] = "避免加入PvP服务器的队伍"
L["WQGF_CONFIG_PVP_REALMS_HOVER"] = "将避免加入PvP服务器的队伍（如为PvP服务器的角色，这个选项将会忽略）"
L["WQGF_CONFIG_PVP_REALMS_TITLE"] = "PvP服务器"
L["WQGF_CONFIG_QUEST_SUPPORT_ENABLE"] = "启用常规任务支持"
L["WQGF_CONFIG_QUEST_SUPPORT_HOVER"] = "勾选后将在任务追踪列表后增加寻找组队按扭，以方便常规任务组队。"
L["WQGF_CONFIG_QUEST_SUPPORT_TITLE"] = "常规任务支持"
L["WQGF_CONFIG_SILENT_MODE_ENABLE"] = "启用无干扰模式"
L["WQGF_CONFIG_SILENT_MODE_HOVER"] = "当启用无干扰模式时，只会显示重要的WQGF信息"
L["WQGF_CONFIG_SILENT_MODE_TITLE"] = "无干扰模式"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_ENABLE"] = "10秒后自动离开队伍"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_HOVER"] = "将会在完成世界任务的10秒钟后离开队伍。"
L["WQGF_CONFIG_WQ_END_DIALOG_ENABLE"] = "开启结束世界任务对话"
L["WQGF_CONFIG_WQ_END_DIALOG_HOVER"] = "当世界任务完成时，会提示离开队伍或从列表中移除"
L["WQGF_CONFIG_WQ_END_DIALOG_TITLE"] = "世界任务完成时显示离开队伍的对话框"
L["WQGF_DEBUG_CONFIGURATION_DUMP"] = "角色设定："
L["WQGF_DEBUG_CURRENT_WQ_ID"] = "现在的世界任务ID为 |c00bfffff%s|c00ffffff."
L["WQGF_DEBUG_MODE_DISABLED"] = "已停用除错模式"
L["WQGF_DEBUG_MODE_ENABLED"] = "开启除错模式。"
L["WQGF_DEBUG_NO_CURRENT_WQ_ID"] = "非目前的世界任务"
L["WQGF_DEBUG_WQ_ZONES_ENTERED"] = "这一次登入所进入的世界任务区域:"
L["WQGF_DELIST"] = "除名"
L["WQGF_DROPPED_WB_SUPPORT"] = "WQGF 0.21.3 已经取消了世界boss任务的支持，请使用默认UI按扭寻找队伍。"
L["WQGF_FIND_GROUP_TOOLTIP"] = "用 WQGF 查找队伍"
L["WQGF_FIND_GROUP_TOOLTIP_2"] = "点击鼠标中键开组"
L["WQGF_FRAME_ACCEPT_INVITE"] = "单击按扭加入队伍"
L["WQGF_FRAME_APPLY_DONE"] = "向所有未满的队伍提交申请了。"
L["WQGF_FRAME_CLICK_TWICE"] = "点击按扭 %d 次开启新的组队。"
L["WQGF_FRAME_CREATE_WAIT"] = "如果你没有响应，你将建立一个新的组队。"
L["WQGF_FRAME_FOUND_GROUPS"] = "找到 %d 个队伍，点击按扭加入"
L["WQGF_FRAME_GROUPS_LEFT"] = "离开 %d 个队伍，点击继续。"
L["WQGF_FRAME_INIT_SEARCH"] = "单击按钮初始化搜索"
L["WQGF_FRAME_NO_GROUPS"] = "没有找到组队，单击按扭建立新的组队。"
L["WQGF_FRAME_RELIST_GROUP"] = "点击按扭补充组队"
L["WQGF_FRAME_SEARCH_GROUPS"] = "点击按扭寻找组队..."
L["WQGF_GLOBAL_CONFIGURATION"] = "全局配置:"
L["WQGF_GROUP_CREATION_ERROR"] = "尝试建立队伍时出问题了，请重新试一次。"
L["WQGF_GROUP_NO_LONGER_DOING_QUEST"] = "你的队伍不再执行任务 ： |c00bfffff%s|c00ffffff "
L["WQGF_GROUP_NO_LONGER_DOING_WQ"] = "你的队伍没有在执行世界任务： |c00bfffff%s|c00ffffff 。"
L["WQGF_GROUP_NOW_DOING_QUEST"] = "你的队伍正在执行任务  |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_QUEST_ALREADY_COMPLETE"] = "你的队伍正在执行任务： |c00bfffff%s|c00ffffff ，你已经完成了。"
L["WQGF_GROUP_NOW_DOING_QUEST_NOT_ELIGIBLE"] = "你的队伍正在执行： | c00bfffff %s | c00ffffff ，你没有办法做这个任务。"
L["WQGF_GROUP_NOW_DOING_WQ"] = "你的队伍正在执行世界任务：|c00bfffff%s|c00ffffff。"
L["WQGF_GROUP_NOW_DOING_WQ_ALREADY_COMPLETE"] = "你的队伍正在执行任务： |c00bfffff%s|c00ffffff  ，你已经完成了。"
L["WQGF_GROUP_NOW_DOING_WQ_NOT_ELIGIBLE"] = "你的队伍正在执行任务： |c00bfffff%s|c00ffffff 。你没办法进行这个任务。"
L["WQGF_INIT_MSG"] = "在追踪目标的世界任务上，点击鼠标中键开始搜索队伍。"
L["WQGF_JOINED_WQ_GROUP"] = "你已经加入 |c00bfffff%s|c00ffffff的队伍（|c00bfffff%s|c00ffffff）。玩得愉快！"
L["WQGF_KICK_TOOLTIP"] = "移除全部距离过远的玩家"
L["WQGF_LEADERS_BL_CLEARED"] = "队长黑名单清空了"
L["WQGF_LEAVE"] = "离开"
L["WQGF_MEMBER_TOO_FAR_AWAY"] = "队伍成员 %s 的距离有 %s 码，使用自动移除按扭将其移出队伍。"
L["WQGF_NEW_ENTRY_CREATED"] = "任务  |c00bfffff%s|c00ffffff  的队伍搜索器登陆已经建立。"
L["WQGF_NO"] = "不要"
L["WQGF_NO_APPLICATIONS_ANSWERED"] = "你任务  |c00bfffff%s|c00ffffff 的组队申请在一定时间内没有回应。试图寻找新的队伍中..."
L["WQGF_NO_APPLY_BLACKLIST"] = "你没有申请 %d 的队伍，因为这名队长在黑名单中。你可以使用 |c00bfffff/wqgf unbl |c00ffffffto 清除黑名单。"
L["WQGF_PLAYER_IS_NOT_LEADER"] = "你并不是队长。"
L["WQGF_QUEST_COMPLETE_LEAVE_DIALOG"] = [=[你已经完成任务了。

想要离开队伍吗？]=]
L["WQGF_QUEST_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[你已经完成任务了。

想要离开队伍或从队伍搜索器中除名吗？]=]
L["WQGF_RAID_MODE_WARNING"] = "|c0000ffff警告:|c00ffffff 这个队伍处于团队模式中，意味着你将无法完成世界任务。你应该建议队长转回队伍模式。当你是此队伍的队长时，将自动切换到队伍模式。"
L["WQGF_REFRESH_TOOLTIP"] = "搜索另一个队伍"
L["WQGF_SEARCH_OR_CREATE_GROUP"] = "搜索或建立队伍"
L["WQGF_SEARCHING_FOR_GROUP"] = "正在寻找世界任务 |c00bfffff%s|c00ffffff 的组队..."
L["WQGF_SEARCHING_FOR_GROUP_QUEST"] = "为任务 |c00bfffff%s|c00ffffff 搜索组队"
L["WQGF_SLASH_COMMANDS_1"] = "|c00bfffff 指令 (/wqgf):"
L["WQGF_SLASH_COMMANDS_2"] = "|c00bfffff /wqgf config : 打开插件设定"
L["WQGF_SLASH_COMMANDS_3"] = "|c00bfffff /wqgf unbl : 清除队长黑名单"
L["WQGF_SLASH_COMMANDS_4"] = "|c00bfffff /wqgf toggle : 切换新的世界任务区域检测"
L["WQGF_START_ANOTHER_QUEST_DIALOG"] = [=[您目前已经有一个任务组队了。

您确定要开始另一个吗？
]=]
L["WQGF_START_ANOTHER_WQ_DIALOG"] = [=["你在其它世界任务的队伍里面了。

确定要开始另一个？"]=]
L["WQGF_STAY"] = "留下"
L["WQGF_STOP_TOOLTIP"] = "停止执行这个世界任务"
L["WQGF_TRANSLATION_INFO"] = "WQGF汉化:  Evilbear@哈卡 "
L["WQGF_USER_JOINED"] = "一位World Quest Group Finder的使用者加入了队伍！"
L["WQGF_USERS_JOINED"] = "有几位World Quest Group Finder的使用者加入了队伍！"
L["WQGF_WQ_AREA_ENTERED_ALREADY_GROUPED_DIALOG"] = [=[你进入了新的世界任务区域，但你还在其他世界任务的队伍中。

你想要离开现在的队伍，并搜索另一个做 "%s" 的队伍吗？]=]
L["WQGF_WQ_AREA_ENTERED_DIALOG"] = [=[你进入了新的世界任务地区。

你想要搜索做 "%s" 的队伍吗？]=]
L["WQGF_WQ_COMPLETE_LEAVE_DIALOG"] = [=[你已经完成世界任务了。

想要离开队伍吗？]=]
L["WQGF_WQ_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[你已经完成世界任务了。

想要离开队伍或从队伍搜索器中除名吗？]=]
L["WQGF_WQ_GROUP_APPLY_CANCELLED"] = "你已经取消申请 |c00bfffff%s|c00ffffff 的队伍（世界任务: |c00bfffff%s|c00ffffff）。 WQGF 不会再尝试加入这个队伍，直到你重新登入或把队长黑名单清空。"
L["WQGF_WQ_GROUP_DESCRIPTION"] = "由WQGF自动创建 %s."
L["WQGF_WRONG_LOCATION_FOR_WQ"] = "你不在这个世界任务的正确位置。"
L["WQGF_YES"] = "好"
L["WQGF_ZONE_DETECTION_DISABLED"] = "新世界任务区域检测现已禁用"
L["WQGF_ZONE_DETECTION_ENABLED"] = "新世界任务区域检测现已启用"
