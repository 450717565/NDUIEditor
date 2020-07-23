local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(MailFrame)
	B.SetupTabStyle(MailFrame, 2)

	B.ReskinFrame(OpenMailFrame)

	B.StripTextures(SendMailFrame)
	B.StripTextures(SendMailMoneyInset)
	B.ReskinScroll(SendMailScrollFrameScrollBar)
	B.ReskinScroll(OpenMailScrollFrameScrollBar)
	B.ReskinRadio(SendMailSendMoneyButton)
	B.ReskinRadio(SendMailCODButton)
	B.ReskinArrow(InboxPrevPageButton, "left")
	B.ReskinArrow(InboxNextPageButton, "right")

	InboxFrameBg:Hide()
	SendMailMoneyBg:Hide()
	OpenMailArithmeticLine:Hide()

	InboxTitleText:ClearAllPoints()
	InboxTitleText:SetPoint("TOP", MailFrame, 0, -5)
	SendMailTitleText:ClearAllPoints()
	SendMailTitleText:SetPoint("TOP", MailFrame, 0, -5)
	OpenMailTitleText:ClearAllPoints()
	OpenMailTitleText:SetPoint("TOP", OpenMailFrame, 0, -5)

	SendMailMailButton:ClearAllPoints()
	SendMailMailButton:SetPoint("RIGHT", SendMailCancelButton, "LEFT", -1, 0)
	OpenMailDeleteButton:ClearAllPoints()
	OpenMailDeleteButton:SetPoint("RIGHT", OpenMailCancelButton, "LEFT", -1, 0)
	OpenMailReplyButton:ClearAllPoints()
	OpenMailReplyButton:SetPoint("RIGHT", OpenMailDeleteButton, "LEFT", -1, 0)

	SendMailMoneySilver:ClearAllPoints()
	SendMailMoneySilver:SetPoint("LEFT", SendMailMoneyGold, "RIGHT", 1, 0)
	SendMailMoneyCopper:ClearAllPoints()
	SendMailMoneyCopper:SetPoint("LEFT", SendMailMoneySilver, "RIGHT", 1, 0)

	SendMailSubjectEditBox:ClearAllPoints()
	SendMailSubjectEditBox:SetPoint("TOPLEFT", SendMailNameEditBox, "BOTTOMLEFT", 0, -1)

	SendMailCostMoneyFrame:ClearAllPoints()
	SendMailCostMoneyFrame:SetPoint("BOTTOMRIGHT", SendMailSubjectEditBox, "TOPRIGHT", 0, 5)

	InvoiceTextFontNormal:SetTextColor(1, .8, 0)
	InvoiceTextFontSmall:SetTextColor(1, 1, 1)
	MailTextFontNormal:SetTextColor(1, 1, 1)

	local buttons = {SendMailMailButton, SendMailCancelButton, OpenMailReplyButton, OpenMailDeleteButton, OpenMailCancelButton, OpenMailReportSpamButton, OpenAllMail}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
		button:SetSize(80, 22)
	end

	local inputs = {SendMailNameEditBox, SendMailSubjectEditBox, SendMailMoneyGold, SendMailMoneySilver, SendMailMoneyCopper}
	for _, input in pairs(inputs) do
		B.ReskinInput(input, 20)
		input:EnableDrawLayer("BACKGROUND")
	end

	local line = CreateFrame("Frame", nil, OpenMailInvoiceFrame)
	line:SetPoint("BOTTOMRIGHT", OpenMailInvoiceAmountReceived, "TOPRIGHT", 0, 10)
	B.CreateGA(line, 250, C.mult, "Horizontal", 1, 1, 1, 0, DB.Alpha)

	for _, button in pairs({"OpenMailLetterButton", "OpenMailMoneyButton"}) do
		local bu = _G[button]
		B.CleanTextures(bu)

		local icbg = B.ReskinIcon(_G[button.."IconTexture"])
		B.ReskinHighlight(bu, icbg)
	end

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local item = "MailItem"..i

		local it = _G[item]
		B.StripTextures(it)

		local bu = _G[item.."Button"]
		B.StripTextures(bu)

		local ib = _G[item.."Button".."IconBorder"]
		ib:SetAlpha(0)

		local icbg = B.ReskinIcon(_G[item.."Button".."Icon"])
		B.ReskinHighlight(bu, icbg)
		B.ReskinChecked(bu, icbg)

		local sender = _G[item.."Sender"]
		sender:ClearAllPoints()
		sender:SetPoint("BOTTOMLEFT", icbg, "RIGHT", 4, 1)

		local Subject = _G[item.."Subject"]
		Subject:ClearAllPoints()
		Subject:SetPoint("TOPLEFT", icbg, "RIGHT", 4, -1)
	end

	for i = 1, ATTACHMENTS_MAX_RECEIVE do
		local button = "OpenMailAttachmentButton"..i

		local bu = _G[button]
		B.CleanTextures(bu)

		local icbg = B.ReskinIcon(_G[button.."IconTexture"])
		B.ReskinHighlight(bu, icbg)

		local ib = bu.IconBorder
		B.ReskinBorder(ib, icbg)
	end

	for i = 1, ATTACHMENTS_MAX_SEND do
		local button = _G["SendMailAttachment"..i]
		B.StripTextures(button)

		local bubg = B.CreateBDFrame(button, 0)
		B.ReskinHighlight(button, bubg)

		local border = button.IconBorder
		B.ReskinBorder(border, bubg)
	end

	hooksecurefunc("SendMailFrame_Update", function()
		for i = 1, ATTACHMENTS_MAX_SEND do
			local button = _G["SendMailAttachment"..i]

			if button:GetNormalTexture() then
				button:GetNormalTexture():SetTexCoord(unpack(DB.TexCoord))
			end
		end
	end)

end)