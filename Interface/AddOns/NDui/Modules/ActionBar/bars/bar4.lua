local _, ns = ...
local B, C, L, DB = unpack(ns)
local AB = B:GetModule("ActionBar")

local _G = _G
local tinsert = tinsert
local cfg = C.Bars.bar4
local margin, padding = C.Bars.margin, C.Bars.padding

local function SetFrameSize(frame, size, num)
	size = size or frame.buttonSize
	num = num or frame.numButtons

	local layout = C.db["ActionBar"]["BarStyle"]
	if layout == 2 then
		frame:SetWidth(25*size + 25*margin + 2*padding)
		frame:SetHeight(2*size + margin + 2*padding)

		local button = _G["MultiBarRightButton7"]
		button:SetPoint("TOPRIGHT", frame, -2*(size+margin) - padding, -padding)
	elseif layout == 3 then
		frame:SetWidth(4*size + 3*margin + 2*padding)
		frame:SetHeight(3*size + 2*margin + 2*padding)
	else
		frame:SetWidth(size + 2*padding)
		frame:SetHeight(num*size + (num-1)*margin + 2*padding)
	end

	if not frame.mover then
		frame.mover = B.Mover(frame, SHOW_MULTIBAR3_TEXT, "Bar4", frame.Pos)
	else
		frame.mover:SetSize(frame:GetSize())
	end

	if not frame.SetFrameSize then
		frame.buttonSize = size
		frame.numButtons = num
		frame.SetFrameSize = SetFrameSize
	end
end

local function updateVisibility(event)
	if InCombatLockdown() then
		B:RegisterEvent("PLAYER_REGEN_ENABLED", updateVisibility)
	else
		InterfaceOptions_UpdateMultiActionBars()
		B:UnregisterEvent(event, updateVisibility)
	end
end

function AB:FixSizebarVisibility()
	B:RegisterEvent("PET_BATTLE_OVER", updateVisibility)
	B:RegisterEvent("PET_BATTLE_CLOSE", updateVisibility)
	B:RegisterEvent("UNIT_EXITED_VEHICLE", updateVisibility)
	B:RegisterEvent("UNIT_EXITING_VEHICLE", updateVisibility)
end

function AB:CreateBar4()
	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}
	local layout = C.db["ActionBar"]["BarStyle"]

	local frame = CreateFrame("Frame", "NDui_ActionBar4", UIParent, "SecureHandlerStateTemplate")
	if layout == 2 then
		frame.Pos = {"BOTTOM", _G.NDui_ActionBar1, "BOTTOM", 0, margin}
	elseif layout == 3 then
		frame.Pos = {"BOTTOMLEFT", _G.NDui_ActionBar3, "BOTTOMRIGHT", margin, 0}
	else
		frame.Pos = {"RIGHT", UIParent, "RIGHT", -1, 5}
	end

	MultiBarRight:SetParent(frame)
	MultiBarRight:EnableMouse(false)
	MultiBarRight.QuickKeybindGlow:SetTexture("")

	for i = 1, num do
		local button = _G["MultiBarRightButton"..i]
		tinsert(buttonList, button)
		tinsert(AB.buttons, button)

		if layout == 2 then
			if i == 1 then
				B.UpdatePoint(button, "TOPLEFT", frame, "TOPLEFT", padding, -padding)
			elseif i == 4 then
				B.UpdatePoint(button, "TOP", _G["MultiBarRightButton1"], "BOTTOM", 0, -margin)
			elseif i == 7 then
				B.UpdatePoint(button, "TOPRIGHT", frame, -2*(cfg.size+margin) - padding, -padding)
			elseif i == 10 then
				B.UpdatePoint(button, "TOP", _G["MultiBarRightButton7"], "BOTTOM", 0, -margin)
			else
				B.UpdatePoint(button, "LEFT", _G["MultiBarRightButton"..i-1], "RIGHT", margin, 0)
			end
		elseif layout == 3 then
			if i == 1 then
				B.UpdatePoint(button, "TOPLEFT", frame, "TOPLEFT", padding, -padding)
			elseif i == 5 or i == 9 then
				B.UpdatePoint(button, "TOP", _G["MultiBarRightButton"..i-4], "BOTTOM", 0, -margin)
			else
				B.UpdatePoint(button, "LEFT", _G["MultiBarRightButton"..i-1], "RIGHT", margin, 0)
			end
		else
			if i == 1 then
				B.UpdatePoint(button, "TOPRIGHT", frame, "TOPRIGHT", -padding, -padding)
			else
				B.UpdatePoint(button, "TOP", _G["MultiBarRightButton"..i-1], "BOTTOM", 0, -margin)
			end
		end
	end

	frame.buttonList = buttonList
	SetFrameSize(frame, cfg.size, num)

	frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	if C.db["ActionBar"]["Bar4Fade"] and cfg.fader then
		AB.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end

	-- Fix visibility when leaving vehicle or petbattle
	AB:FixSizebarVisibility()
end