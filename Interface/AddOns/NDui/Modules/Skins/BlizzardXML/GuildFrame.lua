local _, ns = ...
local B, C, L, DB = unpack(ns)

-- GuildInviteFrame
tinsert(C.XMLThemes, function()
	B.ReskinFrame(GuildInviteFrame)

	B.ReskinButton(GuildInviteFrameJoinButton)
	B.ReskinButton(GuildInviteFrameDeclineButton)
end)

-- GuildRegistrarFrame
tinsert(C.XMLThemes, function()
	B.ReskinFrame(GuildRegistrarFrame)
	B.ReskinInput(GuildRegistrarFrameEditBox, 20)
	B.ReskinText(AvailableServicesText, 1, .8, 0)

	local buttons = {
		GuildRegistrarFrameGoodbyeButton,
		GuildRegistrarFramePurchaseButton,
		GuildRegistrarFrameCancelButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end
end)

-- PetitionFrame
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