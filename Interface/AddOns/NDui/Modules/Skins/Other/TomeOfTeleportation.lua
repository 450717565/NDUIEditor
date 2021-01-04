local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

local function Reskin_TeleporterOpenFrame()
	local frame = TeleporterFrame
	local close = TeleporterCloseButton
	if frame and not frame.styled then
		B.ReskinFrame(frame)
		frame.SetBackdrop = B.Dummy

		close:SetSize(20, 20)
		close:SetText("")
		B.ReskinClose(close)

		local titleBG = TeleporterTitleFrame:GetRegions()
		titleBG:SetTexture(nil)
		titleBG.SetTexture = B.Dummy

		frame.styled = true
	end

	local index = 0
	local button = _G["TeleporterFrameTeleporterB"..index]
	local cooldownbar = _G["TeleporterFrameTeleporterB"..index.."TeleporterCB0"]
	while button and cooldownbar do
		B.ReskinButton(button)
		local icbg = B.ReskinIcon(button.TeleporterIcon)
		icbg:SetFrameLevel(button:GetFrameLevel())

		cooldownbar:SetPoint("TOPLEFT", -3, 2)
		cooldownbar:SetHeight(cooldownbar:GetHeight() + 4)

		index = index + 1
		button = _G["TeleporterFrameTeleporterB"..index]
		cooldownbar = _G["TeleporterFrameTeleporterB"..index.."TeleporterCB0"]
	end
end

function Skins:TomeOfTeleportation()
	if not IsAddOnLoaded("TomeOfTeleportation") then return end

	hooksecurefunc("TeleporterOpenFrame", Reskin_TeleporterOpenFrame)
end