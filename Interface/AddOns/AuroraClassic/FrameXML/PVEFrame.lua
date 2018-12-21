local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local r, g, b = C.r, C.g, C.b

	F.ReskinPortraitFrame(PVEFrame, true)
	F.StripTextures(PVEFrameLeftInset, true)
	F.StripTextures(PVEFrame.shadows, true)

	GroupFinderFrameGroupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
	GroupFinderFrameGroupButton2.icon:SetTexture("Interface\\Icons\\Icon_Scenarios")
	GroupFinderFrameGroupButton3.icon:SetTexture("Interface\\Icons\\inv_helmet_06")

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
		F.Reskin(bu, true)
		F.ReskinTexture(bu.bg, true, bu)

		local icon = bu.icon
		icon:SetPoint("LEFT", bu, "LEFT")
		icon:SetDrawLayer("OVERLAY")
		F.ReskinIcon(icon, true)
	end

	hooksecurefunc("GroupFinderFrame_SelectGroupButton", function(index)
		local self = GroupFinderFrame
		for i = 1, 4 do
			local button = self["groupButton"..i]
			if i == index then
				button.bg:Show()
			else
				button.bg:Hide()
			end
		end
	end)
end)