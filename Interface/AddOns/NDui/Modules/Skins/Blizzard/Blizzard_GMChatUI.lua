local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_GMChatUI"] = function()
	local frame = GMChatFrame
	frame:SetClampRectInsets(0, 0, 0, 0)

	local bg = B.ReskinFrame(frame)
	bg:SetPoint("TOPLEFT", 0, 0)
	bg:SetPoint("BOTTOMRIGHT", C.mult, -5)

	local edit = GMChatFrameEditBox
	edit:SetAltArrowKeyMode(false)
	for i = 3, 8 do
		select(i, edit:GetRegions()):SetAlpha(0)
	end
	edit:ClearAllPoints()
	edit:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, -8)
	edit:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -28, -32)

	local editBG = B.SetBDFrame(edit, 0, 0, 0, 0)
	editBG:Hide()
	hooksecurefunc("ChatEdit_DeactivateChat", function(editBox)
		if editBox.isGM then editBG:Hide() end
	end)
	hooksecurefunc("ChatEdit_ActivateChat", function(editBox)
		if editBox.isGM then editBG:Show() end
	end)

	local lang = GMChatFrameEditBoxLanguage
	lang:GetRegions():SetAlpha(0)
	lang:SetPoint("TOPLEFT", edit, "TOPRIGHT", 3, 0)
	lang:SetPoint("BOTTOMRIGHT", edit, "BOTTOMRIGHT", edit:GetHeight()+3, 0)
	B.SetBDFrame(lang)

	local tab = GMChatTab
	B.StripTextures(tab)
	B.SetBDFrame(tab):SetBackdropColor(0, .6, 1, .25)
	tab:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 4)
	tab:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 28)

	local icon = GMChatTabIcon
	icon:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-Blizz")
	icon:ClearAllPoints()
	icon:SetPoint("LEFT", tab, "LEFT", 5, 0)

	local text = GMChatTabText
	text:ClearAllPoints()
	text:SetPoint("LEFT", icon, "RIGHT", 5, 0)

	B.HideObject(frame.buttonFrame)
end