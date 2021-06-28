local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

function Skins:CovenantMissionHelper()
	if not IsAddOnLoaded("CovenantMissionHelper") then return end

	for i = 1, 2 do
		local tab = _G["MissionHelperTab"..i]
		B.StripTextures(tab)
		tab.bg = B.CreateBGFrame(tab, 3, 0, -3, 0)
	end
	MissionHelperTab2:ClearAllPoints()
	MissionHelperTab2:SetPoint("LEFT", MissionHelperTab1.bg, "RIGHT", 0, 0)

	local frame = MissionHelperFrame
	frame:ClearAllPoints()
	frame:SetPoint("LEFT", CovenantMissionFrame, "RIGHT", 3, 0)

	B.ReskinFrame(frame)
	B.StripTextures(frame.RaisedFrameEdges)
	B.StripTextures(frame.resultHeader)
	B.StripTextures(frame.missionHeader)
	B.CreateBDFrame(frame.missionHeader)

	local resultInfo = frame.resultInfo
	B.StripTextures(resultInfo)
	B.StripTextures(resultInfo.RaisedFrameEdges)
	B.CreateBDFrame(resultInfo)

	local combatLogFrame = frame.combatLogFrame
	B.StripTextures(combatLogFrame)
	B.StripTextures(combatLogFrame.RaisedFrameEdges)
	B.CreateBDFrame(combatLogFrame)
	B.ReskinScroll(combatLogFrame.scrollBar)

	local buttonsFrame = frame.buttonsFrame
	B.StripTextures(buttonsFrame)
	B.ReskinButton(buttonsFrame.BestDispositionButton)
	B.ReskinButton(buttonsFrame.predictButton)
end

C.OnLoginThemes["Blizzard_GarrisonUI"] = Skins.CovenantMissionHelper