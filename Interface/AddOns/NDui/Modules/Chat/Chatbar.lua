local B, C, L, DB = unpack(select(2, ...))
local module = NDui:GetModule("Chat")

function module:Chatbar()
	local chatFrame = SELECTED_DOCK_FRAME
	local editBox = chatFrame.editBox
	local width, height, padding, buttonList = 40, 6, 5, {}

	local Chatbar = CreateFrame("Frame", nil, UIParent)
	Chatbar:SetSize(width, height)
	Chatbar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 5, 9)

	local function AddButton(r, g, b, text, funcC, funcM)
		local bu = CreateFrame("Button", nil, Chatbar, "SecureActionButtonTemplate")
		bu:SetSize(width, height)
		B.CreateIF(bu, true)
		bu.Icon:SetTexture(DB.normTex)
		bu.Icon:SetVertexColor(r, g, b)
		bu:SetHitRectInsets(0, 0, -8, -8)
		bu:RegisterForClicks("AnyUp")
		if text then B.CreateGT(bu, "ANCHOR_TOP", DB.MyColor..text) end
		if funcC then bu:SetScript("OnClick", funcC) end
		if funcM then bu:SetScript("OnMouseUp", funcM) end

		tinsert(buttonList, bu)
		return bu
	end

	-- Create Chatbars
	local buttonInfo = {
		{1, 1, 1, L["Say / Yell"], function(self, btn)
			if btn == "RightButton" then
				ChatFrame_OpenChat("/y ", chatFrame)
			else
				ChatFrame_OpenChat("/s ", chatFrame)
			end
		end},
		{.65, .65, 1, L["Instance / Party"], function()
			ChatFrame_OpenChat("/p ", chatFrame)
		end},
		{1, .5, 0, L["Instance / Raid"], function(self, btn)
			if IsPartyLFG() then
				ChatFrame_OpenChat("/i ", chatFrame)
			else
				ChatFrame_OpenChat("/raid ", chatFrame)
			end
		end},
		{.25, 1, .25, L["Guild / Officer"], function(self, btn)
			if btn == "RightButton" and CanEditOfficerNote() then
				ChatFrame_OpenChat("/o ", chatFrame)
			else
				ChatFrame_OpenChat("/g ", chatFrame)
			end
		end},
		{1, .5, 1, L["Whisper"], function(self, btn)
			if btn == "RightButton" then   
				ChatFrame_ReplyTell(chatFrame)
				if not editBox:IsVisible() or editBox:GetAttribute("chatType") ~= "WHISPER" then
					ChatFrame_OpenChat("/w ", chatFrame)
				end
			else   
				if (UnitExists("target") and UnitName("target") and UnitIsPlayer("target") and GetDefaultLanguage("player") == GetDefaultLanguage("target") )then
					local name = GetUnitName("target", true)
					ChatFrame_OpenChat("/w "..name.." ", chatFrame)
				else
					ChatFrame_OpenChat("/w ", chatFrame)
				end
			end
		end},
		{0, 1, 1, L["Emotion / Roll"], nil, function(self, btn)
			self:SetAttribute("type", "macro")
			if btn == "RightButton" then
				self:SetAttribute("macrotext", "/roll")
			else
				self:SetAttribute("macrotext", "/run ToggleFrame(CustomEmoteFrame)")
			end
		end},
		{1, 1, 0, L["LootMonitor / StatsReport"], nil, function(self, btn)
			self:SetAttribute("type", "macro")
			if not NDuiDB["Extras"]["LootMonitor"] then
				self:SetAttribute("macrotext", "/run ChatFrame_OpenChat(StatsReport())")
			else
				if btn == "RightButton" then
					self:SetAttribute("macrotext", "/run ChatFrame_OpenChat(StatsReport())")
				else
					self:SetAttribute("macrotext", "/ndlm")
				end
			end
		end},
	}
	for _, info in pairs(buttonInfo) do AddButton(unpack(info)) end

	-- WORLD CHANNEL
	if DB.Client == "zhCN" or DB.Client == "zhTW" then
		local channelName, channelID = L["World Channel Name"]
		local wc = AddButton(1, .75, .75, L["World Channel"])

		local function IsInChannel()
			local channels = {GetChannelList()}
			for i = 1, #channels do
				if channels[i] == channelName then
					wc.inChannel = true
					channelID = channels[i-1]
					break
				end
			end
			if wc.inChannel then
				wc.Icon:SetVertexColor(1, .75, .75)
			else
				wc.Icon:SetVertexColor(1, .1, .1)
			end
		end
		IsInChannel()
		NDui:EventFrame("CHANNEL_UI_UPDATE"):SetScript("OnEvent", IsInChannel)

		wc:SetScript("OnClick", function(self, btn)
			if wc.inChannel then
				if btn == "RightButton" then
					LeaveChannelByName(channelName)
					print("|cffFF7F50"..QUIT.."|r "..DB.InfoColor..L["World Channel"])
					wc.inChannel = false
				else
					ChatFrame_OpenChat("/"..channelID, chatFrame)
				end
			else
				JoinPermanentChannel(channelName, nil, 1)
				ChatFrame_AddChannel(ChatFrame1, channelName)
				print("|cff00C957"..JOIN.."|r "..DB.InfoColor..L["World Channel"])
				wc.inChannel = true
			end
		end)
	end

	-- Order Postions
	for i = 1, #buttonList do
		if i == 1 then
			buttonList[i]:SetPoint("LEFT")
		else
			buttonList[i]:SetPoint("LEFT", buttonList[i-1], "RIGHT", padding, 0)
		end
	end
end