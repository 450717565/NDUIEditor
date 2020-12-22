local B, C, L, DB = unpack(select(2, ...))

----------------------------
-- 作者: 青玉的烟火
-- 修改：雨夜独行客
-- 感谢 NGA 公益社区提供的CD君
----------------------------

local cdList = {
	--"郑矢娜-战歌",
	--"永夜绽放之薇-艾森娜",
	--"尼尔-艾森娜",
	"Lau-太阳之井",
	"阿焦大做饭-希尔瓦娜斯",
	"安娜纳尼-瓦里安",
	"波雅丶汉库克-埃雷达尔",
	"蛋总的徒弟-刺骨利刃",
	"第三仙-轻风之语",
	"法治-战歌",
	"肥肥鱼-沃金",
	"工具法-瓦拉纳",
	"古南泉-白银之手",
	"罐子-冬寒",
	"红了眼眶-血色十字军",
	"谎言-加尔",
	"假中医-死亡之翼",
	"联盟预备-战歌",
	"萌闪闪-白银之手",
	"哞哞呜呜-瓦里安",
	"丿长空-凤凰之神",
	"千山云影-雷霆号角",
	"梢眉-安苏",
	"身体很诚实-罗宁",
	"聖殤-通灵学院",
	"时丶光-地狱咆哮",
	"噬魔者-图拉扬",
	"随心而遇-战歌",
	"甜果冻-阿古斯",
	"王权富贵-海加尔",
	"蚊飙-奥蕾莉亚",
	"想静静-贫瘠之地",
	"小小软-苏拉玛",
	"烟哥哥-瓦里安",
	"颜老师-风暴之鳞",
	"演员壹号-影之哀伤",
	"月娜-战歌",
	"昼极至夜-安苏",
	"子瓜-诺兹多姆",
}

local ticker
local whisperList = {}
local isClicked = false

local function updateWhisperList(_, text, name)
	if text == "1" then
		whisperList[name] = true
	elseif text == "0" then
		whisperList[name] = nil
	end
end
B:RegisterEvent("CHAT_MSG_WHISPER_INFORM", updateWhisperList)

local function updateInviteRequest(_, name)
	local realm = select(2, strsplit("-", name))
	if not realm then name = name.."-"..DB.MyRealm end

	if whisperList[name] then
		if ticker then
			ticker:Cancel()
			ticker = nil
		end

		for names in pairs(whisperList) do
			SendChatMessage("0", "WHISPER", nil, names)
		end

		UIErrorsFrame:AddMessage("|cff00FF00找到CD君，已退出其他CD君的队列...|r")

		isClicked = false
	end
end
B:RegisterEvent("PARTY_INVITE_REQUEST", updateInviteRequest)

local function Whisper_OnClick()
	if isClicked then return end

	local i = 1
	ticker = C_Timer.NewTicker(1, function()
		local name = cdList[i]
		if name then
			SendChatMessage("1", "WHISPER", nil, name)
			i = i + 1
		else
			ticker:Cancel()
			ticker = nil

			UIErrorsFrame:AddMessage("|cffFF0000没有找到CD君，请稍候再试...|r")
		end
	end)

	UIErrorsFrame:AddMessage("|cff00FF00开始逐一呼叫CD君，请稍候...|r")

	isClicked = true
end

local function Heroic_OnClick()
	if IsInGroup() then
		SendChatMessage("YX10", "PARTY")
	end
end

local function CDFrame_Create()
	local frame = CreateFrame("Frame", "CDFrame", UIParent)
	frame:SetSize(110, 35)
	frame:Hide()

	B.CreateBG(frame)
	B.Mover(frame, "CDFrame", "CDFrame", {"BOTTOMRIGHT", UIParent, -410, 30})

	local header = B.CreateFS(frame, 14, "革命者-1.421NX", true, "TOP", 0, 10)
	frame.Header = header

	local whisper = B.CreateButton(frame, 40, 20, "呼叫")
	whisper:SetPoint("RIGHT", frame, "CENTER", -5, 0)
	whisper:SetScript("OnClick", Whisper_OnClick)
	frame.Whisper = whisper

	local heroic = B.CreateButton(frame, 40, 20, "英雄")
	heroic:SetPoint("LEFT", frame, "CENTER", 5, 0)
	heroic:SetScript("OnClick", Heroic_OnClick)
	frame.Heroic = heroic
end
B:RegisterEvent("PLAYER_LOGIN", CDFrame_Create)

local function Automatic()
	if not C.db["Extras"]["FreeMountCD"] then return end

	if IsInInstance() then
		if CDFrame and CDFrame:IsShown() then
			CDFrame:Hide()
		end
	else
		if CDFrame and not CDFrame:IsShown() then
			CDFrame:Show()
		end
	end
end
B:RegisterEvent("PLAYER_ENTERING_WORLD", Automatic)