local _, ns = ...
local B, C, L, DB = unpack(ns)
local MISC = B:GetModule("Misc")

local _G = getfenv(0)
local pairs, tremove = pairs, table.remove
local UIParent = _G.UIParent
local AlertFrame = _G.AlertFrame
local GroupLootContainer = _G.GroupLootContainer

local POSITION, ANCHOR_POINT, YOFFSET = "TOP", "BOTTOM", -10
local parentFrame, talkFrame

function MISC:AlertFrame_UpdateAnchor()
	if not parentFrame then return end

	local y = select(2, parentFrame:GetCenter())
	local screenHeight = UIParent:GetTop()
	if y > screenHeight/2 then
		POSITION = "TOP"
		ANCHOR_POINT = "BOTTOM"
		YOFFSET = -10
	else
		POSITION = "BOTTOM"
		ANCHOR_POINT = "TOP"
		YOFFSET = 10
	end

	B.UpdatePoint(self, POSITION, parentFrame, POSITION)
	B.UpdatePoint(GroupLootContainer, POSITION, parentFrame, POSITION)
end

function MISC:UpdatGroupLootContainer()
	local lastIdx = nil

	for i = 1, self.maxIndex do
		local frame = self.rollFrames[i]
		if frame then
			B.UpdatePoint(frame, "CENTER", self, POSITION, 0, self.reservedSize * (i-1 + 0.5) * YOFFSET/10)

			lastIdx = i
		end
	end

	if lastIdx then
		self:SetHeight(self.reservedSize * lastIdx)
		self:Show()
	else
		self:Hide()
	end
end

function MISC:AlertFrame_SetPoint(relativeAlert)
	B.UpdatePoint(self, POSITION, relativeAlert, ANCHOR_POINT, 0, YOFFSET)
end

function MISC:AlertFrame_AdjustQueuedAnchors(relativeAlert)
	for alertFrame in self.alertFramePool:EnumerateActive() do
		MISC.AlertFrame_SetPoint(alertFrame, relativeAlert)
		relativeAlert = alertFrame
	end

	return relativeAlert
end

function MISC:AlertFrame_AdjustAnchors(relativeAlert)
	if self.alertFrame:IsShown() then
		MISC.AlertFrame_SetPoint(self.alertFrame, relativeAlert)
		return self.alertFrame
	end

	return relativeAlert
end

function MISC:AlertFrame_AdjustAnchorsNonAlert(relativeAlert)
	if self.anchorFrame:IsShown() then
		MISC.AlertFrame_SetPoint(self.anchorFrame, relativeAlert)
		return self.anchorFrame
	end

	return relativeAlert
end

function MISC:AlertFrame_AdjustPosition()
	if self.alertFramePool then
		self.AdjustAnchors = MISC.AlertFrame_AdjustQueuedAnchors
	elseif not self.anchorFrame then
		self.AdjustAnchors = MISC.AlertFrame_AdjustAnchors
	elseif self.anchorFrame then
		self.AdjustAnchors = MISC.AlertFrame_AdjustAnchorsNonAlert
	end
end

local function MoveTalkingHead()
	if not talkFrame then return end

	local TalkingHeadFrame = _G.TalkingHeadFrame
	TalkingHeadFrame.ignoreFramePositionManager = true
	TalkingHeadFrame:SetAttribute("ignoreFramePositionManager", true)
	B.UpdatePoint(TalkingHeadFrame, "TOP", talkFrame, "TOP")

	for index, alertFrameSubSystem in pairs(AlertFrame.alertFrameSubSystems) do
		if alertFrameSubSystem.anchorFrame and alertFrameSubSystem.anchorFrame == TalkingHeadFrame then
			tremove(AlertFrame.alertFrameSubSystems, index)
		end
	end
end

local function NoTalkingHeads()
	if not C.db["Misc"]["HideTalking"] then return end

	hooksecurefunc(TalkingHeadFrame, "Show", function(self)
		self:Hide()
	end)
end

local function TalkingHeadOnLoad(event, addon)
	if addon == "Blizzard_TalkingHeadUI" then
		MoveTalkingHead()
		NoTalkingHeads()
		B:UnregisterEvent(event, TalkingHeadOnLoad)
	end
end

function MISC:AlertFrame_Setup()
	if not IsAddOnLoaded("ls_Toasts") then
		if parentFrame then return end

		parentFrame = CreateFrame("Frame", "NDuiAlertFrameMover", UIParent)
		parentFrame:SetSize(200, 30)
		B.Mover(parentFrame, L["AlertFrames"], "AlertFrames", {"TOP", UIParent, 0, -95})
	end

	if not C.db["Misc"]["HideTalking"] then
		if talkFrame then return end

		talkFrame = CreateFrame("Frame", "NDuiTalkingHeadMover", UIParent)
		talkFrame:SetSize(200, 30)
		B.Mover(talkFrame, L["TalkingHeadFrame"], "TalkingHeadFrame", {"TOP", UIParent, 0, -60})
	end

	GroupLootContainer:EnableMouse(false)
	GroupLootContainer.ignoreFramePositionManager = true
	GroupLootContainer:SetAttribute("ignoreFramePositionManager", true)

	for _, alertFrameSubSystem in pairs(AlertFrame.alertFrameSubSystems) do
		MISC.AlertFrame_AdjustPosition(alertFrameSubSystem)
	end

	hooksecurefunc(AlertFrame, "AddAlertFrameSubSystem", function(_, alertFrameSubSystem)
		MISC.AlertFrame_AdjustPosition(alertFrameSubSystem)
	end)

	hooksecurefunc(AlertFrame, "UpdateAnchors", MISC.AlertFrame_UpdateAnchor)
	hooksecurefunc("GroupLootContainer_Update", MISC.UpdatGroupLootContainer)

	if IsAddOnLoaded("Blizzard_TalkingHeadUI") then
		MoveTalkingHead()
		NoTalkingHeads()
	else
		B:RegisterEvent("ADDON_LOADED", TalkingHeadOnLoad)
	end
end
MISC:RegisterMisc("AlertFrame", MISC.AlertFrame_Setup)