local _, ns = ...
local B, C, L, DB = unpack(ns)
local AB = B:GetModule("ActionBar")

local _G = _G
local tinsert = tinsert
local cfg = C.Bars.bar2
local margin, padding = C.Bars.margin, C.Bars.padding

local function SetFrameSize(frame, size, num)
	size = size or frame.buttonSize
	num = num or frame.numButtons

	frame:SetWidth(num*size + (num-1)*margin + 2*padding)
	frame:SetHeight(size + 2*padding)
	if not frame.mover then
		frame.mover = B.Mover(frame, SHOW_MULTIBAR1_TEXT, "Bar2", frame.Pos)
	else
		frame.mover:SetSize(frame:GetSize())
	end

	if not frame.SetFrameSize then
		frame.buttonSize = size
		frame.numButtons = num
		frame.SetFrameSize = SetFrameSize
	end
end

function AB:CreateBar2()
	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}

	local frame = CreateFrame("Frame", "NDui_ActionBar2", UIParent, "SecureHandlerStateTemplate")
	frame.Pos = {"BOTTOM", _G.NDui_ActionBar1, "TOP", 0, -margin}

	MultiBarBottomLeft:SetParent(frame)
	MultiBarBottomLeft:EnableMouse(false)
	MultiBarBottomLeft.QuickKeybindGlow:SetTexture("")

	for i = 1, num do
		local button = _G["MultiBarBottomLeftButton"..i]
		tinsert(buttonList, button)
		tinsert(AB.buttons, button)

		if i == 1 then
			B.UpdatePoint(button, "BOTTOMLEFT", frame, "BOTTOMLEFT", padding, padding)
		else
			B.UpdatePoint(button, "LEFT", _G["MultiBarBottomLeftButton"..i-1], "RIGHT", margin, 0)
		end
	end

	frame.buttonList = buttonList
	SetFrameSize(frame, cfg.size, num)

	frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	if cfg.fader then
		AB.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end
end