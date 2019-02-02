local F, C = unpack(select(2, ...))

C.themes["Blizzard_TradeSkillUI"] = function()
	local cr, cg, cb = C.r, C.g, C.b

	F.ReskinFrame(TradeSkillFrame)

	F.ReskinStatusBar(TradeSkillFrame.RankFrame)
	F.ReskinInput(TradeSkillFrame.SearchBox)
	F.ReskinFilter(TradeSkillFrame.FilterButton)
	F.ReskinArrow(TradeSkillFrame.LinkToButton, "right")

	-- Recipe List
	F.StripTextures(TradeSkillFrame.RecipeInset)

	local RecipeList = TradeSkillFrame.RecipeList
	F.ReskinScroll(RecipeList.scrollBar)

	for i = 1, #RecipeList.Tabs do
		local tab = RecipeList.Tabs[i]

		F.StripTextures(tab)
		tab.bg = F.CreateBDFrame(tab, 0)
		tab.bg:SetPoint("TOPLEFT", 3, -3)
		tab.bg:SetPoint("BOTTOMRIGHT", -3, 0)
	end
	hooksecurefunc(RecipeList, "OnLearnedTabClicked", function()
		RecipeList.Tabs[1].bg:SetBackdropColor(cr, cg, cb, .25)
		RecipeList.Tabs[2].bg:SetBackdropColor(0, 0, 0, 0)
	end)
	hooksecurefunc(RecipeList, "OnUnlearnedTabClicked", function()
		RecipeList.Tabs[1].bg:SetBackdropColor(0, 0, 0, 0)
		RecipeList.Tabs[2].bg:SetBackdropColor(cr, cg, cb, .25)
	end)

	hooksecurefunc(RecipeList, "RefreshDisplay", function(self)
		for i = 1, #self.buttons do
			local button = self.buttons[i]
			if not button.styled then
				F.ReskinExpandOrCollapse(button)

				if button.SubSkillRankBar then
					button.SubSkillRankBar:SetSize(55, 12)
					F.ReskinStatusBar(button.SubSkillRankBar)
				end

				button.styled = true
			end

			button:SetHighlightTexture("")
			local sl = button.SelectedTexture
			sl:SetTexture(C.media.bdTex)
			sl:SetVertexColor(cr, cg, cb, .25)
		end
	end)

	-- Recipe Details
	F.StripTextures(TradeSkillFrame.DetailsInset)

	local DetailsFrame = TradeSkillFrame.DetailsFrame
	F.StripTextures(DetailsFrame, true)
	F.StripTextures(DetailsFrame.CreateMultipleInputBox)
	F.ReskinScroll(DetailsFrame.ScrollBar)
	F.ReskinButton(DetailsFrame.CreateAllButton)
	F.ReskinButton(DetailsFrame.CreateButton)
	F.ReskinButton(DetailsFrame.ExitButton)
	F.ReskinInput(DetailsFrame.CreateMultipleInputBox)
	F.ReskinArrow(DetailsFrame.CreateMultipleInputBox.DecrementButton, "left")
	F.ReskinArrow(DetailsFrame.CreateMultipleInputBox.IncrementButton, "right")

	DetailsFrame.CreateMultipleInputBox.DecrementButton:ClearAllPoints()
	DetailsFrame.CreateMultipleInputBox.DecrementButton:SetPoint("RIGHT", DetailsFrame.CreateMultipleInputBox, "LEFT", -5, 0)
	DetailsFrame.CreateMultipleInputBox.IncrementButton:ClearAllPoints()
	DetailsFrame.CreateMultipleInputBox.IncrementButton:SetPoint("LEFT", DetailsFrame.CreateMultipleInputBox, "RIGHT", 3, 0)

	local Contents = DetailsFrame.Contents
	hooksecurefunc(Contents.ResultIcon, "SetNormalTexture", function(self)
		if not self.styled then
			self.IconBorder:SetAlpha(0)
			self.ResultBorder:SetAlpha(0)
			F.ReskinIcon(self:GetNormalTexture())

			self.styled = true
		end
	end)
	for i = 1, #Contents.Reagents do
		local reagent = Contents.Reagents[i]
		reagent.NameFrame:Hide()

		local icbg = F.ReskinIcon(reagent.Icon)
		local bubg = F.CreateBDFrame(reagent.NameFrame, 0)
		bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
		bubg:SetPoint("BOTTOMRIGHT", -5, 1)
	end
	F.ReskinButton(DetailsFrame.ViewGuildCraftersButton)

	-- Guild Recipe

	local GuildFrame = DetailsFrame.GuildFrame
	F.ReskinFrame(GuildFrame)
	F.ReskinScroll(GuildFrame.Container.ScrollFrame.scrollBar)
	GuildFrame:ClearAllPoints()
	GuildFrame:SetPoint("BOTTOMLEFT", TradeSkillFrame, "BOTTOMRIGHT", 2, 0)

	F.StripTextures(GuildFrame.Container)
	F.CreateBDFrame(GuildFrame.Container, 0)
end