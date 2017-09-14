local lang = GetLocale()

SERVERHOP_HOPHELP = "Time interval in which your character won't be tranferred to already visited realm again."
SERVERHOP_NEXTREALM = "Next"
SERVERHOP_HOPPING = "Hopping..."
HOPADDON_LASTBUTTON = "Last"

HOPADDON_CHANGEMODE = "Change mode"
SERVERHOP_TOGGLE = "Show/hide addon window."


SERVERHOP_AUTOINVITE_OPTIONS = "Non auto-accept groups"
SERVERHOP_AUTOINVITE_TOOLTIP = "Allow addon to send applications to groups without auto-accept option set enabled. Leader of such groups has to invite you manually. You can set wait time duration for the invite in the slider below."
SERVERHOP_INBLACKLIST = "Visited: "
SERVERHOP_ANYSIZE = "Any size"

HOPADDON_LASTREALM = "Last realm:"

SERVERHOP_BLDURATION = "Ignore visited realms"

HOPADDON_NONSAVESETTING = "Resets on logout!"

HOPADDON_CREDITS = "Credits"
HOPADDON_AUTHOR = "Author: "
HOPADDON_AUTHORCONT = "Author's contacts:"
HOPADDON_TESTERS = "Contributors:"
HOPADDON_COMMUNITYTHANKS = "Big thanks to gaming community for spreading the addon!"
SERVERHOP_UPDATESTRING = "You can download the latest version of this addon, leave a suggestion or simply comment at:"

SERVERHOP_NOTIFCHECK = "Notifications in chat"
SERVERHOP_NOTIFTOOLTIP = "Allow addon to send messages in chat when you switch realms."

--v1.17
SERVERHOP_NEXTMACRO = 'Macro for "Next" button'
HOPADDON_LASTMACRO = 'Macro for "Last" button'
SERVERHOP_QUEUEWAITTIME = "Wait for invite"

SERVERHOP_CLEARBL = "Clear blacklist"
SERVERHOP_CLEARBL_QUESTION = "Do you want to remove all visited realms from the blacklist?"
SERVERHOP_MORE_IN_BL = "And %d more"

--v1.22
SERVERHOP_CLEARLEADERBL = "Clear ignored leaders"

-- v4.0.2
HOPADDON_ONLYMYZONE_CHECK = "Only current zone"

if lang == "zhCN" then
	SERVERHOP_HOPHELP = "设置位面冷却时间，可再次进入该位面。"
	SERVERHOP_NEXTREALM = "下一个"
	SERVERHOP_HOPPING = "进行..."
	HOPADDON_LASTBUTTON = "上次"
	HOPADDON_CHANGEMODE = "变换模式"
	SERVERHOP_TOGGLE = "窗口"
	SERVERHOP_AUTOINVITE_OPTIONS = "等待时间"
	SERVERHOP_AUTOINVITE_TOOLTIP = "设置对方邀请你的等待时间。"
	SERVERHOP_INBLACKLIST = "已跨位面: "
	SERVERHOP_ANYSIZE = "任意"
	HOPADDON_LASTREALM = "上次位面:"
	SERVERHOP_BLDURATION = "忽略位面的时间"
	HOPADDON_NONSAVESETTING = "重置!"
	HOPADDON_CREDITS = "支持"
	HOPADDON_AUTHOR = "作者: "
	HOPADDON_AUTHORCONT = "联系作者:"
	HOPADDON_TESTERS = "贡献者:"
	HOPADDON_COMMUNITYTHANKS = "感谢大家支持并扩展插件！"
	SERVERHOP_UPDATESTRING = "你可以到下面下载最新版，提出建议或评论。"
	SERVERHOP_NOTIFCHECK = "聊天提示"
	SERVERHOP_NOTIFTOOLTIP = "当位面变化时，在聊天界面显示提示。"
	--v1.17
	SERVERHOP_NEXTMACRO = '设置"下个位面"按钮宏'
	HOPADDON_LASTMACRO = '设置"上次位面"按钮宏'
	SERVERHOP_QUEUEWAITTIME = "等待邀请时间"
	SERVERHOP_CLEARBL = "清除已跨位面"
	SERVERHOP_CLEARBL_QUESTION = "要清除已跨过的位面吗？"
	SERVERHOP_MORE_IN_BL = "重复：%d个"
	--v1.22
	SERVERHOP_CLEARLEADERBL = "清除忽略对方"
	-- v4.0.2
	HOPADDON_ONLYMYZONE_CHECK = "暂时只有唯一位面"
elseif lang == "ruRU" then
	-- Hop Search
	SERVERHOP_HOPHELP = "Интервал, в течение которого персонаж не попадет на уже посещенный сервер еще раз."
	SERVERHOP_NEXTREALM = "Следующий"
	SERVERHOP_HOPPING = "Прыжок..."
	HOPADDON_LASTBUTTON = "Прошлый"

	HOPADDON_CHANGEMODE = "Сменить режим"
	SERVERHOP_TOGGLE = "Показать/скрыть окно аддона."

	SERVERHOP_UPDATESTRING = "Загрузить последнюю версию аддона, оставить пожелание или комментарий можно на сайте:"
	HOPADDON_AUTHOR = "Автор: "

	SERVERHOP_AUTOINVITE_OPTIONS = "Группы без автоприглашения"
	SERVERHOP_AUTOINVITE_TOOLTIP = "Подавать заявки в группы, в настройках которых не отмечена настройка автоматического приглашения игроков. Лидер таких групп обязан принять вас самостоятельно. Настроить время ожидания приглашения вы можете в ползунке ниже."
	SERVERHOP_INBLACKLIST = "Скачков:"

	SERVERHOP_ANYSIZE = "Все размеры"
	HOPADDON_LASTREALM = "Прошлый мир:"

	SERVERHOP_BLDURATION = "Игнорировать посещенные сервера"
	HOPADDON_NONSAVESETTING = "Сбрасывается при перезаходе!"

	HOPADDON_CREDITS = "Благодарности"
	HOPADDON_AUTHORCONT = "Контакты автора:"
	HOPADDON_TESTERS = "Помощники:"
	HOPADDON_COMMUNITYTHANKS = "Спасибо игровому сообществу за распространение аддона!"

	--v1.15
	SERVERHOP_NOTIFCHECK = "Уведомления в чате"
	SERVERHOP_NOTIFTOOLTIP = "Позволять аддону отправлять в чат сообщения о перемещении между серверами."

	--v1.17
	SERVERHOP_NEXTMACRO = 'Макрос для кнопки "Следующий"'
	HOPADDON_LASTMACRO = 'Макрос для кнопки "Прошлый"'
	SERVERHOP_QUEUEWAITTIME = "Ожидать приглашение"


	SERVERHOP_CLEARBL = "Очистить черный список"
	SERVERHOP_CLEARBL_QUESTION = "Вы точно хотите исключить все посещенные сервера из черного списка?"
	SERVERHOP_MORE_IN_BL = "И еще %d"

	SERVERHOP_CLEARLEADERBL = "Сброс игнорируемых лидеров"

	HOPADDON_ONLYMYZONE_CHECK = "Только текущая зона"

end