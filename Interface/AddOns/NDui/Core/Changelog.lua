local _, ns = ...
local B, C, L, DB = unpack(ns)
if DB.Client ~= "zhCN" then return end

local strsplit, pairs = string.split, pairs

local hx = {
	"AuroraClassic更新到3.1.5；",
	"垃圾社区邀请屏蔽列表更新；",
	"怀旧服的好友不再错误显示为可邀请状态；",
	"头像相关标签更新；",
	"修正团队框体的滚轮施法有时失效的问题；",
	"面板的精华图标添加等级颜色；",
	"世界频道按钮一处潜在错误修正；",
	"Rematch皮肤调整；",
	"信息条好友模块更新；",
	"破控通报的提示添加说明；",
	"更新部分失效的API；",
	"自动攻击计时条优化；",
	"更新部分法术监控；",
	"自动攻击计时条会响应玩家施法条的调整；",
	"小队监控的最大监控数量调整为4；",
	"添加小队技能监控的设置选项；",
	"控制台设置导入导出调整；",
	"控制台及本地文本更新。",
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
	if NDui_Tutorial then return end

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