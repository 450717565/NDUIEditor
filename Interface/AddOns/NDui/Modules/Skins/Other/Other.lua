local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

function S:Other()
	if IsAddOnLoaded("DungeonWatchDog") then
		select(11, LFGListFrame.SearchPanel:GetChildren()):Hide()
	end

	local function resetTabAnchor(self)
		local frameName = self.GetName and self:GetName()
		local text = self.Text or (frameName and _G[frameName.."Text"])
		if text then
			text:SetJustifyH("CENTER")
			text:ClearAllPoints()
			text:SetPoint("CENTER")
		end
	end
	hooksecurefunc("PanelTemplates_DeselectTab", resetTabAnchor)
	hooksecurefunc("PanelTemplates_SelectTab", resetTabAnchor)
end