local F, C = unpack(select(2, ...))

C.themes["Blizzard_IslandsPartyPoseUI"] = function()
	F.StripTextures(IslandsPartyPoseFrame.ModelScene, true)
	F.ReskinFrame(IslandsPartyPoseFrame)
	F.ReskinButton(IslandsPartyPoseFrame.LeaveButton)

	local rewardFrame = IslandsPartyPoseFrame.RewardAnimations.RewardFrame
	rewardFrame.NameFrame:SetAlpha(0)
	F.ReskinIcon(rewardFrame.Icon, true)
	F.ReskinTexture(rewardFrame.IconBorder, false, rewardFrame.Icon, true)
end