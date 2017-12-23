local L = LibStub("AceLocale-3.0"):NewLocale("WorldQuestGroupFinder", "enUS", true) 
if not L then return end 
L = L or {}
L["WQGF_ADDON_DESCRIPTION"] = "Makes it easy to find groups for World Quests by using the Group Finder tool."
L["WQGF_ALREADY_IS_GROUP_FOR_WQ"] = "You already are in a group for this world quest."
L["WQGF_ALREADY_QUEUED_BG"] = "You are currently queued for a battleground. Please leave the queue and try again."
L["WQGF_ALREADY_QUEUED_DF"] = "You are currently queued in the Dungeon Finder. Please leave the queue and try again."
L["WQGF_ALREADY_QUEUED_RF"] = "You are currently queued in the Raid Finder. Please leave the queue and try again."
L["WQGF_APPLIED_TO_GROUPS"] = "You have been applied to |c00bfffff%d|c00ffffff group(s) for the world quest |c00bfffff%s|c00ffffff."
L["WQGF_APPLIED_TO_GROUPS_QUEST"] = "You have been applied to |c00bfffff%d|c00ffffff group(s) for the quest |c00bfffff%s|c00ffffff."
L["WQGF_AUTO_LEAVING_DIALOG"] = [=[You have completed the world quest and will leave the group in %d seconds.

Say goodbye!]=]
L["WQGF_AUTO_LEAVING_DIALOG_QUEST"] = [=[You have completed the quest and will leave the group in %d seconds.

Say goodbye!]=]
L["WQGF_CANCEL"] = "Cancel"
L["WQGF_CANNOT_DO_WQ_IN_GROUP"] = "This world quest cannot be accomplished as a group."
L["WQGF_CANNOT_DO_WQ_TYPE_IN_GROUP"] = "This type of world quest cannot be accomplished as a group."
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_ENABLE"] = "Automatically accept group invites for WQGF groups when not in combat"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_HOVER"] = "Will automatically accept group invites when not in combat"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_TITLE"] = "Auto-accept group invites"
L["WQGF_CONFIG_AUTOINVITE"] = "Auto-invite"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE"] = "Auto-invite everyone"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE_HOVER"] = "Every applicant will automatically be invited to the group up to a limit of 5 players"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS"] = "Auto-invite WQGF users"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS_HOVER"] = "World Quest Group Finder users will automatically be invited to the group"
L["WQGF_CONFIG_BINDING_ADVICE"] = "Remember you can bind the WQGF button to a key from WoW's Key Bindings menu!"
L["WQGF_CONFIG_LANGUAGE_FILTER_ENABLE"] = "Search for groups of any languages (ignore the group finder tool language selection)"
L["WQGF_CONFIG_LANGUAGE_FILTER_HOVER"] = "Will always search for all available groups regardless of their language"
L["WQGF_CONFIG_LANGUAGE_FILTER_TITLE"] = "Group search language filter"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE"] = "WQGF login message"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_ENABLE"] = "Hide WQGF init message at login"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_HOVER"] = "Won't display the WQGF message at login anymore"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_ENABLE"] = "Automatically start searching if not in a group"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_HOVER"] = "A group will automatically be searched when entering a new world quest zone"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_ENABLE"] = "Enable new world quest zone detection"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_HOVER"] = "You will be asked if you want to search for a group when entering a new world quest zone"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_SWITCH_ENABLE"] = "Do not propose if already grouped for another world quest"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_TITLE"] = "Propose searching for a group when entering a world quest area for the first time"
L["WQGF_CONFIG_PAGE_CREDITS"] = "Brought to you by Robou, EU-Hyjal"
L["WQGF_CONFIG_PARTY_NOTIFICATION_ENABLE"] = "Enable party notification"
L["WQGF_CONFIG_PARTY_NOTIFICATION_HOVER"] = "A message will be sent to the party when the world quest is completed"
L["WQGF_CONFIG_PARTY_NOTIFICATION_TITLE"] = "Notify the group when the world quest is completed"
L["WQGF_CONFIG_PVP_REALMS_ENABLE"] = "Avoid joining groups on PvP realms"
L["WQGF_CONFIG_PVP_REALMS_HOVER"] = "Will avoid joining groups on PvP realms (this parameter is ignored for characters on PvP realms)"
L["WQGF_CONFIG_PVP_REALMS_TITLE"] = "PvP realms"
L["WQGF_CONFIG_QUEST_SUPPORT_ENABLE"] = "Enable support for regular quests"
L["WQGF_CONFIG_QUEST_SUPPORT_HOVER"] = "Enabling this will display a button to find groups for supported regular quests"
L["WQGF_CONFIG_QUEST_SUPPORT_TITLE"] = "Regular quests support"
L["WQGF_CONFIG_SILENT_MODE_ENABLE"] = "Enable silent mode"
L["WQGF_CONFIG_SILENT_MODE_HOVER"] = "When silent mode is enabled, only the most important WQGF messages are displayed"
L["WQGF_CONFIG_SILENT_MODE_TITLE"] = "Silent mode"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_ENABLE"] = "Automatically leave the group after 10 seconds"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_HOVER"] = "Will automatically leave the group after 10 seconds when a world quest is completed"
L["WQGF_CONFIG_WQ_END_DIALOG_ENABLE"] = "Enable world quest end dialog"
L["WQGF_CONFIG_WQ_END_DIALOG_HOVER"] = "You will be proposed to leave the group or delist it when the world quest is completed"
L["WQGF_CONFIG_WQ_END_DIALOG_TITLE"] = "Show a dialog to leave the group when the world quest is completed"
L["WQGF_DEBUG_CONFIGURATION_DUMP"] = "Character configuration :"
L["WQGF_DEBUG_CURRENT_WQ_ID"] = "Current quest ID is |c00bfffff%s|c00ffffff."
L["WQGF_DEBUG_MODE_DISABLED"] = "Debug mode is now disabled."
L["WQGF_DEBUG_MODE_ENABLED"] = "Debug mode is now enabled."
L["WQGF_DEBUG_NO_CURRENT_WQ_ID"] = "No current quest"
L["WQGF_DEBUG_WQ_ZONES_ENTERED"] = "World quest zones entered this session:"
L["WQGF_DELIST"] = "Delist"
L["WQGF_DROPPED_WB_SUPPORT"] = "World boss world quests support has been dropped in WQGF 0.21.3. Please use the default UI button to find a group."
L["WQGF_FIND_GROUP_TOOLTIP"] = "Find Group with WQGF"
L["WQGF_FIND_GROUP_TOOLTIP_2"] = "Middle click to create a new group"
L["WQGF_FRAME_ACCEPT_INVITE"] = "Click the button to join the group"
L["WQGF_FRAME_APPLY_DONE"] = "You have applied to all the available groups."
L["WQGF_FRAME_CLICK_TWICE"] = "Click the button %d times to create a new group."
L["WQGF_FRAME_CREATE_WAIT"] = "You'll be able to create a new group if you get no replies."
L["WQGF_FRAME_FOUND_GROUPS"] = "Found %d group(s). Click the button to apply."
L["WQGF_FRAME_GROUPS_LEFT"] = "%d group(s) left, keep clicking!"
L["WQGF_FRAME_INIT_SEARCH"] = "Click the button to initialize the search"
L["WQGF_FRAME_RELIST_GROUP"] = "Click the button to relist the group"
L["WQGF_FRAME_NO_GROUPS"] = "No groups found, click the button to create a new group."
L["WQGF_FRAME_SEARCH_GROUPS"] = "Click the button to search for groups..."
L["WQGF_GLOBAL_CONFIGURATION"] = "Global configuration:"
L["WQGF_GROUP_CREATION_ERROR"] = "An error has occured when trying to create a new group finder entry. Please retry."
L["WQGF_GROUP_NO_LONGER_DOING_QUEST"] = "Your group is no longer doing the quest |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NO_LONGER_DOING_WQ"] = "Your group is no longer doing the world quest |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_QUEST"] = "Your group is now doing the quest |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_QUEST_ALREADY_COMPLETE"] = "Your group is now doing the quest |c00bfffff%s|c00ffffff. You already have completed this quest."
L["WQGF_GROUP_NOW_DOING_QUEST_NOT_ELIGIBLE"] = "Your group is now doing the quest |c00bfffff%s|c00ffffff. You are not eligible to do this quest."
L["WQGF_GROUP_NOW_DOING_WQ"] = "Your group is now doing the world quest |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_WQ_ALREADY_COMPLETE"] = "Your group is now doing the world quest |c00bfffff%s|c00ffffff. You already have completed this world quest."
L["WQGF_GROUP_NOW_DOING_WQ_NOT_ELIGIBLE"] = "Your group is now doing the world quest |c00bfffff%s|c00ffffff. You are not eligible to do this world quest."
L["WQGF_INIT_MSG"] = "Click with the middle mouse button on a world quest in the objective tracking window or on the world map to search for a group."
L["WQGF_JOINED_WQ_GROUP"] = "You have joined |c00bfffff%s|c00ffffff's group for |c00bfffff%s|c00ffffff. Have fun!"
L["WQGF_KICK_TOOLTIP"] = "Kick all the players who are too far away"
L["WQGF_LEADERS_BL_CLEARED"] = "The leaders blacklist has been cleared."
L["WQGF_LEAVE"] = "Leave"
L["WQGF_MEMBER_TOO_FAR_AWAY"] = "The group member %s is %s yards away. Use the auto-kick button to remove him from the party."
L["WQGF_NEW_ENTRY_CREATED"] = "A new group finder entry has been created for |c00bfffff%s|c00ffffff."
L["WQGF_NO"] = "No"
L["WQGF_NO_APPLICATIONS_ANSWERED"] = "None of your applications for |c00bfffff%s|c00ffffff were answered in time. Trying to find new groups..."
L["WQGF_NO_APPLY_BLACKLIST"] = "You have not been applied to %d group(s) because their leader was blacklisted. You can use |c00bfffff/wqgf unbl |c00ffffffto clear the blacklist."
L["WQGF_PLAYER_IS_NOT_LEADER"] = "You are not the group leader."
L["WQGF_QUEST_COMPLETE_LEAVE_DIALOG"] = [=[You have completed the quest.

Would you like to leave the group?]=]
L["WQGF_QUEST_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[You have completed the quest.

Would you like to leave the group or delist it from the Group Finder?]=]
L["WQGF_RAID_MODE_WARNING"] = "|c0000ffffWARNING:|c00ffffff This group is in raid mode which means you won't be able to complete quests and world quests. You should ask the leader to switch back to party mode if possible. The group will automatically switch to party mode if you become the leader."
L["WQGF_REFRESH_TOOLTIP"] = "Search another group"
L["WQGF_SEARCH_OR_CREATE_GROUP"] = "Search or Create Group"
L["WQGF_SEARCHING_FOR_GROUP"] = "Searching for a group for world quest |c00bfffff%s|c00ffffff..."
L["WQGF_SEARCHING_FOR_GROUP_QUEST"] = "Searching for a group for quest |c00bfffff%s|c00ffffff..."
L["WQGF_SLASH_COMMANDS_1"] = "|c00bfffffSlash commands (/wqgf):"
L["WQGF_SLASH_COMMANDS_2"] = "|c00bfffff /wqgf config : Open addon configuration"
L["WQGF_SLASH_COMMANDS_3"] = "|c00bfffff /wqgf unbl : Clear the leaders blacklist"
L["WQGF_SLASH_COMMANDS_4"] = "|c00bfffff /wqgf toggle : Toggle new world quest zone detection"
L["WQGF_START_ANOTHER_QUEST_DIALOG"] = [=[You are currently grouped for a quest.

Are you sure you want to start another one?]=]
L["WQGF_START_ANOTHER_WQ_DIALOG"] = [=[You are currently grouped for a world quest.

Are you sure you want to start another one?]=]
L["WQGF_STAY"] = "Stay"
L["WQGF_STOP_TOOLTIP"] = "Stop doing this World Quest"
L["WQGF_TRANSLATION_INFO"] = "Interested in translating WQGF to your language? Feel free to contact me on Curse!"
L["WQGF_USER_JOINED"] = "A World Quest Group Finder user has joined the group!"
L["WQGF_USERS_JOINED"] = "World Quest Group Finder users have joined the group!"
L["WQGF_WQ_AREA_ENTERED_ALREADY_GROUPED_DIALOG"] = [=[You have entered a new world quest area, but are currently grouped for another world quest.

Would you like to leave your current group and find another for "%s"?]=]
L["WQGF_WQ_AREA_ENTERED_DIALOG"] = [=[You have entered a new world quest area.

Would you like to find a group for "%s"?]=]
L["WQGF_WQ_COMPLETE_LEAVE_DIALOG"] = [=[You have completed the world quest.

Would you like to leave the group?]=]
L["WQGF_WQ_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[You have completed the world quest.

Would you like to leave the group or delist it from the Group Finder?]=]
L["WQGF_WQ_GROUP_APPLY_CANCELLED"] = "You have cancelled your apply for |c00bfffff%s|c00ffffff's group for |c00bfffff%s|c00ffffff. WQGF will not try to join this group again until you relog or clear the leaders blacklist."
L["WQGF_WQ_GROUP_DESCRIPTION"] = "Automatically created by World Quest Group Finder %s."
L["WQGF_WRONG_LOCATION_FOR_WQ"] = "You are not in the right location for this world quest."
L["WQGF_YES"] = "Yes"
L["WQGF_ZONE_DETECTION_DISABLED"] = "New world quest zone detection is now disabled."
L["WQGF_ZONE_DETECTION_ENABLED"] = "New world quest zone detection is now enabled."
