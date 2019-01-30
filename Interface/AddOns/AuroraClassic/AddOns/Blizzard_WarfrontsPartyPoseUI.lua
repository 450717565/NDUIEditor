local F, C = unpack(select(2, ...))

C.themes["Blizzard_WarfrontsPartyPoseUI"] = function()
	F.StripTextures(WarfrontsPartyPoseFrame.ModelScene, true)
	F.ReskinFrame(WarfrontsPartyPoseFrame)
	F.ReskinButton(WarfrontsPartyPoseFrame.LeaveButton)

	local rewardFrame = WarfrontsPartyPoseFrame.RewardAnimations.RewardFrame
	rewardFrame.NameFrame:SetAlpha(0)
	F.ReskinIcon(rewardFrame.Icon)
	F.ReskinBorder(rewardFrame.IconBorder, rewardFrame.Icon)
end