local _, ns = ...
local B, C, L, DB = unpack(ns)
local AB = B:GetModule("ActionBar")

local _G = _G
local tinsert = tinsert
local cfg = C.Bars.stancebar
local margin, padding = C.Bars.margin, C.Bars.padding

local function SetFrameSize(frame, size, num)
	size = size or frame.buttonSize
	num = num or frame.numButtons

	frame:SetWidth(num*size + (num-1)*margin + 2*padding)
	frame:SetHeight(size + 2*padding)
	if not frame.mover then
		frame.mover = B.Mover(frame, L["StanceBar"], "StanceBar", frame.Pos)
	else
		frame.mover:SetSize(frame:GetSize())
	end

	if not frame.SetFrameSize then
		frame.buttonSize = size
		frame.numButtons = num
		frame.SetFrameSize = SetFrameSize
	end
end

function AB:CreateStanceBar()
	local num = NUM_STANCE_SLOTS
	local NUM_POSSESS_SLOTS = NUM_POSSESS_SLOTS
	local buttonList = {}

	local frame = CreateFrame("Frame", "NDui_ActionBarStance", UIParent, "SecureHandlerStateTemplate")
	local anchor = C.db["ActionBar"]["BarStyle"] == 4 and _G.NDui_ActionBar3 or _G.NDui_ActionBar2
	frame.Pos = {"BOTTOMLEFT", anchor, "TOPLEFT", 0, -margin}

	-- StanceBar
	if C.db["ActionBar"]["StanceBar"] then
		StanceBarFrame:SetParent(frame)
		StanceBarFrame:EnableMouse(false)
		StanceBarLeft:SetTexture("")
		StanceBarMiddle:SetTexture("")
		StanceBarRight:SetTexture("")

		for i = 1, num do
			local button = _G["StanceButton"..i]
			tinsert(buttonList, button)
			tinsert(AB.buttons, button)

			if i == 1 then
				B.UpdatePoint(button, "BOTTOMLEFT", frame, "BOTTOMLEFT", padding, padding)
			else
				B.UpdatePoint(button, "LEFT", _G["StanceButton"..i-1], "RIGHT", margin, 0)
			end
		end
	end

	-- PossessBar
	PossessBarFrame:SetParent(frame)
	PossessBarFrame:EnableMouse(false)
	PossessBackground1:SetTexture("")
	PossessBackground2:SetTexture("")

	for i = 1, NUM_POSSESS_SLOTS do
		local button = _G["PossessButton"..i]
		tinsert(buttonList, button)

		if i == 1 then
			B.UpdatePoint(button, "BOTTOMLEFT", frame, "BOTTOMLEFT", padding, padding)
		else
			B.UpdatePoint(button, "LEFT", _G["PossessButton"..i-1], "RIGHT", margin, 0)
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