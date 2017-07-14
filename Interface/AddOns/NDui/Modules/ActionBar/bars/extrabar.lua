local B, C, L, DB = unpack(select(2, ...))
local Bar = NDui:GetModule("Actionbar")
local cfg = C.bars.extrabar
local padding, margin = 10, 5

function Bar:CreateExtrabar()
	local num = 1
	local buttonList = {}

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "NDui_ExtraActionBar", UIParent, "SecureHandlerStateTemplate")
	frame:SetWidth(num*cfg.size + (num-1)*margin + 2*padding)
	frame:SetHeight(cfg.size + 2*padding)
	if NDuiDB["Actionbar"]["Style"] ~= 4 then
		frame.Pos = {"BOTTOMLEFT", MultiBarBottomRightButton7, "TOPLEFT", -10, 5}
	else
		frame.Pos = {"TOPLEFT", MultiBarBottomRightButton12, "TOPRIGHT", -5, 10}
	end
	frame:SetScale(cfg.scale)

	--move the buttons into position and reparent them
	_G.ExtraActionBarFrame:SetParent(frame)
	_G.ExtraActionBarFrame:EnableMouse(false)
	_G.ExtraActionBarFrame:ClearAllPoints()
	_G.ExtraActionBarFrame:SetPoint("CENTER", 0, 0)
	_G.ExtraActionBarFrame.ignoreFramePositionManager = true

	--the extra button
	local button = _G.ExtraActionButton1
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(cfg.size,cfg.size)

	--show/hide the frame on a given state driver
	frame.frameVisibility = "[extrabar] show; hide"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	--create drag frame and drag functionality
	if C.bars.userplaced then
		B.Mover(frame, L["Extrabar"], "Extrabar", frame.Pos)
	end

	--create the mouseover functionality
	if cfg.fader then
		NDui.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end
end