local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(PetitionFrame)
	B.ReskinButton(PetitionFrameSignButton)
	B.ReskinButton(PetitionFrameRequestButton)
	B.ReskinButton(PetitionFrameRenameButton)
	B.ReskinButton(PetitionFrameCancelButton)

	PetitionFrameCharterTitle:SetTextColor(1, .8, 0)
	PetitionFrameMasterTitle:SetTextColor(1, .8, 0)
	PetitionFrameMemberTitle:SetTextColor(1, .8, 0)
end)