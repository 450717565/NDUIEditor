local queueFrames = {}

local function QueueFrame_OnEnter(self)
	local resultID = self.result;
	local id, activityID, name, comment, voiceChat, iLvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, numMembers, autoinv = C_LFGList.GetSearchResultInfo(resultID)
	
	local fullName, shortName, categoryID, groupID, iLevel, filters, minLevel, maxPlayers, displayType, orderIndex, useHonorLevel = C_LFGList.GetActivityInfo(activityID);
	local memberCounts = C_LFGList.GetSearchResultMemberCounts(resultID);
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 10, -40);
	GameTooltip:SetText(name, 1, 1, 1, true);	
	GameTooltip:AddLine(fullName);
	if autoinv then
		GameTooltip:AddLine(HOPADDON_AUTOINVITE, 0.25, 0.75, 0.25, true)
	end	
	if ( comment ~= "" ) then
		GameTooltip:AddLine(string.format(LFG_LIST_COMMENT_FORMAT, comment), LFG_LIST_COMMENT_FONT_COLOR.r, LFG_LIST_COMMENT_FONT_COLOR.g, LFG_LIST_COMMENT_FONT_COLOR.b, true);
	end
	GameTooltip:AddLine(" ");
	if ( iLvl > 0 ) then
		GameTooltip:AddLine(string.format(LFG_LIST_TOOLTIP_ILVL, iLvl));
	end
	if ( voiceChat ~= "" ) then
		GameTooltip:AddLine(string.format(LFG_LIST_TOOLTIP_VOICE_CHAT, voiceChat), nil, nil, nil, true);
	end
	if ( iLvl > 0 or voiceChat ~= "" ) then
		GameTooltip:AddLine(" ");
	end

	if ( leaderName ) then
		GameTooltip:AddLine(string.format(LFG_LIST_TOOLTIP_LEADER, leaderName));
	end
	if ( age > 0 ) then
		GameTooltip:AddLine(string.format(LFG_LIST_TOOLTIP_AGE, SecondsToTime(age, false, false, 1, false)));
	end

	if ( leaderName or age > 0 ) then
		GameTooltip:AddLine(" ");
	end

	GameTooltip:AddLine(string.format(LFG_LIST_TOOLTIP_MEMBERS, numMembers, memberCounts.TANK, memberCounts.HEALER, memberCounts.DAMAGER));

	if ( numBNetFriends + numCharFriends + numGuildMates > 0 ) then
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine(LFG_LIST_TOOLTIP_FRIENDS_IN_GROUP);
		GameTooltip:AddLine(LFGListSearchEntryUtil_GetFriendList(resultID), 1, 1, 1, true);
	end

	local completedEncounters = C_LFGList.GetSearchResultEncounterInfo(resultID);
	if ( completedEncounters and #completedEncounters > 0 ) then
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine(LFG_LIST_BOSSES_DEFEATED);
		for i=1, #completedEncounters do
			GameTooltip:AddLine(completedEncounters[i], RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		end
	end
	
	local id, appStatus, pendingStatus, appDuration, role = C_LFGList.GetApplicationInfo(resultID);

	GameTooltip:AddLine(" ");
	
	GameTooltip:AddDoubleLine(WHISPER,HOPADDON_LMB,1, 0.5, 1);
	
	if pendingStatus == "applied" or appStatus == "applied" then
		GameTooltip:AddDoubleLine(HOPADDON_CANCELAPP,HOPADDON_RMB,0.75, 0.25, 0);
	elseif pendingStatus == "invited" or appStatus == "invited" then
		GameTooltip:AddDoubleLine(HOPADDON_DECLINEAPP,HOPADDON_RMB,0.75, 0.25, 0);
	end

	GameTooltip:Show();
end

local function MakeQueueFrame(index)
	local frame = CreateFrame("Button",nil,ServerHop,"UIMenuButtonStretchTemplate")
	local size = 40
	frame:SetSize(size,size)
	frame:SetPoint("BOTTOMLEFT", ServerHop, "TOPLEFT",4+(index-1)*(SERVERHOP_WIDTH)/5,0)

	frame.spinner = CreateFrame("Frame",nil,frame,"LoadingSpinnerTemplate")
	frame.spinner:SetSize(40,40)
	frame.spinner:SetPoint("CENTER",0,0)
	
	frame.iconGreenChck	= frame:CreateTexture(nil,"OVERLAY")
	frame.iconGreenChck:SetSize(20,20)
	frame.iconGreenChck:SetPoint("CENTER",0,0)
	frame.iconGreenChck:SetAtlas("Tracker-Check")
	frame.iconGreenChck:Hide()
	
	frame.textTime = frame:CreateFontString(nil, "OVERLAY","GameFontNormal")
	frame.textTime:SetSize(40,12)
	frame.textTime:SetPoint("BOTTOM",frame,"TOP",0,0)
	frame.textTime:SetText("4:53")	
	
	frame.result = 0

	frame:Hide()
	frame:RegisterForClicks("AnyUp")
	frame:SetScript("OnClick",function(self,button,down)
		if button == "RightButton" then
			self:Hide()
			local id, appStatus, pendingStatus, appDuration, role = C_LFGList.GetApplicationInfo(self.result);
			if appStatus == "applied" or pendingStatus == "applied" then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
				C_LFGList.CancelApplication(self.result)
			elseif pendingStatus == "invited" or appStatus == "invited" then
				LFGListInviteDialog.DeclineButton:Click()
			end
		elseif button == "LeftButton" then
			local id, activityID, name, comment, voiceChat, iLvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, numMembers, autoinv = C_LFGList.GetSearchResultInfo(self.result)
			ChatFrame_SendTell(leaderName)
		end
	end)
	
	frame:SetScript("OnEnter", QueueFrame_OnEnter)
	frame:SetScript("OnLeave", function(self) GameTooltip:Hide() end);	

	
	queueFrames[index]=frame
end

for i=1,5 do MakeQueueFrame(i) end

local function QueueFrames_EventSystem(self,event,...)
	if event == "LFG_LIST_SEARCH_RESULT_UPDATED" then
		local apps = C_LFGList.GetApplications();
		local index = 0

		for i=1, #apps do
			local id, appStatus, pendingStatus, appDuration = C_LFGList.GetApplicationInfo(apps[i]);
			if appDuration == 0 and pendingStatus == "applied" then
					-- phantom groups fix
					-- phantom groups have 0 duration and applied pending				
			else
				if pendingStatus == "applied" or appStatus == "applied" then
					index = index + 1
					queueFrames[index]:Show()
					queueFrames[index].result = id
					queueFrames[index].iconGreenChck:Hide()
					queueFrames[index].spinner:Show()
					queueFrames[index].spinner.Anim:Play()
				elseif pendingStatus == "invited" or appStatus == "invited" then
					index = index + 1
					queueFrames[index]:Show()
					queueFrames[index].result = id
					queueFrames[index].iconGreenChck:Show()
					queueFrames[index].spinner:Hide()
				end			
			end
		end

		for i=(index+1),5 do
			queueFrames[i]:Hide()
		end
	end

end

local lastUp = 0
ServerHop.queueFrame = CreateFrame("Frame")
ServerHop.queueFrame:SetScript("OnUpdate",function(self,elapsed)
	lastUp=lastUp+elapsed
	if lastUp > 1 then
		for i=1,5 do
			if queueFrames[i]:IsShown() then
				local id, appStatus, pendingStatus,appDuration = C_LFGList.GetApplicationInfo(queueFrames[i].result);
				local duration = 0;
				if appDuration and appDuration > 0 then
					duration = appDuration;
				end

				local minutes = math.floor(duration / 60);
				local seconds = duration % 60;
				queueFrames[i].textTime:SetFormattedText("%d:%.2d", minutes, seconds);			
			else break end
		end
	end
end)
ServerHop.queueFrame:SetScript("OnEvent", QueueFrames_EventSystem)
ServerHop.queueFrame:RegisterEvent("LFG_LIST_SEARCH_RESULT_UPDATED")