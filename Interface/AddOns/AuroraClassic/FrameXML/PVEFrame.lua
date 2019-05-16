local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(PVEFrame)
	F.SetupTabStyle(PVEFrame, 3)

	GroupFinderFrame.groupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
	GroupFinderFrame.groupButton2.icon:SetTexture("Interface\\Icons\\Icon_Scenarios")
	GroupFinderFrame.groupButton3.icon:SetTexture("Interface\\Icons\\INV_Helmet_06")
	GroupFinderFrame.groupButton4.icon:SetTexture("Interface\\Icons\\INV_Misc_GroupNeedMore")

	for i = 1, 4 do
		local bu = GroupFinderFrame["groupButton"..i]
		bu.ring:Hide()
		F.ReskinButton(bu)
		F.ReskinTexture(bu.bg, bu, true)

		local ic = bu.icon
		ic:SetPoint("LEFT", bu, "LEFT")
		F.ReskinIcon(ic)
	end

	hooksecurefunc("GroupFinderFrame_SelectGroupButton", function(index)
		for i = 1, 4 do
			local button = GroupFinderFrame["groupButton"..i]
			button.bg:SetShown(i == index)
		end
	end)
end)