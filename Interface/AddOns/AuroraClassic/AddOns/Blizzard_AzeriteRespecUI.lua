local F, C = unpack(select(2, ...))

C.themes["Blizzard_AzeriteRespecUI"] = function()
	F.StripTextures(AzeriteRespecFrame, 15)
	F.ReskinClose(AzeriteRespecFrameCloseButton)
	F.CreateBD(AzeriteRespecFrame)
	F.CreateSD(AzeriteRespecFrame)

	local Background = AzeriteRespecFrame.Background
	F.CreateBDFrame(Background, .25, true)

	local ItemSlot = AzeriteRespecFrame.ItemSlot
	F.ReskinIcon(ItemSlot.Icon)

	local ButtonFrame = AzeriteRespecFrame.ButtonFrame
	ButtonFrame.MoneyFrameEdge:Hide()
	F.StripTextures(ButtonFrame, true)
	F.ReskinButton(ButtonFrame.AzeriteRespecButton)

	local bubg = F.CreateBDFrame(ButtonFrame, 0)
	bubg:SetPoint("TOPLEFT", ButtonFrame.MoneyFrameEdge, 1, 0)
	bubg:SetPoint("BOTTOMRIGHT", ButtonFrame.MoneyFrameEdge, 0, 2)
end