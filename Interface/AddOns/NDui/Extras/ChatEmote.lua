-------------------------------------
-- 聊天表情
-- Author:M
-------------------------------------

local _, ns = ...
local B, C, L, DB = unpack(ns)
local EX = B:GetModule("Extras")
local cr, cg, cb = DB.cr, DB.cg, DB.cb

local locale = GetLocale()
local patch = "Interface\\AddOns\\NDui\\Media\\Emote\\"

-- key為圖片名
local emotes = {
	{ key = "0", zhCN = "微笑", zhTW = "微笑" },
	{ key = "1", zhCN = "害羞", zhTW = "害羞" },
	{ key = "2", zhCN = "吐舌头", zhTW = "吐舌頭" },
	{ key = "3", zhCN = "偷笑", zhTW = "偷笑" },
	{ key = "4", zhCN = "爱慕", zhTW = "愛慕" },
	{ key = "5", zhCN = "大笑", zhTW = "大笑" },
	{ key = "6", zhCN = "跳舞", zhTW = "跳舞" },
	{ key = "7", zhCN = "飞吻", zhTW = "飛吻" },
	{ key = "8", zhCN = "安慰", zhTW = "安慰" },
	{ key = "9", zhCN = "抱抱", zhTW = "抱抱" },
	{ key = "10", zhCN = "加油", zhTW = "加油" },
	{ key = "11", zhCN = "胜利", zhTW = "勝利" },
	{ key = "12", zhCN = "强", zhTW = "強" },
	{ key = "13", zhCN = "亲亲", zhTW = "親親" },
	{ key = "14", zhCN = "花痴", zhTW = "花癡" },
	{ key = "15", zhCN = "露齿笑", zhTW = "露齒笑" },
	{ key = "16", zhCN = "查找", zhTW = "查找" },
	{ key = "17", zhCN = "呼叫", zhTW = "呼叫" },
	{ key = "18", zhCN = "算账", zhTW = "算賬" },
	{ key = "19", zhCN = "财迷", zhTW = "財迷" },
	{ key = "20", zhCN = "好主意", zhTW = "好主意" },
	{ key = "21", zhCN = "鬼脸", zhTW = "鬼臉" },
	{ key = "22", zhCN = "天使", zhTW = "天使" },
	{ key = "23", zhCN = "再见", zhTW = "再見" },
	{ key = "24", zhCN = "流口水", zhTW = "流口水" },
	{ key = "25", zhCN = "享受", zhTW = "享受" },
	{ key = "26", zhCN = "猥琐", zhTW = "猥瑣" },
	{ key = "27", zhCN = "呆", zhTW = "呆" },
	{ key = "28", zhCN = "思考", zhTW = "思考" },
	{ key = "29", zhCN = "迷惑", zhTW = "迷惑" },
	{ key = "30", zhCN = "疑问", zhTW = "疑問" },
	{ key = "31", zhCN = "没钱了", zhTW = "沒錢了" },
	{ key = "32", zhCN = "无聊", zhTW = "無聊" },
	{ key = "33", zhCN = "怀疑", zhTW = "懷疑" },
	{ key = "34", zhCN = "嘘", zhTW = "噓" },
	{ key = "35", zhCN = "小样", zhTW = "小樣" },
	{ key = "36", zhCN = "摇头", zhTW = "搖頭" },
	{ key = "37", zhCN = "感冒", zhTW = "感冒" },
	{ key = "38", zhCN = "尴尬", zhTW = "尷尬" },
	{ key = "39", zhCN = "傻笑", zhTW = "傻笑" },
	{ key = "40", zhCN = "不会吧", zhTW = "不會吧" },
	{ key = "41", zhCN = "无奈", zhTW = "無奈" },
	{ key = "42", zhCN = "流汗", zhTW = "流汗" },
	{ key = "43", zhCN = "凄凉", zhTW = "淒涼" },
	{ key = "44", zhCN = "困了", zhTW = "困了" },
	{ key = "45", zhCN = "晕", zhTW = "暈" },
	{ key = "46", zhCN = "忧伤", zhTW = "憂傷" },
	{ key = "47", zhCN = "委屈", zhTW = "委屈" },
	{ key = "48", zhCN = "悲泣", zhTW = "悲泣" },
	{ key = "49", zhCN = "大哭", zhTW = "大哭" },
	{ key = "50", zhCN = "痛哭", zhTW = "痛哭" },
	{ key = "51", zhCN = "服了", zhTW = "服了" },
	{ key = "52", zhCN = "对不起", zhTW = "對不起" },
	{ key = "53", zhCN = "告别", zhTW = "告別" },
	{ key = "54", zhCN = "皱眉", zhTW = "皺眉" },
	{ key = "55", zhCN = "好累", zhTW = "好累" },
	{ key = "57", zhCN = "吐", zhTW = "吐" },
	{ key = "58", zhCN = "背", zhTW = "背" },
	{ key = "59", zhCN = "惊讶", zhTW = "驚訝" },
	{ key = "60", zhCN = "惊愕", zhTW = "驚愕" },
	{ key = "61", zhCN = "闭嘴", zhTW = "閉嘴" },
	{ key = "62", zhCN = "欠扁", zhTW = "欠扁" },
	{ key = "63", zhCN = "鄙视", zhTW = "鄙視" },
	{ key = "64", zhCN = "大怒", zhTW = "大怒" },
	{ key = "65", zhCN = "生气", zhTW = "生氣" },
	{ key = "66", zhCN = "财神", zhTW = "財神" },
	{ key = "67", zhCN = "雷锋", zhTW = "雷鋒" },
	{ key = "68", zhCN = "恭喜", zhTW = "恭喜" },
	{ key = "69", zhCN = "小二", zhTW = "小二" },
	{ key = "70", zhCN = "老大", zhTW = "老大" },
	{ key = "71", zhCN = "邪恶", zhTW = "邪惡" },
	{ key = "72", zhCN = "单挑", zhTW = "單挑" },
	{ key = "73", zhCN = "警察", zhTW = "警察" },
	{ key = "74", zhCN = "土匪", zhTW = "土匪" },
	{ key = "75", zhCN = "炸弹", zhTW = "炸彈" },
	{ key = "76", zhCN = "尖叫", zhTW = "尖叫" },
	{ key = "77", zhCN = "美女", zhTW = "美女" },
	{ key = "78", zhCN = "帅哥", zhTW = "帥哥" },
	{ key = "79", zhCN = "招财猫", zhTW = "招財貓" },
	{ key = "80", zhCN = "成交", zhTW = "成交" },
	{ key = "81", zhCN = "鼓掌", zhTW = "鼓掌" },
	{ key = "82", zhCN = "握手", zhTW = "握手" },
	{ key = "83", zhCN = "红唇", zhTW = "紅唇" },
	{ key = "84", zhCN = "玫瑰", zhTW = "玫瑰" },
	{ key = "85", zhCN = "残花", zhTW = "殘花" },
	{ key = "86", zhCN = "爱心", zhTW = "愛心" },
	{ key = "87", zhCN = "心碎", zhTW = "心碎" },
	{ key = "88", zhCN = "金钱", zhTW = "金錢" },
	{ key = "89", zhCN = "购物", zhTW = "購物" },
	{ key = "90", zhCN = "礼物", zhTW = "禮物" },
	{ key = "91", zhCN = "邮件", zhTW = "郵件" },
	{ key = "92", zhCN = "电话", zhTW = "電話" },
	{ key = "93", zhCN = "干杯", zhTW = "幹杯" },
	{ key = "94", zhCN = "时钟", zhTW = "時鐘" },
	{ key = "95", zhCN = "等待", zhTW = "等待" },
	{ key = "96", zhCN = "很晚了", zhTW = "很晚了" },
	{ key = "97", zhCN = "飞机", zhTW = "飛機" },
	{ key = "98", zhCN = "支付宝", zhTW = "支付寶" },

	{ key = "Rez", zhCN = "复活", zhTW = "復活", texture = "Interface\\RaidFrame\\Raid-Icon-Rez" },
	{ key = "NotReady", zhCN = "未就绪", zhTW = "未就緒", texture = "Interface\\RaidFrame\\ReadyCheck-NotReady" },
	{ key = "Ready", zhCN = "已就绪",zhTW = "已就緒", texture = "Interface\\RaidFrame\\ReadyCheck-Ready" },
	{ key = "Waiting", zhCN = "等待", zhTW = "等待", texture = "Interface\\RaidFrame\\ReadyCheck-Waiting" },
	{ key = "Star", zhCN = "星形", zhTW = "星形", texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1" },
	{ key = "Circle", zhCN = "圆形", zhTW = "圓形", texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_2" },
	{ key = "Diamond", zhCN = "菱形", zhTW = "菱形", texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_3" },
	{ key = "Triangle", zhCN = "三角", zhTW = "三角", texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_4" },
	{ key = "Moon", zhCN = "月亮", zhTW = "月亮", texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_5" },
	{ key = "Square", zhCN = "方形", zhTW = "方形", texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_6" },
	{ key = "Cross", zhCN = "红叉", zhTW = "紅叉", texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_7" },
	{ key = "Skull", zhCN = "骷髅", zhTW = "骷髏", texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8" },
}


------------------------
-- 处理表情
------------------------

local function ReplaceEmote(value)
	local emote = value:gsub("[%{%}]", "")
	for _, v in pairs(emotes) do
		if emote == v.key or emote == v.zhCN or emote == v.zhTW then
			return "|T".. (v.texture or patch..v.key) ..":16|t"
		end
	end

	return value
end

local function ChatEmoteFilter(self, event, msg, ...)
	msg = msg:gsub("%{.-%}", ReplaceEmote)

	return false, msg, ...
end

local chatEvents = DB.ChatEvents
for _, v in pairs(chatEvents) do
	ChatFrame_AddMessageEventFilter(v, ChatEmoteFilter)
end

local function TextToEmote(text)
	text = text:gsub("%{.-%}", ReplaceEmote)
	return text
end

local function FindChatBubble()
	local chatBubbles = C_ChatBubbles.GetAllChatBubbles()
	for _, chatBubble in pairs(chatBubbles) do
		local frame = chatBubble:GetChildren()
		if frame and not frame:IsForbidden() then
			local oldMessage = frame.String:GetText()
			local afterMessage = TextToEmote(oldMessage)
			if oldMessage ~= afterMessage then
				frame.String:SetText(afterMessage)
			end

			-- 名字染色
			EX:HookBubble(chatBubble, frame)
		end
	end
end

local events = {
	CHAT_MSG_SAY = "chatBubbles",
	CHAT_MSG_YELL = "chatBubbles",
	CHAT_MSG_MONSTER_SAY = "chatBubbles",
	CHAT_MSG_MONSTER_YELL = "chatBubbles",
	CHAT_MSG_PARTY = "chatBubblesParty",
	CHAT_MSG_PARTY_LEADER = "chatBubblesParty",
	CHAT_MSG_MONSTER_PARTY = "chatBubblesParty",
}

local bubbleHook = CreateFrame("Frame")
for event in pairs(events) do
	bubbleHook:RegisterEvent(event)
end

bubbleHook:SetScript("OnEvent", function(self, event)
	if GetCVarBool(events[event]) then
		self.elapsed = 0
		self:Show()
	end
end)

bubbleHook:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed > .1 then
		FindChatBubble()
		self:Hide()
	end
end)

bubbleHook:Hide()

------------------------
--界面部分
------------------------

local function EmoteButton_OnClick(self, button)
	local editBox = ChatEdit_ChooseBoxForSend()

	if not editBox:IsShown() then
		ChatEdit_ActivateChat(editBox)
	end
	editBox:SetText(string.gsub(editBox:GetText(), "{$", "")..self.emote)
	if button == "LeftButton" then
		self:GetParent():Hide()
	end
end

local function EmoteButton_OnEnter(self)
	self:GetParent().title:SetText(self.emote)
end

local function EmoteButton_OnLeave(self)
	self:GetParent().title:SetText("")
end

do
	local frame, button
	local size, column, space, index = 24, 10, 4, 0

	frame = CreateFrame("Frame", "CustomEmoteFrame", UIParent)
	frame.title = B.CreateFS(frame, 15, "", true, "TOPRIGHT", -35, -12)
	frame:SetWidth(column*(size+space) + 24)
	frame:SetClampedToScreen(true)
	frame:SetFrameStrata("DIALOG")
	B.UpdatePoint(frame, "BOTTOMLEFT", ChatFrame1Tab, "TOPRIGHT", 20, 20)
	B.CreateFS(frame, 15, L["Chat Emote"], true, "TOPLEFT", 12, -12)

	for _, v in pairs(emotes) do
		button = CreateFrame("Button", nil, frame)
		button.emote = "{"..(v[locale] or v.key).."}"
		button:SetSize(size, size)
		button:SetPoint("TOPLEFT", 14+(index%column)*(size+space), -36-math.floor(index/column)*(size+space))
		button:SetScript("OnMouseUp", EmoteButton_OnClick)
		button:SetScript("OnEnter", EmoteButton_OnEnter)
		button:SetScript("OnLeave", EmoteButton_OnLeave)

		if v.texture then
			button:SetNormalTexture(v.texture)
		else
			button:SetNormalTexture(patch..v.key)
		end

		button:SetHighlightTexture(DB.bgTex, "ADD")
		local hl = button:GetHighlightTexture()
		hl:SetVertexColor(cr, cg, cb, .25)

		index = index + 1
	end
	frame:SetHeight(math.ceil(index/column)*(size+space) + 46)
	frame:Hide()
	--让输入框支持当输入 { 时自动弹出聊天表情选择框
	hooksecurefunc("ChatEdit_OnTextChanged", function(self, userInput)
		local text = self:GetText()
		if userInput and string.sub(text, -1) == "{" then
			frame:Show()
		end
	end)

	function EX:ChatEmote()
		B.CreateBG(frame)
		B.CreateMF(frame)

		local closeBTN = B.CreateButton(frame, 20, 20, "X")
		closeBTN:SetPoint("TOPRIGHT", -10, -10)
		closeBTN:SetScript("OnClick", function(self) frame:Hide() end)
	end
end
