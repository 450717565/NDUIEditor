if IsAddOnLoaded('HandyNotes') then
	local L = LibStub("AceLocale-3.0"):GetLocale("HandyNotes_WorldMapButton", false)
	local FOLDER_NAME = ...
	local Frame = CreateFrame("Frame")

	local iconDefault = [[Interface\AddOns\]] .. FOLDER_NAME .. [[\Buttons\Default]]
	local iconDisabled = [[Interface\AddOns\]] .. FOLDER_NAME .. [[\Buttons\Disabled]]

	local btn = CreateFrame("Button", "HandyNotesWorldMapButton", WorldMapUnitPositionFrame, "UIPanelButtonTemplate")

	function SetIconTexture()
		if HandyNotes:IsEnabled() then
			btn:SetNormalTexture(iconDefault)
		else
			btn:SetNormalTexture(iconDisabled)
		end
	end

	btn:ClearAllPoints()
	btn:SetPoint("TOPRIGHT", WorldMapUnitPositionFrame, "TOPRIGHT", -50, -16)
	btn:RegisterForClicks("AnyUp")
	btn:SetSize(24, 24)
	btn:SetText("")
	SetIconTexture()
	btn:Hide()

	local function btnOnEnter(self, motion)
		SetIconTexture()
		WorldMapTooltip:Hide()
		WorldMapTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
		if HandyNotes:IsEnabled() then
			WorldMapTooltip:AddLine(L["TEXT_TOOLTIP_HIDE_ICONS"], nil, nil, nil, nil, 1 )
		else
			WorldMapTooltip:AddLine(L["TEXT_TOOLTIP_SHOW_ICONS"], nil, nil, nil, nil, 1 )
		end
		WorldMapTooltip:Show()
	end

	local function btnOnLeave(self, motion)
		SetIconTexture()
		WorldMapTooltip:Hide()
	end

	local function btnOnClick(self)
		local db = LibStub("AceDB-3.0"):New("HandyNotesDB", defaults).profile

		if HandyNotes:IsEnabled() then
			db.enabled = false
			HandyNotes:Disable()
		else
			db.enabled = true
			HandyNotes:Enable()
		end
		SetIconTexture()
	end

	btn:SetScript("OnClick", btnOnClick)
	btn:SetScript("OnEnter", btnOnEnter)
	btn:SetScript("OnLeave", btnOnLeave)

	local function DoOnEvent(self, event, ...)
		if ((event == "WORLD_MAP_UPDATE") and (WorldMapFrame:IsVisible())) then
			if IsAddOnLoaded('HandyNotes') then
				if btn then btn:Show() end
				SetIconTexture()
			else
				if btn then btn:Hide() end
			end
		end

		-- Move the MapsterOptionsButton by the Width of HandyNotesWorldMapButton to prevent overlap
		if event == "ADDON_LOADED" then
			if (MapsterOptionsButton) and (not MapsterOptionsButton.MovedByHandyNotesWorldMapButton) then
				point, relativeTo, relativePoint, xOfs, yOfs = MapsterOptionsButton:GetPoint()
				MapsterOptionsButton:ClearAllPoints()
				MapsterOptionsButton:SetPoint(point, relativeTo, relativePoint, xOfs - btn:GetWidth(), yOfs)
				Frame:UnregisterEvent("ADDON_LOADED")
				MapsterOptionsButton.MovedByHandyNotesWorldMapButton = true
			end
		end
	end

	Frame:RegisterEvent("WORLD_MAP_UPDATE")
	Frame:RegisterEvent("ADDON_LOADED")
	Frame:SetScript("OnEvent", DoOnEvent)
end