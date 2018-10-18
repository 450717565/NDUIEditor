local _, ns = ...
local B, C, L, DB = unpack(ns)
if DB.Client ~= "zhCN" then return end

local hx = {
	"AuroraClassic更新至1.10.6；",
	"更新技能及团本法术监控；",
	"现在会自动将DBM显示的法术加到姓名板白名单中；",
	"更新特殊目标染色列表；",
	"添加Details的皮肤；",
	"Skada皮肤微调；",
	"更新oUF核心，调整竞技场框体的名字获取；",
	"Alreadyknown调整，支持宠物的收集信息；",
	"背包调整，修复英文语系下背包分类异常的问题；",
	"暴雪框体的隐藏调整，防止污染；",
	"控制台优化，团队框体减益和快速施法有了独立窗口。",
	"部分选项调整为账号共享；",
	"本地文本更新；",
	"更新版本检测的逻辑。",
}

local f
local function changelog()
	if f then f:Show() return end

	local alpha = NDuiDB["Extras"]["SkinAlpha"]
	local cr, cg, cb = DB.CC.r, DB.CC.g, DB.CC.b
	f = CreateFrame("Frame", "NDuiChangeLog", UIParent)
	f:SetPoint("CENTER")
	f:SetScale(1.2)
	f:SetFrameStrata("HIGH")
	B.CreateMF(f)
	B.CreateBD(f)
	B.CreateSD(f)
	B.CreateTex(f)
	B.CreateFS(f, 30, "NDui", true, "TOPLEFT", 10, 27)
	B.CreateFS(f, 14, DB.Version, true, "TOPRIGHT", -10, 14)
	B.CreateFS(f, 16, L["Changelog"], true, "TOP", 0, -10)
	local ll = CreateFrame("Frame", nil, f)
	ll:SetPoint("TOP", -50, -35)
	B.CreateGF(ll, 100, 3, "Horizontal", cr, cg, cb, 0, alpha)
	ll:SetFrameStrata("HIGH")
	local lr = CreateFrame("Frame", nil, f)
	lr:SetPoint("TOP", 50, -35)
	B.CreateGF(lr, 100, 3, "Horizontal", cr, cg, cb, alpha, 0)
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

	local old1, old2 = string.split(".", NDuiADB["Changelog"].Version or "")
	local cur1, cur2 = string.split(".", DB.Version)
	if old1 ~= cur1 or old2 ~= cur2 then
		changelog()
		NDuiADB["Changelog"].Version = DB.Version
	end

	B:UnregisterEvent(event, compareToShow)
end
B:RegisterEvent("PLAYER_ENTERING_WORLD", compareToShow)

SlashCmdList["NDUICHANGELOG"] = changelog
SLASH_NDUICHANGELOG1 = "/ncl"