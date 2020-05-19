local _, ns = ...
local B, C, L, DB = unpack(ns)
if DB.Client ~= "zhCN" then return end

local strsplit, pairs = string.split, pairs

local hx = {
	"腐蚀信息显示调整；",
	"目标观察面板显示腐蚀信息；",
	"更新部分技能监控；",
	"聊天时间戳调整；",
	"稀有提示调整；",
	"控制台及本地文本更新；",
	"聊天栏的装备链接添加腐蚀标记；",
	"添加小队同步任务的标记；",
	"目标框体的等级显示调整；",
	"界面美化更新；",
	"姓名板的施法条调整；",
	"添加雷铸调和符文的缺失监控；",
	"移除拒绝并屏蔽按钮；",
	"添加选项以屏蔽陌生人邀请；",
	"鼠标提示调整；",
	"登录游戏时现在会显示插件logo；",
	"对大幻象中的部分怪物姓名板进行染色。",
}

local f
local function changelog()
	if f then f:Show() return end

	local cr, cg, cb = DB.r, DB.g, DB.b
	f = CreateFrame("Frame", "NDuiChangeLog", UIParent)
	f:SetPoint("CENTER")
	f:SetScale(1.2)
	f:SetFrameStrata("HIGH")
	B.CreateMF(f)
	B.CreateBG(f)
	B.CreateFS(f, 30, "NDui", true, "TOPLEFT", 10, 27)
	B.CreateFS(f, 14, DB.Version, true, "TOPRIGHT", -10, 14)
	B.CreateFS(f, 16, L["Changelog"], true, "TOP", 0, -10)
	local ll = CreateFrame("Frame", nil, f)
	ll:SetPoint("TOPRIGHT", f, "TOP", 0, -35)
	B.CreateGA(ll, 100, C.mult*2, "Horizontal", cr, cg, cb, 0, DB.Alpha)
	ll:SetFrameStrata("HIGH")
	local lr = CreateFrame("Frame", nil, f)
	lr:SetPoint("TOPLEFT", f, "TOP", 0, -35)
	B.CreateGA(lr, 100, C.mult*2, "Horizontal", cr, cg, cb, DB.Alpha, 0)
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