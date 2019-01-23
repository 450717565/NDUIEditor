local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(PVEFrame)
	F.StripTextures(PVEFrame.shadows, true)

	GroupFinderFrameGroupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
	GroupFinderFrameGroupButton3.icon:SetTexture("Interface\\Icons\\INV_Helmet_06")
	GroupFinderFrameGroupButton4.icon:SetTexture("Interface\\Icons\\INV_Misc_GroupNeedMore")

	for i = 1, 3 do
		local tab = _G["PVEFrameTab"..i]
		F.ReskinTab(tab)

		if i ~= 1 then
			tab:SetPoint("LEFT", _G["PVEFrameTab"..i-1], "RIGHT", -15, 0)
		end
	end

	for i = 1, 4 do
		local bu = GroupFinderFrame["groupButton"..i]
		bu.ring:Hide()
		F.ReskinButton(bu)
		F.ReskinTexture(bu.bg, bu, true)

		local icon = bu.icon
		icon:SetPoint("LEFT", bu, "LEFT")
		icon:SetDrawLayer("OVERLAY")
		F.ReskinIcon(icon, true)

		local bg = F.CreateBG(bu.icon)
		bg:SetDrawLayer("ARTWORK")
	end

	hooksecurefunc("GroupFinderFrame_SelectGroupButton", function(index)
		for i = 1, 4 do
			local button = GroupFinderFrame["groupButton"..i]
			button.bg:SetShown(i == index)
		end
	end)
end)