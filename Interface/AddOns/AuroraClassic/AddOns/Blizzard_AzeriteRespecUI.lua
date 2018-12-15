local F, C = unpack(select(2, ...))

C.themes["Blizzard_AzeriteRespecUI"] = function()
	for i = 1, 23 do
		if i ~= 8 then
			select(i, AzeriteRespecFrame:GetRegions()):Hide()
		end
	end

	F.CreateBD(AzeriteRespecFrame)
	F.CreateSD(AzeriteRespecFrame)
	F.CreateBDFrame(AzeriteRespecFrame.Background, .25)
	F.ReskinClose(AzeriteRespecFrameCloseButton)

	F.StripTextures(AzeriteRespecFrame.ItemSlot)
	AzeriteRespecFrame.ItemSlot.Icon:SetTexCoord(.08, .92, .08, .92)
	F.CreateBDFrame(AzeriteRespecFrame.ItemSlot.Icon, .25)

	local bf = AzeriteRespecFrame.ButtonFrame
	F.StripTextures(bf, true)
	bf.MoneyFrameEdge:Hide()
	bf.AzeriteRespecButton:ClearAllPoints()
	bf.AzeriteRespecButton:SetPoint("BOTTOMRIGHT", -4, 5)
	F.Reskin(bf.AzeriteRespecButton)

	local bg = F.CreateBDFrame(bf, .25)
	bg:SetPoint("TOPLEFT", bf.MoneyFrameEdge, 3, 0)
	bg:SetPoint("BOTTOMRIGHT", bf.MoneyFrameEdge, 0, 2)
end