local F, C = unpack(select(2, ...))

C.themes["Blizzard_TradeSkillUI"] = function()
	local cr, cg, cb = C.r, C.g, C.b

	F.ReskinFrame(TradeSkillFrame)
	F.ReskinStatusBar(TradeSkillFrame.RankFrame)
	F.ReskinInput(TradeSkillFrame.SearchBox, 20, 200)
	F.ReskinFilter(TradeSkillFrame.FilterButton)
	F.ReskinArrow(TradeSkillFrame.LinkToButton, "right")

	-- RecipeList
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

	-- DetailsFrame
	F.StripTextures(TradeSkillFrame.DetailsInset)

	local DetailsFrame = TradeSkillFrame.DetailsFrame
	F.StripTextures(DetailsFrame, true)
	F.ReskinScroll(DetailsFrame.ScrollBar)
	F.ReskinButton(DetailsFrame.CreateAllButton)
	F.ReskinButton(DetailsFrame.CreateButton)
	F.ReskinButton(DetailsFrame.ExitButton)
	F.ReskinButton(DetailsFrame.ViewGuildCraftersButton)

	local CreateMultipleInputBox = DetailsFrame.CreateMultipleInputBox
	F.ReskinInput(CreateMultipleInputBox)
	F.ReskinArrow(CreateMultipleInputBox.DecrementButton, "left")
	F.ReskinArrow(CreateMultipleInputBox.IncrementButton, "right")

	CreateMultipleInputBox.DecrementButton:ClearAllPoints()
	CreateMultipleInputBox.DecrementButton:SetPoint("RIGHT", CreateMultipleInputBox, "LEFT", -5, 0)
	CreateMultipleInputBox.IncrementButton:ClearAllPoints()
	CreateMultipleInputBox.IncrementButton:SetPoint("LEFT", CreateMultipleInputBox, "RIGHT", 3, 0)

	hooksecurefunc(DetailsFrame, "RefreshDisplay", function(self)
		local recipeInfo = self.selectedRecipeID and C_TradeSkillUI.GetRecipeInfo(self.selectedRecipeID)
		if recipeInfo and not self.styled then
			local ResultIcon = self.Contents.ResultIcon
			ResultIcon.ResultBorder:Hide()
			F.ReskinIcon(ResultIcon:GetNormalTexture())
			F.ReskinBorder(ResultIcon.IconBorder, ResultIcon)

			local Reagents = self.Contents.Reagents
			for i = 1, #Reagents do
				local reagent = Reagents[i]
				reagent.NameFrame:Hide()
				reagent.Icon:SetSize(36, 36)

				local icbg = F.ReskinIcon(reagent.Icon)
				local bubg = F.CreateBDFrame(reagent.NameFrame, 0)
				bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
				bubg:SetPoint("BOTTOMRIGHT", -5, 3.5)
			end

			self.styled = true
		end
	end)

	-- GuildFrame
	local GuildFrame = DetailsFrame.GuildFrame
	F.ReskinFrame(GuildFrame)
	GuildFrame:ClearAllPoints()
	GuildFrame:SetPoint("BOTTOMLEFT", TradeSkillFrame, "BOTTOMRIGHT", 50, 0)

	local Container = GuildFrame.Container
	F.StripTextures(Container)
	F.CreateBDFrame(Container.ScrollFrame, 0)
	F.ReskinScroll(Container.ScrollFrame.scrollBar)
end