local F, C = unpack(select(2, ...))

C.themes["Blizzard_WarfrontsPartyPoseUI"] = function()
	F.StripTextures(WarfrontsPartyPoseFrame, true)
	F.CreateBD(WarfrontsPartyPoseFrame)
	F.CreateSD(WarfrontsPartyPoseFrame)
	F.Reskin(WarfrontsPartyPoseFrame.LeaveButton)
	F.StripTextures(WarfrontsPartyPoseFrame.ModelScene, true)
	F.CreateBDFrame(WarfrontsPartyPoseFrame.ModelScene, .25)

	local rewardFrame = WarfrontsPartyPoseFrame.RewardAnimations.RewardFrame
	local bg = F.CreateBDFrame(rewardFrame, .25)
	bg:SetPoint("TOPLEFT", -5, 5)
	bg:SetPoint("BOTTOMRIGHT", rewardFrame.NameFrame, 0, -5)
	rewardFrame.NameFrame:SetAlpha(0)
	rewardFrame.IconBorder:SetAlpha(0)
	rewardFrame.Icon:SetTexCoord(.08, .92, .08, .92)
	F.CreateBDFrame(rewardFrame.Icon, .25)
end