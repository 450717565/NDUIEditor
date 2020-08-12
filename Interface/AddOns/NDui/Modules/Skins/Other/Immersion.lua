local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

function S:Immersion()
	if not IsAddOnLoaded("Immersion") then return end

	local cr, cg, cb = DB.r, DB.g, DB.b

	ImmersionFrame:SetScale(UIParent:GetScale())

	local TalkBox = ImmersionFrame.TalkBox
	B.StripTextures(TalkBox.PortraitFrame)
	B.StripTextures(TalkBox.BackgroundFrame)
	B.StripTextures(TalkBox.Hilite)

	local hilite = B.CreateBDFrame(TalkBox.Hilite, 0)
	hilite:SetAllPoints(TalkBox)
	hilite:SetBackdropColor(cr, cg, cb, .25)
	hilite:SetBackdropBorderColor(cr, cg, cb, 1)

	local Elements = TalkBox.Elements
	B.StripTextures(Elements)
	B.CreateBG(Elements, 10, -10, -10, 10)

	local MainFrame = TalkBox.MainFrame
	B.ReskinFrame(MainFrame, "noKill")
	B.StripTextures(MainFrame.Model)
	B.CreateBDFrame(MainFrame.Model, 0)

	local Indicator = MainFrame.Indicator
	Indicator:SetScale(1.25)
	Indicator:ClearAllPoints()
	Indicator:Point("RIGHT", MainFrame.CloseButton, "LEFT", -3, 0)

	local TitleButtons = ImmersionFrame.TitleButtons
	hooksecurefunc(TitleButtons, "GetButton", function(self, index)
		local button = self.Buttons[index]
		if button and not button.styled then
			button:SetSize(290, 44)
			button.Hilite:Hide()

			B.StripTextures(button)
			B.ReskinButton(button)

			if index > 1 then
				button:ClearAllPoints()
				button:SetPoint("TOP", self.Buttons[index-1], "BOTTOM", 0, -B.Scale(3))
			end

			button.styled = true
		end
	end)

	local function updateItemBorder(self)
		if not self.icbg and not self.bubg then return end

		if self.objectType == "item" then
			local itemQuality = select(4, GetQuestItemInfo(self.type, self:GetID()))
			local r, g, b = GetItemQualityColor(itemQuality or 1)
			self.icbg:SetBackdropBorderColor(r, g, b)
			self.bubg:SetBackdropBorderColor(r, g, b)
		elseif self.objectType == "currency" then
			local name, texture, numItems, quality = GetQuestCurrencyInfo(self.type, self:GetID())
			if name and texture and numItems and quality then
				local currencyID = GetQuestCurrencyID(self.type, self:GetID())
				local currencyQuality = select(4, CurrencyContainerUtil.GetCurrencyContainerInfo(currencyID, numItems, name, texture, quality))
				local r, g, b = GetItemQualityColor(currencyQuality or 1)
				self.icbg:SetBackdropBorderColor(r, g, b)
				self.bubg:SetBackdropBorderColor(r, g, b)
			end
		else
			self.icbg:SetBackdropBorderColor(0, 0, 0)
			self.bubg:SetBackdropBorderColor(0, 0, 0)
		end
	end

	local function reskinItemButton(buttons)
		for i = 1, #buttons do
			local button = buttons[i]
			if button and not button.styled then
				button.Mask:Hide()
				button.Border:Hide()
				button.NameFrame:Hide()

				local icbg = B.ReskinIcon(button.Icon)
				button.icbg = icbg

				local bubg = B.CreateBGFrame(button, 2, 0, -6, 0, icbg)
				button.bubg = bubg

				button.styled = true
			end

			local p1, p2, p3 = buttons[1]:GetPoint()
			buttons[1]:ClearAllPoints()
			buttons[1]:SetPoint(p1, p2, p3, 1, -10)

			updateItemBorder(button)
		end
	end

	hooksecurefunc(ImmersionFrame, "AddQuestInfo", function(self)
		local buttons = self.TalkBox.Elements.Content.RewardsFrame.Buttons
		reskinItemButton(buttons)
	end)

	hooksecurefunc(ImmersionFrame, "QUEST_PROGRESS", function(self)
		local buttons = self.TalkBox.Elements.Progress.Buttons
		reskinItemButton(buttons)
	end)
end