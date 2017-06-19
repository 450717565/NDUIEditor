
local _, private = ...
local L = setmetatable({},{ __index = function(self, key) return key end, __call = function(self, key) return rawget(self, key) or key  end })
private.L = L

if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
    L["|cffcd1a1c[Grievous Helper]|r - "] = "|cffcd1a1c【网易有爱】|r- "
    L["all bags are full"] = "背包已满"
    L["enabled"] = "启用重伤助手"
    L["disabled"] = "停用重伤助手"
    L["artifacts taken off"] = "已自动取下神器"
    L["artifacts worn back"] = "重伤消失，自动穿回神器"
    L["click the button to put on artifacts in combat"] = "进入战斗，请点击中央按钮装备神器"
    L["not for healers"] = "治疗专精无法使用重伤脱装助手"
end