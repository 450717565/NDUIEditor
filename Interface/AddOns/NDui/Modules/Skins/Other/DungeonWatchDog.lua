local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

function S:DungeonWatchDog()
	if not IsAddOnLoaded("DungeonWatchDog") then return end

	local button = select(11, LFGListFrame.SearchPanel:GetChildren())
	B.ReskinButton(button)
	button:SetSize(40, 20)

	button:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:SetPoint("RIGHT", PVEFrameCloseButton, "LEFT", -3, 0)
	end)
end