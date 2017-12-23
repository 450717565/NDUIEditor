local L = LibStub("AceLocale-3.0"):NewLocale("WorldQuestGroupFinder", "ruRU") 
if not L then return end 
L = L or {}
L["WQGF_ADDON_DESCRIPTION"] = "Упрощает поиск игроков для выполнения локальных заданий используя \"Заранее собранные группы\""
L["WQGF_ALREADY_IS_GROUP_FOR_WQ"] = "Вы уже находитесь в группе для выполнения этого локального задания."
L["WQGF_ALREADY_QUEUED_BG"] = "Вы состоите в поиске поля боя. Пожалуйста покиньте очередь и повторите снова."
L["WQGF_ALREADY_QUEUED_DF"] = "Вы состоите в поиске подземелья. Пожалуйста покиньте очередь и повторите снова."
L["WQGF_ALREADY_QUEUED_RF"] = "Вы состоите в поиске рейда. Пожалуйста покиньте очередь и повторите снова."
L["WQGF_APPLIED_TO_GROUPS"] = "Было отправлено |c00bfffff%d|c00ffffff заявок для локального задания |c00bfffff%s|c00ffffff."
L["WQGF_APPLIED_TO_GROUPS_QUEST"] = "Было отправлено |c00bfffff%d|c00ffffff заявок для задания |c00bfffff%s|c00ffffff."
L["WQGF_AUTO_LEAVING_DIALOG"] = [=[Вы выполнили локальное задание и покинете группу через %d секунд.

Скажите до свидания!]=]
L["WQGF_AUTO_LEAVING_DIALOG_QUEST"] = [=[Вы выполнили задание и покинете группу через %d секунд.

Скажите до свидания!]=]
L["WQGF_CANCEL"] = "Отменить"
L["WQGF_CANNOT_DO_WQ_IN_GROUP"] = "Данное задание не может быть выполнено в группе."
L["WQGF_CANNOT_DO_WQ_TYPE_IN_GROUP"] = "Данный тип локального задания не может быть выполнен в составе группы."
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_ENABLE"] = "Автоматически принимать приглашения в WQGF группы вне боя"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_HOVER"] = "Будет автоматически принимать приглашения в группу когда вы находитесь вне боя"
L["WQGF_CONFIG_AUTO_ACCEPT_INVITES_TITLE"] = "Принимать приглашение в группу автоматически"
L["WQGF_CONFIG_AUTOINVITE"] = "Автоматическое приглашение"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE"] = "Приглашать всех игроков"
L["WQGF_CONFIG_AUTOINVITE_EVERYONE_HOVER"] = "Все заявки в группу будут одобрены до достижения лимита в 5 игроков"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS"] = "Автоматическое приглашение пользователей WQGF"
L["WQGF_CONFIG_AUTOINVITE_WQGF_USERS_HOVER"] = "Пользователи World Quest Group Finder будут автоматически приглашены в вашу группу"
L["WQGF_CONFIG_BINDING_ADVICE"] = "Помните, что вы можете назначить WQGF на клавишу в меню WoW Key Bindings!"
L["WQGF_CONFIG_LANGUAGE_FILTER_ENABLE"] = "Искать для любых языковых групп (игнорируя выбор языков в ЗСГ)"
L["WQGF_CONFIG_LANGUAGE_FILTER_HOVER"] = "Будет всегда искать группы пользователей с любом языком вне зависимости от выбора"
L["WQGF_CONFIG_LANGUAGE_FILTER_TITLE"] = "Языковой фильтр для поиска группы"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE"] = "WQGF успешно загружен"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_ENABLE"] = "Скрывать сообщение инициализации WQGF при загрузке"
L["WQGF_CONFIG_LOGIN_MESSAGE_TITLE_HOVER"] = "Больше не отображать сообщение WQGF при загрузке"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_ENABLE"] = "Начинать поиск автоматически, если игрок не состоит в группе"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_AUTO_HOVER"] = "Группа будет автоматически найдена при вхождении в новую зону локального задания"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_ENABLE"] = "Включить обнаружение новой квестовой зоны локального задания"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_HOVER"] = "При вхождении в новую зону локального задания, будет предложено найти группу"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_SWITCH_ENABLE"] = "Не будет предложено, если вы уже находитесь в группе для выполнения другого локального задания"
L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_TITLE"] = "Предложение найти группу, когда вы входите в зону локального квеста впервые"
L["WQGF_CONFIG_PAGE_CREDITS"] = "Предоставлено для вас Robou, EU-Hyjal"
L["WQGF_CONFIG_PARTY_NOTIFICATION_ENABLE"] = "Включить уведомление группы"
L["WQGF_CONFIG_PARTY_NOTIFICATION_HOVER"] = "Сообщение будет отправлено в чат группы по завершению выполнения локального задания"
L["WQGF_CONFIG_PARTY_NOTIFICATION_TITLE"] = "Уведомлять группу когда локальное задание выполнено"
L["WQGF_CONFIG_PVP_REALMS_ENABLE"] = "Предотвратить присоединение к группам на PvP серверах"
L["WQGF_CONFIG_PVP_REALMS_HOVER"] = "Будет предотвращать присоединение к группам на PvP серверах (этот параметр будет игнорироваться для персонажей на PvP серверах)"
L["WQGF_CONFIG_PVP_REALMS_TITLE"] = "PvP сервера"
L["WQGF_CONFIG_QUEST_SUPPORT_ENABLE"] = "Включить поддержку для обычных квестов"
L["WQGF_CONFIG_QUEST_SUPPORT_HOVER"] = "Включение опции позволит отображать кнопку поиска групп для поддерживаемых обычных квестов"
L["WQGF_CONFIG_QUEST_SUPPORT_TITLE"] = "Поддержка обычных квестов"
L["WQGF_CONFIG_SILENT_MODE_ENABLE"] = "Включить режим тишины"
L["WQGF_CONFIG_SILENT_MODE_HOVER"] = "Когда режим тишины включен, только самые важные WQGF сообщения будут отображены"
L["WQGF_CONFIG_SILENT_MODE_TITLE"] = "Режим тишины"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_ENABLE"] = "Автоматически покидать группу через 10 секунд"
L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_HOVER"] = "Вы будете автоматически покидать группу через 10 секунд, когда локальное задание выполнено"
L["WQGF_CONFIG_WQ_END_DIALOG_ENABLE"] = "Отобразить диалог по завершению локального задания"
L["WQGF_CONFIG_WQ_END_DIALOG_HOVER"] = "Вам будет предложено покинуть группу или остановить набор, когда локальное задание выполнено"
L["WQGF_CONFIG_WQ_END_DIALOG_TITLE"] = "Отобразить диалог для выхода из группы после выполнения локального задания"
L["WQGF_DEBUG_CONFIGURATION_DUMP"] = "Пользовательская конфигурация:"
L["WQGF_DEBUG_CURRENT_WQ_ID"] = "Текущий ID квеста |c00bfffff%s"
L["WQGF_DEBUG_MODE_DISABLED"] = "Режим отладки отключен."
L["WQGF_DEBUG_MODE_ENABLED"] = "Режим отладки активирован."
L["WQGF_DEBUG_NO_CURRENT_WQ_ID"] = "Неизвестное локальное задание."
L["WQGF_DEBUG_WQ_ZONES_ENTERED"] = "Квестовые зоны посещенные за данную сессию:"
L["WQGF_DELIST"] = "Отписать группу"
L["WQGF_DROPPED_WB_SUPPORT"] = "Поддержка заданий с ворлд боссами была отключена в WQGF 0.21.3. Пожалуйста, используйте стандартную кнопку в интерфейсе, чтобы найти группу. "
L["WQGF_FIND_GROUP_TOOLTIP"] = "Найти группу"
L["WQGF_FIND_GROUP_TOOLTIP_2"] = "Клик колесом мыши для создания новой группы"
L["WQGF_FRAME_ACCEPT_INVITE"] = "Нажмите кнопку, чтобы присоединиться к группе"
L["WQGF_FRAME_APPLY_DONE"] = "Вы зарегистрировались  во всех доступных группах"
L["WQGF_FRAME_CLICK_TWICE"] = "Нажмите кнопку %d раз(а), что бы создать новую группу."
L["WQGF_FRAME_CREATE_WAIT"] = "Вы можете создать новую группу, если не будет доступных"
L["WQGF_FRAME_FOUND_GROUPS"] = "Найдено групп (%d)\\nКликните по кнопке для подтверждения."
L["WQGF_FRAME_GROUPS_LEFT"] = "%d групп осталось, продолжайте нажимать!"
L["WQGF_FRAME_INIT_SEARCH"] = "Нажмите кнопку, чтобы инициализировать поиск."
L["WQGF_FRAME_NO_GROUPS"] = "Ни одной группы не найдено.\\nНажмите кнопку для создания новой группы"
L["WQGF_FRAME_RELIST_GROUP"] = "Нажмите кнопку, чтобы добрать группу"
L["WQGF_FRAME_SEARCH_GROUPS"] = "Нажмите на кнопку для поиска группы."
L["WQGF_GLOBAL_CONFIGURATION"] = "Глобальная конфигурация:"
L["WQGF_GROUP_CREATION_ERROR"] = "При попытке создания новой группы произошла ошибка."
L["WQGF_GROUP_NO_LONGER_DOING_QUEST"] = "Ваша группа больше не выполняет задание |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NO_LONGER_DOING_WQ"] = "Ваша группа больше не выполняет локальное задание |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_QUEST"] = "Ваша группа на данный момент выполняет задание |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_QUEST_ALREADY_COMPLETE"] = "Ваша группа выполняет задание |c00bfffff%s|c00ffffff. Вы уже выполнили данное задание."
L["WQGF_GROUP_NOW_DOING_QUEST_NOT_ELIGIBLE"] = "Ваша группа на данный момент выполняет задание |c00bfffff%s|c00ffffff. Вы не соответствуете требованиям для выполнения задания."
L["WQGF_GROUP_NOW_DOING_WQ"] = "Ваша группа сейчас выполняет локальное задание |c00bfffff%s|c00ffffff."
L["WQGF_GROUP_NOW_DOING_WQ_ALREADY_COMPLETE"] = "Ваша група сейчас выполняет локальное задание |c00bfffff%s|c00ffffff. Вы уже выполнили данное задание."
L["WQGF_GROUP_NOW_DOING_WQ_NOT_ELIGIBLE"] = "Ваша группа сейчас выполняет локальное задание |c00bfffff%s|c00ffffff. Вы не удовлетворяете условиям для выполнения данного задания."
L["WQGF_INIT_MSG"] = "Кликните средней кнопкой мыши по локальному заданию в списке, чтобы найти группу."
L["WQGF_JOINED_WQ_GROUP"] = "Вы присоединились к группе |c00bfffff%s|c00ffffff для выполнения локального задания |c00bfffff%s|c00ffffff. Развлекайтесь !"
L["WQGF_KICK_TOOLTIP"] = "Выгнать игроков, которые слишком далеко"
L["WQGF_LEADERS_BL_CLEARED"] = "Черный список лидеров групп был очищен."
L["WQGF_LEAVE"] = "Покинуть"
L["WQGF_MEMBER_TOO_FAR_AWAY"] = "Член группы %s на расстоянии %s ярдов. Используйте кнопку автокика, чтобы удалить его из группы."
L["WQGF_NEW_ENTRY_CREATED"] = "Новая группа была создана для выполнения локального задания |c00bfffff%s|c00ffffff."
L["WQGF_NO"] = "Нет"
L["WQGF_NO_APPLICATIONS_ANSWERED"] = "Истекло время для ответа на запрос для выполнения задания |c00bfffff%s|c00ffffff. Пытаемся найти новую группу..."
L["WQGF_NO_APPLY_BLACKLIST"] = "Вы не отправили заявку в %d групп, поскольку игнорируете их лидеров. Вы можете использовать |c00bfffff/wqgf unbl |c00ffffffчтобы очистить список."
L["WQGF_PLAYER_IS_NOT_LEADER"] = "Вы не являетесь лидером группы."
L["WQGF_QUEST_COMPLETE_LEAVE_DIALOG"] = [=[Вы выполнили задание.
Желаете покинуть группу?]=]
L["WQGF_QUEST_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[Вы выполнили задание.
Желаете покинуть группу или отписать ее?]=]
L["WQGF_RAID_MODE_WARNING"] = "|c0000ffffПРЕДУПРЕЖДЕНИЕ:|c00ffffff Группа находится в режиме рейда, вы не сможете выполнять локальные квесты. Попросите лидера изменить тип группы. Тип группы будет изменен автоматически, если вы станете ее лидером."
L["WQGF_REFRESH_TOOLTIP"] = "Найти другую группу"
L["WQGF_SEARCH_OR_CREATE_GROUP"] = "Найти или создать новую группу для выполнения задания."
L["WQGF_SEARCHING_FOR_GROUP"] = "Ищем группу для локального задания |c00bfffff%s|c00ffffff..."
L["WQGF_SEARCHING_FOR_GROUP_QUEST"] = "Ищем группу для задания |c00bfffff%s|c00ffffff..."
L["WQGF_SLASH_COMMANDS_1"] = "|c00bfffffСлеш команды (/wqgf):"
L["WQGF_SLASH_COMMANDS_2"] = "|c00bfffff /wqgf config : Открыть конфигурацию аддона"
L["WQGF_SLASH_COMMANDS_3"] = "|c00bfffff /wqgf unbl : Очистить черный список лидеров группы"
L["WQGF_SLASH_COMMANDS_4"] = "|c00bfffff /wqgf toggle : Включить обнаружение новых зон для локальных заданий"
L["WQGF_START_ANOTHER_QUEST_DIALOG"] = [=[Вы состоите в группе для выполнения другого задания.

Желаете начать выполнение нового задания?]=]
L["WQGF_START_ANOTHER_WQ_DIALOG"] = [=[Вы состоите в группе для выполнения другого локального задания.

Желаете начать выполнение нового задания?]=]
L["WQGF_STAY"] = "Остаться"
L["WQGF_STOP_TOOLTIP"] = "Остановить выполнение локального задания"
L["WQGF_TRANSLATION_INFO"] = "Перевод выполнен Минтерм (EU-Soulflayer)"
L["WQGF_USER_JOINED"] = "Пользователь World Quest Group Finder присоединился к группе!"
L["WQGF_USERS_JOINED"] = "Пользователи World Quest Group Finder присоединились к группе!"
L["WQGF_WQ_AREA_ENTERED_ALREADY_GROUPED_DIALOG"] = [=[Вы вошли в новую зону локального задания, но вы уже состоите в группе для другого задания.

Желаете ли найти другую группу для "%s"?]=]
L["WQGF_WQ_AREA_ENTERED_DIALOG"] = [=[Вы вошли в новую зону локального задания.

Желаете найти группу для "%s"?]=]
L["WQGF_WQ_COMPLETE_LEAVE_DIALOG"] = [=[Вы выполнили локальное задание.

Желаете покинуть группу?]=]
L["WQGF_WQ_COMPLETE_LEAVE_OR_DELIST_DIALOG"] = [=[Вы выполнили локальное задание.

Желаете покинуть или прекратить набор в группу?]=]
L["WQGF_WQ_GROUP_APPLY_CANCELLED"] = "Вы отменили предложение |c00bfffff%s|c00ffffff для |c00bfffff%s|c00ffffff. WQGF не будет пытаться найти группу до тех пор, пока вы не сделаете релог или не очистите черный список лидеров групп."
L["WQGF_WQ_GROUP_DESCRIPTION"] = "Создано автоматически аддоном World Quest Group Finder %s."
L["WQGF_WRONG_LOCATION_FOR_WQ"] = "Вы находитесь в неподходящей локации для выполнения данного локального задания."
L["WQGF_YES"] = "Да"
L["WQGF_ZONE_DETECTION_DISABLED"] = "Обнаружение новых зон заданий отключено."
L["WQGF_ZONE_DETECTION_ENABLED"] = "Обнаружение новых зон заданий включено."
