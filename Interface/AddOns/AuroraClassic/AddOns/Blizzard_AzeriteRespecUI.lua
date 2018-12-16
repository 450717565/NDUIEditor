local F, C = unpack(select(2, ...))

C.themes["Blizzard_AzeriteRespecUI"] = function()
	for i = 1, 14 do
		select(i, AzeriteRespecFrame:GetRegions()):Hide()
	end

	F.CleanInset(AzeriteRespecFrame)
	F.CreateBD(AzeriteRespecFrame)
	F.CreateSD(AzeriteRespecFrame)
	F.ReskinClose(AzeriteRespecFrameCloseButton)
	F.CreateBDFrame(AzeriteRespecFrame.Background, .25)

	local ItemSlot = AzeriteRespecFrame.ItemSlot
	F.ReskinIcon(ItemSlot.Icon, true)

	local ButtonFrame = AzeriteRespecFrame.ButtonFrame
	ButtonFrame.MoneyFrameEdge:Hide()
	F.StripTextures(ButtonFrame, true)
	F.Reskin(ButtonFrame.AzeriteRespecButton)

	local bg = F.CreateBDFrame(ButtonFrame, .25)
	bg:SetPoint("TOPLEFT", ButtonFrame.MoneyFrameEdge, 3, 0)
	bg:SetPoint("BOTTOMRIGHT", ButtonFrame.MoneyFrameEdge, 0, 2)
end