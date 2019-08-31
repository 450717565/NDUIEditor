local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local cr, cg, cb = C.r, C.g, C.b

	F.ReskinFrame(MailFrame)
	F.SetupTabStyle(MailFrame, 2)

	F.ReskinFrame(OpenMailFrame)

	F.StripTextures(SendMailFrame)
	F.StripTextures(SendMailMoneyInset)
	F.ReskinScroll(SendMailScrollFrameScrollBar)
	F.ReskinScroll(OpenMailScrollFrameScrollBar)
	F.ReskinRadio(SendMailSendMoneyButton)
	F.ReskinRadio(SendMailCODButton)
	F.ReskinArrow(InboxPrevPageButton, "left")
	F.ReskinArrow(InboxNextPageButton, "right")

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
		F.ReskinButton(button)
		button:SetSize(80, 22)
	end

	local inputs = {SendMailNameEditBox, SendMailSubjectEditBox, SendMailMoneyGold, SendMailMoneySilver, SendMailMoneyCopper}
	for _, input in pairs(inputs) do
		F.ReskinInput(input, 20)
		input:EnableDrawLayer("BACKGROUND")
	end

	local line = CreateFrame("Frame", nil, OpenMailInvoiceFrame)
	line:SetPoint("BOTTOMRIGHT", OpenMailInvoiceAmountReceived, "TOPRIGHT", 0, 10)
	F.CreateGA(line, 250, C.mult, "Horizontal", 1, 1, 1, 0, .8)

	for _, button in pairs({"OpenMailLetterButton", "OpenMailMoneyButton"}) do
		local bu = _G[button]
		F.CleanTextures(bu)

		local icbg = F.ReskinIcon(_G[button.."IconTexture"])
		F.ReskinTexture(bu, icbg)
	end

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local item = "MailItem"..i

		local it = _G[item]
		F.StripTextures(it)

		local bu = _G[item.."Button"]
		F.StripTextures(bu)

		local ib = _G[item.."Button".."IconBorder"]
		ib:SetAlpha(0)

		local icbg = F.ReskinIcon(_G[item.."Button".."Icon"])
		F.ReskinTexture(bu, icbg)
		F.ReskinTexed(bu, icbg)

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
		F.CleanTextures(bu)

		local ib = bu.IconBorder
		F.ReskinBorder(ib, bu)

		local icbg = F.ReskinIcon(_G[button.."IconTexture"])
		F.ReskinTexture(bu, icbg)
	end

	for i = 1, ATTACHMENTS_MAX_SEND do
		local button = _G["SendMailAttachment"..i]
		F.StripTextures(button)

		local border = button.IconBorder
		F.ReskinBorder(border, button)

		local bubg = F.CreateBDFrame(button, 0)
		F.ReskinTexture(button, bubg)
	end

	hooksecurefunc("SendMailFrame_Update", function()
		for i = 1, ATTACHMENTS_MAX_SEND do
			local button = _G["SendMailAttachment"..i]

			if button:GetNormalTexture() then
				button:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
			end
		end
	end)

end)