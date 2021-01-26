local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.XMLThemes, function()
	B.ReskinFrame(PetitionFrame)

	local buttons = {
		PetitionFrameSignButton,
		PetitionFrameRequestButton,
		PetitionFrameRenameButton,
		PetitionFrameCancelButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	local texts = {
		PetitionFrameCharterTitle,
		PetitionFrameMasterTitle,
		PetitionFrameMemberTitle,
	}
	for _, text in pairs(texts) do
		B.ReskinText(text, 1, .8, 0)
	end
end)