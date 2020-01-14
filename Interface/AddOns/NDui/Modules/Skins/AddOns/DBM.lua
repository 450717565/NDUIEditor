local _, ns = ...
local B, C, L, DB, F = unpack(ns)
local S = B:GetModule("Skins")
local TT = B:GetModule("Tooltip")

local strfind, strmatch, gsub = string.find, string.match, string.gsub

function S:DBMSkin()
	-- Default notice message
	local RaidNotice_AddMessage_ = RaidNotice_AddMessage
	RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo)
		if strfind(textString, "|T") then
			if strmatch(textString, ":(%d+):(%d+)") then
				local size1, size2 = strmatch(textString, ":(%d+):(%d+)")
				size1, size2 = size1 + 3, size2 + 3
				textString = gsub(textString,":(%d+):(%d+)",":"..size1..":"..size2..":0:0:64:64:5:59:5:59")
			elseif strmatch(textString, ":(%d+)|t") then
				local size = strmatch(textString, ":(%d+)|t")
				size = size + 3
				textString = gsub(textString,":(%d+)|t",":"..size..":"..size..":0:0:64:64:5:59:5:59|t")
			end
		end
		return RaidNotice_AddMessage_(noticeFrame, textString, colorInfo)
	end

	if not IsAddOnLoaded("DBM-Core") then return end
	if not NDuiDB["Skins"]["DBM"] then return end

	local iconSize = 20
	local function SkinBars(self)
		for bar in self:GetBarIterator() do
			if not bar.injected then
				local frame		= bar.frame
				local tbar		= _G[frame:GetName().."Bar"]
				local icon1		= _G[frame:GetName().."BarIcon1"]
				local icon2		= _G[frame:GetName().."BarIcon2"]
				local name		= _G[frame:GetName().."BarName"]
				local spark		= _G[frame:GetName().."BarSpark"]
				local timer		= _G[frame:GetName().."BarTimer"]

				if not frame.styled then
					B.StripTextures(frame)

					frame.styled = true
				end

				if not spark.killed then
					spark:Hide()

					spark.killed = true
				end

				if not tbar.styled then
					tbar:SetHeight(iconSize/2)
					tbar.SetHeight = B.Dummy

					B.CreateSB(tbar, true)

					tbar.styled = true
				end

				if not icon1.styled then
					icon1:SetSize(iconSize, iconSize)
					icon1.SetSize = B.Dummy
					icon1:SetTexCoord(unpack(DB.TexCoord))
					icon1.SetTexCoord = B.Dummy
					icon1:ClearAllPoints()
					icon1:SetPoint("BOTTOMRIGHT", tbar, "BOTTOMLEFT", -5, 0)
					icon1.SetPoint = B.Dummy

					icon1.bg = F.CreateBDFrame(icon1)

					icon1.styled = true
				end

				if not icon2.styled then
					icon2:SetSize(iconSize, iconSize)
					icon2.SetSize = B.Dummy
					icon2:SetTexCoord(unpack(DB.TexCoord))
					icon2.SetTexCoord = B.Dummy
					icon2:ClearAllPoints()
					icon2:SetPoint("BOTTOMLEFT", tbar, "BOTTOMRIGHT", 5, 0)
					icon2.SetPoint = B.Dummy

					icon2.bg = F.CreateBDFrame(icon2)

					icon2.styled = true
				end

				if not timer.styled then
					timer:ClearAllPoints()
					timer:SetPoint("RIGHT", tbar, "RIGHT", -2, 6)
					timer.SetPoint = B.Dummy
					timer:SetFont(DB.Font[1], 14, DB.Font[3])
					timer.SetFont = B.Dummy
					timer:SetJustifyH("RIGHT")

					timer.styled = true
				end

				if not name.styled then
					name:ClearAllPoints()
					name:SetPoint("LEFT", tbar, "LEFT", 2, 6)
					name:SetPoint("RIGHT", tbar, "RIGHT", -30, 6)
					name.SetPoint = B.Dummy
					name:SetFont(DB.Font[1], 14, DB.Font[3])
					name.SetFont = B.Dummy
					name:SetJustifyH("LEFT")
					name:SetWordWrap(false)

					name.styled = true
				end

				icon1.bg:SetShown(icon1:IsShown())
				icon2.bg:SetShown(icon2:IsShown())
				bar:Update(0)

				bar.injected = true
			end
		end
	end
	hooksecurefunc(DBT, "CreateBar", SkinBars)

	local function SkinRange()
		if DBMRangeCheckRadar and not DBMRangeCheckRadar.styled then
			TT.ReskinTooltip(DBMRangeCheckRadar)

			DBMRangeCheckRadar.styled = true
		end

		if DBMRangeCheck and not DBMRangeCheck.styled then
			TT.ReskinTooltip(DBMRangeCheck)

			DBMRangeCheck.styled = true
		end
	end
	hooksecurefunc(DBM.RangeCheck, "Show", SkinRange)

	if DBM.InfoFrame then
		DBM.InfoFrame:Show(5, "test")
		DBM.InfoFrame:Hide()
		DBMInfoFrame:HookScript("OnShow", TT.ReskinTooltip)
	end

	-- Force Settings
	if not DBM_AllSavedOptions["Default"] then DBM_AllSavedOptions["Default"] = {} end
	DBM_AllSavedOptions["Default"]["BlockVersionUpdateNotice"] = true
	DBM_AllSavedOptions["Default"]["EventSoundVictory"] = "None"
	DBT_AllPersistentOptions["Default"]["DBM"].BarYOffset = 5
	DBT_AllPersistentOptions["Default"]["DBM"].HugeBarYOffset = 5
end