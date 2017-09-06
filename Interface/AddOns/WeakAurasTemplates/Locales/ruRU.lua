if not(GetLocale() == "ruRU") then
  return
end

local L = WeakAuras.L

-- WeakAuras/Templates
	L[" (Channeling)"] = "(Потоковое)"
	L[" (Healing received increase)"] = "(Увеличение входящего исцеления)"
	L["- Any"] = "- Любой"
	--Translation missing 
	-- L["- Death Knight 2P Bonus"] = ""
	--Translation missing 
	-- L["- Death Knight T20 Blood 2P Bonus"] = ""
	--Translation missing 
	-- L["- Death Knight Unholy 4P Bonus"] = ""
	L["- Deathknight 2P Bonus"] = " - Бонус от 2-х частей комплекта, Рыцарь смерти"
	L["- Deathknight Unholy 4P Bonus"] = "- Бонус от 4-х частей комплекта, Рыцарь смерти (Нечестивость)"
	L["- Holy Word: Chastise"] = " - Слово Света: Наказание"
	L["- Holy Word: Sanctify"] = "- Слово Света: Освящение"
	L["- Holy Word: Serenity"] = "- Слово Света: Безмятежность"
	--Translation missing 
	-- L["- Hunter T20 Marksman 4P Bonus"] = ""
	--Translation missing 
	-- L["- Mage T20 Arcane 2P Bonus"] = ""
	--Translation missing 
	-- L["- Mage T20 Fire 2P Bonus"] = ""
	--Translation missing 
	-- L["- Mage T20 Frost 2P Bonus"] = ""
	--Translation missing 
	-- L["- Monk T20 Mistweaver 2P Bonus"] = ""
	L["- Monk Windwalker 4P Bonus"] = " - Бонус от 4-х частей комплекта, Монах (Танцующий с ветром)"
	L["- Paladin Protection 2P Bonus"] = " - Бонус от 2-х частей комплекта, Паладин (Защита)"
	L["- Paladin Retribution 2P Bonus"] = " - Бонус от 2-х частей комплекта, Паладин (Воздаяние)"
	L["- Paladin T19 Retribution 4P Bonus"] = " - Бонус от 4-х частей комплекта Т19, Паладин (Воздаяние)"
	--Translation missing 
	-- L["- Paladin T20 Holy 4P Bonus"] = ""
	--Translation missing 
	-- L["- Paladin T20 Protection 4P Bonus"] = ""
	--Translation missing 
	-- L["- Paladin T20 Retribution 4P Bonus"] = ""
	--Translation missing 
	-- L["- Priest T20 Discipline 4P Bonus"] = ""
	--Translation missing 
	-- L["- Priest T20 Shadow 2P Bonus"] = ""
	L["- Rogue Assassination/Outlaw 4P Bonus"] = " - Бонус от 4-х частей комплекта, Разбойник (Ликвидация)"
	L["- Rogue Subtlety 4P Bonus"] = " - Бонус от 4-х частей комплекта, Разбойник (Скрытность)"
	L["- Rogue T19 Outlaw 4P Bonus"] = " - Бонус от 4-х частей комплекта Т19, Разбойник (Головорез)"
	L["- Shaman Elemental 4P Bonus"] = " - Бонус от 4-х частей комплекта, Шаман (Стихии)"
	L["- Shaman Enhancement 2P Bonus"] = " - Бонус от 2-х частей комплекта, Шаман (Совершенствование)"
	--Translation missing 
	-- L["- Shaman T20 Elemental 2P Bonus"] = ""
	--Translation missing 
	-- L["- Shaman T20 Enhancement 2P Bonus"] = ""
	--Translation missing 
	-- L["- Shaman T20 Enhancement 4P Bonus"] = ""
	--Translation missing 
	-- L["- Shaman T20 Restoration 2P Bonus"] = ""
	--Translation missing 
	-- L["- Shaman T20 Restoration 4P Bonus"] = ""
	L["- T19 Druid Guardian 4P Bonus"] = " - Бонус от 4-х частей комплекта Т19, Друид (Страж)"
	L["- Warlock Affliction 4P/Demonology 2P Bonus"] = " - Бонус от 4-х частей комплекта, Чернокнижник (Колдовство) / Бонус от 2-х частей комплекта, Чернокнижник (Демонология)"
	L["- Warlock T19 Destruction 4P Bonus"] = "- Бонус от 4-х частей комплекта Т19, Чернокнижник (Разрушение)"
	--Translation missing 
	-- L["- Warlock T20 Affliction 4P Bonus"] = ""
	--Translation missing 
	-- L["- Warlock T20 Demonology 4P Bonus"] = ""
	L["- Warrior 2P Bonus"] = "- Бонус от 2-х частей комплекта, Воин"
	L["- Warrior T19 Fury 2P Bonus"] = "- Бонус от 2-х частей комплекта Т19, Воин (Неистовство)"
	--Translation missing 
	-- L["- Warrior T20 Fury 2P Bonus"] = ""
	--Translation missing 
	-- L["- Warrior T20 Protection 2P Bonus"] = ""
	L["(Pet)"] = "(Питомец)"
	L["(Water Elemental)"] = "(Водный элементаль)"
	L["Ability Charges"] = "Способность расходуется"
	L["Add Triggers"] = "Добавить триггеры"
	L["Always Active"] = "Всегда активен"
	L["Back"] = "Назад"
	L["Bleed"] = "Кровотечение"
	L["BloodLust/Heroism"] = "Кровожадность / Героизм"
	--Translation missing 
	-- L["Bloodlust/Heroism"] = ""
	L["buff"] = "бафф"
	L["Buff"] = "Бафф"
	L["Buffs"] = "Баффы"
	L["Cancel"] = "Отмена"
	L["Cast"] = "Каст"
	--Translation missing 
	-- L["Concordance of the Legionfall"] = ""
	L["cooldown"] = "кулдаун (задержка)"
	L["Cooldowns"] = "Кулдаун (задержка)"
	L["Crimson Vial Item Count"] = "Подсчитать использование предмета \"Алый фиал\""
	--Translation missing 
	-- L["Damage Trinkets"] = ""
	L["debuff"] = "дебафф"
	L["Debuffs"] = "Дебафф"
	L["Enchants"] = "Чары"
	L["General"] = "Общий"
	--Translation missing 
	-- L["Healer Trinkets"] = ""
	L["Health"] = "Здоровье"
	L["Keeps existing triggers intact"] = "Сохранить существующие триггеры нетронутыми"
	L["Legendaries"] = "Легендарные"
	--Translation missing 
	-- L["Legion Sets"] = ""
	L["Nimble Brew Item Count"] = "Подсчитать использование предмета \"Отвар проворства\""
	L["Pet alive"] = "Живой питомец"
	L["Pet Behavior"] = "Поведение питомца"
	L["PVP Set"] = "Комплект PvP"
	L["PvP Talents"] = "Талант PvP"
	L["PVP Trinkets"] = "Аксессуары PvP"
	L["Replace all existing triggers"] = "Заменить все существующие триггеры"
	L["Replace Triggers"] = "Заменить триггеры"
	L["Resources"] = "Ресурсы"
	L["Resources and Shapeshift Form"] = "Форма Друида и ресурсы"
	--Translation missing 
	-- L["Rooted"] = ""
	L["Runes"] = "Руны"
	L["Shapeshift Form"] = "Форма Друида"
	L["Slowed"] = "Замедлять"
	L["Stagger"] = "Колебание"
	L["Stun"] = "Оглушение"
	L["T19 Damage Trinkets"] = "Аксессуары Т19, роль \"Боец\" "
	L["T19 Healer Trinkets"] = "Аксессуары Т19, роль \"Лекарь\" "
	L["T19 Sets"] = "Комплекты Т19"
	L["T19 Tank Trinkets"] = "Аксессуары Т19, роль \"Танк\" "
	--Translation missing 
	-- L["Tank Trinkets"] = ""
	L["Totem"] = "Тотем"
	L["Totems"] = "Тотемы"
	L["Unknown Item"] = "Неизвестный предмет"
	L["Unknown Spell"] = "Неизвестное заклинание"

