local _, ns = ...
local B, C, L, DB = unpack(ns)
if DB.Client ~= "zhCN" then return end

local strsplit, pairs = string.split, pairs

local hx = {
	"AuroraClassic更新到2.2.9；",
	"信息条调整；",
	"@提醒修改为公会聊天提醒，不再需要@符号；",
	"控制台及技能监控控制台更新；",
	"团队框体减益不再检查增益；",
	"修复团队框体可驱散的过滤异常；",
	"稀有通报添加一个选项，仅在野外生效；",
	"团队框体增益指示器调整；",
	"团队框体添加召唤指示器；",
	"专业快捷标签添加大厨帽子；",
	"更新部分法术监控；",
	"宠物对战UI皮肤微调；",
	"声望列表调整对巅峰声望的显示，默认开启；",
	"优化插件的性能和占用；",
	"移除WQT的组队屏蔽；",
	"焦点框体现在只显示debuffs；",
	"优化血DK助手；",
	"更新oUF核心；",
	"任务通报的相关选项现在即时生效；",
	"给稀有警报添加新的提示音；",
	"美化BattlePetBreedID的提示框。",
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
	ll:SetPoint("TOP", -50, -35)
	B.CreateGF(ll, 100, C.mult*2, "Horizontal", cr, cg, cb, 0, alpha)
	ll:SetFrameStrata("HIGH")
	local lr = CreateFrame("Frame", nil, f)
	lr:SetPoint("TOP", 50, -35)
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