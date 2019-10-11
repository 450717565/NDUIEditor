local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(PetitionFrame)
	F.ReskinButton(PetitionFrameSignButton)
	F.ReskinButton(PetitionFrameRequestButton)
	F.ReskinButton(PetitionFrameRenameButton)
	F.ReskinButton(PetitionFrameCancelButton)

	PetitionFrameCharterTitle:SetTextColor(1, .8, 0)
	PetitionFrameMasterTitle:SetTextColor(1, .8, 0)
	PetitionFrameMemberTitle:SetTextColor(1, .8, 0)
end)