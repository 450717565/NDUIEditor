local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Reskin_TitleButton(self)
	if self and not self.styled then
		self.Hilite:Hide()

		B.StripTextures(self)
		B.ReskinButton(self)
		B.CreateBT(self.bgTex)

		if index > 1 then
			self:ClearAllPoints()
			self:SetPoint("TOP", self.Buttons[index-1], "BOTTOM", 0, -B.Scale(3))
		end

		self.styled = true
	end
end

local function Update_ItemBorder(self)
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

local function Reskin_ItemButton(self)
	for i = 1, #self do
		local button = self[i]
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

		local p1, p2, p3 = self[1]:GetPoint()
		self[1]:ClearAllPoints()
		self[1]:SetPoint(p1, p2, p3, 1, -10)

		Update_ItemBorder(button)
	end
end

local function Reskin_GetButton(self, index)
	local button = self.Buttons[index]
	Reskin_TitleButton(button)
end

local function Reskin_AddQuestInfo(self)
	local buttons = self.TalkBox.Elements.Content.RewardsFrame.Buttons
	Reskin_ItemButton(buttons)
end

local function Reskin_QUESTPROGRESS(self)
	local buttons = self.TalkBox.Elements.Progress.Buttons
	Reskin_ItemButton(buttons)
end

function Skins:Immersion()
	if not IsAddOnLoaded("Immersion") then return end

	local TalkBox = ImmersionFrame.TalkBox
	B.StripTextures(TalkBox.PortraitFrame)
	B.StripTextures(TalkBox.BackgroundFrame)
	B.StripTextures(TalkBox.Hilite)

	local hilite = B.CreateBDFrame(TalkBox.Hilite)
	hilite:SetAllPoints(TalkBox)
	hilite:SetBackdropColor(cr, cg, cb, .25)
	hilite:SetBackdropBorderColor(cr, cg, cb, 1)

	local Elements = TalkBox.Elements
	B.StripTextures(Elements)
	B.CreateBG(Elements, 10, -10, -10, 10)

	local MainFrame = TalkBox.MainFrame
	B.ReskinFrame(MainFrame, "noKill")
	B.StripTextures(MainFrame.Model)
	B.CreateBDFrame(MainFrame.Model)

	local Indicator = MainFrame.Indicator
	Indicator:SetScale(1.25)
	Indicator:ClearAllPoints()
	Indicator:SetPoint("RIGHT", MainFrame.CloseButton, "LEFT", -3, 0)

	hooksecurefunc(ImmersionFrame, "AddQuestInfo", Reskin_AddQuestInfo)
	hooksecurefunc(ImmersionFrame, "QUEST_PROGRESS", Reskin_QUESTPROGRESS)
	hooksecurefunc(ImmersionFrame.TitleButtons, "GetButton", Reskin_GetButton)
end