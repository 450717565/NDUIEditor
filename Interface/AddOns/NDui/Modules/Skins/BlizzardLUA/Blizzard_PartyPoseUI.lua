local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_PartyPoseUI(self)
	B.ReskinFrame(self)
	B.ReskinButton(self.LeaveButton)
	B.StripTextures(self.ModelScene, 0)
	B.CreateBDFrame(self.ModelScene, 0, -C.mult)

	self.OverlayElements:Hide()

	local RewardFrame = self.RewardAnimations.RewardFrame
	RewardFrame.NameFrame:SetAlpha(0)

	local icbg = B.ReskinIcon(RewardFrame.Icon)
	B.ReskinBorder(RewardFrame.IconBorder, icbg)

	local Label = RewardFrame.Label
	Label:ClearAllPoints()
	Label:SetPoint("LEFT", icbg, "RIGHT", 6, 10)

	local Name = RewardFrame.Name
	Name:ClearAllPoints()
	Name:SetPoint("LEFT", icbg, "RIGHT", 6, -10)
end

C.LUAThemes["Blizzard_IslandsPartyPoseUI"] = function()
	Reskin_PartyPoseUI(IslandsPartyPoseFrame)
end

C.LUAThemes["Blizzard_WarfrontsPartyPoseUI"] = function()
	Reskin_PartyPoseUI(WarfrontsPartyPoseFrame)
end