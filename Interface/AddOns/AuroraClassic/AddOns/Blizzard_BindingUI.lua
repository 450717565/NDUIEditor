local F, C = unpack(select(2, ...))

C.themes["Blizzard_BindingUI"] = function()
	local r, g, b = C.r, C.g, C.b

	F.ReskinPortraitFrame(KeyBindingFrame, true)
	F.StripTextures(KeyBindingFrame.header, true)
	F.StripTextures(KeyBindingFrame.scrollFrame, true)
	F.StripTextures(KeyBindingFrame.categoryList, true)
	F.StripTextures(KeyBindingFrame.bindingsContainer, true)

	F.Reskin(KeyBindingFrame.defaultsButton)
	F.Reskin(KeyBindingFrame.unbindButton)
	F.Reskin(KeyBindingFrame.okayButton)
	F.Reskin(KeyBindingFrame.cancelButton)
	F.ReskinCheck(KeyBindingFrame.characterSpecificButton)
	F.ReskinScroll(KeyBindingFrameScrollFrameScrollBar)

	for i = 1, KEY_BINDINGS_DISPLAYED do
		local button1 = _G["KeyBindingFrameKeyBinding"..i.."Key1Button"]
		local button2 = _G["KeyBindingFrameKeyBinding"..i.."Key2Button"]
		button2:SetPoint("LEFT", button1, "RIGHT", 1, 0)
	end

	hooksecurefunc("BindingButtonTemplate_SetupBindingButton", function(_, button)
		if not button.styled then
			F.Reskin(button)
			F.ReskinTexture(button, "sl", true)

			button.styled = true
		end
	end)

	KeyBindingFrame.characterSpecificButton:SetSize(24, 24)
	KeyBindingFrame.header.text:ClearAllPoints()
	KeyBindingFrame.header.text:SetPoint("TOP", KeyBindingFrame, "TOP", 0, -8)
	KeyBindingFrame.unbindButton:ClearAllPoints()
	KeyBindingFrame.unbindButton:SetPoint("BOTTOMRIGHT", -207, 16)
	KeyBindingFrame.okayButton:ClearAllPoints()
	KeyBindingFrame.okayButton:SetPoint("BOTTOMLEFT", KeyBindingFrame.unbindButton, "BOTTOMRIGHT", 2, 0)
	KeyBindingFrame.cancelButton:ClearAllPoints()
	KeyBindingFrame.cancelButton:SetPoint("BOTTOMLEFT", KeyBindingFrame.okayButton, "BOTTOMRIGHT", 2, 0)

	local line = KeyBindingFrame:CreateTexture(nil, "ARTWORK")
	line:SetSize(1, 546)
	line:SetPoint("LEFT", 205, 10)
	line:SetColorTexture(1, 1, 1, .25)
end