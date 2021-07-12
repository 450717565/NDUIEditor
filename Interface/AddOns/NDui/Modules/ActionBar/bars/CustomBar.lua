local _, ns = ...
local B, C, L, DB = unpack(ns)
local AB = B:GetModule("ActionBar")

local tinsert = tinsert
local mod, min, ceil = mod, min, ceil
local cfg = C.Bars.bar4
local margin, padding = C.Bars.margin, C.Bars.padding

function AB:CreateCustomBar(anchor)
	local size = C.db["ActionBar"]["CustomBarButtonSize"]
	local num = 12
	local name = "NDui_CustomBar"
	local page = 8

	local frame = CreateFrame("Frame", name, UIParent, "SecureHandlerStateTemplate")
	frame:SetWidth(num*size + (num-1)*margin + 2*padding)
	frame:SetHeight(size + 2*padding)
	frame:SetPoint(unpack(anchor))
	frame.mover = B.Mover(frame, L[name], "CustomBar", anchor)
	frame.buttons = {}

	RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show")
	RegisterStateDriver(frame, "page", page)

	local buttonList = {}
	for i = 1, num do
		local button = CreateFrame("CheckButton", "$parentButton"..i, frame, "ActionBarButtonTemplate")
		button:SetSize(size, size)
		button.id = (page-1)*12 + i
		button.isCustomButton = true
		button.commandName = L[name]..i
		button:SetAttribute("action", button.id)
		frame.buttons[i] = button
		tinsert(buttonList, button)
		tinsert(AB.buttons, button)
	end

	if C.db["ActionBar"]["CustomBarFader"] and cfg.fader then
		AB.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end

	AB:UpdateCustomBar()
end

function AB:UpdateCustomBar()
	local frame = _G.NDui_CustomBar
	if not frame then return end

	local size = C.db["ActionBar"]["CustomBarButtonSize"]
	local num = C.db["ActionBar"]["CustomBarNumButtons"]
	local perRow = C.db["ActionBar"]["CustomBarNumPerRow"]
	local scale = size/34

	for i = 1, num do
		local button = frame.buttons[i]
		button:SetSize(size, size)
		button.Name:SetScale(scale)
		button.Count:SetScale(scale)
		button.HotKey:SetScale(scale)

		if i == 1 then
			B.UpdatePoint(button, "TOPLEFT", frame, "TOPLEFT", padding, -padding)
		elseif mod(i-1, perRow) ==  0 then
			B.UpdatePoint(button, "TOP", frame.buttons[i-perRow], "BOTTOM", 0, -margin)
		else
			B.UpdatePoint(button, "LEFT", frame.buttons[i-1], "RIGHT", margin, 0)
		end

		button:SetAttribute("statehidden", false)
		button:Show()
	end

	for i = num+1, 12 do
		local button = frame.buttons[i]
		button:SetAttribute("statehidden", true)
		button:Hide()
	end

	local column = min(num, perRow)
	local rows = ceil(num/perRow)
	frame:SetWidth(column*size + (column-1)*margin + 2*padding)
	frame:SetHeight(size*rows + (rows-1)*margin + 2*padding)
	frame.mover:SetSize(frame:GetSize())
end

function AB:CustomBar()
	if C.db["ActionBar"]["CustomBar"] then
		AB:CreateCustomBar({"BOTTOM", UIParent, "BOTTOM", 0, 140})
	end
end