local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_TradeSkillUI"] = function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	B.ReskinFrame(TradeSkillFrame)
	B.ReskinStatusBar(TradeSkillFrame.RankFrame)
	B.ReskinInput(TradeSkillFrame.SearchBox, 20, 200)
	B.ReskinFilter(TradeSkillFrame.FilterButton)
	B.ReskinArrow(TradeSkillFrame.LinkToButton, "right")

	-- RecipeList
	B.StripTextures(TradeSkillFrame.RecipeInset)

	local RecipeList = TradeSkillFrame.RecipeList
	B.ReskinScroll(RecipeList.scrollBar)

	for i = 1, #RecipeList.Tabs do
		local tab = RecipeList.Tabs[i]
		B.StripTextures(tab)

		tab.bg = B.CreateBDFrame(tab, 0, -3)
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
				B.ReskinExpandOrCollapse(button)

				if button.SubSkillRankBar then
					button.SubSkillRankBar:SetSize(55, 12)
					B.ReskinStatusBar(button.SubSkillRankBar)
				end

				button.styled = true
			end

			button:SetHighlightTexture("")
			local selected = button.SelectedTexture
			selected:SetTexture(DB.bdTex)
			selected:SetAlpha(.5)
		end
	end)

	-- DetailsFrame
	B.StripTextures(TradeSkillFrame.DetailsInset)

	local DetailsFrame = TradeSkillFrame.DetailsFrame
	B.ReskinScroll(DetailsFrame.ScrollBar)
	B.ReskinButton(DetailsFrame.CreateAllButton)
	B.ReskinButton(DetailsFrame.CreateButton)
	B.ReskinButton(DetailsFrame.ExitButton)
	B.ReskinButton(DetailsFrame.ViewGuildCraftersButton)

	local CreateMultipleInputBox = DetailsFrame.CreateMultipleInputBox
	B.ReskinInput(CreateMultipleInputBox)
	B.ReskinArrow(CreateMultipleInputBox.DecrementButton, "left")
	B.ReskinArrow(CreateMultipleInputBox.IncrementButton, "right")

	CreateMultipleInputBox.DecrementButton:ClearAllPoints()
	CreateMultipleInputBox.DecrementButton:SetPoint("RIGHT", CreateMultipleInputBox, "LEFT", -5, 0)
	CreateMultipleInputBox.IncrementButton:ClearAllPoints()
	CreateMultipleInputBox.IncrementButton:SetPoint("LEFT", CreateMultipleInputBox, "RIGHT", 3, 0)

	hooksecurefunc(DetailsFrame, "RefreshDisplay", function(self)
		local recipeInfo = self.selectedRecipeID and C_TradeSkillUI.GetRecipeInfo(self.selectedRecipeID)
		if recipeInfo and not self.styled then
			local ResultIcon = self.Contents.ResultIcon
			ResultIcon.ResultBorder:Hide()
			local icbg = B.ReskinIcon(ResultIcon:GetNormalTexture())
			B.ReskinBorder(ResultIcon.IconBorder, icbg)

			local Reagents = self.Contents.Reagents
			for i = 1, #Reagents do
				local reagent = Reagents[i]
				reagent.NameFrame:Hide()
				reagent.Icon:SetSize(36, 36)

				local icbg = B.ReskinIcon(reagent.Icon)
				local bubg = B.CreateBGFrame(reagent.NameFrame, 2, 0, -10, 0, icbg)
			end

			self.styled = true
		end
	end)

	-- GuildFrame
	local GuildFrame = DetailsFrame.GuildFrame
	B.ReskinFrame(GuildFrame)
	GuildFrame:ClearAllPoints()
	GuildFrame:SetPoint("BOTTOMLEFT", TradeSkillFrame, "BOTTOMRIGHT", 50, 0)

	local Container = GuildFrame.Container
	B.StripTextures(Container)
	B.CreateBDFrame(Container.ScrollFrame, 0)
	B.ReskinScroll(Container.ScrollFrame.scrollBar)
end