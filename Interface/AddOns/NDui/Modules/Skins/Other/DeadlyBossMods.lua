local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")
local TT = B:GetModule("Tooltip")

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
	icon:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", -C.offset, 0)
end

local function Reskin_Bar(bar, frame)
	if not bar then return end

	if not bar.styled then
		B.CreateSB(bar, true)

		bar.styled = true
	end

	bar:SetInside(frame)
end

local function Hide_Spark(self)
	local spark = _G[self.frame:GetDebugName().."BarSpark"]
	spark:Hide()
end

local function Reskin_ApplyStyle(self)
	local frame		= self.frame
	local frameName = frame:GetDebugName()
	local tbar		= _G[frameName.."Bar"]
	local icon1		= _G[frameName.."BarIcon1"]
	local icon2		= _G[frameName.."BarIcon2"]
	local name		= _G[frameName.."BarName"]
	local spark		= _G[frameName.."BarSpark"]
	local texture	= _G[frameName.."BarTexture"]
	local timer		= _G[frameName.."BarTimer"]

	if self.enlarged then
		frame:SetWidth(self.owner.options.HugeWidth)
		tbar:SetWidth(self.owner.options.HugeWidth)
	else
		frame:SetWidth(self.owner.options.Width)
		tbar:SetWidth(self.owner.options.Width)
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

	name:ClearAllPoints()
	name:SetPoint("LEFT", tbar, "LEFT", 2, 6)
	name:SetPoint("RIGHT", tbar, "RIGHT", -30, 6)
	name:SetFont(DB.Font[1], 14, DB.Font[3])
	name:SetJustifyH("LEFT")
	name:SetWordWrap(false)

	timer:ClearAllPoints()
	timer:SetPoint("RIGHT", tbar, "RIGHT", -2, 6)
	timer:SetFont(DB.Font[1], 14, DB.Font[3])
	timer:SetJustifyH("RIGHT")
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
		TT.ReskinTooltip(DBMRangeCheckRadar)

		DBMRangeCheckRadar.styled = true
	end

	if DBMRangeCheck and not DBMRangeCheck.styled then
		TT.ReskinTooltip(DBMRangeCheck)

		DBMRangeCheck.styled = true
	end
end

function Skins:DeadlyBossMods()
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

	if not C.db["Skins"]["DeadlyBossMods"] then return end
	if not IsAddOnLoaded("DBM-Core") then return end

	hooksecurefunc(DBT, "CreateBar", Reskin_CreateBar)
	hooksecurefunc(DBM.RangeCheck, "Show", Reskin_RangeCheck)

	if DBM.InfoFrame then
		DBM.InfoFrame:Show(5, "test")
		DBM.InfoFrame:Hide()
		DBMInfoFrame:HookScript("OnShow", TT.ReskinTooltip)
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