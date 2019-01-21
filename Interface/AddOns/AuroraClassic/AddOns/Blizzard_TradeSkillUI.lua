local F, C = unpack(select(2, ...))

C.themes["Blizzard_TradeSkillUI"] = function()
	local r, g, b = C.r, C.g, C.b

	F.ReskinFrame(TradeSkillFrame)

	F.ReskinStatusBar(TradeSkillFrame.RankFrame, true, true)
	F.ReskinInput(TradeSkillFrame.SearchBox)
	F.ReskinFilter(TradeSkillFrame.FilterButton)
	F.ReskinArrow(TradeSkillFrame.LinkToButton, "right")

	-- Recipe List
	F.StripTextures(TradeSkillFrame.RecipeInset, true)

	local recipe = TradeSkillFrame.RecipeList
	F.ReskinScroll(recipe.scrollBar)

	for i = 1, #recipe.Tabs do
		local tab = recipe.Tabs[i]

		F.StripTextures(tab, true)
		tab.bg = F.CreateBDFrame(tab, .25)
		tab.bg:SetPoint("TOPLEFT", 3, -3)
		tab.bg:SetPoint("BOTTOMRIGHT", -3, 0)
	end
	hooksecurefunc(recipe, "OnLearnedTabClicked", function()
		recipe.Tabs[1].bg:SetBackdropColor(r, g, b, .25)
		recipe.Tabs[2].bg:SetBackdropColor(0, 0, 0, .25)
	end)
	hooksecurefunc(recipe, "OnUnlearnedTabClicked", function()
		recipe.Tabs[1].bg:SetBackdropColor(0, 0, 0, .25)
		recipe.Tabs[2].bg:SetBackdropColor(r, g, b, .25)
	end)

	hooksecurefunc(recipe, "RefreshDisplay", function(self)
		for i = 1, #self.buttons do
			local button = self.buttons[i]
			if not button.styled then
				F.ReskinExpandOrCollapse(button)

				if button.SubSkillRankBar then
					button.SubSkillRankBar:SetSize(55, 12)
					F.ReskinStatusBar(button.SubSkillRankBar, true, true)
				end

				button.styled = true
			end
			button:SetHighlightTexture("")
			button.SelectedTexture:SetTexture(C.media.bdTex)
			button.SelectedTexture:SetVertexColor(r, g, b, .5)
		end
	end)

	-- Recipe Details
	F.StripTextures(TradeSkillFrame.DetailsInset, true)

	local details = TradeSkillFrame.DetailsFrame
	F.StripTextures(details, true)
	F.StripTextures(details.CreateMultipleInputBox, true)
	F.ReskinScroll(details.ScrollBar)
	F.ReskinButton(details.CreateAllButton)
	F.ReskinButton(details.CreateButton)
	F.ReskinButton(details.ExitButton)
	F.ReskinInput(details.CreateMultipleInputBox)
	F.ReskinArrow(details.CreateMultipleInputBox.DecrementButton, "left")
	F.ReskinArrow(details.CreateMultipleInputBox.IncrementButton, "right")

	details.CreateMultipleInputBox.DecrementButton:ClearAllPoints()
	details.CreateMultipleInputBox.DecrementButton:SetPoint("RIGHT", details.CreateMultipleInputBox, "LEFT", -5, 0)
	details.CreateMultipleInputBox.IncrementButton:ClearAllPoints()
	details.CreateMultipleInputBox.IncrementButton:SetPoint("LEFT", details.CreateMultipleInputBox, "RIGHT", 3, 0)

	local contents = details.Contents
	hooksecurefunc(contents.ResultIcon, "SetNormalTexture", function(self)
		if not self.styled then
			self.IconBorder:SetAlpha(0)
			self.ResultBorder:SetAlpha(0)
			F.ReskinIcon(self:GetNormalTexture(), true)

			self.styled = true
		end
	end)
	for i = 1, #contents.Reagents do
		local reagent = contents.Reagents[i]
		reagent.NameFrame:Hide()

		local ic = F.ReskinIcon(reagent.Icon, true)

		local bg = F.CreateBDFrame(reagent.NameFrame, .25)
		bg:SetPoint("TOPLEFT", ic, "TOPRIGHT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -5, 1)
	end
	F.ReskinButton(details.ViewGuildCraftersButton)

	-- Guild Recipe

	local guildFrame = details.GuildFrame
	F.ReskinFrame(guildFrame)
	F.ReskinScroll(guildFrame.Container.ScrollFrame.scrollBar)
	guildFrame:ClearAllPoints()
	guildFrame:SetPoint("BOTTOMLEFT", TradeSkillFrame, "BOTTOMRIGHT", 2, 0)

	F.StripTextures(guildFrame.Container, true)
	F.CreateBDFrame(guildFrame.Container, .25)
end