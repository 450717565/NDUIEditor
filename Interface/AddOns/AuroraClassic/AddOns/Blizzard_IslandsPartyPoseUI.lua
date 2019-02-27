local F, C = unpack(select(2, ...))

C.themes["Blizzard_IslandsPartyPoseUI"] = function()
	F.ReskinFrame(IslandsPartyPoseFrame)
	F.ReskinButton(IslandsPartyPoseFrame.LeaveButton)
	F.StripTextures(IslandsPartyPoseFrame.ModelScene)
	F.CreateBDFrame(IslandsPartyPoseFrame.ModelScene, 0)

	IslandsPartyPoseFrame.OverlayElements.Topper:Hide()

	local rewardFrame = IslandsPartyPoseFrame.RewardAnimations.RewardFrame
	rewardFrame.NameFrame:SetAlpha(0)
	rewardFrame.IconBorder:SetAlpha(0)
	F.ReskinIcon(rewardFrame.Icon)
end