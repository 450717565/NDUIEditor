local F, C = unpack(select(2, ...))

C.themes["Blizzard_WarfrontsPartyPoseUI"] = function()
	F.ReskinFrame(WarfrontsPartyPoseFrame)
	F.ReskinButton(WarfrontsPartyPoseFrame.LeaveButton)
	F.StripTextures(WarfrontsPartyPoseFrame.ModelScene)
	F.CreateBDFrame(WarfrontsPartyPoseFrame.ModelScene, 0)

	WarfrontsPartyPoseFrame.OverlayElements.Topper:Hide()

	local rewardFrame = WarfrontsPartyPoseFrame.RewardAnimations.RewardFrame
	rewardFrame.NameFrame:SetAlpha(0)
	rewardFrame.IconBorder:SetAlpha(0)
	F.ReskinIcon(rewardFrame.Icon)
end