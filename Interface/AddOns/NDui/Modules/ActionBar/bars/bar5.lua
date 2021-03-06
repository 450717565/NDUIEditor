local _, ns = ...
local B, C, L, DB = unpack(ns)
local AB = B:GetModule("ActionBar")

local _G = _G
local tinsert = tinsert
local cfg = C.Bars.bar5
local margin, padding = C.Bars.margin, C.Bars.padding

local function SetFrameSize(frame, size, num)
	size = size or frame.buttonSize
	num = num or frame.numButtons

	frame:SetWidth(size + 2*padding)
	frame:SetHeight(num*size + (num-1)*margin + 2*padding)
	if not frame.mover then
		frame.mover = B.Mover(frame, SHOW_MULTIBAR4_TEXT, "Bar5", frame.Pos)
	else
		frame.mover:SetSize(frame:GetSize())
	end

	if not frame.SetFrameSize then
		frame.buttonSize = size
		frame.numButtons = num
		frame.SetFrameSize = SetFrameSize
	end
end

function AB:CreateBar5()
	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}
	local layout = C.db["ActionBar"]["BarStyle"]

	local frame = CreateFrame("Frame", "NDui_ActionBar5", UIParent, "SecureHandlerStateTemplate")
	if layout == 1 or layout == 4 or layout == 5 then
		frame.Pos = {"RIGHT", _G.NDui_ActionBar4, "LEFT", margin, 0}
	else
		frame.Pos = {"RIGHT", UIParent, "RIGHT", -1, 5}
	end

	MultiBarLeft:SetParent(frame)
	MultiBarLeft:EnableMouse(false)
	MultiBarLeft.QuickKeybindGlow:SetTexture("")

	for i = 1, num do
		local button = _G["MultiBarLeftButton"..i]
		tinsert(buttonList, button)
		tinsert(AB.buttons, button)

		if i == 1 then
			B.UpdatePoint(button, "TOPRIGHT", frame, "TOPRIGHT", -padding, -padding)
		else
			B.UpdatePoint(button, "TOP", _G["MultiBarLeftButton"..i-1], "BOTTOM", 0, -margin)
		end
	end

	frame.buttonList = buttonList
	SetFrameSize(frame, cfg.size, num)

	frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	if C.db["ActionBar"]["Bar5Fade"] and cfg.fader then
		AB.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end
end