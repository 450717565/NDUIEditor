local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Update_SelectGroupButton(index)
	for i = 1, 3 do
		local button = GroupFinderFrame["groupButton"..i]
		button.bg:SetShown(i == index)
	end
end

tinsert(C.XMLThemes, function()
	B.ReskinFrame(PVEFrame)
	B.ReskinFrameTab(PVEFrame, 3)

	GroupFinderFrame.groupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
	GroupFinderFrame.groupButton2.icon:SetTexture("Interface\\Icons\\INV_Helmet_06")
	GroupFinderFrame.groupButton3.icon:SetTexture("Interface\\Icons\\INV_Misc_GroupNeedMore")

	for i = 1, 3 do
		local button = GroupFinderFrame["groupButton"..i]
		button.ring:Hide()
		B.ReskinButton(button)
		B.ReskinHighlight(button.bg, button, true)

		local icon = button.icon
		icon:ClearAllPoints()
		icon:SetPoint("LEFT", button, "LEFT")
		B.ReskinIcon(icon)
	end

	hooksecurefunc("GroupFinderFrame_SelectGroupButton", Update_SelectGroupButton)
end)