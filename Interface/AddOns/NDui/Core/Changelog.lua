local _, ns = ...
local B, C, L, DB = unpack(ns)

local strsplit, pairs = string.split, pairs
local cr, cg, cb = DB.cr, DB.cg, DB.cb

local hx = {
	"动作条添加已装备物品染色，默认关闭；",
	"界面美化更新支持9.1；",
	"Bigwigs美化更新；",
	"技能监控及新副本相关监控更新；",
	"技能监控自定义分组添加一个新的触发器；",
	"oUF库文件更新；",
	"聊天窗口背景调整；",
	"焦点框体显示可驱散buff；",
	"去除地图迷雾支持9.1新地图；",
	"移除部分潜在的内存泄漏；",
	"专业配方的鼠标提示信息显示调整；",
	"额外能量条仅在低于95%时显示；",
	"邮箱添加选项以保存上次收件人；",
	"对话自动交互功能更新；",
	"聊天过滤更新；",
	"修正边角指示器法术层数显示异常的问题；",
	"启用邮箱增强后，邮箱各元素位置调整；",
	"控制台及本地文本更新。",
}

local f
local function changelog()
	if f then f:Show() return end

	f = CreateFrame("Frame", "NDuiChangeLog", UIParent)
	f:SetPoint("CENTER")
	f:SetFrameStrata("HIGH")
	B.CreateBG(f)
	B.CreateMF(f)
	B.CreateFS(f, 18, DB.Version.." "..L["Changelog"], true, "TOP", 0, -10)
	B.CreateWaterMark(f)

	local ll = B.CreateGA(f, "H", cr, cg, cb, 0, C.alpha, 100, C.mult*2)
	ll:SetPoint("TOPRIGHT", f, "TOP", 0, -35)
	local lr = B.CreateGA(f, "H", cr, cg, cb, C.alpha, 0, 100, C.mult*2)
	lr:SetPoint("TOPLEFT", f, "TOP", 0, -35)

	local offset = 0
	for n, t in pairs(hx) do
		B.CreateFS(f, 14, n..". "..t, false, "TOPLEFT", 15, -(50 + offset))
		offset = offset + 24
	end
	f:SetSize(480, 60 + offset)

	local close = B.CreateButton(f, 20, 20, "X")
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