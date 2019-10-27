local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinButton(RecruitAFriendFrame.RecruitmentButton)

	local RewardClaiming = RecruitAFriendFrame.RewardClaiming
	F.StripTextures(RewardClaiming)
	F.ReskinButton(RewardClaiming.ClaimOrViewRewardButton)

	local SplashFrame = RecruitAFriendFrame.SplashFrame
	F.ReskinButton(SplashFrame.OKButton)
	SplashFrame.Title:SetTextColor(1, .8, 0)
	SplashFrame.Description:SetTextColor(1, 1, 1)

	local RecruitList = RecruitAFriendFrame.RecruitList
	F.StripTextures(RecruitList.Header)
	F.CreateBDFrame(RecruitList.Header, 0)
	F.ReskinScroll(RecruitList.ScrollFrame.scrollBar)
	RecruitList.ScrollFrameInset:Hide()

	local RecruitmentFrame = RecruitAFriendRecruitmentFrame
	F.ReskinFrame(RecruitmentFrame)
	F.ReskinButton(RecruitmentFrame.GenerateOrCopyLinkButton)
	F.ReskinInput(RecruitmentFrame.EditBox, 20)

	F.ReskinFrame(RecruitAFriendRewardsFrame)
	RecruitAFriendRewardsFrame:HookScript("OnShow", function(self)
		for i = 1, self:GetNumChildren() do
			local child = select(i, self:GetChildren())
			local button = child and child.Button
			if button and not button.styled then
				button.IconBorder:Hide()

				local icbg = F.ReskinIcon(button.Icon)
				F.ReskinTexture(button, icbg, false)

				button.styled = true
			end
		end
	end)
end)