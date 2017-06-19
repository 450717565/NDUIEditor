local addonName, addonNamespace = ...

local AceLocale = LibStub and LibStub('AceLocale-3.0', true)
local L

if AceLocale then
    local defaultLocale = 'zhCN'

    local data = {
		zhCN = {
			ENCHANTED = "附魔:", -- Needs review
			["Unknown enchant %d"] = "未知附魔（ID）：%d",
			["Missing enchant"] = "缺失附魔",
			["Missing relic"] = "缺失圣物",
			["Missing gem"] = "缺失宝石",
			["Avg. equipped item level: %.1f (%d/%d)"] = "平均装备等级：%.1f (%d/%d)",
			["Avg. equipped item level: %.1f"] = "平均装备等级：%.1f",
		}
		or
        {},
    }

    local function RegisterLocale(locale, strings)
        local L = AceLocale:NewLocale(addonName, locale, locale == defaultLocale, true)

        if L then
            for key, translation in pairs(strings) do
                L[key] = translation
            end
        end
    end

    RegisterLocale(defaultLocale, data[defaultLocale])

    for locale, strings in pairs(data) do
        if locale ~= defaultLocale then
            RegisterLocale(locale, strings)
        end
    end

    L = AceLocale:GetLocale(addonName, true)
end

if not L then
    L = {}

    setmetatable(L, {
        __index = function(table, key)
            return key
        end
    })
end

addonNamespace.L = L
