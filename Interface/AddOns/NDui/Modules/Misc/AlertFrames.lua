local _, ns = ...
local B, C, L, DB = unpack(ns)
local Misc = B:GetModule("Misc")

local _G = getfenv(0)
local ipairs, tremove = ipairs, table.remove
local UIParent = _G.UIParent
local AlertFrame = _G.AlertFrame
local GroupLootContainer = _G.GroupLootContainer

local POSITION, ANCHOR_POINT, YOFFSET = "TOP", "BOTTOM", -10
local parentFrame, talkFrame

function Misc:AlertFrame_UpdateAnchor()
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

	self:ClearAllPoints()
	self:SetPoint(POSITION, parentFrame)
	GroupLootContainer:ClearAllPoints()
	GroupLootContainer:SetPoint(POSITION, parentFrame)
end

function Misc:UpdatGroupLootContainer()
	local lastIdx = nil

	for i = 1, self.maxIndex do
		local frame = self.rollFrames[i]
		if frame then
			frame:ClearAllPoints()
			frame:SetPoint("CENTER", self, POSITION, 0, self.reservedSize * (i-1 + 0.5) * YOFFSET/10)
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

function Misc:AlertFrame_SetPoint(relativeAlert)
	self:ClearAllPoints()
	self:SetPoint(POSITION, relativeAlert, ANCHOR_POINT, 0, YOFFSET)
end

function Misc:AlertFrame_AdjustQueuedAnchors(relativeAlert)
	for alertFrame in self.alertFramePool:EnumerateActive() do
		Misc.AlertFrame_SetPoint(alertFrame, relativeAlert)
		relativeAlert = alertFrame
	end

	return relativeAlert
end

function Misc:AlertFrame_AdjustAnchors(relativeAlert)
	if self.alertFrame:IsShown() then
		Misc.AlertFrame_SetPoint(self.alertFrame, relativeAlert)
		return self.alertFrame
	end

	return relativeAlert
end

function Misc:AlertFrame_AdjustAnchorsNonAlert(relativeAlert)
	if self.anchorFrame:IsShown() then
		Misc.AlertFrame_SetPoint(self.anchorFrame, relativeAlert)
		return self.anchorFrame
	end

	return relativeAlert
end

function Misc:AlertFrame_AdjustPosition()
	if self.alertFramePool then
		self.AdjustAnchors = Misc.AlertFrame_AdjustQueuedAnchors
	elseif not self.anchorFrame then
		self.AdjustAnchors = Misc.AlertFrame_AdjustAnchors
	elseif self.anchorFrame then
		self.AdjustAnchors = Misc.AlertFrame_AdjustAnchorsNonAlert
	end
end

local function MoveTalkingHead()
	local TalkingHeadFrame = _G.TalkingHeadFrame

	TalkingHeadFrame.ignoreFramePositionManager = true
	TalkingHeadFrame:ClearAllPoints()
	TalkingHeadFrame:SetPoint("TOP", talkFrame)

	for index, alertFrameSubSystem in ipairs(AlertFrame.alertFrameSubSystems) do
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

function Misc:AlertFrame_Setup()
	parentFrame = CreateFrame("Frame", nil, UIParent)
	parentFrame:SetSize(200, 30)
	B.Mover(parentFrame, L["AlertFrames"], "AlertFrames", {"TOP", UIParent, 0, -75})

	talkFrame = CreateFrame("Frame", "NDuiTalkingHeadMover", UIParent)
	talkFrame:SetSize(200, 30)
	B.Mover(talkFrame, L["TalkingHeadFrame"], "TalkingHeadFrame", {"TOP", UIParent, 0, -40})

	GroupLootContainer:EnableMouse(false)
	GroupLootContainer.ignoreFramePositionManager = true

	for _, alertFrameSubSystem in ipairs(AlertFrame.alertFrameSubSystems) do
		Misc.AlertFrame_AdjustPosition(alertFrameSubSystem)
	end

	hooksecurefunc(AlertFrame, "AddAlertFrameSubSystem", function(_, alertFrameSubSystem)
		Misc.AlertFrame_AdjustPosition(alertFrameSubSystem)
	end)

	hooksecurefunc(AlertFrame, "UpdateAnchors", Misc.AlertFrame_UpdateAnchor)
	hooksecurefunc("GroupLootContainer_Update", Misc.UpdatGroupLootContainer)

	if IsAddOnLoaded("Blizzard_TalkingHeadUI") then
		MoveTalkingHead()
		NoTalkingHeads()
	else
		B:RegisterEvent("ADDON_LOADED", TalkingHeadOnLoad)
	end
end
Misc:RegisterMisc("AlertFrame", Misc.AlertFrame_Setup)