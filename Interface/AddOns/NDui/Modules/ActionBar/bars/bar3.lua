local _, ns = ...
local B, C, L, DB = unpack(ns)
local AB = B:GetModule("ActionBar")

local _G = _G
local tinsert = tinsert
local cfg = C.Bars.bar3
local margin, padding = C.Bars.margin, C.Bars.padding

local function SetFrameSize(frame, size, num)
	size = size or frame.buttonSize
	num = num or frame.numButtons

	local layout = C.db["ActionBar"]["BarStyle"]
	if layout == 4 then
		frame:SetWidth(num*size + (num-1)*margin + 2*padding)
		frame:SetHeight(size + 2*padding)
	elseif layout == 5 then
		frame:SetWidth(6*size + 5*margin + 2*padding)
		frame:SetHeight(2*size + margin + 2*padding)
	else
		frame:SetWidth(19*size + 17*margin + 2*padding)
		frame:SetHeight(2*size + margin + 2*padding)
	end

	if layout < 4 then
		local button = _G["MultiBarBottomRightButton7"]
		button:SetPoint("TOPRIGHT", frame, -2*(size+margin) - padding, -padding)
	end

	if not frame.mover then
		frame.mover = B.Mover(frame, SHOW_MULTIBAR2_TEXT, "Bar3", frame.Pos)
	else
		frame.mover:SetSize(frame:GetSize())
	end

	if not frame.SetFrameSize then
		frame.buttonSize = size
		frame.numButtons = num
		frame.SetFrameSize = SetFrameSize
	end
end

function AB:CreateBar3()
	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}
	local layout = C.db["ActionBar"]["BarStyle"]
	if layout > 3 then cfg = C.Bars.bar2 end

	local frame = CreateFrame("Frame", "NDui_ActionBar3", UIParent, "SecureHandlerStateTemplate")
	if layout == 4 then
		frame.Pos = {"BOTTOM", _G.NDui_ActionBar2, "TOP", 0, -margin}
	elseif layout == 5 then
		frame.Pos = {"BOTTOMLEFT", _G.NDui_ActionBar1, "BOTTOMRIGHT", -margin, 0}
	else
		frame.Pos = {"BOTTOM", _G.NDui_ActionBar1, "BOTTOM", 0, margin}
	end

	MultiBarBottomRight:SetParent(frame)
	MultiBarBottomRight:EnableMouse(false)
	MultiBarBottomRight.QuickKeybindGlow:SetTexture("")

	for i = 1, num do
		local button = _G["MultiBarBottomRightButton"..i]
		tinsert(buttonList, button)
		tinsert(AB.buttons, button)

		if i == 1 then
			B.UpdatePoint(button, "TOPLEFT", frame, "TOPLEFT", padding, -padding)
		elseif (i == 4 and layout < 4) or (i == 7 and layout == 5) then
			B.UpdatePoint(button, "TOP", _G["MultiBarBottomRightButton1"], "BOTTOM", 0, -margin)
		elseif i == 7 and layout < 4 then
			B.UpdatePoint(button, "TOPRIGHT", frame, -2*(cfg.size+margin) - padding, -padding)
		elseif i == 10 and layout < 4 then
			B.UpdatePoint(button, "TOP", _G["MultiBarBottomRightButton7"], "BOTTOM", 0, -margin)
		else
			B.UpdatePoint(button, "LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", margin, 0)
		end
	end

	frame.buttonList = buttonList
	SetFrameSize(frame, cfg.size, num)

	frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	if C.Bars.bar3.fader then
		AB.CreateButtonFrameFader(frame, buttonList, C.Bars.bar3.fader)
	end
end