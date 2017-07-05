local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
	f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if IsAddOnLoaded("Aurora") then
		local F = unpack(Aurora)
		APIIListsInsetLeft.Bg:Hide()

		F.CreateBD(APII_Core)
		F.CreateSD(APII_Core)
		F.ReskinClose(APII_Core.CloseButton)
		F.ReskinInput(APIILists.searchBox)
		F.ReskinScroll(APIIListsSystemListScrollBar)

		local list = {"TitleBackground", "InsetTopBorder", "InsetBottomBorder", "InsetLeftBorder", "InsetRightBorder", "InsetTopLeftCorner", "InsetTopRightCorner", "InsetBotLeftCorner", "InsetBotRightCorner"}
		for k, v in pairs(list) do
			_G["APIIListsInsetLeft"..v]:Hide()
		end

		for i = 1, 16 do
			select(i, APII_Core:GetRegions()):Hide()
		end
	end
end)