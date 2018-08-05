local _, ns = ...
local B, C, L, DB = unpack(ns)
local module = B:GetModule("Chat")

function module:Chatbar()
	local chatFrame = SELECTED_DOCK_FRAME
	local editBox = chatFrame.editBox
	local width, height, padding, buttonList = 40, 6, 5, {}

	local Chatbar = CreateFrame("Frame", nil, UIParent)
	Chatbar:SetSize(width, height)
	Chatbar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 5, 11.5)

	local function AddButton(r, g, b, text, funcC, funcM)
		local bu = CreateFrame("Button", nil, Chatbar, "SecureActionButtonTemplate")
		bu:SetSize(width, height)
		B.CreateIF(bu, true)
		bu.Icon:SetTexture(DB.normTex)
		bu.Icon:SetVertexColor(r, g, b)
		bu:SetHitRectInsets(0, 0, -8, -8)
		bu:RegisterForClicks("AnyUp")
		if text then B.AddTooltip(bu, "ANCHOR_TOP", B.HexRGB(r, g, b)..text) end
		if funcC then bu:SetScript("OnClick", funcC) end
		if funcM then bu:SetScript("OnMouseUp", funcM) end

		tinsert(buttonList, bu)
		return bu
	end

	function StatusReport()
		local info = ""
		local mainStat = {"STRENGTH", "AGILITY", nil, "INTELLECT"}
		local _, spec, _, _, _, main = GetSpecializationInfo(GetSpecialization())
		local artifactLvl = select(6, C_ArtifactUI.GetEquippedArtifactInfo()) or 0
		local statCollect = {
			{str = CLASS..":%s ", UnitClass("player")},
			{str = SPECIALIZATION..":%s ", disabel = not GetSpecialization(), spec},
			{str = STAT_AVERAGE_ITEM_LEVEL..":%.1f(%.1f) ", GetAverageItemLevel()},
			{str = ARCHAEOLOGY_CURRENT..":%s(%s) " , disable = not C_ArtifactUI.GetEquippedArtifactInfo(), artifactLvl, artifactLvl > 51 and  artifactLvl - 51 or 0},
			{str = _G["SPEC_FRAME_PRIMARY_STAT_"..mainStat[main]]..":%s ", UnitStat("player", main)},
			{str = HEALTH..":%s ", B.Numb(UnitHealthMax("player"))},
			{str = STAT_CRITICAL_STRIKE..":%.2f%% ", GetCritChance()},
			{str = STAT_HASTE..":%.2f%% ", GetHaste()},
			{str = STAT_MASTERY..":%.2f%% ", GetMasteryEffect()},
			{str = STAT_VERSATILITY..":%.2f%% ", disable = GetCombatRatingBonus(29) == 0, GetCombatRatingBonus(29)},
			{str = STAT_AVOIDANCE..":%.2f%% ", disable = GetAvoidance() == 0, GetAvoidance()},
			{str = STAT_LIFESTEAL..":%.2f%% ", disable = GetLifesteal() == 0, GetLifesteal()},
			{str = STAT_DODGE..":%.2f%% ", disable = DB.Role ~= "Tank" or GetDodgeChance() == 0, GetDodgeChance()},
			{str = STAT_PARRY..":%.2f%% ", disable = DB.Role ~= "Tank" or GetParryChance() == 0, GetParryChance()},
			{str = STAT_BLOCK..":%.2f%% ", disable = DB.Role ~= "Tank" or GetBlockChance() == 0, GetBlockChance()},
		}

		for _, stat in ipairs(statCollect) do
			if not stat.disable then
				info = info..stat.str:format(unpack(stat))
			end
		end
		return info
	end

	-- Create Chatbars
	local buttonInfo = {
		{1, 1, 1, L["Say / Yell"], function(_, btn)
			if btn == "RightButton" then
				ChatFrame_OpenChat("/y ", chatFrame)
			else
				ChatFrame_OpenChat("/s ", chatFrame)
			end
		end},
		{.65, .65, 1, L["Instance / Party"], function()
			ChatFrame_OpenChat("/p ", chatFrame)
		end},
		{1, .5, 0, L["Instance / Raid"], function()
			if IsPartyLFG() then
				ChatFrame_OpenChat("/i ", chatFrame)
			else
				ChatFrame_OpenChat("/raid ", chatFrame)
			end
		end},
		{.25, 1, .25, L["Guild / Officer"], function(_, btn)
			if btn == "RightButton" and CanEditOfficerNote() then
				ChatFrame_OpenChat("/o ", chatFrame)
			else
				ChatFrame_OpenChat("/g ", chatFrame)
			end
		end},
		{1, .5, 1, L["Whisper"], function(_, btn)
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
		{1, 1, 0, L["LootMonitor / StatusReport"], nil, function(self, btn)
			self:SetAttribute("type", "macro")
			if not NDuiDB["Extras"]["LootMonitor"] then
				self:SetAttribute("macrotext", "/run ChatFrame_OpenChat(StatusReport())")
			else
				if btn == "RightButton" then
					self:SetAttribute("macrotext", "/run ChatFrame_OpenChat(StatusReport())")
				else
					self:SetAttribute("macrotext", "/ndlm")
				end
			end
		end},
	}
	for _, info in pairs(buttonInfo) do AddButton(unpack(info)) end

	-- WORLD CHANNEL
	if DB.Client == "zhCN" then
		local channelName, channelID, channels = L["World Channel Name"]
		local wc = AddButton(1, .75, .75, L["World Channel"])

		local function isInChannel(event)
			channels = {GetChannelList()}
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

			if event == "PLAYER_ENTERING_WORLD" then
				B:UnregisterEvent(event, isInChannel)
			end
		end
		B:RegisterEvent("PLAYER_ENTERING_WORLD", isInChannel)
		B:RegisterEvent("CHANNEL_UI_UPDATE", isInChannel)

		wc:SetScript("OnClick", function(_, btn)
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