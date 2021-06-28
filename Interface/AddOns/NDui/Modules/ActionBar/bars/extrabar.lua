local _, ns = ...
local B, C, L, DB = unpack(ns)
local Bar = B:GetModule("ActionBar")

local _G = _G
local tinsert = tinsert
local cfg = C.Bars.extrabar
local margin, padding = C.Bars.margin, C.Bars.padding

function Bar:CreateExtrabar()
	local buttonList = {}
	local size = cfg.size
	local layout = C.db["ActionBar"]["BarStyle"]

	-- ExtraActionButton
	local frame = CreateFrame("Frame", "NDui_ActionBarExtra", UIParent, "SecureHandlerStateTemplate")
	frame:SetWidth(size + 2*padding)
	frame:SetHeight(size + 2*padding)
	if layout == 4 then
		frame.Pos = {"TOPLEFT", _G.MultiBarBottomRightButton12, "TOPRIGHT", 0, margin}
	else
		frame.Pos = {"BOTTOMLEFT", _G.MultiBarBottomRightButton7, "TOPLEFT", -margin, 0}
	end
	frame.mover = B.Mover(frame, L["Extrabar"], "Extrabar", frame.Pos)

	ExtraActionBarFrame:EnableMouse(false)
	ExtraAbilityContainer:SetParent(frame)
	ExtraAbilityContainer.ignoreFramePositionManager = true
	ExtraAbilityContainer:SetAttribute("ignoreFramePositionManager", true)
	B.UpdatePoint(ExtraAbilityContainer, "CENTER", frame, "CENTER", 0, 2*padding)

	local button = ExtraActionButton1
	tinsert(buttonList, button)
	tinsert(Bar.buttons, button)
	button:SetSize(size, size)

	frame.frameVisibility = "[extrabar] show; hide"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	if cfg.fader then
		Bar.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end

	-- ZoneAbility
	local zoneFrame = CreateFrame("Frame", "NDui_ActionBarZone", UIParent)
	zoneFrame:SetWidth(size + 2*padding)
	zoneFrame:SetHeight(size + 2*padding)
	if layout == 4 then
		zoneFrame.Pos = {"TOPRIGHT", _G.MultiBarBottomRightButton1, "TOPLEFT", 0, margin}
	else
		zoneFrame.Pos = {"BOTTOMRIGHT", _G.MultiBarBottomRightButton3, "TOPRIGHT", margin, 0}
	end
	zoneFrame.mover = B.Mover(zoneFrame, L["Zone Ability"], "ZoneAbility", zoneFrame.Pos)

	ZoneAbilityFrame.Style:SetAlpha(0)
	ZoneAbilityFrame:SetParent(zoneFrame)
	ZoneAbilityFrame.ignoreFramePositionManager = true
	ZoneAbilityFrame:SetAttribute("ignoreFramePositionManager", true)
	B.UpdatePoint(ZoneAbilityFrame, "CENTER", zoneFrame, "CENTER")

	hooksecurefunc(ZoneAbilityFrame, "UpdateDisplayedZoneAbilities", function(self)
		for spellButton in self.SpellButtonContainer:EnumerateActive() do
			if spellButton and not spellButton.styled then
				spellButton.NormalTexture:SetAlpha(0)
				spellButton.Icon:SetInside()

				local icbg = B.ReskinIcon(spellButton.Icon)
				B.ReskinHLTex(spellButton, icbg)
				B.ReskinCPTex(spellButton, icbg)

				spellButton.styled = true
			end
		end
	end)

	-- Fix button visibility
	hooksecurefunc(ZoneAbilityFrame, "SetParent", function(self, parent)
		if parent == ExtraAbilityContainer then
			self:SetParent(zoneFrame)
		end
	end)
end