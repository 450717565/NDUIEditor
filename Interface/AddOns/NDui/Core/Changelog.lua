local _, ns = ...
local B, C, L, DB = unpack(ns)
if DB.Client ~= "zhCN" then return end

local strsplit, pairs = string.split, pairs

local hx = {
	"界面美化更新；",
	"团队框体的目标边框微调；",
	"姓名板的目标框体调整；",
	"添加选项以调整头像及姓名板的平滑程度；",
	"更新部分技能监控；",
	"版本检测调整；",
	"组队邀请屏蔽按钮调整；",
	"UI缩放调整；",
	"PremadeGroupsFilter美化调整；",
	"鼠标提示中的图标裁剪大小调整；",
	"添加选项以显示装备的腐蚀等级；",
	"WA美化更新；",
	"修正团队框体可驱散边框层级；",
	"修正Buff尺寸大于40时的错误；",
	"优化目标装备及腐化信息的显示；",
	"修复麦卡贡无法添加副本减益的问题；",
	"添加新的职责图标材质；",
	"修复拍卖行某些情况无法上架的问题。",
}

local f
local function changelog()
	if f then f:Show() return end

	local alpha = NDuiDB["Extras"]["SLAlpha"]
	local cr, cg, cb = DB.r, DB.g, DB.b
	f = CreateFrame("Frame", "NDuiChangeLog", UIParent)
	f:SetPoint("CENTER")
	f:SetScale(1.2)
	f:SetFrameStrata("HIGH")
	B.CreateMF(f)
	B.SetBDFrame(f)
	B.CreateFS(f, 30, "NDui", true, "TOPLEFT", 10, 27)
	B.CreateFS(f, 14, DB.Version, true, "TOPRIGHT", -10, 14)
	B.CreateFS(f, 16, L["Changelog"], true, "TOP", 0, -10)
	local ll = CreateFrame("Frame", nil, f)
	ll:SetPoint("TOPRIGHT", f, "TOP", 0, -35)
	B.CreateGA(ll, 100, C.mult*2, "Horizontal", cr, cg, cb, 0, alpha)
	ll:SetFrameStrata("HIGH")
	local lr = CreateFrame("Frame", nil, f)
	lr:SetPoint("TOPLEFT", f, "TOP", 0, -35)
	B.CreateGA(lr, 100, C.mult*2, "Horizontal", cr, cg, cb, alpha, 0)
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