local _, ns = ...
local B, C, L, DB, F = unpack(ns)
local Bar = B:GetModule("Actionbar")
local cfg = C.bars.extrabar

function Bar:CreateExtrabar()
	local buttonList = {}
	local layout = NDuiDB["Actionbar"]["Style"]

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "NDui_ActionBarExtra", UIParent, "SecureHandlerStateTemplate")
	frame:SetSize(cfg.size, cfg.size)
	if layout ~= 4 then
		frame.Pos = {"BOTTOMLEFT", UIParent, "BOTTOM", 221, 108}
	else
		frame.Pos = {"BOTTOMLEFT", UIParent, "BOTTOM", 221, 29}
	end

	--move the buttons into position and reparent them
	ExtraActionBarFrame:SetParent(frame)
	ExtraActionBarFrame:EnableMouse(false)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER", 0, 0)
	ExtraActionBarFrame.ignoreFramePositionManager = true

	--the extra button
	local button = ExtraActionButton1
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(cfg.size, cfg.size)

	--show/hide the frame on a given state driver
	frame.frameVisibility = "[extrabar] show; hide"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	--create drag frame and drag functionality
	if C.bars.userplaced then
		frame.mover = B.Mover(frame, L["Extrabar"], "Extrabar", frame.Pos)
	end

	--create the mouseover functionality
	if cfg.fader then
		Bar.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end

	--zone ability
	local zoneFrame = CreateFrame("Frame", "NDui_ActionBarZone", UIParent)
	zoneFrame:SetSize(cfg.size, cfg.size)
	zoneFrame.Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -221, 108}

	if layout == 4 then
		zoneFrame.Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -221, 29}
	end

	ZoneAbilityFrame:SetParent(zoneFrame)
	ZoneAbilityFrame:ClearAllPoints()
	ZoneAbilityFrame:SetPoint("CENTER", 0, 0)
	ZoneAbilityFrame.ignoreFramePositionManager = true
	ZoneAbilityFrameNormalTexture:SetAlpha(0)
	zoneFrame.mover = B.Mover(zoneFrame, L["Zone Ability"], "ZoneAbility", zoneFrame.Pos)

	local SpellButton = ZoneAbilityFrame.SpellButton
	SpellButton.Style:SetAlpha(0)
	local icbg = F.ReskinIcon(SpellButton.Icon)
	F.ReskinTexture(SpellButton, icbg)
end