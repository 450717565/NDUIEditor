local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinPortraitFrame(MailFrame, true)
	F.ReskinPortraitFrame(OpenMailFrame, true)
	F.StripTextures(SendMailFrame, true)
	F.StripTextures(SendMailScrollFrame, true)
	F.StripTextures(OpenMailScrollFrame, true)
	F.StripTextures(SendMailMoneyInset, true)

	F.Reskin(SendMailMailButton)
	F.Reskin(SendMailCancelButton)
	F.Reskin(OpenMailReplyButton)
	F.Reskin(OpenMailDeleteButton)
	F.Reskin(OpenMailCancelButton)
	F.Reskin(OpenMailReportSpamButton)
	F.Reskin(OpenAllMail)
	F.ReskinInput(SendMailNameEditBox, 20)
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

	InboxFrameBg:Hide()
	SendMailMoneyBg:Hide()
	SendMailMailButton:SetPoint("RIGHT", SendMailCancelButton, "LEFT", -1, 0)
	OpenMailDeleteButton:SetPoint("RIGHT", OpenMailCancelButton, "LEFT", -1, 0)
	OpenMailReplyButton:SetPoint("RIGHT", OpenMailDeleteButton, "LEFT", -1, 0)

	SendMailMoneySilver:SetPoint("LEFT", SendMailMoneyGold, "RIGHT", 1, 0)
	SendMailMoneyCopper:SetPoint("LEFT", SendMailMoneySilver, "RIGHT", 1, 0)

	SendMailSubjectEditBox:SetPoint("TOPLEFT", SendMailNameEditBox, "BOTTOMLEFT", 0, -1)

	for i = 1, 2 do
		F.ReskinTab(_G["MailFrameTab"..i])
	end

	local buttons = {"OpenMailLetterButton", "OpenMailMoneyButton"}
	for _, button in next, buttons do
		local btn = _G[button]
		btn:SetNormalTexture("")
		btn:SetPushedTexture("")
		btn:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

		local ic = _G[button.."IconTexture"]
		ic:SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(ic, .25)
	end

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local it = _G["MailItem"..i]
		F.StripTextures(it, true)

		local bu = _G["MailItem"..i.."Button"]
		F.StripTextures(bu)
		bu:SetCheckedTexture(C.media.checked)
		bu:SetHighlightTexture(C.media.backdrop)

		local hl = bu:GetHighlightTexture()
		hl:SetVertexColor(1, 1, 1, .25)
		hl:SetPoint("TOPLEFT", 0, 0)
		hl:SetPoint("BOTTOMRIGHT", -1, 1)

		local ic = _G["MailItem"..i.."Button".."Icon"]
		ic:SetTexCoord(.08, .92, .08, .92)
		if not ic.styled then
			F.CreateBDFrame(ic, .25)
			ic.styled = true
		end

		local ib = _G["MailItem"..i.."Button".."IconBorder"]
		ib:SetAlpha(0)
	end

	for i = 1, ATTACHMENTS_MAX_SEND do
		local bu = _G["SendMailAttachment"..i]
		bu:GetRegions():Hide()
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		F.CreateBDFrame(bu, .25)

		local border = bu.IconBorder
		border:SetPoint("TOPLEFT", -1.2, 1.2)
		border:SetPoint("BOTTOMRIGHT", 1.2, -1.2)
		border:SetDrawLayer("BACKGROUND")
	end

	hooksecurefunc("SendMailFrame_Update", function()
		for i = 1, ATTACHMENTS_MAX_SEND do
			local bu = _G["SendMailAttachment"..i]

			if bu:GetNormalTexture() == nil and bu.IconBorder:IsShown() then
				bu.IconBorder:Hide()
			end
		end
	end)

	for i = 1, ATTACHMENTS_MAX_RECEIVE do
		local bu = _G["OpenMailAttachmentButton"..i]
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		F.CreateBDFrame(bu, .25)

		local ic = _G["OpenMailAttachmentButton"..i.."IconTexture"]
		ic:SetTexCoord(.08, .92, .08, .92)

		local border = bu.IconBorder
		border:SetTexture(C.media.backdrop)
		border.SetTexture = F.dummy
		border:SetPoint("TOPLEFT", -1.2, 1.2)
		border:SetPoint("BOTTOMRIGHT", 1.2, -1.2)
		border:SetDrawLayer("BACKGROUND")
	end

	hooksecurefunc("SendMailFrame_Update", function()
		for i = 1, ATTACHMENTS_MAX_SEND do
			local button = _G["SendMailAttachment"..i]
			button.IconBorder:SetTexture(C.media.backdrop)

			if button:GetNormalTexture() then
				button:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			end
		end
	end)

	MailFont_Large:SetTextColor(1, 1, 1)
	MailFont_Large:SetShadowOffset(1, -1)
	MailTextFontNormal:SetTextColor(1, 1, 1)
	MailTextFontNormal:SetShadowOffset(1, -1)
	InvoiceTextFontNormal:SetTextColor(1, 1, 1)
	InvoiceTextFontSmall:SetTextColor(1, 1, 1)
end)