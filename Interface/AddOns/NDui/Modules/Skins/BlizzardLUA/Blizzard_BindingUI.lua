local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_BindingButtonTemplate(_, button)
	if not button.styled then
		B.ReskinButton(button)
		B.ReskinHLTex(button.selectedHighlight, button, true)

		button.styled = true
	end
end

C.OnLoadThemes["Blizzard_BindingUI"] = function()
	B.ReskinFrame(KeyBindingFrame)
	B.ReskinCheck(KeyBindingFrame.characterSpecificButton)
	B.ReskinScroll(KeyBindingFrameScrollFrameScrollBar)

	KeyBindingFrame.characterSpecificButton:SetSize(24, 24)

	local frames = {
		"scrollFrame",
		"bindingsContainer",
		"categoryList",
	}
	for _, frame in pairs(frames) do
		B.StripTextures(KeyBindingFrame[frame])
	end

	local buttons = {
		"defaultsButton",
		"unbindButton",
		"okayButton",
		"cancelButton",
		"quickKeybindButton",
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(KeyBindingFrame[button])
	end

	for i = 1, KEY_BINDINGS_DISPLAYED do
		local button = "KeyBindingFrameKeyBinding"..i

		local button1 = _G[button.."Key1Button"]
		local button2 = _G[button.."Key2Button"]

		button2:ClearAllPoints()
		button2:SetPoint("LEFT", button1, "RIGHT", 1, 0)
	end

	hooksecurefunc("BindingButtonTemplate_SetupBindingButton", Reskin_BindingButtonTemplate)

	local line = B.CreateLines(KeyBindingFrameCategoryList, "V")
	line:SetPoint("RIGHT", 10, 0)

	-- QuickKeybindFrame
	local frame = QuickKeybindFrame
	B.ReskinFrame(frame)
	B.ReskinButton(frame.okayButton)
	B.ReskinButton(frame.defaultsButton)
	B.ReskinButton(frame.cancelButton)
	B.ReskinCheck(frame.characterSpecificButton)
	frame.characterSpecificButton:SetSize(24, 24)
end