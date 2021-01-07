local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_AlliedRacesFrame()
	local Child = ScrollFrame.Child
	B.StripTextures(Child.ObjectivesFrame)

	for i = 1, Child:GetNumChildren() do
		local button = select(i, Child:GetChildren())

		if not button.styled then
			if button.Icon then
				B.ReskinIcon(button.Icon)
				select(3, button:GetRegions()):Hide()
			end

			if button.Text then
				B.ReskinText(button.Text, 1, 1, 1)
			end

			button.styled = true
		end
	end
end

C.LUAThemes["Blizzard_AlliedRacesUI"] = function()
	B.ReskinFrame(AlliedRacesFrame)
	B.StripTextures(AlliedRacesFrame.ModelFrame, 0)

	local RaceInfoFrame = AlliedRacesFrame.RaceInfoFrame
	B.ReskinText(RaceInfoFrame.AlliedRacesRaceName, 1, .8, 0)

	local ScrollFrame = RaceInfoFrame.ScrollFrame
	B.ReskinScroll(ScrollFrame.ScrollBar)
	B.ReskinText(ScrollFrame.Child.RaceDescriptionText, 1, 1, 1)
	B.ReskinText(ScrollFrame.Child.RacialTraitsLabel, 1, .8, 0)

	AlliedRacesFrame:HookScript("OnShow", Reskin_AlliedRacesFrame)
end