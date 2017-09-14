-- Populating ServerHop frame
--[[
ServerHop.buttonChangeMode = CreateFrame("Button",nil,ServerHop,"BrowserButtonTemplate")
ServerHop.buttonChangeMode:SetSize(25,25)
ServerHop.buttonChangeMode:SetPoint("TOPRIGHT",-25,4)
ServerHop.buttonChangeMode:SetText("_")

-- hop/search mode toggle button
ServerHop.buttonChangeMode:SetScript("OnClick", function(self)

	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end)

]]

-- close button in the topright corner
ServerHop.closeButton = CreateFrame("Button", nil, ServerHop,"BrowserButtonTemplate")
ServerHop.closeButton:SetSize(25,25)
ServerHop.closeButton:SetPoint("TOPRIGHT",-4,4)
ServerHop.closeButton.Icon = ServerHop.closeButton:CreateTexture(nil,"OVERLAY")
ServerHop.closeButton.Icon:SetSize(14,14)
ServerHop.closeButton.Icon:SetPoint("CENTER",0,0)
ServerHop.closeButton.Icon:SetTexture("Interface\\Buttons\\UI-StopButton")
ServerHop.closeButton:SetScript("OnClick", function(self)
	ServerHop.optionsFrame:Hide()
	PlaySound(SOUNDKIT.GS_TITLE_OPTION_EXIT);
	ServerHop:Hide()
end)

local customOptions = ServerHop.optionsFrame.customSearchOptionsFrame

local function ServerHop_EventSystem(self, event, ...)
	local arg1 = ...
	if event == "ADDON_LOADED" and arg1 == "ServerHop" then	
		if ServerHopSettings ~= nil then
			-- positioning
			if ServerHopSettings["POINT"] ~= nil and ServerHopSettings["X"] ~= nil and ServerHopSettings["Y"] then
				ServerHop:ClearAllPoints()
				ServerHop:SetPoint(ServerHopSettings["POINT"],ServerHopSettings["X"],ServerHopSettings["Y"])
			end
			if ServerHopSettings["ISSHOWN"] then
				ServerHop:Show()
			end

			if ServerHopSettings["DEFAULT_MODE"] ~= nil and ServerHopSettings["DEFAULT_MODE"] == false then
				-- standard mode / compact mode
				--ServerHop.hopFrame:Hide()
				--ServerHop.compactFrame:Show()
			end
		else
			ServerHopSettings = {}
		end

		if ServerHopSettingsGlobal ~= nil then
			if ServerHopSettingsGlobal["NON_AUTO_GROUPS"] ~= nil then
				ServerHop.optionsFrame.hopSearchOptionsFrame.autoInviteCheck:SetChecked(ServerHopSettingsGlobal["NON_AUTO_GROUPS"])
			end
			
			if ServerHop.optionsFrame.hopSearchOptionsFrame.autoInviteCheck:GetChecked() then		
				Slider_Enable(ServerHop.optionsFrame.hopSearchOptionsFrame.sliderQueueWait)
			end

			if ServerHopSettingsGlobal["NON_AUTO_GROUPS_WAIT"] ~= nil then
				ServerHop.optionsFrame.hopSearchOptionsFrame.sliderQueueWait:SetValue(ServerHopSettingsGlobal["NON_AUTO_GROUPS_WAIT"])
			end
			
			if ServerHopSettingsGlobal["BLACKLIST_DURATION"] ~= nil then
				ServerHop.optionsFrame.hopSearchOptionsFrame.sliderBLTime:SetValue(ServerHopSettingsGlobal["BLACKLIST_DURATION"])
			end
			
			if ServerHopSettingsGlobal["HOP_TO_PVP"] ~= nil then
				UIDropDownMenu_SetSelectedID(ServerHop.hopFrame.pvpDrop, ServerHopSettingsGlobal["HOP_TO_PVP"])
				UIDropDownMenu_SetText(ServerHop.hopFrame.pvpDrop, ServerHop_serverTypeDropTable[ServerHopSettingsGlobal["HOP_TO_PVP"]])
			end
			if ServerHopSettingsGlobal["CHAT_NOTIFICATIONS"] ~= nil then
				ServerHop.optionsFrame.hopSearchOptionsFrame.chatNotifButton:SetChecked(ServerHopSettingsGlobal["CHAT_NOTIFICATIONS"])
			end
		else
			ServerHopSettingsGlobal = {}
		end

	elseif event == "PLAYER_LOGIN" then
		-- setup some stuff
		C_LFGList.RequestAvailableActivities()
		ServerHop_GatherPvPRealms(GetCurrentRegion())
		ServerHop:GetZoneList()
		ServerHop.var.currentZone = ServerHop:GetMyZoneID()

	elseif event == "PLAYER_LOGOUT" then
		local point, relativeTo, relativePoint, xOfs, yOfs = ServerHop:GetPoint()
		ServerHopSettings["POINT"] = point
		ServerHopSettings["X"] = xOfs
		ServerHopSettings["Y"] = yOfs
		ServerHopSettings["ISSHOWN"] = ServerHop:IsShown()
		ServerHopSettings["DEFAULT_MODE"] = ServerHop.hopFrame:IsShown()

		ServerHopSettingsGlobal["NON_AUTO_GROUPS"] = ServerHop.optionsFrame.hopSearchOptionsFrame.autoInviteCheck:GetChecked()
		ServerHopSettingsGlobal["NON_AUTO_GROUPS_WAIT"] = ceil(ServerHop.optionsFrame.hopSearchOptionsFrame.sliderQueueWait.value)
		ServerHopSettingsGlobal["BLACKLIST_DURATION"] = ServerHop.optionsFrame.hopSearchOptionsFrame.sliderBLTime.value
		ServerHopSettingsGlobal["HOP_TO_PVP"] = UIDropDownMenu_GetSelectedID(ServerHop.hopFrame.pvpDrop)
		ServerHopSettingsGlobal["CHAT_NOTIFICATIONS"] = ServerHop.optionsFrame.hopSearchOptionsFrame.chatNotifButton:GetChecked()
	end
end

--Events
ServerHop:SetScript("OnEvent", ServerHop_EventSystem)
ServerHop:RegisterEvent("ADDON_LOADED")
ServerHop:RegisterEvent("PLAYER_LOGIN")
ServerHop:RegisterEvent("PLAYER_LOGOUT")
ServerHop:RegisterEvent("DISCONNECTED_FROM_SERVER")