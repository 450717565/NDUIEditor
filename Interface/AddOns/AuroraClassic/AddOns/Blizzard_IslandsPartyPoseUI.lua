local F, C = unpack(select(2, ...))

C.themes["Blizzard_IslandsPartyPoseUI"] = function()
	F.StripTextures(IslandsPartyPoseFrame, true)
	F.StripTextures(IslandsPartyPoseFrame.ModelScene, true)
	F.CreateBD(IslandsPartyPoseFrame)
	F.CreateSD(IslandsPartyPoseFrame)
	F.Reskin(IslandsPartyPoseFrame.LeaveButton)

	local rewardFrame = IslandsPartyPoseFrame.RewardAnimations.RewardFrame
	rewardFrame.NameFrame:SetAlpha(0)
	rewardFrame.IconBorder:SetAlpha(0)
	rewardFrame.Icon:SetTexCoord(.08, .92, .08, .92)
	F.CreateBDFrame(rewardFrame.Icon, .25)
end