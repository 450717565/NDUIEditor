local _, ns = ...
local _, _, L = unpack(ns)
if GetLocale() ~= "ruRU" then return end
-- Credit: unw1s3
L["From"] = "Шепчет"
L["Tell"] = "Я шепчу"
L["Ghost"] = "Призрак"
L["Skip"] = "Пропустить"
L["Sort"] = "Сортировать"
L["Chat Copy"] = "%sКопировать|n%sМеню" --хз
L["Collect All"] = "Открыть все"
L["Collect Gold"] = "Собрать золото"
L["Collect Letters"] = "Получить"
L["Attach List"] = "Список вложений:"
L["Arch Count"] = "Статистика Археологии"
L["Rare"] = "Рарник"
L["Stack Cap"] = "Лимит пачки"
L["Lack"] = "Отсутствует"
L["Flask"] = "Фласка"
L["Food"] = "Еда"
L["World Channel"] = ""
L["Damage Poison"] = "Яды наносящие урон"
L["Effect Poison"] = "Яды с эффектами"
L["Raid Tool"] = "Управление Рейдом"
L["Disband Info"] = "Вы уверены что хотите |cffff0000распустить|r группу?"
L["Disband Process"] = "[NDui] Роспуск рейда"
L["Raid Buff Check"] = "[NDui] Проверка рейдовых бафов:"
L["Count Down"] = "Начать/Отменить отсчёт"
L["Check Status"] = "Проверить фласки и еду"
L["Buffs Ready"] = "[NDui] Все бафы готовы!"
L["DBM Required"] = "Вы не можете сделать этого без DBM или BigWigs."
L["Rare Found"] = "Рарник рядом！"
L["Wrong Difficulty"] = "Неверная сложность？"
L["ReloadUI Required"] = "Настройки заработают после перезагрузки интерфейса."
L["Default Settings Check"] = "Настройки по умолчанию загружены."
L["Chat Settings Check"] = "Настройки чата загружены"
L["UIScale Check"] = "Масштаб интерфейса загружен"
L["Tutorial Complete"] = "Настройки совместимых аддонов загружены.Вам необходимо перезагрузить интерфейс."
L["Tips"] = "Подсказка"
L["Version Info1"] = "загружено,"
L["Version Info2"] = "Введите команду"
L["Version Info3"] = "для помощи в работе с NDui."
L["Tutorial Page1"] = "Приветствую вас в обучении! Оно необходимо, чтобы облегчить вам настройку NDui.|n|nНажмите кнопку, чтобы установить некоторые настройки для NDui по умолчанию, включая индикаторы здоровья,панели команд, рамки рейда.|n|n|cffff0000Это настоятельно рекомендуется.|r"
L["Tutorial Page2"] = "Сейчас будут установлены соответствующие настройки для окна чата и |cffffcc00зафиксируется|r его положение по умолчанию.|n|nВы можете разблокировать его в |cffffcc00Настройки NDui-Чат|r.|n|n|cffff0000ВНИМАНИЕ:|r|n|n|cff00ccffВы можете прокрутить чат к началу или концу удерживая SHIFT.|n|nКнопки внизу окна чата помогут вам быстро начать набирать сообщение в необходимом канале.|r"
L["Tutorial Page3"] = "|cffff0000ВНИМАНИЕ: Эти настройки распространяются на весь аккаунт.|r|n|nСейчас произойдёт смена масштаба интерфейса на рекомендуемый.|n|nВы сможете его изменить в |cffffcc00Настройки NDui-Настройки UI|r позже."
L["Tutorial Page4"] = "|cffff0000ВНИМАНИЕ: Эти настройки распространяются на весь аккаунт.|r|n|nИ наконец, настройки Skada/DBM/BigWigs будут загружены после нажатия на кнопку Применить.|n|nВы можете отключить темы для них в |cffffcc00Настроки NDui-Темы|r."
L["Tutorial Page5"] = "Готово!Вы прошли обучение.|n|n|cffff0000ВНИМАНИЕ:|r|n|n|cff00ccffПКМ на миникарте открывает меню отслеживания;|n|nИ обратите внимание, что большинство инфо-панелей содержит дополнительные функции;|n|nВы можете легко взять в фокус нажатием SHIFT+ЛКМ на цели;|n|nБольшинство настроек можно изменить в |cffffcc00Настройки NDui|r.|r"
L["Help Title"] = "Помощь"
L["Help Info1"] = "Спасибо, что выбрали |cff0080ffNDui|r,"
L["Help Info2"] = "для вас есть следующие команды: "
L["Help Info5"] = "лёгкое назначение клавиш;"
L["Help Info6"] = "разблокировать элементы интерфейса;"
L["Help Info7"] = "перезагрузить все аддоны;"
L["Help Info9"] = "показать список изменений NDui (zhCN клиент)."
L["Help Info10"] = "Если это ваш первый раз использования |cff0080ffNDui|r,"
L["Help Info11"] = "пройдите обучение, нажав кнопку внизу."
L["Help Info12"] = "добавить новую AuraWatch;"
L["Tutorial"] = "Обучение"
L["Default Settings"] = "Настройки по умолчанию"
L["Changelog"] = "Список изменений"
L["Auto Quest"] = "Автоквест"
L["Main Actionbar"] = "Главная панель команд"
L["StanceBar"] = "Панель стоек"
L["Extrabar"] = "Дополнительная панель команд"
L["LeaveVehicle"] = "Кнопка выхода из транспорта"
L["Pet Actionbar"] = "Панель команд питомца"
L["Actionbar"] = "Панель команд"
L["Unitframes"] = "Рамки игроков"
L["Auras"] = "Ауры"
L["Raid Tools"] = "Уведомления"
L["ChatFrame"] = "Чат"
L["Maps"] = "Карты"
L["Nameplate"] = "Индик.здоровья"
L["Skins"] = "Темы"
L["Tooltip"] = "Подсказки"
L["Misc"] = "Дополнительно"
L["UI Settings"] = "Настройки UI"
L["Enable Actionbar"] = "Включить панели команд"
L["Actionbar Hotkey"] = "Показывать горячие клавиши"
L["Actionbar Macro"] = "Показывать макросы"
L["Actionbar Item Counts"] = "Показывать кол-во вещей"
L["ClassColor BG"] = "Фон классового цвета"
L["Show Cooldown"] = "Показывать время восстановления"
L["Actionbar Style"] = "Стиль панелей команд"
L["Actionbar Scale"] = "Масштаб панелей команд"
L["BarStyle1"] = "Стандартный стиль"
L["BarStyle2"] = "Правая панель"
L["BarStyle3"] = "Правая панель 3x4"
L["BarStyle4"] = "Главная панель 3x12"
L["BarStyle5"] = "Совместить панели"
L["Bar4 Fade"] = "Затухание 1й правой панели"
L["Bar5 Fade"] = "Затухание 2й правой панели"
L["Enable AuraWatch"] = "Включить Aurawatch"
L["AuraWatch ClickThrough"] = "Не показывать подсказки AuraWatch"
L["Enable Reminder"] = "Напоминания о бафах (Крик/Интеллект/Яд)"
L["Enable Totems"] = "Панель тотемов"
L["Totembar"] = "Панель тотемов"
L["Enable Statue"] = "Показывать статуи монаха"
L["Statue"] = "Статуя"
L["Enable UFs"] = "Включить рамки игроков"
L["UFs Portrait"] = "Показывать 3D портреты"
L["Player Debuff"] = "Показывать дебафы игрока"
L["ToT Debuff"] = "Показывать дебафы цели цели"
L["Boss Frame"] = "Показывать рамку Босса"
L["Arena Frame"] = "Показывать рамки арены"
L["UFs Castbar"] = "Включить полосы заклинаний"
L["UFs CombatText"] = "ПростойТекстБоя"
L["CombatText HotsDots"] = "Хоты и Доты"
L["CombatText ShowPets"] = "Урон/Отхил питомцев"
L["CombatText AutoAttack"] = "Урон от автоатак"
L["CombatText OverHealing"] = "Показывать оверхил"
L["CombatText"] = "ПростойТекстБоя"
L["UFs SwingBar"] = "Полоска замаха"
L["UFs SwingTimer"] = "Таймер полоски замаха"
L["UFs ClassPower"] = "Показывать классовый ресурс"
L["PlayerUF"] = "Рамка игрока"
L["TargetUF"] = "Рамка цели"
L["TotUF"] = "Рамка цели цели"
L["PetUF"] = "Рамка питомца"
L["FocusUF"] = "Рамка фокуса"
L["FotUF"] = "Рамка цели фокуса"
L["BossFrame"] = "Рамка Босса/Арены"
L["UFs RaidFrame"] = "Включить рамки рейда"
L["RaidFrameTip"] = "|nЕсли отключено, простые рамки рейда, группы и питомцев группы также будут отключены."
L["RaidFrame"] = "Рамки рейда"
L["Num Groups"] = "Показывать номера групп"
L["UFs AutoRes"] = "Автовоскрешение на СКМ"
L["RaidFrame TeamIndex"] = "Показывать номер группы"
L["Simple RaidFrame"] = "Простые рамки рейда (без аур)"
L["Dispellable Only"] = "Только снимаемые дебафы"
L["Instance Auras"] = "Показывать дебафы рейда"
L["RaidAuras ClickThrough"] = "Отключить подсказки аур"
L["ClassColor RaidFrame"] = "Рамки рейда классового цвета"
L["Horizon RaidFrame"] = "Горизонтальные рамки рейда"
L["SimpleMode Scale"] = "Масштаб простого режима"
L["SimpleMode SortByRole"] = "Сортировка по роли"
L["Show HealthPerc"] = "Показывать процент здоровья"
L["Spec RaidPos"] = "Сохранять позиции по специальностям"
L["Lock Chat"] = "Заблокировать настройки чата"
L["Chat Sticky"] = "Оставаться в /w если шепчетесь."
L["Whisper Invite"] = "Инвайт в шёпот"
L["Whisper Keyword"] = "Ключевое слово для инвайта"
L["Default Channel"] = "Стандартные имена каналов"
L["Guild Invite Only"] = "Принимать приглашение только из гильдии"
L["Easy Mark"] = "Быстрые метки на Ctrl+ЛКМ"
L["Timestamp"] = "Показывать время"
L["Enable Chatfilter"] = "Включить фильтр чата"
L["Block Addon Alert"] = "Блокировать уведомления аддона"
L["Keyword Match"] = "Кол-во совпадения для фильтра"
L["Filter List"] = "Список фильтра"
L["Map Coords"] = "Координаты на карте"
L["Minimap Clock"] = "Часы на миникарте"
L["Map Scale"] = "Масштаб карты мира"
L["Minimap Scale"] = "Масштаб миникарты"
L["Minimap Pulse"] = "Мигание окантовки миникарты"
L["Minimap RecycleBin"] = "Корзина иконок"
L["Show RecycleBin"] = "Корзина иконок на миникарте"
L["Show WhoPings"] = "Показывать кто пингует"
L["Enable Nameplate"] = "Включить индикаторы здоровья"
L["Tank Mode"] = "Танковская цветовая схема"
L["Friendly CC"] = "Классовый цвет индикаторов союзников"
L["Hostile CC"] = "Классовый цвет индикаторов врагов"
L["NP Width"] = "Ширина полосы"
L["NP Height"] = "Высота полосы"
L["NP VerticalSpacing"] = "Вертикальный отступ"
L["Max Auras"] = "Максимум аур"
L["Auras Size"] = "Размер аур"
L["Nameplate Distance"] = "Максимальная дистанция видимости индикаторов"
L["Nameplate InsideView"] = "Выделенный индикатор остаётся внутри"
L["CustomUnitColor"] = "Свой цвет своим целям"
L["Custom Color"] = "Сменить свой цвет"
L["UnitColor List"] = "Свой список целей"
L["ShowPowerList"] = "Свой список ресурсов"
L["DBM Skin"] = "Тема для DBM"
L["Micromenu"] = "Микроменю"
L["Menubar"] = "Полоса микроменю"
L["Bar Line"] = "Линии панелей команд"
L["Infobar Line"] = "Линии инфо-панели"
L["Chat Line"] = "Линии панели чата"
L["Menu Line"] = "Линии панели микроменю"
L["ClassColor Line"] = "Линии классового цвета"
L["Skada Skin"] = "Тема для Skada"
L["Bigwigs Skin"] = "Тема для BigWigs"
L["TMW Skin"] = "Тема для TellMeWhen"
L["WeakAuras Skin"] = "Тема для WeakAuras"
L["Bags"] = "Сумки"
L["Enable Bags"] = "Включить 'Сумки'"
L["Bags Scale"] = "Масштаб сумок"
L["Bags IconSize"] = "Размер слотов"
L["Bags Width"] = "Ширина сумок"
L["Bank Width"] = "Ширина банка"
L["Bags Itemlevel"] = "Показывать уровень предметов"
L["Bags ReverseSort"] = "Обратная сортировка"
L["Bags ItemFilter"] = "Фильтр предметов"
L["Raid Manger"] = "Управление рейдом"
L["Runes Check"] = "Проверка на руны"
L["Lock UIScale"] = "Автоустановка масштаба UI"
L["Countdown Sec"] = "Отсчёт в секундах"
L["Setup UIScale"] = "Настройка масштаба UI"
L["Hide Tooltip"] = "Скрывать подсказки в бою"
L["Follow Cursor"] = "Следовать за курсором"
L["Classcolor Border"] = "Классовый цвет окантовки"
L["Hide Rank"] = "Скрыть ранг в гильдии"
L["Hide Title"] = "Скрыть титул"
L["Hide Realm"] = "Название мира по нажатию на SHIFT"
L["FactionIcon"] = "Иконка фракции"
L["Group Roles"] = "Иконка выбранной роли"
L["Show TargetedBy"] = "Показывать кто выбрал целью"
L["Mail Tool"] = "Включить модуль почты"
L["Show ItemLevel"] = "Уровень предметов в окне персонажа"
L["Show MissingStats"] = "Полные хар-ки в окне персонажа"
L["Hide Error"] = "Скрывать ошибки"
L["Language Filter"] = "Выключить фильтр лексики"
L["SoloInfo"] = "Уведом. о сложности подземелий"
L["Rare Alert"] = "Уведомления о рарниках и событиях."
L["Alert In Chat"] = "Уведомлять в окне чата"
L["Easy Focus"] = "Быстро взять в фокус на Shift+ЛКМ"
L["Show Expbar"] = "Опыт/репутация у миникарты"
L["Auto ScreenShot"] = "Скриншот при достижении"
L["TradeTabs"] = "Упрощенное окно обмена"
L["Interrupt Alert"] = "Уведомления о прерывании и пр."
L["Own Interrupt"] = "Только личные прерывания"
L["Alert In Instance"] = "Только в неЛФГ группах"
L["Broken Spell"] = "Уведомления о сбивании СС"
L["BrokenSpellTip"] = "|nПредупреждать когда кто-то сбивает СС.|nнапр. Ослепление, Замораживающая ловушка, Превращение."
L["Interrupt"] = "Прервано - %s > %s"
L["Steal"] = "Украдено - %s > %s"
L["Dispel"] = "Рассеяно - %s > %s"
L["BrokenSpell"] = "Сбито - %s > %s"
L["QuestNotifier"] = "Включить уведомления о заданиях"
L["QuestProgress"] = "Уведомления о прогрессе заданий"
L["AcceptQuest"] = "Принимать задания"
L["Faster Loot"] = "Ускоренный сбор добычи"
L["No Talking"] = "Скрывать 'Говорящую голову'"
L["Hide Bossbanner"] = "Скрывать БоссБаннер"
L["Show PetFilter"] = "Показывать вкладки фильтра питомцев"
L["Numberize"] = "Нумеризация"
L["Number Type1"] = "Стандартная: b/m/k"
L["Number Type2"] = "Азиатская: y/w"
L["Number Type3"] = "Полностью цифровые"
L["NDui Reset"] = "Сбросить настройки"
L["Reset NDui Check"] = "Вы уверены что хотите сбросить все настройки?"
L["NDui Console"] = "Настройка NDui"
L["Damager Ring"] = "легендарное кольцо ДД"
L["Healer Ring"] = "легендарное кольцо Лекаря"
L["Tank Ring"] = "легендарное кольцо Танка"
L["Player Castbar"] = "Полоса заклинаний игрока"
L["Target Castbar"] = "Полоса заклинаний цели"
L["Focus Castbar"] = "Полоса заклинаний фокуса"
L["Get Out"] = "Прочь!"
L["Get Close"] = "Ближе!"
L["Stack Buying Check"] = "Вы точно хотите купить |cffff0000a штук|r этого?"
L["Details by Shift"] = "Удерживайте SHIFT для деталей"
L["Next Trait"] = "Следующий трейт"
L["Invite"] = "Пригласить"
L["Copy Name"] = "Скопировать имя"
L["Whisper"] = "Шепнуть"
L["Targeted By"] = "В цели у: "
L["Extend Instance"] = "Продлить все рейдовые сохранения"
L["Extend Instance Tip"] = "%sПродлить %sОтменить"
L["NumberCap1"] = "w"
L["NumberCap2"] = "y"
L["NumberCap3"] = "z"
L["Get Naked"] = "Кликните дважды, чтобы раздеться"
L["Mover Console"] = "NDui Mover"
L["Grids"] = "Клетки"
L["Reset Mover Confirm"] = "Вы уверены что хотите сбросить позиции рамок?"
L["AWConfig Title"] = "Настройка NDui AuraWatch"
L["Groups"] = "Группы"
L["Player Aura"] = "Аура Игрока"
L["Target Aura"] = "Аура Цели"
L["Special Aura"] = "Специальная Аура"
L["Focus Aura"] = "Аура Фокуса"
L["Spell Cooldown"] = "КД"
L["Enchant Aura"] = "Чары"
L["Raid Buff"] = "Рейдбаф"
L["Raid Debuff"] = "Рейддебаф"
L["Warning"] = "Внимание"
L["InternalCD"] = "Свой КД"
L["Type*"] = "Тип*"
L["Unit*"] = "Цель*"
L["Caster"] = "Кастер"
L["Stack"] = "Кол-во"
L["Value"] = "Значение"
L["Timeless"] = "Вечный"
L["Combat"] = "Бой"
L["Text"] = "Текст"
L["Slot*"] = "Слот*"
L["Totem*"] = "Тотем*"
L["AuraWatch List"] = "Свой список"
L["Choose a Type"] = "Нужно выбрать тип."
L["Incomplete Input"] = "Заполните все поля, отмеченные *."
L["Incorrect SpellID"] = "Неверный SpellID."
L["Existing ID"] = "Верный SpellID."
L["TotemSlot"] = "Слот Тотема"
L["Reset your AuraWatch List?"] = "Вы уверены что хотите удалить все свои группы?"
L["Type Intro"] = "|nAuraID: следит за статусом бафов\дебафов.|n|nSpellID: следит за кд заклинаний.|n|nSlotID: следит за кд вещей.|n|nTotemID: следит за длительностью установленных тотемов."
L["ID Intro"] = "|nSpell ID, должно быть числом.|n|nВы можете получить ID на подсказке к заклинанию.|n|nИмя заклинаний не поддерживается."
L["Unit Intro"] = "|nИнфо о цели заклинаний.|n|nplayer: цель - игрок.|n|ntarget: цель - ваша цель.|n|nfocus: цель - фокус.|n|npet: цель - питомец."
L["Caster Intro"] = "|nФильтр кастера заклинания.|n|nplayer: сотворено игроком.|n|ntarget: сотворено целью.|n|npet: сотворено питомцем.|n|nВсе ауры будут рассматриваться, если ничего не выбрано."
L["Stack Intro"] = "|nКол-во стаков заклинания, должно быть числом.|n|nЗаклинание показывается только достигнув этого кол-ва стаков.|n|nКол-во стаков будет игнорироваться, если ничего не выбрано."
L["Value Intro"] = "|nЕсли выбрано, то будет показываться значение заклинания.|n|ne.g. Щит Жреца будет показывать оставшееся кол-во поглощаемого урона.|n|nЭто имеет больший приоритет, чем ТЕКСТ."
L["Timeless Intro"] = "|nЕсли выбрано, то таймер заклинания будет скрыт."
L["Combat Intro"] = "|nЕсли выбрано, то заклинание будет показываться только в бою."
L["Text Intro"] = "|nПоказывает текст на заклинании.|n|nКогда заклинание активно, будет показан установленный текст.|n|nТекст будет скрыт, если установлено ЗНАЧЕНИЕ."
L["Slot Intro"] = "|nПоказывает кд вещей.|n|nнапр. Зачарование инженера на наручах или спине.|n|nПоддерживает только используемые аксессуары."
L["Totem Intro"] = "|nПоказывает длительность выбранного тотема."
L["IntID*"] = "Заклинания*"
L["IntID Intro"] = "|nSpellID, которое запускает таймер, должно быть числом.|n|nВы можете получить ID на подсказке к заклинанию.|n|nИмя заклинаний не поддерживается."
L["Duration*"] = "Длительность*"
L["Duration Intro"] = "|nДлительность запущенного таймера."
L["ItemID"] = "Имя"
L["ItemID Intro"] = "|nИмя предмета, таймер которого запущен.|n|nЕсли будет пустым, то это будет имя заклинания."
L["Paragon"] = "Идеал "
L["EdieBox Tip"] = "|nИспользуйте Пробел между ключевыми словами.|n|nНажмите Ввод для подтверждения."
L["RaidFrame Debuffs"] = "Свои рейдовые дебафы"
L["Instance*"] = "Подземелье*"
L["Instance Intro"] = "|nВыберите подземелье, к которому относится spellID."
L["Priority"] = "Приоритет"
L["Priority Intro"] = "|nПриоритет видимых заклинаний.|n|nКогда несколько заклинаний выбрано, оставляет только одно, с высшим приоритетом.|n|nПриоритет по умолчанию - 2.|n|nМаксимальный приоритет - 6,при этом иконка будет мигать."
L["Existing ClickSet"] = "КликСет используется."
L["Invalid Input"] = "Неверная функция КликСета."
L["Action*"] = "Действие*"
L["Action Intro"] = "|nВыберите действие для рамок рейда.|n|n'target': выбрать целью.|n|n'focus': взять в фокус.|n|n'follow': следовать.|n|nчисла, spellID для произнесения заклинания.|n|nмакрос: можете вписать текст макроса.|nЕсли макрос многострочный, используйте ~ чтобы разделить его.|n|nМожно использовать один макрос для разных спеков:|n/cast [@mouseover,spec1]XXX;[@mouseover,spec2]XXX"
L["Key*"] = "Кнопка*"
L["Key Intro"] = "|nВыберите кнопку мыши для произнесения заклинания.|n|nЛучше не использовать ЛКМ и СКМ без модификаторов"
L["Modified Key"] = "Модификатор"
L["ModKey Intro"] = "|nВыберите сочетание клавиш для произнесения заклинания.|n|nЛучше не использовать SHIFT+ЛКМ."
L["Enable ClickSets"] = "Включить КликСет для рамок рейда"
L["Add ClickSets"] = "Добавить КликСеты"
L["Reset your click sets?"] = "Вы уверены что хотите сбросить КликСеты?"
L["AW Fel"] = "Желчь"
L["AW Light"] = "Свет"
L["Version Check"] = "Проверка версии NDui"
L["Outdated NDui"] = "  |cff0080ffNDui|r устарел, последняя версия - |cff70C0F5%s|r"
L["Fire Side"] = "Огонь"
L["Shadow Side"] = "Тьма"
L["Minimap"] = "Миникарта"
L["Equipement Set"] = "Предметы комплекта экипировки"
L["Use ItemSetFilter"] = "Фильтр комплектов экипировки"
L["ItemSetFilterTips"] = "|nЕсли выбрано, то фильтр экипиковки будет заменён фильтром комплектов экипировки."
L["NFG"] = "Не согильдиец"
L["Used"] = "Использовано"
L["Currency Panel"] = "Открыть валюты"
L["AutoSell Junk"] = "Автопродажа хлама"
L["Selljunk Calculate"] = "Вы продали хлам на"
L["D"] = "Пр"
L["Low Durability"] = "Вашим вещам требуется ремонт!"
L["Hands"] = "Кисти рук"
L["Feet"] = "Ступни"
L["Player Panel"] = "Открыть окно персонажа"
L["Auto Repair"] = "Автопочинка"
L["Guild repair"] = "Стоимость ремонта покрыла гильдия."
L["Repair cost"] = "Ремонт обошёлся в"
L["Repair error"] = "О боги! Да у Вас кончились деньги!"
L["Earned"] = "Заработано"
L["Spent"] = "Потрачено"
L["Deficit"] = "Расход"
L["Profit"] = "Доход"
L["Session"] = "Сессия:"
L["Character"] = "Персонажи в этом мире:"
L["Hidden"] = "Скрыто"
L["Hold Shift"] = "Удерживайте <Shift>"
L["Default UI Memory Usage:"] = "Стандартное использование памяти:"
L["Total Memory Usage:"] = "Всего использовано памяти:"
L["Collect Memory"] = "Очистить память"
L["My Position"] = "Мои координаты"
L["System"] = "Система"
L["FPS"] = "FPS"
L["Latency"] = "Задержка"
L["Home Latency"] = "Локальная задержка"
L["World Latency"] = "Глобальная задержка"
L["CPU Usage"] = "Показать использование ЦП"
L["Are you sure to reset the gold count?"] = "Вы уверены, что хотите сбросить значения золота?"
L["WoW"] = "World of Warcraft"
L["BN"] = "Battle.NET"
L["SpecPanel"] = "Окно талантов"
L["Change Spec"] = "Специальность"
L["Reset Gold"] = "Сбросить значения"
L["Toggle Calendar"] = "Календарь"
L["Toggle Clock"] = "Часы"
L["WorldMap"] = "Карта"
L["Send My Pos"] = "Отправить координаты"
L["No Online"] = "Нет друзей онлайн."
L["Timewarped"] = "500 Искаженных временем знаков"
L["Mean One"] = "Зимний покров"
L["Blingtron"] = "Запечатанный подарок Блескотрона"
L["Legion Invasion"] = "Вторжения Легиона"
L["Current Invasion"] = "Текущее: "
L["Next Invasion"] = "Следующее: "
L["Local Time"] = "Местное время:"
L["Realm Time"] = "Серверное время:"
L["Section"] = "Раздел"
L["AW Switcher"] = "Блокировать ауры"
L["Trigger"] = "Триггер"
L["Trigger Intro"] = "|nДобавить триггер к таймеру кд.|n|nАура получена: срабатывает при получении ауры.|n|nКаст успешен: Срабатывает при успешном применении заклинания."
L["Trigger Unit Intro"] = "|nВыбрать цель для триггера.|n|nИгрок: проверяет только ваши ауры и заклинания.|n|nВсе: проверяет ауры и заклинания всех членов группы или рейда."
L["Azerite Armor"] = "Азеритовая броня"
L["Mouse"] = "Мышь"
L["PlayerNP"] = "Личная панель"
L["Enable PlayerPlate"] = "Показывать личную панель"
L["Tooltip Scale"] = "Масштаб подсказок"
L["Differ WhipserColor"] = "Различить цвета шёпота вам и от вас"
L["Map Reveal"] = "Без тумана войны"
L["Zone Ability"] = "Кнопка способности зоны"
L["Enable ClassAuras"] = "Классовые ауры на панели"
L["PlayerPlate HPHeight"] = "Ширина полос ресурса и здоровья"
L["PlayerPlate MPHeight"] = "Высота полосы ресурса"
L["AuraWatch IconScale"] = "Масштаб иконок AuraWatch"
L["PlayerPlate PowerText"] = "Показывать значение ресурса"
L["OnlyCompleteRing"] = "Только звук завершения"
L["Stranger"] = "Незнакомец"
L["Reverse RaidFrame"] = "Обратить рамки рейда"
L["Show AzeriteArmor"] = "Показывать инфо о азеритовой броне"
L["Show FullHealth"] = "Показывать значение здоровья"
L["WheelUp"] = "КолёсикоВверх"
L["WheelDown"] = "КолёсикоВниз"
L["Wheel"] = "Колёсико"
L["ExplosivesScale"] = "Масштаб индикаторов для сфер"
L["DPS Revert Threat"] = "Обратить цвета, если не танк"
L["Secure Color"] = "Безопасный цвет"
L["Trans Color"] = "Переходный цвет"
L["Insecure Color"] = "Небезопасный"
L["WhiteList"] = "Белый список аур на полосах здоровья"
L["BlackList"] = "Чёрный список аур на полосах здоровья"
L["Details Skin"] = "Тема для Details"
L["Reset your raiddebuffs list?"] = "Вы уверены что хотите восстановить стандартный список?"
L["Flash"] = "Свечение"
L["Flash Intro"] = "|nЕсли выбрано, будет подсвечивать иконку."
L["Show SpecLevelByShift"] = "Спек и УП по нажатию SHIFT"
L["Instance Type"] = "|nВыберите тип подземелья, к которому относится ID."
L["Dungeons Intro"] = "|nВыберите подземелья, к которым относится ID."
L["Raid Intro"] = "|nВыберите рейды, к которым относится ID."
L["ExplosiveCount"] = "Кол-во сфер - "
L["Explosive Alert"] = "Кол-во сфер в M+"
L["UFs QuakeTimer"] = "Показывать таймер землетрясений"
L["QuakeTimer"] = "Таймер землетрясений"
L["Castbar LagString"] = "Задержка на полосе заклинаний"
L["Crit"] = "Крит"
L["Haste"] = "Скорость"
L["Mastery"] = "Искусность"
L["Versa"] = "Универсальность"
L["Option* Tips"] = "Настройки не отмеченные звёздочкой (*) требуют перезагрузки UI."
L["Place item"] = "%s поставил %s"
L["Placed Item Alert"] = "Уведом. о поставленной еде/котле"
L["ExRT Potioncheck"] = "Проверка препотов"
L["Prio Editbox"] = "|nПриорите в пределах 1-6.|n|nНажмите Ввод для подтверждения."
L["Player Count"] = "%s игроков"
L["BfA Invasion"] = "Нападения фракий"
L["UFs RuneTimer"] = "Таймер рун рыцаря смерти"
L["RaidBuffIndicator"] = "Показывать угловой индикатор бафов"
L["RaidBuffIndicatorTip"] = "|nЕсли не выбрано, бафы на рамках рейда будут отфильтровываться через настройки углового индикатора бафов."
L["BuffIndicatorType"] = "Тип индикатора бафов"
L["BuffIndicatorScale"] = "Масштаб индикатора бафов"
L["BI_Blocks"] = "Квадраты"
L["BI_Icons"] = "Иконки"
L["BI_Numbers"] = "Числа"
L["TOPLEFT"] = "Левый верх"
L["TOP"] = "Верх"
L["TOPRIGHT"] = "Правый верх"
L["LEFT"] = "Лево"
L["RIGHT"] = "Право"
L["BOTTOMLEFT"] = "Левый низ"
L["BOTTOM"] = "Низ"
L["BOTTOMRIGHT"] = "Правый низ"
L["RaidBuffWatch"] = "Настроить Auras Watch"
L["BuffIndicator"] = "Настроить угловой индикатор бафов"
L["RareAlertInWild"] = "Не уведомлять в подземельях"
L["ParagonRep"] = "Идеалы в окне репутаций"
L["HideJunkGuild"] = "Сокращенное имя гильдии"
L["PlayerPlate IconSize"] = "Размер иконки игрока"
L["Freeze"] = "Заморозить"
L["Move"] = "Двигать"
L["PGF Skin"] = "Тема для PremadeGroupsFilter"
L["Texture Style"] = "Стиль текстур"
L["Highlight"] = "Светлый"
L["Gradient"] = "Градиент"
L["Flat"] = "Плоский"
L["Combo"] = "Комбо"
L["AttackSpeed"] = "AS"
L["CD"] = "КД"
L["Strike"] = "SS"
L["Power"] = "PW"
L["UFs PartyFrame"] = "Отдельная рамка группы"
L["PartyFrame"] = "Рамки группы"
L["UFs PartyWatcher"] = "Показывать PartyWatcher"
L["PartyWatcherOnRight"] = "Сменить положение иконок"
L["AngryKeystones Progress"] = "Прогресс AngryKeystones"
L["HideCooldownOnWA"] = "Скрыть КД в WA"
L["Fadeout OOC"] = "Видим только в бою"
L["Account Keystones"] = "Ваш эпохальный ключ"
L["AutoBubbles"] = "Автоматические пузырьки в рейде"
L["HealthColor"] = "Цвет полосы здоровья"
L["Default Dark"] = "Стандартный тёмный"
L["ClassColorHP"] = "Классовый цвет"
L["GradientHP"] = "Процентный градиент"
L["Uunat Alert"] = "Разлом забвения Уу'ната"
L["UunatAlertString"] = "%s шаг в разломе забвения за %d (с)."
L["Bags DeleteButton"] = "Добавить кнопку удаления"
L["DeleteMode Enabled"] = "|nВы можете удалить удерживая CTRL+ALT. Предмет может быть наследуемым или качеством ниже редкого (синего)."
L["ItemDeleteMode"] = "Режим удаления"
L["Trait"] = "Трейт"
L["Drag AltBar Tip"] = "Вы можете свободно перемещать полоску альтернативного ресурса."
L["Data Info"] = "Данные"
L["Version"] = "Версия"
L["Character"] = "Персонаж"
L["Import"] = "Импорт"
L["Import Header"] = "Импорт настроек NDui"
L["Import data error"] = "Ошибка импорта из-за исключения данных."
L["Import data warning"] = "Вы точно хотите импортировать настройки?"
L["Export"] = "Экспорт"
L["Export Header"] = "Экспорт настроек NDui"
L["Data Exception"] = "Ошибка экспорта"
L["Rematch Skin"] = "Тема для Rematch"
L["ResetCPUUsage"] = "Сброс использования ЦП"
L["Rotation"] = "Ротация"
L["SystemInfoType"] = "Информация"
L["ReverseBuffs"] = "Бафы слева направо"
L["ReverseDebuffs"] = "Дебафы слева направо"
L["BuffSize"] = "Размер бафов"
L["DebuffSize"] = "Размер дебафов"
L["BuffsPerRow"] = "Бафов в строке"
L["DebuffsPerRow"] = "Дебафов в строке"
L["DeprecatedAuras"] = "Ауры из предыдущих дополнений"
L["QuestTracker"] = "Окно отслеживания заданий"
L["VehicleSeat"] = "Места в транспорте"
L["Join or Invite"] = "Вступить или пригласить"
L["RaidHPMode"] = "Здоровье рейда"
L["DisableRaidHP"] = "Отключить здоровье"
L["RaidHPPercent"] = "Здоровье в процентах"
L["RaidHPCurrent"] = "Оставшееся здоровье"
L["RaidHPLost"] = "Потерянное здоровье"
L["AlertFrames"] = "Рамка уведомлений"
L["UIWidgetFrame"] = "UIWidgetBelowMinimapContainerFrame"
L["Horizon PartyFrame"] = "Горизонтальная рамка группы"
L["Nameplate ClassPower"] = "На индикаторе здоровья цели"
L["MaxPowerGlow"] = "Свечение при полном ресурсе"
L["OffTank Color"] = "ОфТанк"
L["Armor icons only"] = "Скрыть описание ресурса"
L["ShowChatItemLevel"] = "Показывать уровень предметов в окне чата"
L["NameTextSize"] = "Размер шрифта имени"
L["HealthTextSize"] = "Размер шрифта здоровья"
L["Nameplate MinScale"] = "Масштаб не активных индикаторов здоровья"
L["Nameplate MinAlpha"] = "Прозрачность не активных индикаторов здоровья"
L["TargetIndicator"] = "Настройка индикаторов цели"
L["TopArrow"] = "Стрелка вверху"
L["RightArrow"] = "Стрелка справа"
L["TargetGlow"] = "Свечение"
L["TopNGlow"] = "Стрелка вверху+свечение"
L["RightNGlow"] = "Стрелка справа+свечение"
L["ColorBorder"] = "Цвет окантовки аур"
L["QuestIndicator"] = "Индикатор прогресса заданий"
L["Minimap Calendar"] = "Календарь у миникарты"
L["Show GemNEnchant"] = "Зачарования и камни"
L["ShowChatbar"] = "Панель чата"
L["Chatbar"] = "Панель каналов"
L["UnitFrame Size"] = "Размер рамок"
L["Health Width"] = "Ширина здоровья"
L["Health Height"] = "Высота здоровья"
L["Power Height"] = "Высота ресурса"
L["Player&Target"] = "Игрок и цель"
L["Pet&*Target"] = "Питомец и цель"
L["Boss&Arena"] = "Босс и Арена"
L["LockChatWidth"] = "Зафиксировать ширину чата"
L["LockChatHeight"] = "Зафиксировать высоту чата"
L["FavouriteMode"] = "Предпочтения"
L["FavouriteMode Enabled"] = "|nВы можете помечать предметы.|nЕсли 'Фильтр предметов' включен, отмеченные предметы будут перемещены в отдельную категорию.|nНеприменимо к хламу."
L["DisableInfobars"] = "Отключитель все инфо-панели"
L["FreeSlots"] = "Свободно слотов"
L["Bags GatherEmpty"] = "Собирать пустые слоты в один"
L["Castbar Settings"] = "Настройки полосы заклинаний"
L["Castbar Colors"] = "Цвета полосы заклинаний"
L["Interruptible Color"] = "Цвет прерываемого"
L["NotInterruptible Color"] = "Цвет не прерываемого"
L["Castbar Width"] = "Ширина полосы заклинаний"
L["Castbar Height"] = "Высота полосы заклинаний"
L["StupidShiftKey"] = "Ваш SHIFT возможно запал."
L["Reset Details check"] = "Вы уверены что хотите сбросить тему для Details?"
L["FilterListTip"] = "|nОтфильтровывает сообщения, содержащие эти слова."
L["CustomUnitTips"] = "|nВведите имя напрямую."
L["AddPartyWatcher"] = "Заклинания для PartyWatcher (Максимум 6)"
L["Cooldown*"] = "Время восстановления*"
L["Cooldown Intro"] = "|nВведите время восстановления заклинаний.|n|nPartywatcher поддерживает только обычные заклинания и способности.|n|nДля заклинаний наподобие 'Дух дикой природы' (Охотник), невозможен точный подсчёт."
L["SwingTimer Tip"] = "|nПоказывать длительность на полосе замаха."
L["QuakeRing"] = "Уведомление при землетрясении в M+"
L["AuraWatch"] = "AuraWatch"
L["AuraWatchToggleError"] = "Вы не можете спрятать якорь AuraWatch"
L["Reset anchor"] = "Сбросить якорь"
L["Hide panel"] = "Спрятать панель"
L["HideUFWarning"] = "|nЕсли не выбрано,то будут также отключена полоса заклинаний и ПростойТекстБоя."
L["Bags ShowNewItem"] = "Подсвечивать новые предметы"
L["UFTextScale"] = "Масштаб текста рамок"
L["InstantDelete"] = "Авто заполнять 'УДАЛИТЬ' при удалении"
L["PartyPetFrame"] = "Рамка питомцев группы"
L["UFs PartyPetFrame"] = "Показывать питомцев группы"
L["ToggleDirection"] = "Переключить направление"
L["Show AzeriteTraits"] = "Показывать азеритовые таланты"
L["ContactList"] = "Контакты"
L["QuickSplit"] = "Разделить"
L["SplitCount"] = "Кол-во"
L["SplitMode Enabled"] = "|nЩелкните, чтобы разделить пачку в сумках. Вы можете изменить кол-во, которое хотите отделить, в поле ввода."
L["SpecialBagsColor"] = "Цветные 'специальные' сумки"
L["SpecialBagsColorTip"] = "|nВыделять цветом специальные сумки:|n- Сумка травника|n- Сумка шахтёра|n- Сумка ювелира|n- Сумка зачаровывателя"
L["iLvlToShow"] = "Минимальный уровень предметов"
L["iLvlToShowTip"] = "|nПоказывать УП только, если он выше этого значения."
L["RaidFrame Size"] = "Размер рамок рейда"
L["RaidDebuffScale"] = "Масштаб дебафов рейда"
L["Flat Mode"] = "Плоский стиль кнопок"
L["Skin Shadow"] = "Тень фона"
L["Backdrop Alpha"] = "Прозрачность темы"
L["Font Outline"] = "Контур глобального шрифта"
L["ChatBubbles"] = "Сменить тему пузырьков чата"
L["DefaultBagsTips"] = "|nВам надо отключить 'Сумки' также."
L["BlizzardSkins"] = "Сменить стандартную тему"
L["BlizzardSkinsTips"] = "|nЕсли выключено, большинству окон будет возвращён оригинальный вид Близзард.|n|nИ также, темы для Rematch и PremadeGroupsFilter будут отключены."
L["AuroraClassic warning"] = "Прежде чем мы начнём, отключите аддон Aurora или AuroraClassic."
L["BlockStranger"] = "Блокировать ЛС от незнакомцев"
L["BlockStrangerTip"] = "|nЕсли выбрано, то принимать сообщения только от членов гильдии, группы, рейда или друзей"
L["LesserVision"] = "Малое видение Н'Зота"
L["UFs PartyAltPower"] = "Альт.ресурс группы"
L["BlockWQT"] = "Кнопка блокировки инвайтов"
L["DeclineNBlock"] = "Отклонить и заблокировать"
L["DeclineNBlockTips"] = "|nБлокирует автоматические инвайты из говёного WorldQuestTracker, действует только на эту сессию."
L["BagFilterSetup"] = "Настройка фильтра сумок"
L["FilterJunk"] = "Фильтр хлама"
L["FilterAzerite"] = "Фильтр азеритовой брони"
L["FilterEquipment"] = "Фильтр экипировки"
L["FilterConsumble"] = "Фильтр расходуемого"
L["FilterLegendary"] = "Фильтр легендарок"
L["FilterMount"] = "Фильтр транспорта и питомцев"
L["FilterFavourite"] = "Фильтр предпочтительного"
L["FilterGoods"] = "Хозяйственные товары"
L["Max Rank"] = "Макс.ранг"
L["SmoothAmount"] = "Smooth Frequency" -- need translation
L["SmoothAmountTip"] = "|nSetup healthbar smooth frequency for unitframes and nameplates.|nThe lower the smoother." -- need translation
L["ShowCorruptionRank"] = "Show corruption rank" -- need translation
L["ShowAllTip"] = "|nIf unchecked, you can only see the aura you cast.|n|nIf checked, the aura would be tracked from all casters." -- need translation