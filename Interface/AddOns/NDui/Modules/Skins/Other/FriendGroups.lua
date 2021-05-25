local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

local function replaceButtonStatus(self, texture)
	self:SetPoint("TOPLEFT", 4, 1)
	self.bg:Show()

	if strfind(texture, "PlusButton") then
		self:SetAtlas("Soulbinds_Collection_CategoryHeader_Collapse", true)
	elseif strfind(texture, "MinusButton") then
		self:SetAtlas("Soulbinds_Collection_CategoryHeader_Expand", true)
	else
		self:SetPoint("TOPLEFT", 4, -3)
		self.bg:Hide()
	end
end

local function Update_FriendButton(button)
	if not button.styled then
		local bg = B.CreateBDFrame(button.status)
		bg:SetInside(button.status, 3, 3)
		button.status.bg = bg
		hooksecurefunc(button.status, "SetTexture", replaceButtonStatus)

		button.styled = true
	end
end

function Skins:FriendGroups()
	if not IsAddOnLoaded("FriendGroups") then return end

	if FriendGroups_UpdateFriendButton then
		hooksecurefunc("FriendGroups_UpdateFriendButton", Update_FriendButton)
	end
end