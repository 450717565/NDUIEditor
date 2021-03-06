local _, ns = ...
local B, C, L, DB = unpack(ns)

local tL, tR, tT, tB = unpack(DB.TexCoord)

local function Update_SendMailFrame()
	for i = 1, ATTACHMENTS_MAX_SEND do
		local button = _G["SendMailAttachment"..i]
		local icon = button:GetNormalTexture()

		if HasSendMailItem(i) and icon then
			icon:SetTexCoord(tL, tR, tT, tB)
			icon:SetInside(button)
		end
	end
end

local function Update_OpenAllMail(self)
	self:ClearAllPoints()
	self:SetPoint("BOTTOMRIGHT", MailFrameInset, "TOP", -2, 5)
end

C.OnLoginThemes["MailFrame"] = function()
	B.ReskinFrame(MailFrame)
	B.ReskinFrameTab(MailFrame, 2)

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

	SendMailNameEditBox:SetWidth(160)
	SendMailSubjectEditBox:SetWidth(160)
	SendMailCostMoneyFrame:DisableDrawLayer("BACKGROUND")

	B.UpdatePoint(InboxTitleText, "TOP", MailFrame, "TOP", 0, -5)
	B.UpdatePoint(SendMailTitleText, "TOP", MailFrame, "TOP", 0, -5)
	B.UpdatePoint(OpenMailTitleText, "TOP", OpenMailFrame, "TOP", 0, -5)
	B.UpdatePoint(SendMailMailButton, "RIGHT", SendMailCancelButton, "LEFT", -1, 0)
	B.UpdatePoint(OpenMailDeleteButton, "RIGHT", OpenMailCancelButton, "LEFT", -1, 0)
	B.UpdatePoint(OpenMailReplyButton, "RIGHT", OpenMailDeleteButton, "LEFT", -1, 0)
	B.UpdatePoint(SendMailMoneySilver, "LEFT", SendMailMoneyGold, "RIGHT", 1, 0)
	B.UpdatePoint(SendMailMoneyCopper, "LEFT", SendMailMoneySilver, "RIGHT", 1, 0)
	B.UpdatePoint(SendMailNameEditBox, "TOPLEFT", SendMailFrame, "TOPLEFT", 80, -30)
	B.UpdatePoint(SendMailSubjectEditBox, "TOPLEFT", SendMailNameEditBox, "BOTTOMLEFT", 0, -1)
	B.UpdatePoint(SendMailCostMoneyFrame, "LEFT", SendMailSubjectEditBox, "RIGHT", 4, 0)

	local buttons = {
		OpenAllMail,
		OpenMailCancelButton,
		OpenMailDeleteButton,
		OpenMailReplyButton,
		OpenMailReportSpamButton,
		SendMailCancelButton,
		SendMailMailButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
		button:SetSize(80, 24)
	end

	local inputs = {
		SendMailMoneyCopper,
		SendMailMoneyGold,
		SendMailMoneySilver,
		SendMailNameEditBox,
		SendMailSubjectEditBox,
	}
	for _, input in pairs(inputs) do
		B.ReskinInput(input, 20)
		input:EnableDrawLayer("BACKGROUND")
	end

	local line = B.CreateLines(OpenMailInvoiceFrame, "H")
	line:SetWidth(250)
	line:SetPoint("BOTTOMRIGHT", OpenMailInvoiceAmountReceived, "TOPRIGHT", 7, 7)

	local buttons = {"OpenMailLetterButton", "OpenMailMoneyButton"}
	for _, name in pairs(buttons) do
		local button = _G[name]
		B.CleanTextures(button)

		local icbg = B.ReskinIcon(_G[name.."IconTexture"])
		B.ReskinHLTex(button, icbg)
	end

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local items = "MailItem"..i
		local buttons = items.."Button"

		local item = _G[items]
		B.StripTextures(item)

		local button = _G[buttons]
		B.StripTextures(button)

		local icbg = B.ReskinIcon(_G[buttons.."Icon"])
		B.ReskinHLTex(button, icbg)
		B.ReskinCPTex(button, icbg)

		local border = _G[buttons.."IconBorder"]
		B.ReskinBorder(border, icbg)

		local sender = _G[items.."Sender"]
		sender:ClearAllPoints()
		sender:SetPoint("BOTTOMLEFT", icbg, "RIGHT", 4, 1)

		local Subject = _G[items.."Subject"]
		Subject:ClearAllPoints()
		Subject:SetPoint("TOPLEFT", icbg, "RIGHT", 4, -1)
	end

	for i = 1, ATTACHMENTS_MAX_RECEIVE do
		local buttons = "OpenMailAttachmentButton"..i

		local button = _G[buttons]
		B.CleanTextures(button)

		local icbg = B.ReskinIcon(_G[buttons.."IconTexture"])
		B.ReskinHLTex(button, icbg)
		B.ReskinCPTex(button, icbg)

		local border = button.IconBorder
		B.ReskinBorder(border, icbg)
	end

	for i = 1, ATTACHMENTS_MAX_SEND do
		local button = _G["SendMailAttachment"..i]
		B.StripTextures(button)

		local bubg = B.CreateBDFrame(button)
		B.ReskinHLTex(button, bubg)
		B.ReskinCPTex(button, icbg)

		local border = button.IconBorder
		B.ReskinBorder(border, bubg)
	end

	hooksecurefunc("SendMailFrame_Update", Update_SendMailFrame)
end