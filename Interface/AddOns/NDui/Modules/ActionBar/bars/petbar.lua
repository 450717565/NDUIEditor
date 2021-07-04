local _, ns = ...
local B, C, L, DB = unpack(ns)
local Bar = B:GetModule("ActionBar")

local _G = _G
local tinsert = tinsert
local cfg = C.Bars.petbar
local margin, padding = C.Bars.margin, C.Bars.padding

local function SetFrameSize(frame, size, num)
	size = size or frame.buttonSize
	num = num or frame.numButtons

	frame:SetWidth(num*size + (num-1)*margin + 2*padding)
	frame:SetHeight(size + 2*padding)
	if not frame.mover then
		frame.mover = B.Mover(frame, L["Pet ActionBar"], "PetBar", frame.Pos)
	else
		frame.mover:SetSize(frame:GetSize())
	end

	if not frame.SetFrameSize then
		frame.buttonSize = size
		frame.numButtons = num
		frame.SetFrameSize = SetFrameSize
	end
end

function Bar:CreatePetBar()
	local num = NUM_PET_ACTION_SLOTS
	local buttonList = {}

	local frame = CreateFrame("Frame", "NDui_ActionBarPet", UIParent, "SecureHandlerStateTemplate")
	local anchor = C.db["ActionBar"]["BarStyle"] == 4 and _G.NDui_ActionBar3 or _G.NDui_ActionBar2
	frame.Pos = {"BOTTOMRIGHT", anchor, "TOPRIGHT", 0, -margin}

	PetActionBarFrame:SetParent(frame)
	PetActionBarFrame:EnableMouse(false)
	SlidingActionBarTexture0:SetTexture("")
	SlidingActionBarTexture1:SetTexture("")

	for i = 1, num do
		local button = _G["PetActionButton"..i]
		tinsert(buttonList, button)
		tinsert(Bar.buttons, button)

		if i == 1 then
			B.UpdatePoint(button, "LEFT", frame, "LEFT", padding, 0)
		else
			B.UpdatePoint(button, "LEFT", _G["PetActionButton"..i-1], "RIGHT", margin, 0)
		end
	end

	frame.buttonList = buttonList
	SetFrameSize(frame, cfg.size, num)

	frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; [pet] show; hide"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	if cfg.fader then
		Bar.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end
end