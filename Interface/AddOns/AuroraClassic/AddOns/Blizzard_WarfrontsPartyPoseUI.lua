local F, C = unpack(select(2, ...))

C.themes["Blizzard_WarfrontsPartyPoseUI"] = function()
	F.StripTextures(WarfrontsPartyPoseFrame, true)
	F.StripTextures(WarfrontsPartyPoseFrame.ModelScene, true)
	F.CreateBD(WarfrontsPartyPoseFrame)
	F.CreateSD(WarfrontsPartyPoseFrame)
	F.Reskin(WarfrontsPartyPoseFrame.LeaveButton)

	local rewardFrame = WarfrontsPartyPoseFrame.RewardAnimations.RewardFrame
	rewardFrame.NameFrame:SetAlpha(0)
	rewardFrame.IconBorder:SetAlpha(0)
	rewardFrame.Icon:SetTexCoord(.08, .92, .08, .92)
	F.CreateBDFrame(rewardFrame.Icon, .25)
end