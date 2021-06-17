local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local r, g, b = B.GetQualityColor(4)
local function Reskin_DisplayedItem(self)
	if not self.styled then
		self:DisableDrawLayer("BORDER")
		self.Icon:SetPoint("LEFT", 6, 0)

		local icbg = B.ReskinIcon(self.Icon)
		icbg:SetBackdropBorderColor(r, g, b)
		icbg:SetFrameLevel(self:GetFrameLevel())

		local bubg = B.CreateBGFrame(self, 2, 0, 0, 0, icbg)
		bubg:SetBackdropBorderColor(r, g, b)

		self.styled = true
	end
end

local function Update_SelectionState(self)
	if not self.bg then return end

	if self.SelectedTexture:IsShown() then
		self.bg:SetBackdropBorderColor(cr, cg, cb)
	else
		self.bg:SetBackdropBorderColor(0, 0, 0)
	end
end

local function Reskin_ActivityFrame(self, isObject)
	if self.Border then
		if isObject then
			self.Border:SetAlpha(0)
			self.SelectedTexture:SetAlpha(0)

			hooksecurefunc(self, "SetSelectionState", Update_SelectionState)
			hooksecurefunc(self.ItemFrame, "SetDisplayedItem", Reskin_DisplayedItem)
		else
			self.Border:SetTexCoord(.926, 1, 0, 1)
			self.Border:SetSize(25, 137)
			self.Border:SetPoint("LEFT", self, "RIGHT", 3, 0)
		end
	end

	if self.Background then
		self.Background:SetTexCoord(.02, .98, .02, .98)
		self.bg = B.CreateBDFrame(self.Background, 0, -C.mult)
	end

	if self.UnselectedFrame then
		B.StripTextures(self.UnselectedFrame)
	end
end

local function Reskin_Reward(self)
	if self.icbg then return end

	self.icbg = B.ReskinIcon(self.Icon)
	B.ReskinBorder(self.IconBorder, self.icbg, nil, true)
end

local function Reskin_SelectReward(self)
	local confirmFrame = self.confirmSelectionFrame
	if confirmFrame then
		if not confirmFrame.styled then
			WeeklyRewardsFrameNameFrame:Hide()
			Reskin_Reward(confirmFrame.ItemFrame)

			confirmFrame.styled = true
		end

		local alsoItemsFrame = confirmFrame.AlsoItemsFrame
		if alsoItemsFrame then
			for frame in alsoItemsFrame.pool:EnumerateActive() do
				Reskin_Reward(frame)
			end
		end
	end
end

local function Replace_IconString(self, text)
	if not text then text = self:GetText() end
	if not text or text == "" then return end

	local newText, count = gsub(text, "24:24:0:%-2", "24:24:0:0:64:64:5:59:5:59")
	if count > 0 then self:SetFormattedText("%s", newText) end
end

C.LUAThemes["Blizzard_WeeklyRewards"] = function()
	B.ReskinFrame(WeeklyRewardsFrame)

	local HeaderFrame = WeeklyRewardsFrame.HeaderFrame
	B.StripTextures(HeaderFrame)
	HeaderFrame.Text:SetFontObject(SystemFont_Huge1)
	B.ReskinText(HeaderFrame.Text, 1, .8, 0)

	local SelectRewardButton = WeeklyRewardsFrame.SelectRewardButton
	B.StripTextures(SelectRewardButton)
	B.ReskinButton(SelectRewardButton)

	local ConcessionFrame = WeeklyRewardsFrame.ConcessionFrame
	ConcessionFrame:DisableDrawLayer("BACKGROUND")
	ConcessionFrame:DisableDrawLayer("BORDER")
	ConcessionFrame.SelectedTexture:SetAlpha(0)
	ConcessionFrame.bg = B.CreateBDFrame(ConcessionFrame)
	hooksecurefunc(ConcessionFrame, "SetSelectionState", Update_SelectionState)

	local Text = ConcessionFrame.RewardsFrame.Text
	Replace_IconString(Text)
	hooksecurefunc(Text, "SetText", Replace_IconString)

	Reskin_ActivityFrame(WeeklyRewardsFrame.RaidFrame)
	Reskin_ActivityFrame(WeeklyRewardsFrame.MythicFrame)
	Reskin_ActivityFrame(WeeklyRewardsFrame.PVPFrame)

	for _, frame in pairs(WeeklyRewardsFrame.Activities) do
		Reskin_ActivityFrame(frame, true)
	end

	hooksecurefunc(WeeklyRewardsFrame, "SelectReward", Reskin_SelectReward)
end