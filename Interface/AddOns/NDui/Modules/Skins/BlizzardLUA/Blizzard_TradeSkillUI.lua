local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Update_OnLearnedTabClicked(self)
	self.Tabs[1].bg:SetBackdropColor(cr, cg, cb, .5)
	self.Tabs[2].bg:SetBackdropColor(0, 0, 0, 0)
end

local function Update_OnUnlearnedTabClicked(self)
	self.Tabs[1].bg:SetBackdropColor(0, 0, 0, 0)
	self.Tabs[2].bg:SetBackdropColor(cr, cg, cb, .5)
end

local function Reskin_Reagents(self)
	for i = 1, #self do
		local reagent = self[i]
		reagent.NameFrame:Hide()
		reagent.Icon:SetSize(36, 36)

		local icbg = B.ReskinIcon(reagent.Icon)
		local bubg = B.CreateBGFrame(reagent, 2, 0, -10, 0, icbg)

		if reagent.SelectedTexture then
			B.ReskinHighlight(reagent.SelectedTexture, icbg)
		end
	end
end

local function Reskin_OptionalReagentList(self)
	local buttons = self.ScrollList.ScrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		if not button.styled then
			button.NameFrame:Hide()

			button.Icon:SetSize(36, 36)
			button.Icon:ClearAllPoints()
			button.Icon:SetPoint("TOPLEFT", button, "TOPLEFT", 3, -3)

			local icbg = B.ReskinIcon(button.Icon)
			local bubg = B.CreateBGFrame(button, 2, 0, -5, 0, icbg)

			B.ReskinBorder(button.IconBorder, icbg, bubg)
		end
	end
end

local function Reskin_RecipeList(self)
	for i = 1, #self.buttons do
		local button = self.buttons[i]
		if not button.styled then
			B.ReskinCollapse(button)

			if button.SubSkillRankBar then
				B.ReskinStatusBar(button.SubSkillRankBar)
			end

			button.styled = true
		end

		button:SetHighlightTexture("")
		local selected = button.SelectedTexture
		selected:SetTexture(DB.bgTex)
		selected:SetAlpha(.5)
	end
end

local function Reskin_DetailsFrame(self)
	local recipeInfo = self.selectedRecipeID and C_TradeSkillUI.GetRecipeInfo(self.selectedRecipeID)
	if not recipeInfo then return end

	if not self.styled then
		local ResultIcon = self.Contents.ResultIcon
		ResultIcon.ResultBorder:Hide()

		local icbg = B.ReskinIcon(ResultIcon:GetNormalTexture())
		B.ReskinBorder(ResultIcon.IconBorder, icbg)

		local Reagents = self.Contents.Reagents
		Reskin_Reagents(Reagents)

		local OptionalReagents = self.Contents.OptionalReagents
		Reskin_Reagents(OptionalReagents)

		self.styled = true
	end
end

C.LUAThemes["Blizzard_TradeSkillUI"] = function()
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

		tab.bg = B.CreateBDFrame(tab, 0, 3)
	end

	hooksecurefunc(RecipeList, "OnLearnedTabClicked", Update_OnLearnedTabClicked)
	hooksecurefunc(RecipeList, "OnUnlearnedTabClicked", Update_OnUnlearnedTabClicked)
	hooksecurefunc(RecipeList, "RefreshDisplay", Reskin_RecipeList)

	-- DetailsFrame
	B.StripTextures(TradeSkillFrame.DetailsInset)

	local DetailsFrame = TradeSkillFrame.DetailsFrame
	B.ReskinScroll(DetailsFrame.ScrollBar)
	B.ReskinButton(DetailsFrame.CreateAllButton)
	B.ReskinButton(DetailsFrame.CreateButton)
	B.ReskinButton(DetailsFrame.ExitButton)
	B.ReskinButton(DetailsFrame.ViewGuildCraftersButton)

	local CreateMultipleInputBox = DetailsFrame.CreateMultipleInputBox
	B.ReskinArrow(CreateMultipleInputBox.DecrementButton, "left")
	B.ReskinArrow(CreateMultipleInputBox.IncrementButton, "right")

	local bg = B.ReskinInput(CreateMultipleInputBox)
	CreateMultipleInputBox.DecrementButton:ClearAllPoints()
	CreateMultipleInputBox.DecrementButton:SetPoint("RIGHT", bg, "LEFT", -3, 0)
	CreateMultipleInputBox.IncrementButton:ClearAllPoints()
	CreateMultipleInputBox.IncrementButton:SetPoint("LEFT", bg, "RIGHT", 3, 0)

	hooksecurefunc(DetailsFrame, "RefreshDisplay", Reskin_DetailsFrame)

	-- OptionalReagentList
	local OptionalReagentList = TradeSkillFrame.OptionalReagentList
	B.StripTextures(OptionalReagentList)
	B.CreateBG(OptionalReagentList)
	B.ReskinCheck(OptionalReagentList.HideUnownedButton)
	B.ReskinButton(OptionalReagentList.CloseButton)

	local ScrollList = OptionalReagentList.ScrollList
	B.StripTextures(ScrollList)
	B.CreateBGFrame(ScrollList, 1, -2, -25, 5)
	B.ReskinScroll(ScrollList.ScrollFrame.scrollBar)

	OptionalReagentList:HookScript("OnShow", Reskin_OptionalReagentList)

	OptionalReagentList:ClearAllPoints()
	OptionalReagentList:SetPoint("LEFT", TradeSkillFrame, "RIGHT", 40, 0)

	-- GuildFrame
	local GuildFrame = DetailsFrame.GuildFrame
	B.ReskinFrame(GuildFrame)
	GuildFrame:ClearAllPoints()
	GuildFrame:SetPoint("BOTTOMLEFT", TradeSkillFrame, "BOTTOMRIGHT", 40, 0)

	local Container = GuildFrame.Container
	B.StripTextures(Container)
	B.CreateBDFrame(Container.ScrollFrame)
	B.ReskinScroll(Container.ScrollFrame.scrollBar)
end