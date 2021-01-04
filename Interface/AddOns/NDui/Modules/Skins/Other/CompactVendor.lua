local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

local function Update_OnShowPoint(self)
	self:ClearAllPoints()
	self:SetPoint("TOPLEFT", MerchantFrame, "TOPRIGHT", 3, -25)
end

local function Format_Number(self, text)
	if self.setting or (not text or type(text) ~= "number") then return end
	self.setting = true
	self:SetText(B.FormatNumb(text))

	self.setting = false
end

local function Reskin_RefreshListDisplay(self)
	local buttons = self.ListScrollFrame.buttons
	if buttons and not self.ListScrollFrame.styled then
		for i = 1, #buttons do
			local button = buttons[i]
			button.CircleMask:Hide()
			button.Icon:SetScale(.8)
			local icbg1 = B.ReskinIcon(button.Icon)

			local Costs = button.Cost.Costs
			for j = 1, #Costs do
				local Icon = Costs[j].Icon
				Icon.CircleMask:Hide()
				Icon.Texture:SetMask("")
				Icon.Texture:SetScale(.8)

				local ip1, ip2, ip3 = Icon:GetPoint()
				Icon:ClearAllPoints()
				Icon:SetPoint(ip1, ip2, ip3, -2, 2)

				local icbg2 = B.ReskinIcon(Icon.Texture)
				hooksecurefunc(Icon.Count, "SetText", Format_Number)

				local Name = Costs[j].Name
				local np1, np2, np3 = Name:GetPoint()
				Name:ClearAllPoints()
				Name:SetPoint(np1, np2, np3, 1, 0)
			end

			if icbg1 then icbg1:SetFrameLevel(button:GetFrameLevel()+1) end
			if icbg2 then icbg2:SetFrameLevel(button:GetFrameLevel()+1) end
		end

		self.ListScrollFrame.styled = true
	end
end

function Skins:CompactVendor()
	if not IsAddOnLoaded("CompactVendor") then return end

	local frame = VladsVendorFrame
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", MerchantFrameInset, "TOPLEFT", 3, -3)
	frame:SetPoint("BOTTOMRIGHT", MerchantFrameInset, "BOTTOMRIGHT", -20, 55)

	local Search = frame.Search
	B.ReskinInput(Search, 20)
	Search:ClearAllPoints()
	Search:SetPoint("RIGHT", MerchantFrameLootFilter, "LEFT", 10, 2)

	local List = frame.List
	B.StripTextures(List)
	B.ReskinScroll(List.ListScrollFrame.ScrollBar)

	local splitFrame = VladsVendorListItemQuantityStackSplitFrame
	B.ReskinFrame(splitFrame)
	B.ReskinButton(splitFrame.OkayButton)
	B.ReskinButton(splitFrame.CancelButton)
	B.ReskinArrow(splitFrame.LeftButton, "left")
	B.ReskinArrow(splitFrame.RightButton, "right")

	hooksecurefunc(splitFrame, "Show", Update_OnShowPoint)
	hooksecurefunc(List, "RefreshListDisplay", Reskin_RefreshListDisplay)
end