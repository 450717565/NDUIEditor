local _, ns = ...
local B, C, L, DB = unpack(ns)
local SKIN = B:GetModule("Skins")

local iconSize = 20

local function Reskin_Icon(icon, frame)
	if not icon then return end

	if not icon.styled then
		icon:SetSize(iconSize, iconSize)
		icon.SetSize = B.Dummy

		B.ReskinIcon(icon)

		icon.styled = true
	end

	icon:ClearAllPoints()
	icon:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", -C.margin, 0)
end

local function Reskin_Bar(bar, frame)
	if not bar then return end

	if not bar.styled then
		B.StripTextures(bar, 6)
		B.CreateBDFrame(bar, 0, -C.mult, true)
		bar:SetStatusBarTexture(DB.normTex)

		bar.styled = true
	end

	bar:SetInside(frame)
end

local function Hide_Spark(self)
	B.GetObject(self.frame, "BarSpark"):Hide()
end

local function Reskin_ApplyStyle(self)
	local frame = self.frame
	local tbar = B.GetObject(frame, "Bar")
	local name = B.GetObject(frame, "BarName")
	local icon1 = B.GetObject(frame, "BarIcon1")
	local icon2 = B.GetObject(frame, "BarIcon2")
	local spark = B.GetObject(frame, "BarSpark")
	local timer = B.GetObject(frame, "BarTimer")
	local texture = B.GetObject(frame, "BarTexture")

	if self.enlarged then
		frame:SetWidth(self.owner.Options.HugeWidth)
		tbar:SetWidth(self.owner.Options.HugeWidth)
	else
		frame:SetWidth(self.owner.Options.Width)
		tbar:SetWidth(self.owner.Options.Width)
	end

	if not frame.styled then
		B.StripTextures(frame)

		frame.styled = true
	end

	Reskin_Icon(icon1, tbar)
	Reskin_Icon(icon2, tbar)
	Reskin_Bar(tbar, frame)

	frame:SetScale(1)
	frame:SetHeight(iconSize/2)
	if texture then texture:SetTexture(DB.normTex) end

	name:SetWordWrap(false)
	name:SetJustifyH("LEFT")
	name:SetWidth(tbar:GetWidth()*.8)
	name:SetFont(DB.Font[1], 14, DB.Font[3])
	B.UpdatePoint(name, "LEFT", tbar, "TOPLEFT", C.margin, 0)

	timer:SetJustifyH("RIGHT")
	timer:SetWidth(tbar:GetWidth()*.2)
	timer:SetFont(DB.Font[1], 14, DB.Font[3])
	B.UpdatePoint(timer, "RIGHT", tbar, "TOPRIGHT", -C.margin, 0)
end

local function Reskin_CreateBar(self)
	for bar in self:GetBarIterator() do
		if not bar.injected then
			hooksecurefunc(bar, "Update", Hide_Spark)
			hooksecurefunc(bar, "ApplyStyle", Reskin_ApplyStyle)
			bar:ApplyStyle()

			bar.injected = true
		end
	end
end

local function Reskin_RangeCheck()
	if DBMRangeCheckRadar and not DBMRangeCheckRadar.styled then
		B.ReskinTooltip(DBMRangeCheckRadar)

		DBMRangeCheckRadar.styled = true
	end

	if DBMRangeCheck and not DBMRangeCheck.styled then
		B.ReskinTooltip(DBMRangeCheck)

		DBMRangeCheck.styled = true
	end
end

function SKIN:DeadlyBossMods()
	-- Default notice message
	local RaidNotice_AddMessage_ = RaidNotice_AddMessage
	RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo)
		if string.find(textString, "|T") then
			if string.match(textString, ":(%d+):(%d+)") then
				local size1, size2 = string.match(textString, ":(%d+):(%d+)")
				size1, size2 = size1 + 3, size2 + 3
				textString = string.gsub(textString, ":(%d+):(%d+)",":"..size1..":"..size2..":0:0:64:64:5:59:5:59")
			elseif string.match(textString, ":(%d+)|t") then
				local size = string.match(textString, ":(%d+)|t")
				size = size + 3
				textString = string.gsub(textString, ":(%d+)|t",":"..size..":"..size..":0:0:64:64:5:59:5:59|t")
			end
		end

		return RaidNotice_AddMessage_(noticeFrame, textString, colorInfo)
	end

	if not C.db["Skins"]["DeadlyBossMods"] or not IsAddOnLoaded("DBM-Core") then return end

	hooksecurefunc(DBT, "CreateBar", Reskin_CreateBar)
	hooksecurefunc(DBM.RangeCheck, "Show", Reskin_RangeCheck)

	if DBM.InfoFrame then
		DBM.InfoFrame:Show(5, "test")
		DBM.InfoFrame:Hide()
		DBMInfoFrame:HookScript("OnShow", B.ReskinTooltip)
	end

	-- Force Settings
	if not DBM_AllSavedOptions["Default"] then DBM_AllSavedOptions["Default"] = {} end
	DBM_AllSavedOptions["Default"]["BlockVersionUpdateNotice"] = true
	DBM_AllSavedOptions["Default"]["EventSoundVictory"] = "None"
	DBM_AllSavedOptions["Default"]["EventSoundVictory2"] = "None"

	if not DBT_AllPersistentOptions["Default"] then DBT_AllPersistentOptions["Default"] = {} end
	DBT_AllPersistentOptions["Default"]["DBM"]["BarYOffset"] = 5
	DBT_AllPersistentOptions["Default"]["DBM"]["HugeBarYOffset"] = 5
	DBT_AllPersistentOptions["Default"]["DBM"]["ExpandUpwards"] = true
	DBT_AllPersistentOptions["Default"]["DBM"]["ExpandUpwardsLarge"] = true
end