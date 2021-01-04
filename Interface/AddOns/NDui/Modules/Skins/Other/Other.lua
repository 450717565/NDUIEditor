local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

local function Reset_TabAnchor(self)
	local frameName = self:GetDebugName()
	local text = self.Text or (frameName and _G[frameName.."Text"])
	if text then
		text:SetJustifyH("CENTER")
		text:ClearAllPoints()
		text:SetPoint("CENTER")
	end
end

function Skins:Other()
	if IsAddOnLoaded("EasyScrap") then
		EasyScrapParentFrame:ClearAllPoints()
		EasyScrapParentFrame:SetPoint("LEFT", ScrappingMachineFrame, "RIGHT", 3, 0)
	end

	hooksecurefunc("PanelTemplates_DeselectTab", Reset_TabAnchor)
	hooksecurefunc("PanelTemplates_SelectTab", Reset_TabAnchor)
end