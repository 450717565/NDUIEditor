local F, C = unpack(select(2, ...))

C.login["Postal"] = function()
	F.ReskinButton(PostalSelectOpenButton)
	F.ReskinButton(PostalSelectReturnButton)
	F.ReskinButton(PostalOpenAllButton)
	F.ReskinArrow(Postal_ModuleMenuButton, "down")
	F.ReskinArrow(Postal_OpenAllMenuButton, "down")
	F.ReskinArrow(Postal_BlackBookButton, "down")
	for i = 1, 7 do
		local checkbox = _G["PostalInboxCB"..i]
		F.ReskinCheck(checkbox)
	end

	Postal_ModuleMenuButton:ClearAllPoints()
	Postal_ModuleMenuButton:SetPoint("RIGHT", MailFrame.CloseButton, "LEFT", -2, 0)
	Postal_OpenAllMenuButton:ClearAllPoints()
	Postal_OpenAllMenuButton:SetPoint("LEFT", PostalOpenAllButton, "RIGHT", 2, 0)
	Postal_BlackBookButton:ClearAllPoints()
	Postal_BlackBookButton:SetPoint("LEFT", SendMailNameEditBox, "RIGHT", 2, 0)
end