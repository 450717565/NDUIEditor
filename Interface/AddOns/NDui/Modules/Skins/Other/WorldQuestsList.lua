local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

function Skins:WorldQuestsList()
	if not IsAddOnLoaded("WorldQuestsList") then return end

	local frame = WorldQuestsListFrame
	B.ReskinFrame(frame)

	B.StripTextures(frame.footer)
	B.StripTextures(frame.backdrop)
	B.StripTextures(frame.ViewAllButton.Argus)
	B.StripTextures(frame.oppositeContinentButton)

	B.ReskinButton(frame.ViewAllButton.Argus, true)
	B.ReskinButton(frame.oppositeContinentButton, true)

	local buttons = {
		"moveHeader",
		"sortDropDown",
		"filterDropDown",
		"optionsDropDown",
		"modeSwitcherCheck",
		"ViewAllButton",
	}
	for _, button in pairs(buttons) do
		B.StripTextures(frame[button])

		if frame[button].Button then
			B.ReskinButton(frame[button].Button, true)
		else
			B.ReskinButton(frame[button], true)
		end
	end

	local check = select(17, WorldMapFrame:GetChildren())
	B.ReskinCheck(check)
	check:ClearAllPoints()
	check:SetPoint("BOTTOMRIGHT", WorldMapFrame, "TOPRIGHT", 4, -4)
end