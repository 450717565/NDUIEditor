local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(PetitionFrame)
	F.ReskinButton(PetitionFrameSignButton)
	F.ReskinButton(PetitionFrameRequestButton)
	F.ReskinButton(PetitionFrameRenameButton)
	F.ReskinButton(PetitionFrameCancelButton)

	PetitionFrameCharterTitle:SetTextColor(1, 1, 1)
	PetitionFrameMasterTitle:SetTextColor(1, 1, 1)
	PetitionFrameMemberTitle:SetTextColor(1, 1, 1)
end)