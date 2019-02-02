local F, C = unpack(select(2, ...))

C.themes["Blizzard_BindingUI"] = function()
	F.ReskinFrame(KeyBindingFrame)
	F.ReskinCheck(KeyBindingFrame.characterSpecificButton)
	F.ReskinScroll(KeyBindingFrameScrollFrameScrollBar)

	KeyBindingFrame.characterSpecificButton:SetSize(24, 24)
	KeyBindingFrame.header:ClearAllPoints()
	KeyBindingFrame.header:SetPoint("TOP", KeyBindingFrame, "TOP", 0, 5)
	KeyBindingFrame.cancelButton:ClearAllPoints()
	KeyBindingFrame.cancelButton:SetPoint("BOTTOMRIGHT", KeyBindingFrame, "BOTTOMRIGHT", -16, 16)
	KeyBindingFrame.okayButton:ClearAllPoints()
	KeyBindingFrame.okayButton:SetPoint("RIGHT", KeyBindingFrame.cancelButton, "LEFT", -1, 0)
	KeyBindingFrame.unbindButton:ClearAllPoints()
	KeyBindingFrame.unbindButton:SetPoint("RIGHT", KeyBindingFrame.okayButton, "LEFT", -1, 0)

	local line = KeyBindingFrame:CreateTexture(nil, "ARTWORK")
	line:SetSize(C.mult, 546)
	line:SetPoint("LEFT", 205, 10)
	line:SetColorTexture(1, 1, 1, .25)

	local frames =  {"header", "scrollFrame", "bindingsContainer", "categoryList"}
	for _, frame in next, frames do
		F.StripTextures(KeyBindingFrame[frame], true)
	end

	local buttons =  {"defaultsButton", "unbindButton", "okayButton", "cancelButton"}
	for _, button in next, buttons do
		F.ReskinButton(KeyBindingFrame[button])
	end

	for i = 1, KEY_BINDINGS_DISPLAYED do
		local button1 = _G["KeyBindingFrameKeyBinding"..i.."Key1Button"]
		local button2 = _G["KeyBindingFrameKeyBinding"..i.."Key2Button"]
		button2:SetPoint("LEFT", button1, "RIGHT", 1, 0)
	end

	hooksecurefunc("BindingButtonTemplate_SetupBindingButton", function(_, button)
		if not button.styled then
			F.ReskinButton(button)
			F.ReskinTexture(button.selectedHighlight, button, true)

			button.styled = true
		end
	end)
end