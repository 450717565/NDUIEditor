local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_BindingUI"] = function()
	B.ReskinFrame(KeyBindingFrame)
	B.ReskinCheck(KeyBindingFrame.characterSpecificButton)
	B.ReskinScroll(KeyBindingFrameScrollFrameScrollBar)

	KeyBindingFrame.characterSpecificButton:SetSize(24, 24)
	KeyBindingFrame.cancelButton:ClearAllPoints()
	KeyBindingFrame.cancelButton:SetPoint("BOTTOMRIGHT", KeyBindingFrame, "BOTTOMRIGHT", -16, 16)
	KeyBindingFrame.okayButton:ClearAllPoints()
	KeyBindingFrame.okayButton:SetPoint("RIGHT", KeyBindingFrame.cancelButton, "LEFT", -1, 0)
	KeyBindingFrame.unbindButton:ClearAllPoints()
	KeyBindingFrame.unbindButton:SetPoint("RIGHT", KeyBindingFrame.okayButton, "LEFT", -1, 0)

	local frames =  {"scrollFrame", "bindingsContainer", "categoryList"}
	for _, frame in pairs(frames) do
		B.StripTextures(KeyBindingFrame[frame])
	end

	local buttons =  {"defaultsButton", "unbindButton", "okayButton", "cancelButton"}
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

	hooksecurefunc("BindingButtonTemplate_SetupBindingButton", function(_, button)
		if not button.styled then
			B.ReskinButton(button)
			B.ReskinTexture(button.selectedHighlight, button, true)

			button.styled = true
		end
	end)

	local line = B.CreateLine(KeyBindingFrameCategoryList)
	line:SetPoint("RIGHT", 10, 0)
end