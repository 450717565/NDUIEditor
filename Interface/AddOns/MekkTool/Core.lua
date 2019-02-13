local strfind, strmatch, gsub, tonumber = string.find, string.match, string.gsub, tonumber
local myName = UnitName("player")
local unitName
local VERSION = GetAddOnMetadata("MekkTool", "Version")
local soundFile = "Interface\\AddOns\\MekkTool\\Media\\"
local bgTex = "Interface\\ChatFrame\\ChatFrameBackground"

C_Timer.After(5, function()
	SetCVar("chatBubbles", 1)
end)

local iconList = {
	[1] = 286152,	-- 红色扳手
	[2] = 286192,	-- 紫色小鸡
	[3] = 286215,	-- 绿色弹簧
	[4] = 286219,	-- 黄色螺丝
	[5] = 286226	-- 蓝色齿轮
}

local iconString = {
	[1] = "你是红色(1)",
	[2] = "你是紫色(2)",
	[3] = "你是绿色(3)",
	[4] = "你是黄色(4)",
	[5] = "你是蓝色(5)",
}

local function SetBackdrop(parent)
	parent:SetBackdrop({
		bgFile = bgTex, edgeFile = bgTex, edgeSize = 1.2,
	})
	parent:SetBackdropColor(0, 0, 0, .5)
	parent:SetBackdropBorderColor(0, 0, 0)
end

local function SetupIcon(parent)
	local icon = parent:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("TOPLEFT", 1.2, -1.2)
	icon:SetPoint("BOTTOMRIGHT", -1.2, 1.2)
	icon:SetTexCoord(.08, .92, .08, .92)
	local hl = parent:CreateTexture(nil, "HIGHLIGHT")
	hl:SetAllPoints(icon)
	hl:SetColorTexture(1, 1, 1, .25)

	parent.Icon = icon
end

local function SetMovable(parent)
	parent:SetMovable(true)
	parent:SetUserPlaced(true)
	parent:SetClampedToScreen(true)
	parent:EnableMouse(true)
	parent:RegisterForDrag("LeftButton")
	parent:SetScript("OnDragStart", function(self) self:StartMoving() end)
	parent:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
end

local function CreateFS(parent, text, anchor, x, y)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
	fs:SetText(text)
	fs:SetWordWrap(false)
	fs:SetPoint(anchor, x, y)
	return fs
end

local function updateGlow(index)
	if not IsAddOnLoaded("NDui") then return end
	local B = unpack(NDui)
	for i = 1, 5 do
		local button = _G["ActionButton"..i]
		if index > 0 and i == index then
			B.ShowOverlayGlow(button)
		else
			B.HideOverlayGlow(button)
		end
	end
end

local myBu = CreateFrame("Frame", "MekkTool_MyButton", UIParent)
myBu:SetSize(80, 80)
myBu:SetPoint("CENTER")
SetBackdrop(myBu)
SetupIcon(myBu)
SetMovable(myBu)
myBu:Hide()
local myText = CreateFS(myBu, "你的颜色: 无", "TOP", 0, 18)
local myTurn = CreateFS(myBu, "轮次：1/3", "BOTTOM", 0, -18)

local tarF = CreateFrame("Frame", "MekkTool_TargetBar", UIParent)
tarF:SetSize(50*5+5*4, 22)
tarF:SetPoint("TOP", 0, -150)
SetBackdrop(tarF)
SetMovable(tarF)
tarF:Hide()
local tarText = CreateFS(tarF, "当前通报目标: 无", "LEFT", 2, 0)

local tarBu = {}
for i = 1, 5 do
	local bu = CreateFrame("Button", nil, tarF)
	bu:SetSize(50, 50)
	bu:SetPoint("TOPLEFT", tarF, "BOTTOMLEFT", (i-1)*55, -5)
	SetBackdrop(bu)
	SetupIcon(bu)
	bu.Icon:SetTexture(GetSpellTexture(iconList[i]))
	bu:SetScript("OnClick", function(self)
		if unitName and UnitIsPlayer(unitName) and (not self.lastClick or GetTime() - self.lastClick > .5) then
			SendChatMessage("MekkTool: "..iconString[i], "WHISPER", nil, unitName)
			self.lastClick = GetTime()
		end
	end)
	tarBu[i] = bu
end

local caller = CreateFrame("Frame")
caller:Hide()
caller:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > 2 then
		SendChatMessage(myName, "YELL")
		self.elapsed = 0
	end
end)

local versionList = {}
C_ChatInfo.RegisterAddonMessagePrefix("MekkToolVer")

local function SendVerCheck()
	wipe(versionList)
	C_ChatInfo.SendAddonMessage("MekkToolVer", "VersionCheck", "RAID")

	C_Timer.After(3, function()
		print("----------")
		for name, version in pairs(versionList) do
			print(name.." "..version)
		end
	end)
end

local function VerCheckListen(prefix, msg, distType, sender)
	if prefix == "MekkToolVer" then
		if msg == "VersionCheck" then
			C_ChatInfo.SendAddonMessage("MekkToolVer", "MyVer-"..VERSION, distType)
		elseif strfind(msg, "MyVer") then
			local _, version = strsplit("-", msg)
			versionList[sender] = version
		end
	end
end

local currentTurn = 1
local index
local f = CreateFrame("Frame")
f:RegisterUnitEvent("UNIT_AURA", "player")
f:RegisterEvent("CHAT_MSG_WHISPER")
f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
f:RegisterEvent("CHAT_MSG_ADDON")
f:SetScript("OnEvent", function(_, event, ...)
	if not IsInRaid() then return end

	if event == "CHAT_MSG_ADDON" then
		VerCheckListen(...)
	else
		if not UnitHasVehicleUI("player") then
			currentTurn = 1
			myBu:Hide()
			tarF:Hide()
			caller:Hide()
			updateGlow(0)
			return
		end

		if event == "UNIT_AURA" then
			local isOn = false
			for i = 1, 20 do
				local name, _, _, _, _, _, _, _, _, spellID = UnitDebuff("player", i)
				if not name then break end
				if spellID == 286105 then
					isOn = true
					break
				end
			end

			if isOn then
				caller.elapsed = 2
				caller:Show()
			else
				caller:Hide()
			end
		elseif event == "CHAT_MSG_WHISPER" then
			-- MekkTool: 你是红色(1),紫色(2),绿色(3),黄色(4),蓝色(5)
			local msg = ...
			if strfind(msg, "^MekkTool:") then
				local color = gsub(msg, "MekkTool: ", "")
				index = tonumber(strmatch(msg, "^MekkTool:.+(%d)"))
				PlaySoundFile(soundFile..index..".ogg", "master")
				myBu:Show()
				myBu.Icon:SetTexture(GetSpellTexture(iconList[index]))
				myText:SetText(color)
				myTurn:SetText("轮次："..currentTurn.."/3")
				updateGlow(index)
			end
		elseif event == "PLAYER_TARGET_CHANGED" and UnitExists("target") then
			unitName = GetUnitName("target", true)
			tarF:Show()
			tarText:SetText("当前通报目标："..unitName)
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			local unit, _, spellID = ...
			if unit == "vehicle" and spellID ~= 282408 then
				updateGlow(0)
				print(currentTurn.."/3: ".."你按了"..GetSpellLink(spellID))
				if currentTurn == 3 then
					myBu:Show()
					myBu.Icon:SetTexture(237290)
					myText:SetText("|cff00ff00随便按，下车！")
				else
					myBu:Hide()
					currentTurn = currentTurn + 1
				end
			end
		end
	end
end)

local shown
SlashCmdList["MEKK_TOOL"] = function(msg)
	if msg == "ver" then
		if not IsInRaid() then return end
		SendVerCheck()
	else
		if not shown then
			myBu:Show()
			tarF:Show()
			caller:Show()
			shown = true
		else
			myBu:Hide()
			tarF:Hide()
			caller:Hide()
			shown = false
		end
	end
end
SLASH_MEKK_TOOL1 = "/csb"