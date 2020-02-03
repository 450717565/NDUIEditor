local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinButton(RecruitAFriendFrame.RecruitmentButton)

	local RewardClaiming = RecruitAFriendFrame.RewardClaiming
	B.StripTextures(RewardClaiming)
	B.ReskinButton(RewardClaiming.ClaimOrViewRewardButton)

	local SplashFrame = RecruitAFriendFrame.SplashFrame
	B.ReskinButton(SplashFrame.OKButton)
	SplashFrame.Title:SetTextColor(1, .8, 0)
	SplashFrame.Description:SetTextColor(1, 1, 1)

	local RecruitList = RecruitAFriendFrame.RecruitList
	B.StripTextures(RecruitList.Header)
	B.CreateBDFrame(RecruitList.Header, 0)
	B.ReskinScroll(RecruitList.ScrollFrame.scrollBar)
	RecruitList.ScrollFrameInset:Hide()

	local RecruitmentFrame = RecruitAFriendRecruitmentFrame
	B.ReskinFrame(RecruitmentFrame)
	B.ReskinButton(RecruitmentFrame.GenerateOrCopyLinkButton)
	B.ReskinInput(RecruitmentFrame.EditBox, 20)

	B.ReskinFrame(RecruitAFriendRewardsFrame)
	RecruitAFriendRewardsFrame:HookScript("OnShow", function(self)
		for i = 1, self:GetNumChildren() do
			local child = select(i, self:GetChildren())
			local button = child and child.Button
			if button and not button.styled then
				button.IconBorder:Hide()

				local icbg = B.ReskinIcon(button.Icon)
				B.ReskinTexture(button, icbg, false)

				button.styled = true
			end
		end
	end)
end)