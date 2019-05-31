local _, ns = ...
local B, C, L, DB = unpack(ns)
if DB.Client ~= "zhCN" then return end

local strsplit, pairs = string.split, pairs

local hx = {
	"AuroraClassic更新到2.8.2；",
	"更新部分法术监控；",
	"添加特殊能量条移动提示；",
	"额外动作条按键的宏及快捷键字号调整；",
	"LibSharedMedia注册的一处错误修正；",
	"非治疗职业也将在边角指示器显示嗜血debuff；",
	"版本检测调整；",
	"稀有警报忽略联盟的激流堡战役；",
	"团队框体快速施法调整；",
	"更新猎人的默认快速施法设置；",
	"聊天复制窗口调整；",
	"控制台优化，添加数据的导入和导出；",
	"背包的摧毁模式现在也可以摧毁传家宝；",
	"添加社区的污染修正；",
	"更新头像等框体的标签；",
	"部分细节调整。",
}

local f
local function changelog()
	if f then f:Show() return end

	local alpha = NDuiDB["Extras"]["SkinAlpha"]
	local cr, cg, cb = DB.r, DB.g, DB.b
	f = CreateFrame("Frame", "NDuiChangeLog", UIParent)
	f:SetPoint("CENTER")
	f:SetScale(1.2)
	f:SetFrameStrata("HIGH")
	B.CreateMF(f)
	B.SetBackground(f)
	B.CreateFS(f, 30, "NDui", true, "TOPLEFT", 10, 27)
	B.CreateFS(f, 14, DB.Version, true, "TOPRIGHT", -10, 14)
	B.CreateFS(f, 16, L["Changelog"], true, "TOP", 0, -10)
	local ll = CreateFrame("Frame", nil, f)
	ll:SetPoint("TOPRIGHT", f, "TOP", 0, -35)
	B.CreateGF(ll, 100, C.mult*2, "Horizontal", cr, cg, cb, 0, alpha)
	ll:SetFrameStrata("HIGH")
	local lr = CreateFrame("Frame", nil, f)
	lr:SetPoint("TOPLEFT", f, "TOP", 0, -35)
	B.CreateGF(lr, 100, C.mult*2, "Horizontal", cr, cg, cb, alpha, 0)
	lr:SetFrameStrata("HIGH")
	local offset = 0
	for n, t in pairs(hx) do
		B.CreateFS(f, 12, n..L[":"]..t, false, "TOPLEFT", 15, -(50 + offset))
		offset = offset + 20
	end
	f:SetSize(400, 60 + offset)
	local close = B.CreateButton(f, 16, 16, "X")
	close:SetPoint("TOPRIGHT", -10, -10)
	close:SetScript("OnClick", function() f:Hide() end)
end

local function compareToShow(event)
	if HelloWorld then return end

	local old1, old2 = strsplit(".", NDuiADB["Changelog"].Version or "")
	local cur1, cur2 = strsplit(".", DB.Version)
	if old1 ~= cur1 or old2 ~= cur2 then
		changelog()
		NDuiADB["Changelog"].Version = DB.Version
	end

	B:UnregisterEvent(event, compareToShow)
end
B:RegisterEvent("PLAYER_ENTERING_WORLD", compareToShow)

SlashCmdList["NDUICHANGELOG"] = changelog
SLASH_NDUICHANGELOG1 = "/ncl"