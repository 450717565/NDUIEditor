local L = LibStub("AceLocale-3.0"):NewLocale("WorldQuestGroupFinder", "koKR") 
if not L then return end 
L = L or {}
L["WQGF_ADDON_DESCRIPTION"] = "파티 찾기 도구를 사용하여 손쉽게 전역 퀘스트 파티를 찾을 수 있습니다."
L["WQGF_ALREADY_IS_GROUP_FOR_WQ"] = "당신이 이미 해당 전역 퀘스트를 위한 파티에 속해있습니다."
L["WQGF_ALREADY_QUEUED_BG"] = "현재 전장 대기열에 등록되어 있습니다. 대기 취소 후 다시 시도하십시오."
L["WQGF_ALREADY_QUEUED_DF"] = "현재 던전 찾기 대기열에 등록되어 있습니다. 대기 취소 후 다시 시도하십시오."
L["WQGF_ALREADY_QUEUED_RF"] = "현재 공격대 찾기 대기열에 등록되어 있습니다. 대기 취소 후 다시 시도하십시오."
L["WQGF_APPLIED_TO_GROUPS"] = "|c00bfffff%s|c00ffffff 전역 퀘스트를 위한 |c00bfffff%d|c00ffffff개 파티에 신청되었습니다."
L["WQGF_APPLIED_TO_GROUPS_QUEST"] = "|c00bfffff%s|c00ffffff 퀘스트를 위한 |c00bfffff%d|c00ffffff개 파티에 신청되었습니다."
L["WQGF_AUTO_LEAVING_DIALOG"] = [=[전역 퀘스트를 완료했으며 %d초 뒤에 그룹을 떠납니다.

파티원에게 작별 인사를 하세요!]=]
L["WQGF_AUTO_LEAVING_DIALOG_QUEST"] = [=[퀘스트를 완료했으며 %d초 뒤에 그룹을 떠납니다.

파티원에게 작별 인사를 하세요!]=]
L["WQGF_CANCEL"] = "취소"
L["WQGF_CANNOT_DO_WQ_IN_GROUP"] = "이 전역 퀘스트는 파티로 수행할 수 없습니다."
L["WQGF_CANNOT_DO_WQ_TYPE_IN_GROUP"] = "이 유형의 전역 퀘스트는 파티로 수행할 수 없습니다."
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_ENABLE"] = "전투 중이 아닐 경우 WQGF 파티가 보내는 초대를 자동으로 수락합니다."
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_HOVER"] = "전투 중이 아닐 경우 초대를 자동으로 수락합니다."
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_TITLE"] = "파티 초대 자동 수락"
L["WQGF_CONFIG_AUTOINVITE"] = "자동 초대"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE"] = "모두 자동 초대"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE_HOVER"] = "모든 신청자는 최대 5명까지 자동으로 파티에 초대됩니다"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS"] = "WQGF 사용자 자동 초대"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS_HOVER"] = "World Quest Group Finder 사용자를 자동으로 그룹에 초대합니다."
L["WQGF_CONFIG_BINDING_ADVICE"] = "WoW 단축키 설정에서 WQGF 버튼에 단축키를 지정할 수 있습니다!"
L["WQGF_CONFIG_LANGUAGE_FILTER_ENABLE"] = "모든 언어의 파티 검색하기 (파티 찾기 도구의 언어 선택 무시)"
L["WQGF_CONFIG_LANGUAGE_FILTER_HOVER"] = "언어에 관계없이 항상 활성화 되있는 모든 파티를 검색합니다."
L["WQGF_CONFIG_LANGUAGE_FILTER_TITLE"] = "파티 검색 언어 필터"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE"] = "WQGF 접속 메시지"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_ENABLE"] = "접속 시 WQGF 시작 메시지 숨기기"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_HOVER"] = "더 이상 접속할 때 WQGF 메시지를 표시하지 않습니다"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_ENABLE"] = "파티가 아닐 경우 자동으로 검색 시작"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_HOVER"] = "새로운 전역 퀘스트 지역에 진입하면 자동으로 파티를 검색합니다"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_ENABLE"] = "새로운 전역 퀘스트 지역 감지 사용"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_HOVER"] = "새로운 전역 퀘스트 지역에 진입했을 때 파티를 검색할 지 묻습니다"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_SWITCH_ENABLE"] = "이미 다른 전역 퀘스트를 위한 파티에 있다면 묻지 않습니다"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_TITLE"] = "처음으로 전역 퀘스트 지역에 진입했을 때 파티를 검색할 지 묻습니다"
L["WQGF_CONFIG_PAGE_CREDITS"] = "Robou, EU-Hyjal이 만들었습니다"
L["WQGF_CONFIG_PARTY_NOTIFICATION_ENABLE"] = "파티 알림 사용"
L["WQGF_CONFIG_PARTY_NOTIFICATION_HOVER"] = "전역 퀘스트가 완료되면 메시지가 파티에 전송됩니다"
L["WQGF_CONFIG_PARTY_NOTIFICATION_TITLE"] = "전역 퀘스트가 완료되면 파티에 알리기"
L["WQGF_CONFIG_PVP_REALMS_ENABLE"] = "PvP 서버에서 생성된 파티 참여 방지"
L["WQGF_CONFIG_PVP_REALMS_HOVER"] = "PvP 서버에서 생성된 파티에 참여하지 않습니다 (이 기능은 PvP 서버의 캐릭터에게는 무시됩니다)"
L["WQGF_CONFIG_PVP_REALMS_TITLE"] = "PvP 서버"
L["WQGF_CONFIG_QUEST_SUPPORT_ENABLE"] = "일반 퀘스트 지원 사용"
L["WQGF_CONFIG_QUEST_SUPPORT_HOVER"] = "지원되는 일반 퀘스트에 파티 찾기 버튼이 표시됩니다."
L["WQGF_CONFIG_QUEST_SUPPORT_TITLE"] = "일반 퀘스트 지원"
L["WQGF_CONFIG_SILENT_MODE_ENABLE"] = "침묵 모드 사용"
L["WQGF_CONFIG_SILENT_MODE_HOVER"] = "침묵 모드가 활성화되면 중요한 WQGF 메시지만 표시됩니다"
L["WQGF_CONFIG_SILENT_MODE_TITLE"] = "침묵 모드"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_ENABLE"] = "10초 후 자동으로 파티를 떠납니다"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_HOVER"] = "전역 퀘스트가 완료되면 10초 후에 자동으로 파티를 떠납니다"
L["WQGF_CONFIG_WQ_END_DIALOG_ENABLE"] = "전역 퀘스트 종료 대화상자 사용"
L["WQGF_CONFIG_WQ_END_DIALOG_HOVER"] = "전역 퀘스트가 완료되면 파티를 떠나거나 파티 등록 취소를 할지 묻습니다."
L["WQGF_CONFIG_WQ_END_DIALOG_TITLE"] = "전역 퀘스트가 완료되면 파티에서 나가기 위한 대화상자 표시"
L["WQGF_DEBUG_CONFIGURATION_DUMP"] = "해당 캐릭터 설정 :"
L["WQGF_DEBUG_CURRENT_WQ_ID"] = "현재 퀘스트 ID는 |c00bfffff%s|c00ffffff 입니다."
L["WQGF_DEBUG_MODE_DISABLED"] = "디버그 모드가 이제 비활성화 됩니다."
L["WQGF_DEBUG_MODE_ENABLED"] = "디버그 모드가 이제 활성화 됩니다."
L["WQGF_DEBUG_NO_CURRENT_WQ_ID"] = "현재 퀘스트 없음"
L["WQGF_DEBUG_WQ_ZONES_ENTERED"] = "현재 세션에서 진입한 전역 퀘스트 지역:"
L["WQGF_DELIST"] = "파티 등록 취소"
L["WQGF_DROPPED_WB_SUPPORT"] = [=[WQGF 0.21.3에서 야외 우두머리 전역 퀘스트 지원이 중단되었습니다.
파티를 찾으려면 기본 UI 버튼을 사용해 주세요.]=]
L["WQGF_FIND_GROUP_TOOLTIP"] = "WQGF로 파티 찾기"
L["WQGF_FIND_GROUP_TOOLTIP_2"] = "가운데 클릭으로 새로운 파티를 만듭니다"
L["WQGF_FRAME_ACCEPT_INVITE"] = "파티에 참여하려면 버튼 클릭"
L["WQGF_FRAME_APPLY_DONE"] = "이용 가능한 모든 파티에 적용했습니다."
L["WQGF_FRAME_CLICK_TWICE"] = "새로운 파티를 만드려면 버튼을 %d번 클릭하세요."
L["WQGF_FRAME_CREATE_WAIT"] = "아무런 응답을 받지 못해야 새로운 파티를 만들 수 있습니다."
L["WQGF_FRAME_FOUND_GROUPS"] = "%d개 파티를 찾았습니다. 적용하려면 버튼을 클릭하세요."
L["WQGF_FRAME_GROUPS_LEFT"] = "%d개 파티 남음, 클릭하고 계세요!"
L["WQGF_FRAME_INIT_SEARCH"] = "검색하려면 버튼을 클릭하세요"
L["WQGF_FRAME_NO_GROUPS"] = "파티를 찾지 못했습니다, 새로운 파티를 만드려면 버튼을 클릭하세요."
L["WQGF_FRAME_RELIST_GROUP"] = "파티를 다시 나열하려면 버튼을 클릭하세요"
L["WQGF_FRAME_SEARCH_GROUPS"] = "파티를 찾으려면 버튼을 클릭하세요..."
L["WQGF_GLOBAL_CONFIGURATION"] = "공통 설정:"
L["WQGF_GROUP_CREATION_ERROR"] = "새로운 파티 찾기 항목을 만드는 동안 오류가 발생했습니다. 다시 시도하십시오."
L["WQGF_GROUP_NO_LONGER_DOING_QUEST"] = "당신의 파티는 더 이상 |c00bfffff%s|c00ffffff 퀘스트를 수행하지 않습니다."
L["WQGF_GROUP_NO_LONGER_DOING_WQ"] = "당신의 파티는 더 이상 |c00bfffff%s|c00ffffff 전역 퀘스트를 수행하지 않습니다."
L["WQGF_GROUP_NOW_DOING_QUEST"] = "당신의 파티는 이제 |c00bfffff%s|c00ffffff 퀘스트를 수행합니다."
L["WQGF_GROUP_NOW_DOING_QUEST_ALREADY_COMPLETE"] = "당신의 파티는 이제 |c00bfffff%s|c00ffffff 퀘스트를 수행합니다. 당신은 이미 이 전역 퀘스트를 완료했습니다."
L["WQGF_GROUP_NOW_DOING_QUEST_NOT_ELIGIBLE"] = "당신의 파티는 이제 |c00bfffff%s|c00ffffff 퀘스트를 수행합니다. 당신은 이 퀘스트를 수행할 수 있는 조건을 충족하지 못했습니다."
L["WQGF_GROUP_NOW_DOING_WQ"] = "당신의 파티는 이제 |c00bfffff%s|c00ffffff 전역 퀘스트를 수행합니다."
L["WQGF_GROUP_NOW_DOING_WQ_ALREADY_COMPLETE"] = "당신의 파티는 이제 |c00bfffff%s|c00ffffff 전역 퀘스트를 수행합니다. 당신은 이미 이 전역 퀘스트를 완료했습니다."
L["WQGF_GROUP_NOW_DOING_WQ_NOT_ELIGIBLE"] = "당신의 파티는 이제 |c00bfffff%s|c00ffffff 전역 퀘스트를 수행합니다. 당신은 이 전역 퀘스트를 수행할 수 있는 조건을 충족하지 못했습니다."
L["WQGF_INIT_MSG"] = "파티를 찾으려면 임무 추적 창이나 세계 지도 상의 전역 퀘스트를 마우스 가운데 버튼으로 클릭하세요."
L["WQGF_JOINED_WQ_GROUP"] = "|c00bfffff%2$s|c00ffffff|1을;를; 위해 |c00bfffff%1$s|c00ffffff의 파티에 참여했습니다. 즐거운 시간되세요!"
L["WQGF_KICK_TOOLTIP"] = "너무 먼 곳에 있는 모든 플레이어를 추방합니다"
L["WQGF_LEADERS_BL_CLEARED"] = "파티장 차단 목록이 초기화 되었습니다."
L["WQGF_LEAVE"] = "떠나기"
L["WQGF_MEMBER_TOO_FAR_AWAY"] = "파티원 %s|1이;가; %s미터 떨어져 있습니다. 파티에서 제거하려면 자동 추방 버튼을 사용하세요."
L["WQGF_NEW_ENTRY_CREATED"] = "|c00bfffff%s|c00ffffff|1을;를; 위한 새로운 파티 찾기 항목이 생성되었습니다."
L["WQGF_NO"] = "아니오"
L["WQGF_NO_APPLICATIONS_ANSWERED"] = "|c00bfffff%s|c00ffffff|1을;를; 위한 당신의 신청 중 어떠한 것도 응답이 없었습니다. 새 파티를 찾고 있습니다..."
L["WQGF_NO_APPLY_BLACKLIST"] = "해당 파티장이 차단 목록에 있기 때문에 %d개 그룹에 신청하지 않았습니다. |c00bfffff/wqgf unbl|c00ffffff을 입력하여 차단 목록을 초기화할 수 있습니다."
L["WQGF_PLAYER_IS_NOT_LEADER"] = "당신은 파티장이 아닙니다."
L["WQGF_QUEST_COMPLETE_LEAVE_DIALOG"] = [=[퀘스트를 완료했습니다.

파티를 떠나시겠습니까?]=]
L["WQGF_QUEST_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[퀘스트를 완료했습니다.

파티를 떠나거나 파티 등록 취소를 하시겠습니까?]=]
L["WQGF_RAID_MODE_WARNING"] = "|c0000ffff경고:|c00ffffff 이 파티는 공격대 모드이므로 퀘스트와 전역 퀘스트를 완료할 수 없습니다. 가능하다면 당신은 공격대장에게 파티 모드로 전환하도록 요청해야 합니다. 당신이 공격대장이 되면 자동으로 파티 모드로 전환합니다."
L["WQGF_REFRESH_TOOLTIP"] = "다른 파티 찾기"
L["WQGF_SEARCH_OR_CREATE_GROUP"] = "파티 찾기 또는 만들기"
L["WQGF_SEARCHING_FOR_GROUP"] = "|c00bfffff%s|c00ffffff 전역 퀘스트 파티 찾는 중..."
L["WQGF_SEARCHING_FOR_GROUP_QUEST"] = "|c00bfffff%s|c00ffffff 퀘스트 파티 찾는 중..."
L["WQGF_SLASH_COMMANDS_1"] = "|c00bfffff슬래시 명령어 (/wqgf):"
L["WQGF_SLASH_COMMANDS_2"] = "|c00bfffff /wqgf config : 애드온 설정 열기"
L["WQGF_SLASH_COMMANDS_3"] = "|c00bfffff /wqgf unbl : 파티장 차단 목록 초기화"
L["WQGF_SLASH_COMMANDS_4"] = "|c00bfffff /wqgf toggle : 새로운 전역 퀘스트 지역 감지 사용 전환"
L["WQGF_START_ANOTHER_QUEST_DIALOG"] = [=[퀘스트 파티에 참여 중입니다.

다른 퀘스트를 시작하시겠습니까?]=]
L["WQGF_START_ANOTHER_WQ_DIALOG"] = [=[현재 전역 퀘스트 파티에 참여 중입니다.

다른 전역 퀘스트를 시작하시겠습니까?]=]
L["WQGF_STAY"] = "머물기"
L["WQGF_STOP_TOOLTIP"] = "이 전역 퀘스트 그만하기"
L["WQGF_TRANSLATION_INFO"] = "적셔줄게가 한국어로 번역했습니다"
L["WQGF_USER_JOINED"] = "World Quest Group Finder 사용자가 파티에 참여했습니다!"
L["WQGF_USERS_JOINED"] = "World Quest Group Finder 사용자들이 파티에 참여했습니다!"
L["WQGF_WQ_AREA_ENTERED_ALREADY_GROUPED_DIALOG"] = [=[새로운 전역 퀘스트 지역에 진입했지만 현재 다른 전역 퀘스트 파티에 속해있습니다.

현재 파티를 떠나고 "%s" 파티를 찾으시겠습니까?]=]
L["WQGF_WQ_AREA_ENTERED_DIALOG"] = [=[새로운 전역 퀘스트 지역에 진입했습니다.

"%s" 파티를 찾으시겠습니까?]=]
L["WQGF_WQ_COMPLETE_LEAVE_DIALOG"] = [=[전역 퀘스트를 완료했습니다.

파티를 떠나시겠습니까?]=]
L["WQGF_WQ_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[전역 퀘스트를 완료했습니다.

파티를 떠나거나 파티 등록 취소를 하시겠습니까?]=]
L["WQGF_WQ_GROUP_APPLY_CANCELLED"] = "|c00bfffff%$2s|c00ffffff|1을;를; 위한 |c00bfffff%1$s|c00ffffff의 파티에 신청을 취소했습니다. 다시 접속하거나 파티장 차단 목록을 초기화하기 전까지 WQGF는 이 파티에 다시는 참여 신청을 하지 않습니다."
L["WQGF_WQ_GROUP_DESCRIPTION"] = "World Quest Group Finder %s에 의해 자동으로 생성되었습니다."
L["WQGF_WRONG_LOCATION_FOR_WQ"] = "당신은 이 전역 퀘스트를 위한 올바른 지역에 있지 않습니다."
L["WQGF_YES"] = "예"
L["WQGF_ZONE_DETECTION_DISABLED"] = "새로운 전역 퀘스트 지역 감지는 이제 비활성화 됩니다."
L["WQGF_ZONE_DETECTION_ENABLED"] = "새로운 전역 퀘스트 지역 감지는 이제 활성화 됩니다."
