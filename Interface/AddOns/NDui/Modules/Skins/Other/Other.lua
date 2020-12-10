local B, C, L, DB = unpack(select(2, ...))
local Skins = B:GetModule("Skins")

function Skins:Other()
	if IsAddOnLoaded("EasyScrap") then
		EasyScrapParentFrame:ClearAllPoints()
		EasyScrapParentFrame:SetPoint("LEFT", ScrappingMachineFrame, "RIGHT", 3, 0)
	end

	local function resetTabAnchor(self)
		local frameName = self:GetDebugName()
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