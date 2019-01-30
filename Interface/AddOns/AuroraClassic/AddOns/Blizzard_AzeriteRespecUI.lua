local F, C = unpack(select(2, ...))

C.themes["Blizzard_AzeriteRespecUI"] = function()
	for i = 1, 14 do
		select(i, AzeriteRespecFrame:GetRegions()):Hide()
	end
	AzeriteRespecFrame.NineSlice:Hide()

	F.ReskinFrame(AzeriteRespecFrame, true)

	local Background = AzeriteRespecFrame.Background
	Background:SetAlpha(1)
	Background:Show()
	F.CreateBDFrame(Background, .25, true)

	local ItemSlot = AzeriteRespecFrame.ItemSlot
	F.ReskinIcon(ItemSlot.Icon)

	local ButtonFrame = AzeriteRespecFrame.ButtonFrame
	F.StripTextures(ButtonFrame, true)
	F.ReskinButton(ButtonFrame.AzeriteRespecButton)

	local bg = F.CreateBDFrame(ButtonFrame, 0)
	bg:SetPoint("TOPLEFT", ButtonFrame.MoneyFrameEdge, 1, 0)
	bg:SetPoint("BOTTOMRIGHT", ButtonFrame.MoneyFrameEdge, 0, 2)
end