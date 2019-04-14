local F, C = unpack(select(2, ...))

C.themes["Blizzard_GMChatUI"] = function()
	local frame = GMChatFrame
	frame:SetClampRectInsets(0, 0, 0, 0)
	F.StripTextures(frame)
	F.SetBDFrame(frame):SetPoint("BOTTOMRIGHT", C.mult, -5)

	local close = GMChatFrameCloseButton
	F.ReskinClose(close, "RIGHT", GMChatTab, "RIGHT", -5, 0)

	local edit = GMChatFrameEditBox
	edit:SetAltArrowKeyMode(false)
	for i = 3, 8 do
		select(i, edit:GetRegions()):SetAlpha(0)
	end
	edit:ClearAllPoints()
	edit:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, -8)
	edit:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -28, -32)

	local bg = F.SetBDFrame(edit)
	bg:Hide()
	hooksecurefunc("ChatEdit_DeactivateChat", function(editBox)
		if editBox.isGM then bg:Hide() end
	end)
	hooksecurefunc("ChatEdit_ActivateChat", function(editBox)
		if editBox.isGM then bg:Show() end
	end)

	local lang = GMChatFrameEditBoxLanguage
	lang:GetRegions():SetAlpha(0)
	lang:SetPoint("TOPLEFT", edit, "TOPRIGHT", 4, 0)
	lang:SetPoint("BOTTOMRIGHT", edit, "BOTTOMRIGHT", 28, 0)
	F.SetBDFrame(lang)

	local tab = GMChatTab
	F.StripTextures(tab)
	F.SetBDFrame(tab):SetBackdropColor(0, .6, 1, .3)
	tab:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 4)
	tab:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 28)

	local icon = GMChatTabIcon
	icon:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-Blizz")
	icon:ClearAllPoints()
	icon:SetPoint("LEFT", tab, "LEFT", 5, 0)

	local text = GMChatTabText
	text:ClearAllPoints()
	text:SetPoint("LEFT", icon, "RIGHT", 5, 0)

	F.HideObject(frame.buttonFrame)
end