
local _, private = ...
local L = setmetatable({},{ __index = function(self, key) return key end, __call = function(self, key) return rawget(self, key) or key  end })
private.L = L

L["Enabled"] = "Enabled (auto toggle weapons), use /gh to disable."
L["Disabled"] = "Disabled, use /gh to enable."
if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
    local u1name = select(5, GetAddOnInfo("!!!163UI!!!")) and "网易有爱" or ""
    L["|cffcd1a1c[Grievous Helper]|r - "] = "|cffcd1a1c【" .. u1name .. "重伤助手】|r- " --君子勿动
    L["Enabled"] = "|cff00ff00已启用|r（自动切换武器，/zszs停用）by 桂花猫猫-暗影之月"
    L["Disabled"] = "|cffff0000已停用|r，/zszs启用"
    L["All bags are full"] = "背包已满"
    L["Weapons taken off"] = "自动取下神器"
    L["Weapons worn back"] = "自动穿回神器"
    L["Click the button to put on weapons in combat"] = "请点击中央按钮装备神器"
    L["Not for healers"] = "治疗专精无法使用重伤助手"
end