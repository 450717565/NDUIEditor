local _, ns = ...
local B, C, L, DB = unpack(ns)
local SKIN = B:GetModule("Skins")

function SKIN:Postal()
	if not IsAddOnLoaded("Postal") then return end

	B.ReskinButton(PostalSelectOpenButton)
	B.ReskinButton(PostalSelectReturnButton)
	B.ReskinButton(PostalOpenAllButton)
	B.ReskinArrow(Postal_ModuleMenuButton, "down")
	B.ReskinArrow(Postal_OpenAllMenuButton, "down")
	B.ReskinArrow(Postal_BlackBookButton, "down")
	for i = 1, 7 do
		local checkbox = _G["PostalInboxCB"..i]
		B.ReskinCheck(checkbox)
	end

	Postal_ModuleMenuButton:ClearAllPoints()
	Postal_ModuleMenuButton:SetPoint("RIGHT", MailFrame.CloseButton, "LEFT", -2, 0)
	Postal_OpenAllMenuButton:ClearAllPoints()
	Postal_OpenAllMenuButton:SetPoint("LEFT", PostalOpenAllButton, "RIGHT", 2, 0)
	Postal_BlackBookButton:ClearAllPoints()
	Postal_BlackBookButton:SetPoint("LEFT", SendMailNameEditBox, "RIGHT", 2, 0)
end

C.OnLoginThemes["Postal"] = SKIN.Postal