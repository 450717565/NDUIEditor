local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(MailFrame)
	F.ReskinFrame(OpenMailFrame)
	F.StripTextures(SendMailFrame, true)
	F.StripTextures(SendMailScrollFrame, true)
	F.StripTextures(OpenMailScrollFrame, true)
	F.StripTextures(SendMailMoneyInset, true)

	F.ReskinButton(SendMailMailButton)
	F.ReskinButton(SendMailCancelButton)
	F.ReskinButton(OpenMailReplyButton)
	F.ReskinButton(OpenMailDeleteButton)
	F.ReskinButton(OpenMailCancelButton)
	F.ReskinButton(OpenMailReportSpamButton)
	F.ReskinButton(OpenAllMail)
	F.ReskinInput(SendMailNameEditBox, false, 20)
	F.ReskinInput(SendMailSubjectEditBox)
	F.ReskinInput(SendMailMoneyGold)
	F.ReskinInput(SendMailMoneySilver)
	F.ReskinInput(SendMailMoneyCopper)
	F.ReskinScroll(SendMailScrollFrameScrollBar)
	F.ReskinScroll(OpenMailScrollFrameScrollBar)
	F.ReskinRadio(SendMailSendMoneyButton)
	F.ReskinRadio(SendMailCODButton)
	F.ReskinArrow(InboxPrevPageButton, "left")
	F.ReskinArrow(InboxNextPageButton, "right")

	F.SetupTabStyle(MailFrame, 2)

	InboxFrameBg:Hide()
	SendMailMoneyBg:Hide()
	SendMailMailButton:SetPoint("RIGHT", SendMailCancelButton, "LEFT", -1, 0)
	OpenMailDeleteButton:SetPoint("RIGHT", OpenMailCancelButton, "LEFT", -1, 0)
	OpenMailReplyButton:SetPoint("RIGHT", OpenMailDeleteButton, "LEFT", -1, 0)

	SendMailMoneySilver:SetPoint("LEFT", SendMailMoneyGold, "RIGHT", 1, 0)
	SendMailMoneyCopper:SetPoint("LEFT", SendMailMoneySilver, "RIGHT", 1, 0)

	SendMailSubjectEditBox:SetPoint("TOPLEFT", SendMailNameEditBox, "BOTTOMLEFT", 0, -1)

	for _, button in pairs({"OpenMailLetterButton", "OpenMailMoneyButton"}) do
		local btn = _G[button]
		btn:SetNormalTexture("")
		btn:SetPushedTexture("")

		local ic = F.ReskinIcon(_G[button.."IconTexture"])
		F.ReskinTexture(btn, ic, false)
	end

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local it = _G["MailItem"..i]
		F.StripTextures(it, true)

		local bu = _G["MailItem"..i.."Button"]
		F.StripTextures(bu)
		bu:SetCheckedTexture(C.media.checked)

		local ic = F.ReskinIcon(_G["MailItem"..i.."Button".."Icon"])
		F.ReskinTexture(bu, ic, false)

		local ib = _G["MailItem"..i.."Button".."IconBorder"]
		ib:SetAlpha(0)
	end

	for i = 1, ATTACHMENTS_MAX_SEND do
		local bu = _G["SendMailAttachment"..i]
		bu:GetRegions():Hide()

		local bg = F.CreateBDFrame(bu, 0)
		F.ReskinTexture(bu, bg, false)

		local border = bu.IconBorder
		F.ReskinBorder(border, bu)
	end

	for i = 1, ATTACHMENTS_MAX_RECEIVE do
		local bu = _G["OpenMailAttachmentButton"..i]
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")

		local ic = F.ReskinIcon(_G["OpenMailAttachmentButton"..i.."IconTexture"])
		F.ReskinTexture(bu, ic, false)

		local border = bu.IconBorder
		F.ReskinBorder(border, bu)
	end

	hooksecurefunc("SendMailFrame_Update", function()
		for i = 1, ATTACHMENTS_MAX_SEND do
			local button = _G["SendMailAttachment"..i]

			if button:GetNormalTexture() then
				button:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			end
		end
	end)

	MailFont_Large:SetTextColor(1, 1, 1)
	MailFont_Large:SetShadowOffset(C.mult, -C.mult)
	MailTextFontNormal:SetTextColor(1, 1, 1)
	MailTextFontNormal:SetShadowOffset(C.mult, -C.mult)
	InvoiceTextFontNormal:SetTextColor(1, 1, 1)
	InvoiceTextFontSmall:SetTextColor(1, 1, 1)
end)