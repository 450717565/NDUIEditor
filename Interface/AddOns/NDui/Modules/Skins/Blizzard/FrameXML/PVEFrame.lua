local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(PVEFrame)
	B.ReskinFrameTab(PVEFrame, 3)
	B.ReskinClose(PremadeGroupsPvETutorialAlert.CloseButton)

	GroupFinderFrame.groupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
	GroupFinderFrame.groupButton2.icon:SetTexture("Interface\\Icons\\Icon_Scenarios")
	GroupFinderFrame.groupButton3.icon:SetTexture("Interface\\Icons\\INV_Helmet_06")
	GroupFinderFrame.groupButton4.icon:SetTexture("Interface\\Icons\\INV_Misc_GroupNeedMore")

	for i = 1, 4 do
		local bu = GroupFinderFrame["groupButton"..i]
		bu.ring:Hide()
		B.ReskinButton(bu)
		B.ReskinHighlight(bu.bg, bu, true)

		local ic = bu.icon
		ic:ClearAllPoints()
		ic:SetPoint("LEFT", bu, "LEFT")
		B.ReskinIcon(ic)
	end

	hooksecurefunc("GroupFinderFrame_SelectGroupButton", function(index)
		for i = 1, 4 do
			local button = GroupFinderFrame["groupButton"..i]
			button.bg:SetShown(i == index)
		end
	end)
end)