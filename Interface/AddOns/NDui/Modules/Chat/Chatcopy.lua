local _, ns = ...
local B, C, L, DB, F = unpack(ns)
local module = B:GetModule("Chat")

function module:ChatCopy()
	local gsub, format, tconcat = string.gsub, string.format, table.concat

	-- Custom ChatMenu
	local menu = CreateFrame("Frame", nil, UIParent)
	menu:SetSize(25, 100)
	menu:SetPoint("TOPLEFT", ChatFrame1, "TOPRIGHT")
	menu:SetShown(NDuiDB["Chat"]["ChatMenu"])

	QuickJoinToastButton:Hide()
	ChatFrameMenuButton:ClearAllPoints()
	ChatFrameMenuButton:SetPoint("TOP", menu)
	ChatFrameMenuButton:SetParent(menu)
	ChatFrameChannelButton:ClearAllPoints()
	ChatFrameChannelButton:SetPoint("TOP", ChatFrameMenuButton, "BOTTOM", 0, -2)
	ChatFrameChannelButton:SetParent(menu)
	ChatFrameToggleVoiceDeafenButton:SetParent(menu)
	ChatFrameToggleVoiceMuteButton:SetParent(menu)
	QuickJoinToastButton:SetParent(menu)
	ChatAlertFrame:ClearAllPoints()
	ChatAlertFrame:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "TOPLEFT", 5, 25)

	-- Chat Copy
	local lines = {}
	local frame = CreateFrame("Frame", "NDuiChatCopy", UIParent)
	frame:SetPoint("CENTER")
	frame:SetSize(700, 400)
	frame:Hide()
	frame:SetFrameStrata("DIALOG")
	B.CreateMF(frame)
	B.SetBackground(frame)

	local closeBotton = B.CreateButton(frame, 18, 18, "X")
	closeBotton:SetPoint("TOPRIGHT", frame, -7, -7)
	closeBotton:SetScript("OnClick", function() frame:Hide() end)

	local scrollArea = CreateFrame("ScrollFrame", "ChatCopyScrollFrame", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 10)

	local editBox = CreateFrame("EditBox", nil, frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFont(DB.Font[1], 12)
	editBox:SetWidth(scrollArea:GetWidth())
	editBox:SetHeight(270)
	editBox:SetScript("OnEscapePressed", function() frame:Hide() end)
	editBox:SetScript("OnTextChanged", function(_, userInput)
		if userInput then return end
		local _, max = ChatCopyScrollFrameScrollBar:GetMinMaxValues()
		for i = 1, max do
			ScrollFrameTemplate_OnMouseWheel(scrollArea, -1)
		end
	end)
	scrollArea:SetScrollChild(editBox)
	scrollArea:HookScript("OnVerticalScroll", function(self, offset)
		editBox:SetHitRectInsets(0, 0, offset, (editBox:GetHeight() - offset - self:GetHeight()))
	end)

	local function colorReplace(msg, r, g, b)
		local hexRGB = B.HexRGB(r, g, b)
		local hexReplace = format("|r%s", hexRGB)
		msg = gsub(msg, "|r", hexReplace)
		msg = format("%s%s|r", hexRGB, msg)

		return msg
	end

	local function copyFunc(_, btn)
		if not frame:IsShown() then
			local chatframe = SELECTED_DOCK_FRAME
			local _, fontSize = chatframe:GetFont()
			FCF_SetChatWindowFontSize(chatframe, chatframe, .01)
			frame:Show()

			local index = 1
			for i = 1, chatframe:GetNumMessages() do
				local message, r, g, b = chatframe:GetMessageInfo(i)
				r = r or 1
				g = g or 1
				b = b or 1
				message = colorReplace(message, r, g, b)

				lines[index] = tostring(message)
				index = index + 1
			end

			local lineCt = index - 1
			local text = table.concat(lines, "\n", 1, lineCt)
			FCF_SetChatWindowFontSize(chatframe, chatframe, fontSize)
			editBox:SetText(text)

			wipe(lines)
		else
			frame:Hide()
		end
	end

	local function hintFunc(self)
		B.AddTooltip(self, "ANCHOR_TOP", L["Chat Copy"], "class")
	end

	for i = 1, NUM_CHAT_WINDOWS do
		local tab = _G["ChatFrame"..i.."Tab"]
		tab:SetScript("OnDoubleClick", copyFunc)
		tab:SetScript("OnEnter", hintFunc)
	end

	if F then F.ReskinScroll(ChatCopyScrollFrameScrollBar) end
end